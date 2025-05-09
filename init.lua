-- Basic settings
vim.opt.number = true -- Show absolute line number on the current line
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 2 -- Tab size of 2 spaces
vim.opt.shiftwidth = 2 -- Indentation size of 2 spaces
vim.opt.expandtab = false -- Use tabs instead of spaces
vim.opt.termguicolors = true -- Enable true color support
vim.opt.clipboard = "unnamedplus" -- System clipboard integration

-- Key mappings
vim.g.mapleader = " " -- Space as leader key

-- Load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end
vim.opt.rtp:prepend(lazypath)

local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.5 -- You can change this too

-- Configure Lazy.nvim
require("lazy").setup({ -- Syntax highlighting
{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
}, -- Fuzzy finder
{
    "nvim-telescope/telescope.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    keys = {{
        "<leader>ff",
        "<cmd>Telescope find_files<CR>",
        desc = "Find files"
    }}
}, -- Theme
{
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000
}, -- File Explorer
{
    "kyazdani42/nvim-tree.lua",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require('nvim-tree').setup({
            view = {
                float = {
                    enable = true,
                    open_win_config = function()
                        local screen_w = vim.opt.columns:get()
                        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                        local window_w = screen_w * WIDTH_RATIO
                        local window_h = screen_h * HEIGHT_RATIO
                        local window_w_int = math.floor(window_w)
                        local window_h_int = math.floor(window_h)
                        local center_x = (screen_w - window_w) / 2
                        local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                        return {
                            border = 'rounded',
                            relative = 'editor',
                            row = center_y,
                            col = center_x,
                            width = window_w_int,
                            height = window_h_int
                        }
                    end
                },
                width = function()
                    return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                end
            }
        })
    end
}, {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {{
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = {
            history = true,
            updateevents = "TextChanged,TextChangedI"
        },
        config = function(_, opts)
            require("luasnip").config.set_config(opts)
            require "configs.luasnip"
        end
    }, -- autopairing of (){}[] etc
    {
        "windwp/nvim-autopairs",
        opts = {
            fast_wrap = {},
            disable_filetype = {"TelescopePrompt", "vim"}
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)

            -- setup cmp for autopairs
            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    }, -- cmp sources plugins
    {"saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer",
     "hrsh7th/cmp-path"}},
    opts = function()
        return require "configs.cmp"
    end
}, {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        require("which-key").setup({})
    end,
    keys = {{
        "<leader>?",
        function()
            require("which-key").show({
                global = false
            })
        end,
        desc = "Buffer Local Keymaps (which-key)"
    }}
}, -- LSP & Autocomplete
{"neovim/nvim-lspconfig"}, {
    "williamboman/mason.nvim",
    config = function()
        require("mason").setup()
    end
}, {
    "williamboman/mason-lspconfig.nvim",
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {"tailwindcss"}
        })
    end
}, {
    "phpactor/phpactor",
    build = "composer install --no-dev -o"
}, {"folke/trouble.nvim"}, {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()
    end
}, {
    "windwp/nvim-autopairs",
    config = function()
        require("nvim-autopairs").setup()
    end
}, {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()
    end
}, {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {"nvim-treesitter/nvim-treesitter", -- Required for Treesitter support
    "nvim-telescope/telescope.nvim", -- Optional, for telescope integration
    "neovim/nvim-lspconfig" -- Optional, for LSP support
    },
    opts = {
        server = {
            override = true, -- setup the server from the plugin if true
            settings = {}, -- shortcut for `settings.tailwindCSS`
            on_attach = function(client, bufnr)
            end -- callback triggered when the server attaches to a buffer
        },
        document_color = {
            enabled = true, -- can be toggled by commands
            kind = "inline", -- "inline" | "foreground" | "background"
            inline_symbol = "󰝤 ", -- only used in inline mode
            debounce = 200 -- in milliseconds, only applied in insert mode
        },
        conceal = {
            enabled = false, -- can be toggled by commands
            min_length = nil, -- only conceal classes exceeding the provided length
            symbol = "󱏿", -- only a single character is allowed
            highlight = { -- extmark highlight options
                fg = "#38BDF8"
            }
        },
        cmp = {
            highlight = "foreground" -- color preview style
        },
        telescope = {
            utilities = {
                callback = function(name, class)
                end -- callback used when selecting an utility class in telescope
            }
        }
    }
}, {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = { --[[ things you want to change go here]] }
}})

require("keymaps") -- Load keymaps

-- Theme settings
vim.g.tokyonight_style = "night" -- Change to "storm" or "moon" if you prefer
vim.cmd("colorscheme tokyonight") -- Apply theme

-- LSP configuration (ensure correct LSP setups for each language server)
local lspconfig = require("lspconfig")
lspconfig.ts_ls.setup({}) -- TypeScript / JavaScript (use ts_ls instead of tsserver)
lspconfig.phpactor.setup({}) -- PHP
lspconfig.gopls.setup({}) -- Go
lspconfig.tailwindcss.setup({
    filetypes = {"html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "tsx", "jsx"},
    cmd = {"tailwindcss-language-server", "--stdio"},
    settings = {
        tailwindCSS = {
            classAttributes = {"class", "className", "class:list", "classList", "ngClass"},
            includeLanguages = {
                typescript = "javascript",
                typescriptreact = "javascript",
                javascriptreact = "javascript",
                eelixir = "html-eex",
                eruby = "erb",
                htmlangular = "html",
                templ = "html"
            },
            validate = true
        }
    }
})
