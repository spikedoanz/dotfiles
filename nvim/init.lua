---------------------------
-- spike's neovim config --
---------------------------

local opt = vim.opt

-- editor settings
opt.number = false
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.signcolumn = "no"
opt.shortmess:append("I")
opt.autoread = true
opt.clipboard = "unnamedplus" -- use shared system clipboard
opt.scrolloff = 999           -- Keep cursor centered vertically
opt.sidescrolloff = 8         -- Keep some horizontal context visible

-- inherit terminal colors
opt.termguicolors = false
opt.hlsearch = true

-- extra file extensions
vim.filetype.add({ extension = { ispc = "c", }, }) -- ispc

-- disable swap/backup
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- persistent undo
local undodir = vim.fn.stdpath("data") .. "/undodir"
if not vim.fn.isdirectory(undodir) then
  vim.fn.mkdir(undodir, "p")
end

opt.undofile = true        -- Enable persistent undo
opt.undodir = undodir      -- Set undo directory
opt.undolevels = 10000     -- Maximum number of changes that can be undone
opt.undoreload = 10000     -- Maximum number lines to save for undo on buffer reload

-- tab spacing shortcuts
local function set_tab_width(width)
  opt.tabstop = width
  opt.shiftwidth = width
  print("Tab spacing set to " .. width)
end

-- keymaps
local map = vim.keymap.set
vim.g.mapleader = " "

map("n","<C-b>",":NvimTreeToggle<CR>",{silent=true})

map({'n','i','v'},'<C-J>','10j',{noremap=true,silent=true})
map({'n','i','v'},'<C-K>','10k',{noremap=true,silent=true})

map('n', '<leader>n', ':set number!<CR>', { noremap = true, silent = true })
map('n', '<leader>r', ':set relativenumber!<CR>', { noremap = true, silent = true })

map('n','<leader>t2',function()set_tab_width(2)end,{noremap=true,silent=true})
map('n','<leader>t4',function()set_tab_width(4)end,{noremap=true,silent=true})

-- Magma.nvim keybindings
map('n', '<LocalLeader>r', ':MagmaEvaluateOperator<CR>', { noremap = true, silent = true })
map('n', '<LocalLeader>rr', ':MagmaEvaluateLine<CR>', { noremap = true, silent = true })
map('v', '<LocalLeader>r', ':MagmaEvaluateVisual<CR>', { noremap = true, silent = true })
map('n', '<LocalLeader>rc', ':MagmaReevaluateCell<CR>', { noremap = true, silent = true })
map('n', '<LocalLeader>rd', ':MagmaDelete<CR>', { noremap = true, silent = true })
map('n', '<LocalLeader>ro', ':MagmaShowOutput<CR>', { noremap = true, silent = true })

-- Magma.nvim settings
vim.g.magma_automatically_open_output = false
vim.g.magma_image_provider = "ueberzug"

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },

  { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      map("n", "<leader>ff", builtin.find_files)
      map("n", "<leader>fg", builtin.live_grep)
      map("n", "<leader>fb", builtin.buffers)
      map("n", "<leader>fh", builtin.help_tags)
    end,
  },

  { "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Pyright setup
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- Clangd setup
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
        },
      })

      -- LSP keybindings
      local opts = { noremap = true, silent = true }
      map('n', 'gD', vim.lsp.buf.declaration, opts)
      map('n', 'gd', vim.lsp.buf.definition, opts)
      map('n', 'K', vim.lsp.buf.hover, opts)
      -- Diagnostic navigation
      map('n', '[d', vim.diagnostic.goto_prev, opts)
      map('n', ']d', vim.diagnostic.goto_next, opts)
    end,
  },
})

-- disable error highlighting in markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.cmd("highlight link markdownError NONE")
  end,
})
