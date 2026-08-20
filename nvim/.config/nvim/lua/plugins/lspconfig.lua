return {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"lua_ls",
			"basedpyright",
			"ruff",
			"bashls",
			"vtsls",
			"clangd",
			"gopls",
		},
	},
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		{
			"neovim/nvim-lspconfig",
			config = function()
				-- 1. Configure Basedpyright to defer linting to Ruff
				vim.lsp.config("basedpyright", {
					settings = {
						basedpyright = {
							analysis = {
								ignore = { "*" },
							},
						},
					},
				})

				-- 2. Configure Ruff to disable hover and avoid overlap conflicts
				vim.lsp.config("ruff", {
					on_attach = function(client, _)
						client.server_capabilities.hoverProvider = false
					end,
				})

				-- 3. Enable all your language servers natively (replaces .setup())
				local servers = {
					"lua_ls",
					"basedpyright",
					"ruff",
					"bashls",
					"vtsls",
					"clangd",
					"gopls",
				}
				for _, server in ipairs(servers) do
					vim.lsp.enable(server)
				end

				-- 4. Set Global Hotkeys
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
				vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			end,
		},
	},
}
