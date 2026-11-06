-- Customize Mason

---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "debugpy",
        "tree-sitter-cli",
      },
    },
  },
}
