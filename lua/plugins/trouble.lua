return {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle focus=true<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle focus=true<cr>', desc = 'Quickfix (Trouble)' },
      { '<leader>xl', '<cmd>Trouble loclist toggle focus=true<cr>', desc = 'Location List (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=true<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cS', '<cmd>Trouble lsp toggle focus=true win.position=right<cr>', desc = 'LSP Definitions/References (Trouble)' },
    },
  },
}
