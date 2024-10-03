vim.keymap.set("n", "<leader>u", function ()
  vim.cmd.UndotreeToggle()
  vim.cmd.UndotreeFocus()
end)

vim.g.undotree_WindowLayout = 2
vim.g.undotree_DiffAutoOpen = 1
vim.g.undotree_SetFocusWhenToggle = 1

