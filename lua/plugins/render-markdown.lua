require("render-markdown").setup({
	completions = { blink = { enabled = true } }, -- checkboxes/callouts en blink.cmp
})

vim.keymap.set("n", "<leader>tm", "<cmd>RenderMarkdown toggle<CR>", { desc = "[T]oggle [M]arkdown render" })
