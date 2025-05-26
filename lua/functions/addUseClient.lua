function _G._add_use_client()
  local bufnr = vim.api.nvim_get_current_buf()
  local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)

  -- Check if "use client" is already present
  if first_line[1] and first_line[1]:match '^"use client"$' then
    print "'use client' is already at the top of the file."
    return
  end

  -- Insert "use client" at the top
  vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { '"use client"' })
end

vim.api.nvim_set_keymap('n', '<leader>nu', ':lua _add_use_client()<CR>',
  { noremap = true, silent = true, desc = 'Add "[u]se client" to top' })
