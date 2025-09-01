-- 全局折行设置
vim.o.wrap = true -- 自动折行
vim.o.linebreak = true -- 折行不截断单词

-- 定义一个 augroup 管理 autocmd
local group = vim.api.nvim_create_augroup("BetterOGlobal", { clear = true })

-- 只在代码文件类型触发的新行滚屏
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  pattern = { "*.lua", "*.cpp", "*.c", "*.h", "*.py", "*.java", "*.js", "*.ts" }, -- 可按需增加
  callback = function()
    local cur_line = vim.fn.line "."
    local prev_line = cur_line - 1
    local line_text = vim.fn.getline(cur_line)

    -- 当前行为空，上一行非空 → 新行
    if line_text:match "^%s*$" and vim.fn.getline(prev_line):match "%S" then
      vim.cmd "normal! zH" -- 滚屏到最左，不影响缩进
    end
  end,
})

local ls = require "luasnip"

vim.keymap.set({ "i", "s" }, "<Esc>", function()
  if ls.in_snippet() then
    ls.unlink_current() -- 退出 snippet session
    return "<Esc>" -- 阻止跳回 Normal 模式（可选，按你需要）
  else
    return "<Esc>" -- 普通 Esc 正常退出插入模式
  end
end, { expr = true, silent = true, desc = "Exit snippet session" })
