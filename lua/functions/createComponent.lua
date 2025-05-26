function _G.create_react_component()
  -- Default path to components directory
  local default_path = vim.fn.getcwd() .. "/components"

  -- Use vim.ui.input for better UI experience
  vim.ui.input({
    prompt = "Component Name: ",
    default = "",
  }, function(component_name)
    -- If user entered nothing or cancelled, return
    if not component_name or component_name == "" then
      print("Cancelled.")
      return
    end

    -- Convert name to PascalCase
    local function to_pascal_case(str)
      return str:gsub("(%a)([%w_]*)", function(a, b)
        return a:upper() .. b:lower()
      end)
    end
    local pascal_name = to_pascal_case(component_name)

    -- Create the folder path
    local folder_path = default_path .. "/" .. component_name

    -- Create the folder
    vim.fn.mkdir(folder_path, "p")

    -- Component template
    local component_template = string.format([[
import React from "react";

export const %s = () => {
return <p>new component</p>;
};

]], pascal_name)

    -- Write the file
    local file_path = folder_path .. "/" .. component_name .. ".tsx"
    local file = io.open(file_path, "w")
    if file then
      file:write(component_template)
      file:close()
      print("Component created: " .. file_path)
    else
      print("Failed to create file.")
    end

    -- Check if index.ts exists in the components directory and create it if missing
    local index_ts_path = default_path .. "/index.ts"
    if not vim.loop.fs_stat(index_ts_path) then
      local index_file = io.open(index_ts_path, "w")
      if index_file then
        index_file:write("export * from './" .. component_name .. "/" .. component_name .. "';\n")
        index_file:close()
        print("Created index.ts for exports.")
      end
    else
      -- Append export line if not already present
      local existing_content = io.open(index_ts_path, "r"):read("*a")
      if not existing_content:match("export %* from './" .. component_name .. "/" .. component_name .. "';") then
        local index_file = io.open(index_ts_path, "a")
        index_file:write("export * from './" .. component_name .. "/" .. component_name .. "';\n")
        index_file:close()
        print("Updated index.ts with export.")
      end
    end

    -- Open the new file in Neovim
    vim.cmd("edit " .. file_path)
  end)
end
vim.keymap.set('n', '<leader>nc', '<cmd>lua create_react_component()<cr>', { desc = 'Create new [c]omponent' })
