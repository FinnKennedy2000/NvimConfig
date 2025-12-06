# Custom Neovim Helpers

Quick reference for the bespoke functions/keymaps in this config.

## Global keymaps
- `<leader>fo`: Format buffer (Conform with LSP fallback).
- `<leader>lr`: Restart LSP.
- `<leader>li`: Show LSP info.
- `<leader>jf` (visual): Wrap selection in `<>...</>` (JSX fragment).
- `<leader>tw`: Sort tailwind classes on the current line.

## Next.js / React helpers
- `<leader>np`: Create a Next.js page scaffold at `app/<name>/page.tsx` and open it.
- `<leader>na`: Create a Next.js API route scaffold at `app/api/<name>/route.ts` and open it.
- `<leader>nt`: Toggle/create sibling test file (`*.test.*`) for the current buffer.
- `<leader>nc`: Create a React component folder/file under `components/` with exports (`createComponent.lua`).
- `<leader>nu`: Add `"use client"` to top of current buffer (`addUseClient.lua`).

## Functions modules
- `lua/functions/addUseClient.lua`: Adds `"use client"` to the top of the current buffer (`<leader>nu`).
- `lua/functions/createComponent.lua`: Prompts for a component name, creates `components/<Name>/<Name>.tsx`, updates/creates `components/index.ts`, opens the new file (`<leader>nc`).
- `lua/functions/devshortcuts.lua`:
  - `create_next_page` (`<leader>np`): Scaffold Next.js page.
  - `create_api_route` (`<leader>na`): Scaffold Next.js API route.
  - `toggle_test_file` (`<leader>nt`): Jump to/create sibling test.
  - `sort_tailwind` (`<leader>tw`): Sort tailwind classes on the current line.
  - `wrap_jsx_fragment` (`<leader>jf` visual): Wrap selection in fragment.

## Notes
- Formatters: PHP tries `pint` → `php-cs-fixer` → `prettier` (with plugin-php). JS/TS/MD/etc. use Prettier/prettierd; Lua uses stylua.
- PATH setup in `setup.sh` includes npm and composer global bins so formatters are discoverable.
