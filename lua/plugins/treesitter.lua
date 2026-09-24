local languages = require("config.languages")

local treesitter = require("nvim-treesitter")
treesitter.setup({})

local treesitter_config = require("nvim-treesitter.config")

local already_installed = treesitter_config.get_installed()
local parsers_to_install = {}

for _, parser in ipairs(languages.parsers()) do
	if not vim.tbl_contains(already_installed, parser) then
		table.insert(parsers_to_install, parser)
	end
end

if #parsers_to_install > 0 then
	treesitter.install(parsers_to_install)
end

local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if vim.list_contains(treesitter_config.get_installed(), lang) then
			vim.treesitter.start(args.buf)
			-- indentación por treesitter solo si el lenguaje tiene reglas (indents.scm);
			-- si no, queda el indent nativo de vim / smartindent de options.lua
			if vim.treesitter.query.get(lang, "indents") then
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end
	end,
})
