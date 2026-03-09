return {
  "Badhi/nvim-treesitter-cpp-tools",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = function()
    return {
      preview = {
        quit = "q",
        accept = "<tab>",
      },
      header_extension = "hpp",
      source_extension = "cpp",
      custom_define_class_function_commands = {
        TSCppImplWrite = {
          output_handle = function(str, context)
            local target_file = vim.fn.expand "%:p:r" .. ".cpp"
            local bufnr = vim.fn.bufnr(target_file)

            -- 1. 处理 Buffer 冲突：如果文件已打开且有未保存修改，先强制保存
            if bufnr ~= -1 and vim.api.nvim_buf_get_option(bufnr, "modified") then
              vim.api.nvim_buf_call(bufnr, function() vim.cmd "silent! write" end)
            end

            -- 2. 追加内容到磁盘文件
            local f = io.open(target_file, "a+")
            if f then
              f:write("\n" .. str .. "\n")
              f:close()

              -- 3. 发送通知
              vim.notify(
                "已追加实现至: " .. vim.fn.fnamemodify(target_file, ":t"),
                vim.log.levels.INFO,
                { title = "C++ Tools" }
              )

              -- 4. 静默重载 Buffer，避免弹出 W12 警告
              if bufnr ~= -1 then vim.api.nvim_buf_call(bufnr, function() vim.cmd "silent! edit!" end) end
            else
              vim.notify("无法写入文件: " .. target_file, vim.log.levels.ERROR)
            end
          end,
        },
      },
    }
  end,
  config = true,
  keys = {
    { "<leader>lm", "<cmd>TSCppImplWrite<CR>", mode = "n", desc = "C++: Impl write" },
    { "<leader>lm", ":TSCppImplWrite<CR>", mode = "v", desc = "C++: Impl write (Visual)" },
  },
}
