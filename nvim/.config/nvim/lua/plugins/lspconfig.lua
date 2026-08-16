return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = { "lua_ls", "basedpyright", "bashls"},
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        { 
          "neovim/nvim-lspconfig",
          config = function()
           vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
           vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
           vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})

         end,
        },
    }
}
