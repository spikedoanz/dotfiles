require "nvchad.mappings"

-- Disable mappings
local nomap = vim.keymap.del

nomap("i", "<C-k>")
nomap("n", "<C-c>")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "J", "10j", { desc = "Reasonably go down" })
map("n", "K", "10k", { noremap = false , silent = true, desc = "Reasonably go up " })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
