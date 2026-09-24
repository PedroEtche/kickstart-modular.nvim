local languages = require("config.languages")

vim.lsp.config("efm", {
	filetypes = languages.efm_filetypes(),
	init_options = { documentFormatting = true },
	settings = {
		languages = languages.efm_languages(),
	},
})
