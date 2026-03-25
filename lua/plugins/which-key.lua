return
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup({
      spec = {
        { "<leader>s", group = "[S]earch", icon = { icon = "", color = "green" } },
      },
    })
  end,
}
