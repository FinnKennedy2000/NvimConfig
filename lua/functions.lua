function _G.create_react_component(api)
    -- Get the current directory safely
    local node = api.tree.get_node_under_cursor()
    local default_path = node and node.absolute_path or vim.fn.getcwd()

    -- Ask for the component path (showing the default path)
    local user_input = vim.fn.input("Component Path (" .. default_path .. "/): ")

    -- If user entered nothing, cancel
    if user_input == "" then
        print("Cancelled.")
        return
    end

    -- Normalize the path (append to default path if relative)
    local folder_path = user_input:match("^/") and user_input or (default_path .. "/" .. user_input)

    -- Extract the component name from the last part of the path
    local folder_name = folder_path:match("([^/]+)$")

    -- Convert name to PascalCase
    local function to_pascal_case(str)
        return str:gsub("(%a)([%w_]*)", function(a, b)
            return a:upper() .. b:lower()
        end)
    end
    local component_name = to_pascal_case(folder_name)

    -- Create the folder
    vim.fn.mkdir(folder_path, "p")

    -- Component template
    local component_template = string.format([[
import React from "react";

export const %s = () => {
return <p>new component</p>;
};

]], component_name)

    -- Write the file
    local file_path = folder_path .. "/index.tsx"
    local file = io.open(file_path, "w")
    if file then
        file:write(component_template)
        file:close()
        print("Component created: " .. file_path)
    else
        print("Failed to create file.")
    end

    -- Check if index.ts exists in the directory and create it if missing
    local index_ts_path = folder_path:gsub("[^/]+$", "") .. "index.ts"
    if not vim.loop.fs_stat(index_ts_path) then
        local index_file = io.open(index_ts_path, "w")
        if index_file then
            index_file:write("export * from './" .. folder_name .. "';\n")
            index_file:close()
            print("Created index.ts for exports.")
        end
    else
        -- Append export line if not already present
        local existing_content = io.open(index_ts_path, "r"):read("*a")
        if not existing_content:match("export %* from './" .. folder_name .. "';") then
            local index_file = io.open(index_ts_path, "a")
            index_file:write("export * from './" .. folder_name .. "';\n")
            index_file:close()
            print("Updated index.ts with export.")
        end
    end

    -- Open the new file in Neovim
    vim.cmd("edit " .. file_path)
end

local tree_actions = {{
    name = "Create node",
    handler = require("nvim-tree.api").fs.create
}, {
    name = "Remove node",
    handler = require("nvim-tree.api").fs.remove
}, {
    name = "Trash node",
    handler = require("nvim-tree.api").fs.trash
}, {
    name = "Rename node",
    handler = require("nvim-tree.api").fs.rename
}, {
    name = "Fully rename node",
    handler = require("nvim-tree.api").fs.rename_sub
}, {
    name = "Copy",
    handler = require("nvim-tree.api").fs.copy.node
}, {
    name = "Create component",
    handler = function(node)
        _G.create_react_component(require("nvim-tree.api")) -- Pass the node to the function
    end
} -- ... other custom actions you may want to display in the menu
}

function _G.tree_actions_menu(node)
    local entry_maker = function(menu_item)
        return {
            value = menu_item,
            ordinal = menu_item.name,
            display = menu_item.name
        }
    end

    local finder = require("telescope.finders").new_table({
        results = tree_actions,
        entry_maker = entry_maker
    })

    local sorter = require("telescope.sorters").get_generic_fuzzy_sorter()

    local default_options = {
        finder = finder,
        sorter = sorter,
        attach_mappings = function(prompt_buffer_number)
            local actions = require("telescope.actions")

            -- On item select
            actions.select_default:replace(function()
                local state = require("telescope.actions.state")
                local selection = state.get_selected_entry()
                -- Closing the picker
                actions.close(prompt_buffer_number)
                -- Executing the callback
                selection.value.handler(node)
            end)

            -- The following actions are disabled in this example
            -- You may want to map them too depending on your needs though
            actions.add_selection:replace(function()
            end)
            actions.remove_selection:replace(function()
            end)
            actions.toggle_selection:replace(function()
            end)
            actions.select_all:replace(function()
            end)
            actions.drop_all:replace(function()
            end)
            actions.toggle_all:replace(function()
            end)

            return true
        end
    }

    -- Opening the menu
    require("telescope.pickers").new({
        prompt_title = "Tree menu"
    }, default_options):find()
end


local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
  -- function to run on closing the terminal
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})

function _G._lazygit_toggle()
  lazygit:toggle()
end

