return {
  "folke/which-key.nvim",
  -- 修复：LuaSnip 的 snippet placeholder 是用 SELECT 模式进入的（Tab 跳转后占位文本被选中）。
  -- which-key 默认 triggers 的监听模式是 "nxso"，包含 SELECT(s)，
  -- 导致在占位符里输入 g/z 等前缀键时被 which-key 拦截弹出按键菜单，
  -- 文本无法输入，看起来像"输入 g 进入了命令模式"。
  -- 这里把 s 从监听模式中去掉，恢复正常输入。
  opts = {
    triggers = {
      { "<auto>", mode = "nxo" },
    },
  },
}
