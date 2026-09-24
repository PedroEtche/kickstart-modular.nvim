vim.opt.termguicolors = true

-- ============================================================================
-- ENTRY POINT
-- config/*  -> Configuraciones basicas provistas por Neo Vim
-- plugins/* -> un archivo por plugin, requerido en orden desde plugins/init.lua
-- ============================================================================

require("config.options")
require("config.keymaps")
require("config.pack")
require("config.autocmds")
require("plugins")
