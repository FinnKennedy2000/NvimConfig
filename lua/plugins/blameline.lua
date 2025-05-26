return {
  {
    'tveskag/nvim-blame-line',
    config = function()
      vim.keymap.set('n', '<leader>b', '<cmd>ToggleBlameLine<CR>', { desc = '[B]lame Line' })
    end,
  },
}
