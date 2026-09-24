-- ============================================================================
-- PLUGIN CONFIGS
-- Un archivo por plugin. El orden acá importa en dos casos puntuales:
--   - plugins.efm tiene que ir antes que plugins.lspconfig (que hace vim.lsp.enable)
--   - plugins.blink tiene que ir antes que plugins.rustaceanvim (usa sus capabilities)
-- ============================================================================

require("plugins.treesitter")
require("plugins.telescope")
require("plugins.commentstring")
require("plugins.mini")
require("plugins.mason")
require("plugins.blink")
require("plugins.rustaceanvim")
require("plugins.efm")
require("plugins.lspconfig")
require("plugins.todo-comments")
require("plugins.rose-pine")
