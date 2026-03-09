return {
  "sainnhe/everforest",
  lazy = false,
  priority = 1000,
  config = function()
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.everforest_enable_italic = true
    vim.o.background = "dark"
    vim.g.everforest_background = "hard"
    --
    -- 强制设置光标颜色为 dbbc7f (Everforest Yellow)
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "everforest",
      callback = function()
        -- 背景色设为主题深色 #2b3339，确保光标下的字符清晰
        vim.api.nvim_set_hl(0, "Cursor", { bg = "#dbbc7f", fg = "#2b3339", force = true })
        vim.api.nvim_set_hl(0, "TermCursor", { bg = "#dbbc7f", fg = "#2b3339", force = true })
      end,
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "everforest",
      callback = function()
        -- 定义你想用的颜色，这里换成 Everforest 经典的绿色 #a7c080 试试，看能不能变绿
        local target_color = "#e67e80"

        -- 强制覆盖所有可能导致“黄色”的相关高亮组
        local groups = {
          "SnacksIndentScope", -- 针对 snacks.nvim 的可能命名
        }

        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { fg = target_color, nocombine = true, force = true })
        end
      end,
    })
    -- vim.cmd.colorscheme "everforest"
  end,
}
