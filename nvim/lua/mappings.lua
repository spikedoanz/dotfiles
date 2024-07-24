require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "J", "10j", { desc = "Reasonably go down" })
map("n", "U", "10k", { desc = "Reasonably go up " })



-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
