-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local k = vim.keymap

k.set("n", "<leader>rr", ":CompetiTest run<CR>")
k.set("n", "<leader>ra", ":CompetiTest add_testcase<CR>")
k.set("n", "<leader>re", ":CompetiTest edit_testcase<CR>")
k.set("n", "<leader>rd", ":CompetiTest delete_testcase<CR>")
k.set("n", "<leader>rt", ":CompetiTest receive testcases<CR>")
k.set("n", "<leader>rp", ":CompetiTest receive problem<CR>")
k.set("n", "<leader>rc", ":CompetiTest receive contest<CR>")

--k.set("n", "<leader>rv", ":CompetiTest edit_testcase<Enter><CR>")
k.set("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = false })
