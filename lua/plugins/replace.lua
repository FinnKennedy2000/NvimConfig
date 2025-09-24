return {
	-- Find & Replace like VS Code (project-wide), with Snacks integration
	{
		-- 1) VS Code–style search/replace UI
		"MagicDuck/grug-far.nvim",
		version = "*",
		opts = {
			-- optional: examples of sensible defaults
			-- engine = "rg", -- or "astgrep" if you have ast-grep installed
			-- windowCreationCommand = "vsplit", -- open beside current window
		},
		keys = {
			-- <leader>sr = replace in project (prefill with word/visual selection)
			{
				"<leader>sr",
				function()
					local search = ""
					if vim.fn.mode():match("[vV\22]") then
						-- yank visual selection safely into register z
						local save = vim.fn.getreg("z")
						local save_type = vim.fn.getregtype("z")
						vim.cmd('normal! "zy')
						search = vim.fn.getreg("z")
						vim.fn.setreg("z", save, save_type)
					else
						search = vim.fn.expand("<cword>")
					end
					require("grug-far").open({
						search = search,
						cwd = vim.loop.cwd(), -- project root; adjust if you use a rooter
					})
				end,
				mode = { "n", "x" },
				desc = "Search & Replace (project)",
			},
			-- quick open
			{
				"<leader>sR",
				function()
					require("grug-far").open({ cwd = vim.loop.cwd() })
				end,
				desc = "Open Grug-Far",
			},
		},
	},

	-- 2) Snacks: add an action to send current grep query → Grug-Far
	{
		"folke/snacks.nvim",
		optional = true, -- remove if you already load Snacks explicitly
		opts = {
			picker = {
				actions = {
					-- Called from Snacks grep to open Grug-Far with the same pattern/cwd
					open_in_grug_far = function(picker)
						local pat = picker.input.filter.pattern or picker.input.filter.search
						require("grug-far").open({ search = pat or "", cwd = picker:cwd() })
					end,
				},
				win = {
					input = {
						keys = {
							-- Alt-r while in a Snacks picker = launch Grug-Far with the query
							["<a-r>"] = { "open_in_grug_far", mode = { "n", "i" } },
						},
					},
				},
			},
		},
		keys = {
			-- Snacks live grep (root); then press Alt-r to switch to replace UI
			{
				"<leader>/",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep (Snacks)",
			},
		},
	},
}
