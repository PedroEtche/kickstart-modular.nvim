local languages = require("config.languages")
local blink = require("plugins.blink")
local augroup = require("config.autocmds").augroup

local diagnostic_signs = {
	Error = "\u{f057} ",
	Warn = "\u{f071} ",
	Hint = "\u{ea61}",
	Info = "\u{f05a}",
}

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local function opts(desc)
		return { noremap = true, silent = true, buffer = bufnr, desc = desc }
	end

	-- keymaps de LSP: todos con prefijo g (buffer-local, pisan los gr* globales de Neovim)
	local function map(keys, func, desc, mode)
		vim.keymap.set(mode or "n", keys, func, opts("LSP: " .. desc))
	end
	local telescope = require("telescope.builtin")

	map("grd", telescope.lsp_definitions, "[G]oto [D]efinition")
	map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	map("grv", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, "[G]oto definition in [V]split")
	map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
	map("grr", telescope.lsp_references, "[G]oto [R]eferences")
	map("gri", telescope.lsp_implementations, "[G]oto [I]mplementation")
	map("grt", telescope.lsp_type_definitions, "[G]oto [T]ype Definition")
	map("gO", telescope.lsp_document_symbols, "Open Document Symbols")
	map("gW", telescope.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
	map("grh", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		print("Inlay hints", vim.lsp.inlay_hint.is_enabled() and "enable" or "disable")
	end, "Toggle inlay [H]ints")

	vim.keymap.set("n", "<leader>dd", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, opts("[D]iagnostic under cursor"))

	if client:supports_method("textDocument/codeAction", bufnr) then
		map("gro", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, "[O]rganize imports")
	end
end
vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.lsp.config["*"] = { capabilities = blink.capabilities }

-- ----------------------------------------------------------------------------
-- Todo lo de abajo sale de config/languages.lua. Para agregar un lenguaje
-- nuevo, agregá una entrada ahí — no hace falta tocar este archivo.
-- ----------------------------------------------------------------------------

for _, server in ipairs(languages.servers()) do
	vim.lsp.config(server.name, server.config)
end

local enable_list = { "efm" }
for _, server in ipairs(languages.servers()) do
	table.insert(enable_list, server.name)
end

vim.lsp.enable(enable_list)
