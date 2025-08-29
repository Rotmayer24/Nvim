-- Отключаем ввод "Esc + Space" и вешаем на него TreeNvim
vim.keymap.set("n", "<Esc><Space>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
