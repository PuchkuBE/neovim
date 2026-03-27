return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("nvim-treesitter.config").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
			sync_install = true,
			modules = {},
			ignore_install = {},
			ensure_installed = {
				"go",
				"python",
				"yaml",
				"bash",
				"java",
				"json",
				"lua",
				"c",
			},
			auto_install = true, -- autoinstall languages that are not installed yet
			highlight = {
				enable = true,
			},
		})
	end,
}
