return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      { 'williamboman/mason-lspconfig.nvim', opts = {} },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
          ensure_installed = {
            'lua-language-server',
            'typescript-language-server',
            'gopls',
            'pyright',
          },
          auto_update = true,
          run_on_start = true,
        },
      },
      {
        'j-hui/fidget.nvim',
        opts = {
          integration = { ['nvim-tree'] = { enable = false } },
          notification = { window = { avoid = { filetypes = { 'NvimTree' } } } },
        },
      },
      'hrsh7th/cmp-nvim-lsp',
    },

    config = function()
      -- Apply capabilities to all servers
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      -- Per-server settings
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { 'vim' } },
          },
        },
      })

      vim.lsp.enable({ 'lua_ls', 'ts_ls', 'gopls', 'pyright' })

      -- LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-keymaps', { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end

          nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
          nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<leader>lk', vim.lsp.buf.signature_help, 'Signature Help')
        end,
      })
    end,
  },

  {
    'antosha417/nvim-lsp-file-operations',
    event = 'LspAttach',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim',
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },
}
