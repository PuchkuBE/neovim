---------------------------------------------------------------------
-- LEADER
---------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

---------------------------------------------------------------------
-- OPTIONS
---------------------------------------------------------------------
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.wrap = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80
vim.opt.scrolloff = 10

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  virtual_text = true,
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

---------------------------------------------------------------------
-- LAZY BOOTSTRAP
---------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

---------------------------------------------------------------------
-- PLUGINS
---------------------------------------------------------------------
require("lazy").setup({

  -------------------------------------------------------------------
  -- Colorscheme
  -------------------------------------------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -------------------------------------------------------------------
  -- Treesitter
  -------------------------------------------------------------------
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
        auto_install = true, -- autoinstall languages that are not installed yet
        highlight = {
          enable = true,
        },
      })
    end,
  },

  -------------------------------------------------------------------
  -- Completion (blink.cmp)
  -------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    config = function()
      require("blink.cmp").setup({
        completion = { documentation = { auto_show = true } },
        keymap = {
          ["<C-n>"] = { "select_next", "fallback_to_mappings" },
          ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
          ["<C-y>"] = { "select_and_accept", "fallback" },
          ["<C-e>"] = { "cancel", "fallback" },
          ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
          ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
          ["<CR>"] = { "select_and_accept", "fallback" },
          ["<Esc>"] = { "cancel", "hide_documentation", "fallback" },
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },
          ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        },
        fuzzy = { implementation = "lua" },
      })
    end,
  },

  -------------------------------------------------------------------
  -- LSP (Neovim 0.11 API)
  -------------------------------------------------------------------
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
  },

  -------------------------------------------------------------------
  -- Telescope
  -------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Telescope",
    config = function()
      require("telescope").setup({})
      local pickers = require("telescope.builtin")

      vim.keymap.set("n", "<leader>sp", pickers.builtin, { desc = "[S]earch Builtin [P]ickers" })
      vim.keymap.set("n", "<leader>sb", pickers.buffers, { desc = "[S]earch [B]uffers" })
      vim.keymap.set("n", "<leader>sf", pickers.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>sw", pickers.grep_string, { desc = "[S]earch Current [W]ord" })
      vim.keymap.set("n", "<leader>sg", pickers.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sr", pickers.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>sh", pickers.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sm", pickers.man_pages, { desc = "[S]earch [M]anuals" })
    end,
  },

  -------------------------------------------------------------------
  -- Lualine
  -------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
      })
    end,
  },

  -------------------------------------------------------------------
  -- Which-key
  -------------------------------------------------------------------
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
  },

  -------------------------------------------------------------------
  -- Utility plugins
  -------------------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    config = function()
      require("todo-comments").setup()
    end,
    },

    -------------------------------------------------------------------
    -- mini.files (file explorer)
    -------------------------------------------------------------------
    {
      "echasnovski/mini.files",
      version = false,   -- always use latest
      lazy = false,      -- load at startup (fast enough)
      config = function()
            require("mini.files").setup({
                mappings = {
                    close       = 'q',
                    go_in       = 'l',
                    go_in_plus  = 'L',
                    go_out      = 'h',
                    go_out_plus = 'H',
                    mark_goto   = "'",
                    mark_set    = 'm',
                    reset       = '<BS>',
                    reveal_cwd  = '@',
                    show_help   = 'g?',
                    synchronize = '=',
                    trim_left   = '<',
                    trim_right  = '>',
                    },
                -- General options
                options = {
                  -- Whether to delete permanently or move into module-specific trash
                  permanent_delete = true,
                  -- Whether to use for editing directories
                  use_as_default_explorer = true,
                },
                -- Customization of explorer windows
                windows = {
                  -- Maximum number of windows to show side by side
                  max_number = math.huge,
                  -- Whether to show preview of file/directory under cursor
                  preview = false,
                  -- Width of focused window
                  width_focus = 50,
                  -- Width of non-focused window
                  width_nofocus = 15,
                  -- Width of preview window
                  width_preview = 25,
                    },
        })

        -- Keymap: open mini.files in the current directory
        vim.keymap.set("n", "<leader>e", function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0))
        end, { desc = "Open Mini Files" })
      end,
    },

    {
      "stevearc/oil.nvim",
      version = false,   -- always use latest
      lazy = false,      -- load at startup (fast enough)
      config = function()
            require("oil").setup({
                    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
                  -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
                  default_file_explorer = true,
                  -- Id is automatically added at the beginning, and name at the end
                  -- See :help oil-columns
                  columns = {
                    "icon",
                    -- "permissions",
                    -- "size",
                    -- "mtime",
                  },
                  -- Buffer-local options to use for oil buffers
                  buf_options = {
                    buflisted = false,
                    bufhidden = "hide",
                  },
                  -- Window-local options to use for oil buffers
                  win_options = {
                    wrap = false,
                    signcolumn = "no",
                    cursorcolumn = false,
                    foldcolumn = "0",
                    spell = false,
                    list = false,
                    conceallevel = 3,
                    concealcursor = "nvic",
                  },
                  -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
                  delete_to_trash = false,
                  -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
                  skip_confirm_for_simple_edits = false,
                  -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
                  -- (:help prompt_save_on_select_new_entry)
                  prompt_save_on_select_new_entry = true,
                  -- Oil will automatically delete hidden buffers after this delay
                  -- You can set the delay to false to disable cleanup entirely
                  -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
                  cleanup_delay_ms = 2000,
                  lsp_file_methods = {
                    -- Enable or disable LSP file operations
                    enabled = true,
                    -- Time to wait for LSP file operations to complete before skipping
                    timeout_ms = 1000,
                    -- Set to true to autosave buffers that are updated with LSP willRenameFiles
                    -- Set to "unmodified" to only save unmodified buffers
                    autosave_changes = false,
                  },
                  -- Constrain the cursor to the editable parts of the oil buffer
                  -- Set to `false` to disable, or "name" to keep it on the file names
                  constrain_cursor = "editable",
                  -- Set to true to watch the filesystem for changes and reload oil
                  watch_for_changes = false,
                  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
                  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
                  -- Additionally, if it is a string that matches "actions.<name>",
                  -- it will use the mapping at require("oil.actions").<name>
                  -- Set to `false` to remove a keymap
                  -- See :help oil-actions for a list of all available actions
                  keymaps = {
                    ["g?"] = { "actions.show_help", mode = "n" },
                    ["<CR>"] = "actions.select",
                    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                    ["<C-t>"] = { "actions.select", opts = { tab = true } },
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = { "actions.close", mode = "n" },
                    ["<C-l>"] = "actions.refresh",
                    ["-"] = { "actions.parent", mode = "n" },
                    ["_"] = { "actions.open_cwd", mode = "n" },
                    ["`"] = { "actions.cd", mode = "n" },
                    ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                    ["gs"] = { "actions.change_sort", mode = "n" },
                    ["gx"] = "actions.open_external",
                    ["g."] = { "actions.toggle_hidden", mode = "n" },
                    ["g\\"] = { "actions.toggle_trash", mode = "n" },
                  },
                  -- Set to false to disable all of the above keymaps
                  use_default_keymaps = true,
                  view_options = {
                    -- Show files and directories that start with "."
                    show_hidden = false,
                    -- This function defines what is considered a "hidden" file
                    is_hidden_file = function(name, bufnr)
                      local m = name:match("^%.")
                      return m ~= nil
                    end,
                    -- This function defines what will never be shown, even when `show_hidden` is set
                    is_always_hidden = function(name, bufnr)
                      return false
                    end,
                    -- Sort file names with numbers in a more intuitive order for humans.
                    -- Can be "fast", true, or false. "fast" will turn it off for large directories.
                    natural_order = "fast",
                    -- Sort file and directory names case insensitive
                    case_insensitive = false,
                    sort = {
                      -- sort order can be "asc" or "desc"
                      -- see :help oil-columns to see which columns are sortable
                      { "type", "asc" },
                      { "name", "asc" },
                    },
                    -- Customize the highlight group for the file name
                    highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
                      return nil
                    end,
                  },
                  -- Extra arguments to pass to SCP when moving/copying files over SSH
                  extra_scp_args = {},
                  -- Extra arguments to pass to aws s3 when creating/deleting/moving/copying files using aws s3
                  extra_s3_args = {},
                  -- EXPERIMENTAL support for performing file operations with git
                  git = {
                    -- Return true to automatically git add/mv/rm files
                    add = function(path)
                      return false
                    end,
                    mv = function(src_path, dest_path)
                      return false
                    end,
                    rm = function(path)
                      return false
                    end,
                  },
                  -- Configuration for the floating window in oil.open_float
                  float = {
                    -- Padding around the floating window
                    padding = 2,
                    -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                    max_width = 0,
                    max_height = 0,
                    border = nil,
                    win_options = {
                      winblend = 0,
                    },
                    -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
                    get_win_title = nil,
                    -- preview_split: Split direction: "auto", "left", "right", "above", "below".
                    preview_split = "auto",
                    -- This is the config that will be passed to nvim_open_win.
                    -- Change values here to customize the layout
                    override = function(conf)
                      return conf
                    end,
                  },
                  -- Configuration for the file preview window
                  preview_win = {
                    -- Whether the preview window is automatically updated when the cursor is moved
                    update_on_cursor_moved = true,
                    -- How to open the preview window "load"|"scratch"|"fast_scratch"
                    preview_method = "fast_scratch",
                    -- A function that returns true to disable preview on a file e.g. to avoid lag
                    disable_preview = function(filename)
                      return false
                    end,
                    -- Window-local options to use for preview window buffers
                    win_options = {},
                  },
                  -- Configuration for the floating action confirmation window
                  confirmation = {
                    -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                    -- min_width and max_width can be a single value or a list of mixed integer/float types.
                    -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
                    max_width = 0.9,
                    -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
                    min_width = { 40, 0.4 },
                    -- optionally define an integer/float for the exact width of the preview window
                    width = nil,
                    -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                    -- min_height and max_height can be a single value or a list of mixed integer/float types.
                    -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
                    max_height = 0.9,
                    -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
                    min_height = { 5, 0.1 },
                    -- optionally define an integer/float for the exact height of the preview window
                    height = nil,
                    border = nil,
                    win_options = {
                      winblend = 0,
                    },
                  },
                  -- Configuration for the floating progress window
                  progress = {
                    max_width = 0.9,
                    min_width = { 40, 0.4 },
                    width = nil,
                    max_height = { 10, 0.9 },
                    min_height = { 5, 0.1 },
                    height = nil,
                    border = nil,
                    minimized_border = "none",
                    win_options = {
                      winblend = 0,
                    },
                  },
                  -- Configuration for the floating SSH window
                  ssh = {
                    border = nil,
                  },
                  -- Configuration for the floating keymaps help window
                  keymaps_help = {
                    border = nil,
                  },
        })

        -- Keymap: vinegar method of navigation
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      end,
    },

})

