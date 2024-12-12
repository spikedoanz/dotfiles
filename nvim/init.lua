-- init.lua
-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- core options
local opt = vim.opt
vim.g.mapleader = " "

-- disable swap/backup
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- editor settings
opt.number = false
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.signcolumn = "no"
opt.shortmess:append("I")
opt.clipboard = "unnamedplus"
opt.autoread = true

-- disable auto indent
opt.autoindent = false
opt.cindent = false
opt.smartindent = false

-- load math symbols
require("math")

-- auto reload files
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- keymaps
local map = vim.keymap.set

map("n", "<C-b>", ":NvimTreeToggle<CR>", { silent = true })
map({ 'n', 'i', 'v' }, '<C-J>', '10j', { noremap = true, silent = true })
map({ 'n', 'i', 'v' }, '<C-K>', '10k', { noremap = true, silent = true })
map('n', '<leader>n', ':set number!<CR>', { noremap = true, silent = true })
map('n', '<leader>r', ':set relativenumber!<CR>', { noremap = true, silent = true })

-- tab spacing shortcuts
local function set_tab_width(width)
  opt.tabstop = width
  opt.shiftwidth = width
  print("Tab spacing set to " .. width)
end

map('n', '<leader>t2', function() set_tab_width(2) end, { noremap = true, silent = true })
map('n', '<leader>t4', function() set_tab_width(4) end, { noremap = true, silent = true })

-- shared lsp setup
local function on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  
  local opts = { buffer = bufnr }
  map('n', 'gD', vim.lsp.buf.declaration, opts)
  map('n', 'gd', vim.lsp.buf.definition, opts)
  map('n', 'K', vim.lsp.buf.hover, opts)
  map('n', 'gi', vim.lsp.buf.implementation, opts)
  map('n', '<space>D', vim.lsp.buf.type_definition, opts)
  map('n', '<space>rn', vim.lsp.buf.rename, opts)
  map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
  map('n', 'gr', vim.lsp.buf.references, opts)
end

-- plugins
require("lazy").setup({
  -- theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function() vim.cmd.colorscheme "catppuccin" end,
  },

  -- utilities
  { "norcalli/nvim-colorizer.lua", config = true },
  { 
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      map("n", "<leader>ff", builtin.find_files)
      map("n", "<leader>fg", builtin.live_grep)
      map("n", "<leader>fb", builtin.buffers)
      map("n", "<leader>fh", builtin.help_tags)
    end,
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      local lspconfig = require("lspconfig")
      
      -- ruff setup
      lspconfig.ruff_lsp.setup{
        on_attach = on_attach,
        init_options = {
          settings = {
            "--ignore=E701",
            "--extend-ignore=E402,F401"
          }
        }
      }
      -- global diagnostic mappings
      map('n', '<space>e', vim.diagnostic.open_float)
      map('n', '[d', vim.diagnostic.goto_prev)
      map('n', ']d', vim.diagnostic.goto_next)
      map('n', '<space>q', vim.diagnostic.setloclist)
    end,
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- lean
  {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
    },
    opts = {
      lsp = {},
      mappings = true,
    }
  },
})


-- $$math symbols$$
-- greek 
vim.keymap.set('i', '\\alpha', 'α', {buffer = true})
vim.keymap.set('i', '\\a', 'α', {buffer = true}) -- sugar
vim.keymap.set('i', '\\beta', 'β', {buffer = true}) 
vim.keymap.set('i', '\\b', 'β', {buffer = true}) 
vim.keymap.set('i', '\\gamma', 'γ', {buffer = true})
vim.keymap.set('i', '\\delta', 'δ', {buffer = true})
vim.keymap.set('i', '\\epsilon', 'ε', {buffer = true})
vim.keymap.set('i', '\\zeta', 'ζ', {buffer = true})
vim.keymap.set('i', '\\eta', 'η', {buffer = true})
vim.keymap.set('i', '\\theta', 'θ', {buffer = true})
vim.keymap.set('i', '\\lambda', 'λ', {buffer = true})
vim.keymap.set('i', '\\lam', 'λ', {buffer = true}) -- sugar
vim.keymap.set('i', '\\mu', 'μ', {buffer = true})
vim.keymap.set('i', '\\nu', 'ν', {buffer = true})
vim.keymap.set('i', '\\xi', 'ξ', {buffer = true})
vim.keymap.set('i', '\\pi', 'π', {buffer = true})
vim.keymap.set('i', '\\rho', 'ρ', {buffer = true})
vim.keymap.set('i', '\\sigma', 'σ', {buffer = true})
vim.keymap.set('i', '\\tau', 'τ', {buffer = true})
vim.keymap.set('i', '\\phi', 'φ', {buffer = true})
vim.keymap.set('i', '\\chi', 'χ', {buffer = true})
vim.keymap.set('i', '\\psi', 'ψ', {buffer = true})
vim.keymap.set('i', '\\omega', 'ω', {buffer = true})

