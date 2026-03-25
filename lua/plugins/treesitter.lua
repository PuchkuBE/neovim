return
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.config").setup({
      sync_install = true,
      modules = {},
      ignore_install = {},
      ensure_installed = {
        "lua",
        "c",
        "rust",
        "go",
      },
      auto_install = true,   -- autoinstall languages that are not installed yet
      highlight = {
        enable = true,
      },
    })
  end,
}
