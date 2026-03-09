return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    enable_diagnostics = true,

    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1,
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },

      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        folder_empty_open = "",
        default = "󰈚",
        highlight = "NeoTreeFileIcon",
      },

      name = {
        highlight = "NeoTreeFileName",
      },

      git_status = {
        async = true,
        symbols = {
          added = "",
          modified = "",
          deleted = "",
          renamed = "",
          untracked = "*",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },

      diagnostics = {
        symbols = {
          hint = "󰌶",
          info = "󰋽",
          warn = "󰀪",
          error = "󰅚",
        },
      },
    },

    filesystem = {
      follow_current_file = { enabled = false },

      filtered_items = {
        visible = false,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".DS_Store",
        },
        never_show = {},
      },
    },

    -- window = {
    --   width = 34,
    --   mappings = {
    --     ["<space>"] = "toggle_node",
    --     ["l"] = "open",
    --     ["h"] = "close_node",
    --     ["o"] = "open",
    --   },
    -- },
  },
}
