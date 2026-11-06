return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      ["<C-e>"] = { "cancel", "fallback" }, -- 取消补全
      ["<Esc>"] = { "cancel", "fallback" }, -- 菜单开着时取消，否则就是正常 Esc
      ["<CR>"] = { "accept", "fallback" }, -- 明确接受
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      -- 这个很重要！避免没选的时候自动上屏第一个候选
      list = { selection = { preselect = false } },
    },
    -- 排序规则（通用，不针对特定候选硬编码）：
    -- 1) 标签以输入词开头（忽略大小写）最优先，如 fal→false、tru→true
    -- 2) 否则：输入词在标签中出现位置越靠前越优先；位置相同则标签越短越优先，
    --    如输入 strin 时 std::string（位置5、更短）排在 std::pmr::string（位置9）前面
    -- 3) 子串都匹配不上时（纯模糊散点命中）交给 score → sort_text
    fuzzy = {
      sorts = {
        function(a, b)
          -- 输入词：优先用 blink 触发补全时捕获的上下文（比直接读 buffer 更稳）
          local ok, keyword = pcall(function()
            local ctx = require("blink.cmp.completion.list").context
            if ctx and ctx.line and ctx.cursor then
              local kw = ctx.line:sub(1, ctx.cursor[2]):match "[%w_]*$"
              if kw and #kw > 0 then return kw end
            end
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            return line:sub(1, col):match "[%w_]*$"
          end)
          if not ok or not keyword or #keyword == 0 then return end
          local kw = keyword:lower() -- 忽略大小写：输入 FAL/Fal 也能置顶 false
          local ok2, ra, rb = pcall(function()
            -- rank = (档位, 出现位置, 标签长度)：档位 0=前缀命中 1=子串命中 2=无子串
            local function rank(item)
              local label = item.label:lower()
              if label:sub(1, #kw) == kw then return 0, 0, #label end
              local pos = label:find(kw, 1, true)
              if pos then return 1, pos, #label end
              return 2, 0, #label
            end
            return { rank(a) }, { rank(b) }
          end)
          if not ok2 then return end
          -- 有一方连子串都匹配不上（纯模糊命中）时，不干预，交给 score 排
          if ra[1] == 2 or rb[1] == 2 then return end
          for i = 1, 3 do
            if ra[i] ~= rb[i] then return ra[i] < rb[i] end
          end
        end,
        "exact",
        "score",
        "sort_text",
      },
    },
  },
}
