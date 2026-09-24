-- treesitter-aware comment strings (correct comment syntax inside embedded
-- regions, e.g. JS inside JSX/Vue/Svelte) — mini.comment lo usa en
-- plugins/mini.lua
require("ts_context_commentstring").setup({
	enable_autocmd = false,
})
