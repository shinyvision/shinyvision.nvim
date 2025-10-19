return {
	{
		"numToStr/Comment.nvim",
		opts = {},
		keys = {
			{ "<Leader>/", function() require("Comment.api").toggle.linewise.current() end, mode = "n", desc = "Toggle comment line" },
			{
				"<Leader>/",
				function()
					local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
					vim.api.nvim_feedkeys(esc, "nx", false)
					require("Comment.api").toggle.linewise(vim.fn.visualmode())
				end,
				mode = "v",
				desc = "Toggle comment block"
			},
		},
	}
}
