return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
     local ts = require("nvim-treesitter")

      -- 1. Main configuration setup
      ts.setup({
        -- Enable syntax highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        },
        -- Enable consistent code indentation
        indent = {
          enable = true
        },
        autotage = {
          enable = true
        }
      })

      -- 2. Explicitly manage and install your desired parsers
      local ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "bash",
        "python",
        "javascript",
        "typescript",
      }

      -- Install missing parsers sequentially
      ts.install(ensure_installed)
  end,
}
