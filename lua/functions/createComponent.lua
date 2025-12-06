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

    -- Convert name to PascalCase (strip non-alphanumeric separators)
    local function to_pascal_case(str)
      local parts = {}
      for word in tostring(str):gmatch("[A-Za-z0-9]+") do
        parts[#parts + 1] = word:sub(1, 1):upper() .. word:sub(2):lower()
      end
      return table.concat(parts)
    end
    local pascal_name = to_pascal_case(component_name)
    if pascal_name == "" then
      print("Invalid component name.")
      return
    end

    -- Create the folder path
    local folder_path = default_path .. "/" .. pascal_name

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
    local file_path = folder_path .. "/" .. pascal_name .. ".tsx"
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
    local export_line = string.format("export * from './%s/%s';\n", pascal_name, pascal_name)
    local index_file = io.open(index_ts_path, "r")
    if not index_file then
      local new_index = io.open(index_ts_path, "w")
      if new_index then
        new_index:write(export_line)
        new_index:close()
        print("Created index.ts for exports.")
      end
    else
      local existing_content = index_file:read("*a") or ""
      index_file:close()
      if not existing_content:find(export_line, 1, true) then
        local append_index = io.open(index_ts_path, "a")
        if append_index then
          append_index:write(export_line)
          append_index:close()
          print("Updated index.ts with export.")
        end
      end
    end

    -- Open the new file in Neovim
    vim.cmd("edit " .. file_path)
  end)
end
vim.keymap.set('n', '<leader>nc', '<cmd>lua create_react_component()<cr>', { desc = 'Create new [c]omponent' })
