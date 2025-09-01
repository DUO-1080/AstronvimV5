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
  },
}
