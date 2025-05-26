-- ~/.config/nvim/lua/keymaps.lua
-- Import Custom function
require("functions")

-- General Key Mappings
vim.keymap.set("n", "<leader>q", ":q<CR>", {
    silent = true,
    desc = "Quick quit"
}) -- Quick quit
vim.keymap.set("n", "<leader>w", ":w<CR>", {
    silent = true,
    desc = "Save file"
}) -- Save file
vim.keymap.set("n", "<leader>c", ":bdelete<CR>", {
    silent = true,
    desc = "Close buffer"
}) -- Close buffer

-- Telescope Key Mappings
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {
    desc = "Find Files"
})
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {
    desc = "Live Grep"
})
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {
    desc = "Find Buffers"
})
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", {
    desc = "Git Status"
})

-- NvimTree Key Mappings
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", {
    desc = "Toggle NvimTree"
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", {
    desc = "Focus NvimTree"
})

-- Which-key Key Mappings
vim.keymap.set("n", "<leader>?", function()
    require("which-key").show({
        global = false
    })
end, {
    desc = "Buffer Local Keymaps"
})

-- Comment.nvim Key Mappings
vim.keymap.set("n", "<leader>/", "<cmd>CommentToggle<CR>", {
    desc = "Toggle Comment"
})
vim.keymap.set("v", "<leader>/", "<cmd>CommentToggle<CR>", {
    desc = "Toggle Comment in Visual Mode"
})

-- Trouble.nvim Key Mappings
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<CR>", {
    desc = "Toggle Trouble"
})

-- Gitsigns.nvim Key Mappings
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", {
    desc = "Next Git Hunk"
})
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", {
    desc = "Previous Git Hunk"
})
vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", {
    desc = "Stage Git Hunk"
})

-- Nvim Autopairs Key Mappings
vim.keymap.set("i", "<C-l>", "<cmd>lua require('nvim-autopairs').close()<CR>", {
    desc = "Close Pairs"
})

-- Emmet-LS Key Mappings
vim.keymap.set("i", "<C-y>", "<cmd>EmmetExpandAbbr<CR>", {
    desc = "Expand Emmet Abbreviation"
})

-- Go.nvim Key Mappings
vim.keymap.set("n", "<leader>gf", "<cmd>GoFmt<CR>", {
    desc = "GoFmt"
})
vim.keymap.set("n", "<leader>gd", "<cmd>GoDef<CR>", {
    desc = "Go to Definition"
})
vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", {
    desc = "Go Test"
})

vim.keymap.set("n", "<C-Space>", ":lua tree_actions_menu() <CR>", {
    buffer = buffer,
    noremap = true
})

vim.api.nvim_set_keymap("n", "<C-G>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>pf", "<cmd>!npx prettier --write %<CR>", {
    desc = "Format with Prettier"
})

vim.api.nvim_set_keymap("n", "<leader>nc", ":lua _add_use_client()<CR>", { noremap = true, silent = true })
