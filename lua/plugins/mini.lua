require("mini.ai").setup({})
require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
		end,
	},
})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.splitjoin").setup({}) -- gS: parte/junta argumentos y tablas
require("mini.notify").setup({
	-- no mostrar el progreso del LSP ($/progress): pyright lo manda en cada edición
	lsp_progress = { enable = false },
})
require("mini.icons").setup({})
require("mini.statusline").setup({})

-- shows available keymaps as you type a prefix (e.g. <leader>)
local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		{ mode = "n", keys = "<leader>" },
		{ mode = "x", keys = "<leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "i", keys = "<C-x>" }, -- builtin_completion
		{ mode = "n", keys = "'" }, -- marks
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = '"' }, -- registers
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" }, -- windows
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
	},
	window = {
		-- Show window immediately
		delay = 100,

		config = {
			-- Compute window width automatically
			width = "auto",

			-- Use double-line border
			border = "double",
		},
	},
	clues = {
		-- nombres de grupo (el prefijo solo, sin atajo propio)
		{ mode = "n", keys = "<leader>s", desc = "[S]earch" },
		{ mode = "n", keys = "<leader>S", desc = "[S]plit" },
		{ mode = "n", keys = "<leader>st", desc = "[S]earch [T]elescope extras" },
		{ mode = "n", keys = "<leader>h", desc = "Git [H]unk" },
		{ mode = "n", keys = "<leader>t", desc = "[T]oggle" },
		{ mode = "n", keys = "gr", desc = "LSP" },
		{ mode = "n", keys = "<leader>d", desc = "[D]iagnostic" },
		{ mode = "n", keys = "<leader>b", desc = "[B]uffer" },
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
		miniclue.gen_clues.square_brackets(),
	},
})

require("mini.diff").setup({
	view = {
		style = "sign",
		signs = { add = "▎", change = "▎", delete = "▎" },
	},
})

require("mini.git").setup({})

require("mini.files").setup({})
vim.keymap.set("n", "\\", function()
	local MiniFiles = require("mini.files")
	-- close() devuelve nil si no había explorador abierto
	if MiniFiles.close() == nil then
		local path = vim.api.nvim_buf_get_name(0)
		-- abre en el archivo actual; si el buffer no es un archivo en disco, en el cwd
		MiniFiles.open(vim.uv.fs_stat(path) and path or nil)
	end
end, { desc = "Toggle mini.files" })

local MiniDiff = require("mini.diff")
vim.keymap.set("n", "]h", function()
	MiniDiff.goto_hunk("next")
end, { desc = "Next git hunk" })
vim.keymap.set("n", "[h", function()
	MiniDiff.goto_hunk("prev")
end, { desc = "Prev git hunk" })
vim.keymap.set("n", "<leader>hs", MiniDiff.operator, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hp", function()
	MiniDiff.toggle_overlay()
end, { desc = "Preview diff overlay" })
vim.keymap.set("n", "<leader>hb", function()
	require("mini.git").show_at_cursor()
end, { desc = "Git blame/show" })
