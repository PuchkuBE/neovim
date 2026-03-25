return
{
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local lsp_servers = {
      lua_ls = {
        Lua = {
          workspace = {
            library = vim.api.nvim_get_runtime_file("lua", true),
          },
        },
      },
    }

    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-tool-installer").setup({
      ensure_installed = vim.tbl_keys(lsp_servers),
    })

    for server, config in pairs(lsp_servers) do
      vim.lsp.config(server, {
        settings = config,
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "grd", vim.lsp.buf.definition,
            { buffer = bufnr, desc = "vim.lsp.buf.definition()" })
          vim.keymap.set("n", "grf", vim.lsp.buf.format,
            { buffer = bufnr, desc = "vim.lsp.buf.format()" })
        end,
      })
    end
  end,
}
