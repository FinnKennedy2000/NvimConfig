return {{
    "stevearc/conform.nvim",
    event = {"BufReadPre", "BufWritePre", "BufNewFile"},
    config = function()
        local conform = require("conform")

        -- Ensure formatter binaries are discoverable even when installed globally
        local function prepend_to_path(dir)
            if dir and dir ~= "" and vim.fn.isdirectory(dir) == 1 then
                vim.env.PATH = dir .. ":" .. vim.env.PATH
            end
        end
        prepend_to_path(vim.fn.expand("~/.composer/vendor/bin"))
        prepend_to_path(vim.fn.expand("~/.config/composer/vendor/bin"))
        prepend_to_path(vim.fn.systemlist("npm root -g")[1])

        conform.setup({
            formatters = {
                prettier = {
                    prepend_args = {"--tab-width", "2", "--use-tabs", "false"}
                },
                php_cs_fixer = {
                    env = { PHP_CS_FIXER_IGNORE_ENV = "1" },
                },
                prettier_php = (function()
                    local npm_root = vim.fn.systemlist("npm root -g")[1] or ""
                    return {
                        command = "prettier",
                        prefer_local = false, -- always use global prettier, ignore per-project installs
                        args = {
                            "--stdin-filepath",
                            "$FILENAME",
                            "--plugin",
                            "@prettier/plugin-php",
                            "--plugin-search-dir",
                            "/usr/lib/node_modules",
                            "--plugin-search-dir",
                            npm_root,
                            "--parser",
                            "php",
                            "--tab-width",
                            "2",
                            "--use-tabs",
                            "false"
                        },
                    }
                end)(),
            },
            formatters_by_ft = {
                css = {"prettierd", "prettier"},
                graphql = {"prettierd", "prettier"},
                html = {"prettierd", "prettier"},
                javascript = {"prettierd", "prettier"},
                javascriptreact = {"prettierd", "prettier"},
                json = {"prettierd", "prettier"},
                lua = {"stylua"},
                markdown = {"prettierd", "prettier"},
                php = {"pint", "php_cs_fixer", "prettier_php"},
                python = {"isort", "black"},
                sql = {"sql-formatter"},
                svelte = {"prettierd", "prettier"},
                typescript = {"prettierd", "prettier", "sql-formatter"},
                typescriptreact = {"prettierd", "prettier"},
                yaml = {"prettier"},
                xml = {"xmlformatter"}
            }
        })

        vim.keymap.set({"n"}, "<leader>f", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
                stop_after_first = true
            })
        end, {
            desc = '[F]ormat buffer'
        })

        vim.keymap.set({"v"}, "<leader>f", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
                stop_after_first = true
            })
        end, {
            desc = "format selection"
        })

        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = {args.line1, 0},
                    ["end"] = {args.line2, end_line:len()}
                }
            end

            conform.format({
                async = true,
                lsp_fallback = true,
                range = range,
                stop_after_first = true
            })
        end, {
            range = true
        })
    end
}}
