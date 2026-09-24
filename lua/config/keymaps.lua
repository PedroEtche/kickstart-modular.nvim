-- ============================================================================
-- KEYMAPS
-- Keymaps generales de edición. Los keymaps de un plugin específico viven
-- en su propio archivo dentro de lua/plugins/.
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window/pane" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window/pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window/pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window/pane" })

vim.keymap.set("n", "<leader>Sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>Sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "<leader>pa", function() -- show file path
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	local diagnosticStatus = vim.diagnostic.is_enabled() and "enable" or "disable"
	print("Diagnostic", diagnosticStatus)
end, { desc = "[T]oggle [d]iagnostics" })
