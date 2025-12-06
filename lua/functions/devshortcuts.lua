local M = {}

local function ensure_dir(path)
  vim.fn.mkdir(path, "p")
end

local function write_file(path, content)
  local f = io.open(path, "w")
  if not f then
    vim.notify("Failed to create file: " .. path, vim.log.levels.ERROR)
    return false
  end
  f:write(content)
  f:close()
  return true
end

function M.create_next_page()
  local name = vim.fn.input("Page path (e.g. dashboard): ")
  if name == "" then
    return
  end
  local root = vim.fn.getcwd() .. "/app/" .. name
  ensure_dir(root)
  local path = root .. "/page.tsx"
  if vim.loop.fs_stat(path) then
    vim.notify("page.tsx already exists at " .. path, vim.log.levels.WARN)
  else
    local tpl = [[
export default function %s() {
  return (
    <section>
      <h1>%s page</h1>
    </section>
  );
}
]]
    local pascal = name:gsub("(%a)([%w_]*)", function(a, b)
      return a:upper() .. b:lower()
    end)
    write_file(path, string.format(tpl, pascal, name))
  end
  vim.cmd.edit(path)
end

function M.create_api_route()
  local name = vim.fn.input("API route (e.g. users): ")
  if name == "" then
    return
  end
  local root = vim.fn.getcwd() .. "/app/api/" .. name
  ensure_dir(root)
  local path = root .. "/route.ts"
  if vim.loop.fs_stat(path) then
    vim.notify("route.ts already exists at " .. path, vim.log.levels.WARN)
  else
    local tpl = [[
import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({ ok: true });
}
]]
    write_file(path, tpl)
  end
  vim.cmd.edit(path)
end

function M.toggle_test_file()
  local buf = vim.api.nvim_buf_get_name(0)
  if buf == "" then
    return
  end
  local dir = vim.fn.fnamemodify(buf, ":h")
  local file = vim.fn.fnamemodify(buf, ":t")
  local base, ext = file:match("^(.*)%.([%w]+)$")
  if not base or not ext then
    return
  end
  local target
  if base:match("%.test$") then
    target = dir .. "/" .. base:gsub("%.test$", "") .. "." .. ext
  else
    target = dir .. "/" .. base .. ".test." .. ext
  end
  if not vim.loop.fs_stat(target) then
    write_file(target, "// test for " .. file .. "\n")
  end
  vim.cmd.edit(target)
end

local function sort_tailwind_on_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local patterns = {
    'className%s*=%s*"([^"]*)"',
    "className%s*=%s*'([^']*)'",
    'class%s*=%s*"([^"]*)"',
    "class%s*=%s*'([^']*)'",
  }
  local found = false
  for _, pat in ipairs(patterns) do
    local m = line:match(pat)
    if m then
      local classes = {}
      for c in m:gmatch("%S+") do
        classes[#classes + 1] = c
      end
      table.sort(classes)
      local sorted = table.concat(classes, " ")
      line = line:gsub(pat, function()
        return pat:sub(1, 5):find("class") and (pat:sub(1, 5):match("class") .. '="' .. sorted .. '"') or ''
      end, 1)
      found = true
      break
    end
  end
  if found then
    vim.api.nvim_set_current_line(line)
    vim.notify("Sorted tailwind classes", vim.log.levels.INFO)
  else
    vim.notify("No class/className found on this line", vim.log.levels.WARN)
  end
end

function M.sort_tailwind()
  sort_tailwind_on_line()
end

function M.wrap_jsx_fragment()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" then
    return
  end
  local _, ls, cs = unpack(vim.fn.getpos("'<"))
  local _, le, ce = unpack(vim.fn.getpos("'>"))
  local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
  if #lines == 0 then
    return
  end
  lines[1] = "<>\n" .. lines[1]
  lines[#lines] = lines[#lines] .. "\n</>"
  vim.api.nvim_buf_set_lines(0, ls - 1, le, false, lines)
end

return M
