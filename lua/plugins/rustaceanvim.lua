local blink = require("plugins.blink")

-- rust: rustaceanvim maneja su propio cliente LSP por fuera de vim.lsp.enable
vim.g.rustaceanvim = {
	server = {
		capabilities = blink.capabilities,
	},
}
