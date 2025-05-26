return {{
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    config = function()
        vim.opt.list = true
        -- vim.opt.listchars:append("space:⋅")
        -- vim.opt.listchars:append("eol:↴")

        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }

        local hooks = require "ibl.hooks"
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#9B6B6B" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#B8A67B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#7B8FA3" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#A38B7B" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#7B9B7B" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#8B7B9B" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#7B9B9B" })
        end)

        require("ibl").setup {
            exclude = {
                filetypes = {"help", "dashboard", "packer", "NvimTree", "Trouble", "TelescopePrompt", "Float"},
                buftypes = {"terminal", "nofile", "telescope"}
            },
            indent = {
                char = "│",
                highlight = highlight
            },
            scope = {
                enabled = true,
                show_start = false
            }
        }
    end
}}
