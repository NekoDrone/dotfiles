require('Serenity.commands')
require('Serenity.lspconfig-remap')

local function newTab ()
    vim.cmd.tabnew()
    vim.cmd.NvimTreeToggle()
end

vim.g.mapleader = "Q"
vim.keymap.set("n", "<leader>x", vim.cmd.Ex)
vim.keymap.set("n", "<leader>t", newTab)
vim.keymap.set("n", "<C-.>", vim.cmd.tabnext)
vim.keymap.set("n", "<C-,>", function() vim.cmd.tabnext("-") end)

function EscapeInsert()
    local buftype = vim.bo.buftype
    if buftype == "" then
     vim.cmd.w()
     vim.cmd.stopinsert()
    end
end
vim.keymap.set("i", "<Esc>", "<Esc>:lua EscapeInsert()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>Q", "<cmd>Telescope git_files<cr>")
