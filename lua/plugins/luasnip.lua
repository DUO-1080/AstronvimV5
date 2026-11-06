return {
  -- 1. 配置 LuaSnip：负责物理清除
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      -- 禁用历史记录，这是第一道防线
      opts.history = false
      -- 注意：插入模式下方向键移动光标触发的是 CursorMovedI（不是 CursorMoved），
      -- 缺了它，方向键移出 snippet 后它仍然保持活跃，之后按 Tab 会跳回旧占位符
      opts.region_check_events = "InsertEnter,CursorMoved,CursorMovedI"
      opts.delete_check_events = "TextChanged,InsertLeave"

      require "astronvim.plugins.configs.luasnip"(plugin, opts)

      -- -- 激进清理：如果检测到没有跳跃点处于活跃状态，强制断开
      -- local luasnip = require "luasnip"
      -- vim.api.nvim_create_autocmd("InsertLeave", {
      --   callback = function()
      --     if
      --       require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      --       and not require("luasnip").session.jump_active
      --     then
      --       require("luasnip").unlink_current()
      --     end
      --   end,
      -- })
    end,
  },
}
