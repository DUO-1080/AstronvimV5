return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          -- second key is the lefthand side of the map
          -- mappings seen under group name "Buffer"
          ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
          ["<Leader>bD"] = {
            function()
              require("astroui.status").heirline.buffer_picker(function(bufnr)
                require("astrocore.buffer").close(bufnr)
              end)
            end,
            desc = "Pick to close",
          },
          -- tables with just a `desc` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          ["<Leader>b"] = { desc = "Buffers" },
          -- quick save
          -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
          ["<leader>wa"] = { ":wa<cr>zt", desc = "Save All" },
          ["<leader>w"] = { ":w<cr>zt", desc = "Save File" },
          ["<S-CR>"] = { "<ESC>o<c-g>u", desc = "Next Line" },
          ["<C-\\>"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "open term", noremap = true, silent = true },
          ["<leader>lS"] = { ":TagbarToggle<cr>", desc = "Open Tagbar" },

        },
        i = {
          ["<C-\\>"] = { "<ESC><cmd>ToggleTerm<cr>", desc = "open term", noremap = true, silent = true },
          ["<S-CR>"] = { "<ESC>o<c-g>u", desc = "Next Line" },
          ["<C-CR>"] = { "<ESC>$a", desc = "Move cursor to line end" },
          ["<CR>"] = { "<c-g>u<cr>", desc = "Next Line" },
          ["<C-S-CR>"] = { "<ESC>$a;<c-g>u<ESC>zt", desc = "Auto Complete Statement" },
          ["jk"] = { "<ESC>", desc = "ESC" },
          ["jj"] = { "<ESC>", desc = "ESC" },
        },
        t = {
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
          ["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "open term" },
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          -- this mapping will only be set in buffers with an LSP attached
          K = {
            function()
              vim.lsp.buf.hover()
            end,
            desc = "Hover symbol details",
          },
          -- condition for only server with declaration capabilities
          gD = {
            function()
              vim.lsp.buf.declaration()
            end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
        },
      },
    },
  },
}
