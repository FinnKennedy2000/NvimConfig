return {
  {
    -- Main LSP setup
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Mason: LSP installer UI
      {
        'williamboman/mason.nvim',
        opts = {}
      },

      -- Bridge Mason to lspconfig
      {
        'williamboman/mason-lspconfig.nvim',
        opts = {}
      },

      -- Automatically install servers
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
          ensure_installed = {
            "lua-language-server",
            "typescript-language-server",
            "gopls",
            "pyright",
          },
          auto_update = true,
          run_on_start = true,
        }
      },

      -- LSP progress UI
      {
        'j-hui/fidget.nvim',
        opts = {},
      },

      -- LSP completion source
      'hrsh7th/cmp-nvim-lsp',
    },

    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Optional: Custom on_attach function for LSP keybindings
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

      -- Configure your LSP servers here
      local servers = {
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { "vim" },
            },
          }
        },
        ts_ls = {},
        gopls = {},
        pyright = {},
      }

      for name, opts in pairs(servers) do
        lspconfig[name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = opts,
        }
      end
    end
  },

  {
    -- Handles renaming, moving, etc. of files with LSP awareness
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end
  }
}
