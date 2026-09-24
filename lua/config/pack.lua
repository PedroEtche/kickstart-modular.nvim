-- ============================================================================
-- PACK: qué plugins instalar (vim.pack.add). La CONFIGURACIÓN de cada uno
-- vive en lua/plugins/, un archivo por plugin.
-- ============================================================================

-- vim.pack no tiene `build`: los pasos post-instalación van en PackChanged.
-- Tiene que estar definido ANTES de vim.pack.add para capturar "install".
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end
		if name == "telescope-fzf-native.nvim" then
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		elseif name == "nvim-treesitter" and ev.data.active then
			vim.cmd("TSUpdate")
		end
	end,
})

-- ripgrep y fd son binarios (brew install ripgrep fd), no plugins:
-- telescope los busca en el PATH. Ver el chequeo en plugins/telescope.lua.
vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim.git",
	"https://github.com/nvim-lua/plenary.nvim.git", -- For Telescope
	"https://github.com/nvim-tree/nvim-web-devicons.git", -- For Telescope
	"https://github.com/nvim-telescope/telescope.nvim.git",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim", -- compila con make (hook arriba)
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
	},
	"https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
	-- Language Server Protocols
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		-- NOTE: blink.cmp v2 is now the actively developed branch (breaking
		-- changes vs v1). Staying pinned to v1 here deliberately for stability.
		-- Revisit this pin when ready to migrate — v2 requires installing
		-- blink.lib as a native dependency outside vim.pack.
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/mrcjkb/rustaceanvim",
	"https://github.com/folke/todo-comments.nvim.git",
	{
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine",
	},
})
