return {
  {
    -- Main LSP setup
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {},
      },
      {
        'williamboman/mason-lspconfig.nvim',
        opts = {},
      },
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
          integration = {
            ['nvim-tree'] = { enable = false },
          },
          notification = {
            window = {
              avoid = { filetypes = { 'NvimTree' } },
            },
          },
        },
      },
      'hrsh7th/cmp-nvim-lsp',
    },

    config = function()
      local configs = require('lspconfig.configs')

      local function server(name)
        local ok, cfg = pcall(require, 'lspconfig.configs.' .. name)
        if ok and configs[name] == nil then
          configs[name] = cfg
        end
        return configs[name]
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local function on_attach(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
      end

      local servers = {
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
        ts_ls = {},
        gopls = {},
        pyright = {},
      }

      for name, opts in pairs(servers) do
        local cfg = server(name)
        if cfg and cfg.setup then
          cfg.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = opts,
          }
        end
      end
    end,
  },

  {
    -- Handles renaming, moving, etc. of files with LSP awareness
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
