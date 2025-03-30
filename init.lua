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
}, {"williamboman/mason-lspconfig.nvim"}, {"hrsh7th/nvim-cmp"}, {"hrsh7th/cmp-nvim-lsp"}, {"L3MON4D3/LuaSnip"},
-- Next.js, React, Tailwind & SCSS
{"jose-elias-alvarez/typescript.nvim"}, {"aca/emmet-ls"}, -- PHP & Twig
{
    "phpactor/phpactor",
    build = "composer install --no-dev -o"
}, {"lumiliet/vim-twig"}, -- Go
{"ray-x/go.nvim"}, -- Misc
{"folke/trouble.nvim"}, {
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
