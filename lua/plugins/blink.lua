local snippet_trigger_text = ";"

return {{
    'saghen/blink.nvim',
    -- Use nightly if available to satisfy blink.cmp's SIMD features; fallback to stable
    build = function()
      local cmd = { 'cargo', 'build', '--release', '--locked' }
      if vim.fn.executable('rustup') == 1 then
        cmd = { 'cargo', '+nightly', 'build', '--release', '--locked' }
        vim.fn.system({ 'rustup', 'toolchain', 'install', 'nightly', '--profile', 'minimal', '--quiet' })
      end
      vim.fn.system(cmd)
    end,
    dependencies = {{
        'saghen/blink.cmp',
        build = function()
          local cmd = { 'cargo', 'build', '--release', '--locked' }
          if vim.fn.executable('rustup') == 1 then
            cmd = { 'cargo', '+nightly', 'build', '--release', '--locked' }
            vim.fn.system({ 'rustup', 'toolchain', 'install', 'nightly', '--profile', 'minimal', '--quiet' })
          end
          vim.fn.system(cmd)
        end, -- ensure fuzzy native lib is built
    }},
    keys = { -- chartoggle
    {
        '<C-;>',
        function()
            require('blink.chartoggle').toggle_char_eol(';')
        end,
        mode = {'n', 'v'},
        desc = 'Toggle ; at eol'
    }, {
        ',',
        function()
            require('blink.chartoggle').toggle_char_eol(',')
        end,
        mode = {'n', 'v'},
        desc = 'Toggle , at eol'
    }, -- tree
    {
        '<C-e>',
        '<cmd>BlinkTree reveal<cr>',
        desc = 'Reveal current file in tree'
    }, {
        '<leader>E',
        '<cmd>BlinkTree toggle<cr>',
        desc = 'Reveal current file in tree'
    }, {
        '<leader>e',
        '<cmd>BlinkTree toggle-focus<cr>',
        desc = 'Toggle file tree focus'
    }},
    -- all modules handle lazy loading internally
    lazy = false,
    opts = {
        chartoggle = {
            enabled = true
        },
        tree = {
            enabled = true
        }
    }
}}
