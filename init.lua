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
vim.keymap.set("n", "<leader>q", ":q<CR>", {
    silent = true
}) -- Quick quit

-- Load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- Configure Lazy.nvim
require("lazy").setup({{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
}, -- Syntax highlighting
{
    "nvim-telescope/telescope.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    keys = {{
        "<leader>ff",
        "<cmd>Telescope find_files<CR>",
        desc = "Find files"
    }}
}, -- Fuzzy finder
{
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000
}, -- Theme
{
    "kyazdani42/nvim-tree.lua",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require("nvim-tree").setup()
    end,
    keys = {{
        "<leader>e",
        "<cmd>NvimTreeToggle<CR>",
        desc = "Toggle NvimTree"
    }}
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
}})

-- Theme settings
vim.g.tokyonight_style = "night" -- Change to "storm" or "moon" if you prefer
vim.cmd("colorscheme tokyonight") -- Apply theme
