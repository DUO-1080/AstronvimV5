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

-- vim.cmd [[
--   highlight CursorNormal guifg=NONE guibg=#D08770  " Normal/Command 模式，柔和金色
--   highlight CursorInsert guifg=NONE guibg=#A3BE8C  " Insert 模式，柔和亮绿色
-- ]]

-- 设置光标形状和闪烁
-- vim.opt.guicursor = "n-v-c:block-CursorNormal,i:block-CursorInsert-blinkwait175-blinkon150-blinkoff175"

vim.opt.guicursor = {
  "n-v-c:block-blinkon0", -- 普通、视觉、命令行模式：方块，且不闪烁 (blinkon0)
  "i-ci-ve:ver50-blinkwait175-blinkoff150-blinkon175", -- 插入模式：50%厚竖线，且开启闪烁
  "r-cr:hor20",
  "o:hor50",
  "a:Cursor/lCursor",
}

vim.api.nvim_set_hl(0, "NeoTreeModified", { fg = "#e69875", bold = true })
vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#dbbc7f" })
vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#a7c080" })
vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#e67e80" })
vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = "#F07178" })
vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#4f585e" })
