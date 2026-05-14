return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'scss' },
        auto_install = true,
      }

      -- Disable treesitter highlighting for markdown (use regex instead)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'markdown', 'markdown_inline' },
        callback = function(args)
          pcall(vim.treesitter.stop, args.buf)
        end,
      })
    end,
  },
}
