return {
	{
		"frankroeder/parrot.nvim",
		dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
		-- optionally include "folke/noice.nvim" or "rcarriga/nvim-notify" for beautiful notifications
		config = function()
			require("parrot").setup({
				-- Providers must be explicitly set up to make them available.
				providers = {
					openai = {
						name = "openai",
						api_key = "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",
						endpoint = "https://api.openai.com/v1/chat/completions",
						params = {
							chat = { temperature = 1.1, top_p = 1 },
							command = { temperature = 1.1, top_p = 1 },
						},
						topic = {
							model = "gpt-4.1-nano",
							params = { max_completion_tokens = 64 },
						},
						models = {
							"gpt-4o",
							"o4-mini",
							"gpt-4.1-nano",
						},
					},
				},
			})
		end,
	},
}
