-- ============================================================================
-- LANGUAGES
-- Única fuente de verdad para agregar soporte a un lenguaje. Con una entrada
-- acá se alimenta automáticamente: parsers de treesitter (plugins/treesitter.lua),
-- servidores LSP (plugins/lspconfig.lua) y linters/formatters de efm
-- (plugins/efm.lua). No hay que tocar esos archivos para un caso estándar.
--
-- Campos de cada entrada (todos opcionales salvo `name`):
--   parser     : nombre del parser de nvim-treesitter a instalar
--   server     : nombre del servidor lspconfig a habilitar (vim.lsp.enable)
--   config     : tabla pasada a vim.lsp.config(server, config) — opcional
--   filetypes  : filetypes de vim en los que corre efm para este lenguaje
--   efm        : lista de herramientas de efmls-configs, en el orden en que
--                deben correr. Prefijo "lint:" o "fmt:" + nombre del módulo
--                en efmls-configs/lua/efmls-configs/{linters,formatters}/
--
-- Ejemplo para agregar Zig (una sola entrada, todo junto):
--   { name = "zig", parser = "zig", server = "zls", filetypes = { "zig" }, efm = { "fmt:zigfmt" } },
-- ============================================================================

local M = {}

-- inlay hints de ts_ls (se ven con <leader>th, ver plugins/lspconfig.lua)
local ts_inlay_hints = {
	includeInlayParameterNameHints = "all",
	includeInlayFunctionParameterTypeHints = true,
	includeInlayVariableTypeHints = true,
	includeInlayPropertyDeclarationTypeHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayEnumMemberValueHints = true,
}

M.list = {
	{ name = "vim", parser = "vim" },
	{ name = "vimdoc", parser = "vimdoc" },
	-- rust: LSP lo maneja rustaceanvim directamente, no pasa por vim.lsp.enable
	{ name = "rust", parser = "rust", filetypes = { "rust" }, efm = { "fmt:rustfmt" } },
	{
		name = "go",
		parser = "go",
		server = "gopls",
		filetypes = { "go" },
		efm = { "fmt:gofumpt", "lint:go_revive" },
		config = {
			settings = {
				gopls = {
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		},
	},
	{ name = "html", parser = "html", filetypes = { "html" }, efm = { "fmt:prettier_d" } },
	{ name = "css", parser = "css", filetypes = { "css" }, efm = { "fmt:prettier_d" } },
	{
		name = "javascript",
		parser = "javascript",
		server = "ts_ls",
		filetypes = { "javascript", "javascriptreact" },
		efm = { "lint:eslint_d", "fmt:prettier_d" },
		-- config de ts_ls: aplica también a typescript (M.servers() usa la primera entrada del server)
		config = {
			settings = {
				typescript = { inlayHints = ts_inlay_hints },
				javascript = { inlayHints = ts_inlay_hints },
			},
		},
	},
	{
		name = "typescript",
		parser = "typescript",
		server = "ts_ls",
		filetypes = { "typescript", "typescriptreact" },
		efm = { "lint:eslint_d", "fmt:prettier_d" },
	},
	{ name = "json", parser = "json", filetypes = { "json", "jsonc" }, efm = { "lint:eslint_d", "fmt:fixjson" } },
	{
		name = "lua",
		parser = "lua",
		server = "lua_ls",
		filetypes = { "lua" },
		efm = { "lint:luacheck", "fmt:stylua" },
		config = {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					telemetry = { enable = false },
					hint = { enable = true },
				},
			},
		},
	},
	{ name = "markdown", parser = "markdown", filetypes = { "markdown" }, efm = { "fmt:prettier_d" } },
	{
		name = "python",
		parser = "python",
		server = "pyright",
		filetypes = { "python" },
		efm = { "lint:ruff", "fmt:ruff" },
	},
	{
		name = "bash",
		parser = "bash",
		server = "bashls",
		filetypes = { "sh" },
		efm = { "lint:shellcheck", "fmt:shfmt" },
	},
	-- odin: sin efm (efmls-configs no trae odinfmt) — formateo manual con
	-- vim.lsp.buf.format(), que lo resuelve ols. Requiere `:MasonInstall ols`.
	{ name = "odin", parser = "odin", server = "ols" },
}

---@param spec string  "lint:name" o "fmt:name"
local function efm_tool(spec)
	local kind, name = spec:match("^(%a+):(.+)$")
	local folder = (kind == "lint") and "linters" or "formatters"
	return require("efmls-configs." .. folder .. "." .. name)
end

-- Lista de parsers de treesitter a instalar, sin duplicados
function M.parsers()
	local seen, result = {}, {}
	for _, lang in ipairs(M.list) do
		if lang.parser and not seen[lang.parser] then
			seen[lang.parser] = true
			table.insert(result, lang.parser)
		end
	end
	return result
end

-- Lista de servidores LSP a habilitar (vim.lsp.enable), y sus vim.lsp.config
function M.servers()
	local seen, result = {}, {}
	for _, lang in ipairs(M.list) do
		if lang.server and not seen[lang.server] then
			seen[lang.server] = true
			table.insert(result, { name = lang.server, config = lang.config or {} })
		end
	end
	return result
end

-- Filetypes en los que efm debe registrarse
function M.efm_filetypes()
	local seen, result = {}, {}
	for _, lang in ipairs(M.list) do
		if lang.efm then
			for _, ft in ipairs(lang.filetypes or {}) do
				if not seen[ft] then
					seen[ft] = true
					table.insert(result, ft)
				end
			end
		end
	end
	return result
end

-- Tabla filetype -> lista de herramientas efm (settings.languages de efm)
function M.efm_languages()
	local result = {}
	for _, lang in ipairs(M.list) do
		if lang.efm and lang.filetypes then
			local tools = {}
			for _, spec in ipairs(lang.efm) do
				table.insert(tools, efm_tool(spec))
			end
			for _, ft in ipairs(lang.filetypes) do
				result[ft] = tools
			end
		end
	end
	return result
end

return M
