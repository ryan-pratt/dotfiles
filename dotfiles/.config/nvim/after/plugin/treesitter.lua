local langs = { 'vimdoc', 'javascript', 'typescript', 'c', 'lua', 'rust', 'vue', 'ruby' }

require('nvim-treesitter').install(langs)

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'vue', 'ruby', 'rust', 'javascript', 'typescript' },
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
