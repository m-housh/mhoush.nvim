-- Markdown specific key maps.

local todos = require("todo-comments")
local keywords = { "WARN", "WARNING", "IMPORTANT" }

-- Show all the warnings in the quick fix list.
vim.keymap.set(
	"n",
	"<leader>tw",
	"<CMD>TodoQuickFix filter = {tag = {WARN, IMPORTANT}}<CR>",
	{ desc = "[T]odo [W]arnings" }
)

vim.keymap.set("n", "<leader>wn", function()
	todos.jump_next({ keywords = keywords })
end, { desc = "[W]arning - [n]ext" })

vim.keymap.set("n", "<leader>wp", function()
	todos.jump_prev({ keywords = keywords })
end, { desc = "[W]arning - [p]revious" })
