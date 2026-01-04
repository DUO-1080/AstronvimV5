local M = {}

-- 增强版章节正则，匹配“第X章”或“第X章 标题”
local chapter_pattern = "^[ \t　]*第[零一二三四五六七八九十百千万0-9]+[卷章节回集][ \t　]*(.*)$"

-- 扫描当前 buffer 的章节（逐行扫描）
function M.scan_chapters()
  local chapters = {}
  local total_lines = vim.api.nvim_buf_line_count(0)
  for i = 1, total_lines do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if line and line:match(chapter_pattern) then
      if not line:find("，", 1, true) and not line:find("。", 1, true) and not line:find("！", 1, true) then
        table.insert(chapters, { line = line, lnum = i })
      end
    end
  end
  return chapters
end

-- Telescope 弹窗打开章节列表
function M.open_chapter_picker()
  local ok, telescope = pcall(require, "telescope.pickers")
  if not ok then
    vim.notify("Telescope not found!", vim.log.levels.ERROR)
    return
  end

  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  local chapters = M.scan_chapters()
  if #chapters == 0 then
    vim.notify("No chapters found!", vim.log.levels.WARN)
    return
  end

  -- 获取当前行号，找到最近的章节索引
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local select_idx = 0
  if current_line > chapters[#chapters].lnum then
    select_idx = #chapters - 1 -- 最后一个章节（0-based 索引）
  else
    for i, chapter in ipairs(chapters) do
      if chapter.lnum <= current_line then
        select_idx = i - 1 -- 0-based 索引
      else
        break
      end
    end
  end

  telescope
    .new({
      prompt_title = "TXT Chapters",
      finder = finders.new_table {
        results = chapters,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.line,
            ordinal = entry.line, -- 仅用于过滤
          }
        end,
      },
      sorter = nil, -- 禁用排序，严格按 results 顺序
      layout_strategy = "vertical", -- 垂直布局
      layout_config = {
        prompt_position = "top", -- 提示框置于顶部
        height = 0.6,
        width = 0.8,
        mirror = false, -- 禁用列表反转
      },
      sorting_strategy = "ascending", -- 明确升序
      initial_mode = "insert", -- 以插入模式打开
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.api.nvim_win_set_cursor(0, { selection.value.lnum, 0 })
          vim.cmd "normal! zz" -- 居中显示
        end)
        -- 根据当前行号选择章节
        vim.defer_fn(function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          picker:set_selection(select_idx)
        end, 100) -- 延迟 100ms
        return true
      end,
    }, {})
    :find()
end

return M
