return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Define a variante do tema ('dark' ou 'light')
      vim.o.background = "dark"

      -- Opções de customização adicionais do tema
      require("vscode").setup({
        transparent = true,
        italic_comments = true,
        underline_links = true,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
