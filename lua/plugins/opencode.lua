---@type LazySpec
return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      {
        "folke/snacks.nvim",
        opts = { input = { enabled = true }, picker = { enabled = true }, terminal = { enabled = true } },
      },
    },
    init = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          -- Only used when no OpenCode daemon is running at all; the usual path is `toggle` below.
          start = function()
            require("snacks.terminal").open("opencode", { win = { position = "right", enter = true } })
          end,
        },
      }
    end,
  },
  {
    "AstroNvim/astroui",
    opts = { icons = { OpenCode = "" } },
  },
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      local maps = assert(opts.mappings)
      local prefix = "<Leader>O"
      local snacks = require("snacks.terminal")

      -- Keep the terminal window around so `toggle` can show/hide the same instance.
      ---@type snacks.terminal?
      local term_win

      ---@param err any
      local function notify(err)
        vim.notify(tostring(err), vim.log.levels.ERROR, { title = "opencode" })
      end

      ---@return snacks.terminal?
      local function get_term()
        if term_win and term_win:buf_valid() then
          return term_win
        end
        term_win = nil
      end

      ---@param session opencode.server.Session
      ---@param enter? boolean
      local function open_term(session, enter)
        term_win = snacks.open(
          { "opencode", "--session", session.id },
          { win = { position = "right", enter = enter == true } }
        )
      end

      ---Run `cb` with the newest session for the current directory, creating one if none exists.
      ---Also opens the embedded terminal (without stealing focus unless `opts.enter`) so the
      ---result is visible. OpenCode v2's TUI does not create a session until the first prompt,
      ---but opencode.nvim requires an existing session to target.
      ---@param cb fun(session: opencode.server.Session)
      ---@param opts? { enter?: boolean }
      local function with_session(cb, opts)
        opts = opts or {}
        local function run(session)
          if not get_term() then
            open_term(session, opts.enter)
          end
          return cb(session)
        end

        require("opencode.server.discovery")
          .get()
          :next(function(server)
            return server:get_sessions():next(function(sessions)
              for _, session in ipairs(sessions) do
                if not (session.time and session.time.archived) then
                  return run(session)
                end
              end
              return server
                :request("/api/session", "POST", { location = { directory = vim.fn.getcwd() } })
                :next(function(response)
                  return run(response.data)
                end)
            end)
          end)
          :catch(notify)
      end

      local function toggle()
        local win = get_term()
        if win then
          win:toggle()
        else
          with_session(function() end, { enter = true })
        end
      end

      local function new_session()
        require("opencode.server.discovery")
          .get()
          :next(function(server)
            return server
              :request("/api/session", "POST", { location = { directory = vim.fn.getcwd() } })
              :next(function(response)
                local win = get_term()
                if win then win:close() end
                open_term(response.data, true)
              end)
          end)
          :catch(notify)
      end

      ---Send raw keys to the TUI (for actions that only exist in the TUI itself).
      ---@param keys string
      local function send_tui_keys(keys)
        local win = get_term()
        if not win then return end
        -- Terminal buffers expose their PTY job id as the `channel` buffer option.
        local ok, chan = pcall(function() return vim.bo[win.buf].channel end)
        if ok and chan and chan > 0 then
          vim.fn.chansend(chan, keys)
        end
      end

      maps.n[prefix] = { desc = require("astroui").get_icon("OpenCode", 1, true) .. "OpenCode" }
      maps.n[prefix .. "t"] = { toggle, desc = "Toggle embedded" }
      maps.t["<C-.>"] = { toggle, desc = "Toggle OpenCode" }
      maps.n[prefix .. "n"] = { new_session, desc = "New session" }
      maps.n[prefix .. "a"] = {
        function() with_session(function() require("opencode").ask("@this: ") end) end,
        desc = "Ask about this",
      }
      maps.n[prefix .. "e"] = {
        function() with_session(function() require("opencode").prompt("Explain @this and its context") end) end,
        desc = "Explain this code",
      }
      maps.n[prefix .. "+"] = {
        function() with_session(function() require("opencode").ask("@buffer") end) end,
        desc = "Add buffer to prompt",
      }
      maps.n[prefix .. "s"] = {
        function() with_session(function() require("opencode").select() end) end,
        desc = "Select prompt",
      }
      maps.n["<S-C-u>"] = { function() send_tui_keys("\x1b\x15") end, desc = "Messages half page up" }
      maps.n["<S-C-d>"] = { function() send_tui_keys("\x1b\x04") end, desc = "Messages half page down" }

      maps.v[prefix] = { desc = require("astroui").get_icon("OpenCode", 1, true) .. "OpenCode" }
      maps.v[prefix .. "a"] = {
        function() with_session(function() require("opencode").ask("@this: ") end) end,
        desc = "Ask about selection",
      }
      maps.v[prefix .. "+"] = {
        function() with_session(function() require("opencode").ask("@this") end) end,
        desc = "Add selection to prompt",
      }
      maps.v[prefix .. "s"] = {
        function() with_session(function() require("opencode").select() end) end,
        desc = "Select prompt",
      }
    end,
  },
}