-- Greek

vim.keymap.set('i', '\\Alpha', 'Α', {buffer = true})
vim.keymap.set('i', '\\Beta', 'Β', {buffer = true})
vim.keymap.set('i', '\\Gamma', 'Γ', {buffer = true})
vim.keymap.set('i', '\\Delta', 'Δ', {buffer = true})
vim.keymap.set('i', '\\Epsilon', 'Ε', {buffer = true})
vim.keymap.set('i', '\\Zeta', 'Ζ', {buffer = true})
vim.keymap.set('i', '\\Eta', 'Η', {buffer = true})
vim.keymap.set('i', '\\Theta', 'Θ', {buffer = true})
vim.keymap.set('i', '\\Iota', 'Ι', {buffer = true})
vim.keymap.set('i', '\\Kappa', 'Κ', {buffer = true})
vim.keymap.set('i', '\\Lambda', 'Λ', {buffer = true})
vim.keymap.set('i', '\\Mu', 'Μ', {buffer = true})
vim.keymap.set('i', '\\Nu', 'Ν', {buffer = true})
vim.keymap.set('i', '\\Xi', 'Ξ', {buffer = true})
vim.keymap.set('i', '\\Omicron', 'Ο', {buffer = true})
vim.keymap.set('i', '\\Pi', 'Π', {buffer = true})
vim.keymap.set('i', '\\Rho', 'Ρ', {buffer = true})
vim.keymap.set('i', '\\Sigma', 'Σ', {buffer = true})
vim.keymap.set('i', '\\Tau', 'Τ', {buffer = true})
vim.keymap.set('i', '\\Upsilon', 'Υ', {buffer = true})
vim.keymap.set('i', '\\Phi', 'Φ', {buffer = true})
vim.keymap.set('i', '\\Chi', 'Χ', {buffer = true})
vim.keymap.set('i', '\\Psi', 'Ψ', {buffer = true})
vim.keymap.set('i', '\\Omega', 'Ω', {buffer = true})

-- operators
vim.keymap.set('i', '\\in', '∈', {buffer = true})
vim.keymap.set('i', '\\notin', '∉', {buffer = true})
vim.keymap.set('i', '\\union', '∪', {buffer = true})
vim.keymap.set('i', '\\intersect', '∩', {buffer = true})
vim.keymap.set('i', '\\subset', '⊂', {buffer = true})
vim.keymap.set('i', '\\supset', '⊃', {buffer = true})
vim.keymap.set('i', '\\forall', '∀', {buffer = true})
vim.keymap.set('i', '\\exists', '∃', {buffer = true})
vim.keymap.set('i', '\\therefore', '∴', {buffer = true})
vim.keymap.set('i', '\\sum', '∑', {buffer = true})
vim.keymap.set('i', '\\prod', '∏', {buffer = true})

-- arrows
vim.keymap.set('i', '\\implies', '⟹', {buffer = true})
vim.keymap.set('i', '\\iff', '⟺', {buffer = true})
vim.keymap.set('i', '\\to', '→', {buffer = true})
vim.keymap.set('i', '\\gets', '←', {buffer = true})

-- misc symbols
vim.keymap.set('i', '\\trademark', '™', {buffer = true})
vim.keymap.set('i', '\\copyright', '©', {buffer = true})

vim.keymap.set('i', '\\dot', '·', {buffer = true})
vim.keymap.set('i', '\\', '\\', {buffer = true})
