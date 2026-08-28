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
			lazy = false,
			config = function()
				-- No Neovim 0.11+, aplicamos as capacidades globais diretamente no seletor "*"
				local capabilities = require("cmp_nvim_lsp").default_capabilities()
				vim.lsp.config("*", { capabilities = capabilities })

				-- 1. Configurar Basedpyright para ignorar lints duplicados (delega ao Ruff)
				vim.lsp.config("basedpyright", {
					settings = {
						basedpyright = {
							analysis = {
								-- Desativa o type checking/linting redundante do Pyright
								typeCheckingMode = "off",
							},
						},
					},
				})

				-- 2. Configurar Ruff para desativar o HoverProvider (evita conflito com Pyright)
				vim.lsp.config("ruff", {
					on_attach = function(client, _)
						-- Impede o Ruff de exibir caixas de documentação flutuantes
						client.server_capabilities.hoverProvider = false
					end,
				})

				-- 3. Habilitar todos os seus servidores nativamente (Substitui o antigo .setup())
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

				-- 4. Atalhos Globais de Teclado
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
				vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			end,
		},
	},
}

