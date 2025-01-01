---------------------------
-- spike's neovim config --
---------------------------

local opt = vim.opt

-- disable swap/backup
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- disable error highlighting
vim.diagnostic.disable()

-- editor settings
opt.number = false
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.signcolumn = "no"
opt.shortmess:append("I")
opt.clipboard = "unnamedplus"
opt.autoread = true

-- inherit term colors
opt.termguicolors = false
opt.hlsearch = true

-- file extensions
vim.filetype.add({ extension = { ispc = "c", }, }) -- ispc

-- persistent undo
local undodir = vim.fn.stdpath("data") .. "/undodir"
if not vim.fn.isdirectory(undodir) then
  vim.fn.mkdir(undodir, "p")
end

vim.opt.undofile = true        -- Enable persistent undo
vim.opt.undodir = undodir      -- Set undo directory
vim.opt.undolevels = 10000     -- Maximum number of changes that can be undone
vim.opt.undoreload = 10000     -- Maximum number lines to save for undo on buffer reload

-- tab spacing shortcuts
local function set_tab_width(width)
  opt.tabstop = width
  opt.shiftwidth = width
  print("Tab spacing set to " .. width)
end

-- keymaps
local map = vim.keymap.set
vim.g.mapleader = " "

map("n", "<C-b>", ":NvimTreeToggle<CR>", { silent = true })

map({ 'n', 'i', 'v' }, '<C-J>', '10j', { noremap = true, silent = true })
map({ 'n', 'i', 'v' }, '<C-K>', '10k', { noremap = true, silent = true })

map('n', '<leader>n', ':set number!<CR>', { noremap = true, silent = true })
map('n', '<leader>r', ':set relativenumber!<CR>', { noremap = true, silent = true })

map('n','<leader>t2',function() set_tab_width(2) end,{ noremap=true, silent=true })
map('n','<leader>t4',function() set_tab_width(4) end,{ noremap=true, silent=true })

local function setup_symbols(symbols)
  for trigger, symbol in pairs(symbols) do
    vim.keymap.set('i', '\\' .. trigger, symbol, {buffer = true})
  end
end

-- Define symbols by category
local symbols = {
  -- Greek lowercase
  greek_lower = {
    alpha = 'α', a = 'α',  -- sugar
    beta = 'β', b = 'β',   -- sugar
    gamma = 'γ',
    delta = 'δ',
    epsilon = 'ε',
    zeta = 'ζ',
    eta = 'η',
    theta = 'θ',
    lambda = 'λ', lam = 'λ', -- sugar
    mu = 'μ',
    nu = 'ν',
    xi = 'ξ',
    pi = 'π',
    rho = 'ρ',
    sigma = 'σ',
    tau = 'τ',
    phi = 'φ',
    chi = 'χ',
    psi = 'ψ',
    omega = 'ω',
  },

  -- Greek uppercase
  greek_upper = {
    Alpha = 'Α',
    Beta = 'Β',
    Gamma = 'Γ',
    Delta = 'Δ',
    Epsilon = 'Ε',
    Zeta = 'Ζ',
    Eta = 'Η',
    Theta = 'Θ',
    Iota = 'Ι',
    Kappa = 'Κ',
    Lambda = 'Λ',
    Mu = 'Μ',
    Nu = 'Ν',
    Xi = 'Ξ',
    Omicron = 'Ο',
    Pi = 'Π',
    Rho = 'Ρ',
    Sigma = 'Σ',
    Tau = 'Τ',
    Upsilon = 'Υ',
    Phi = 'Φ',
    Chi = 'Χ',
    Psi = 'Ψ',
    Omega = 'Ω',
  },

  -- Operators
  operators = {
    ['in'] = '∈',
    notin = '∉',
    union = '∪',
    intersect = '∩',
    subset = '⊂',
    supset = '⊃',
    forall = '∀',
    exists = '∃',
    therefore = '∴',
    sum = '∑',
    prod = '∏',
  },

  -- Arrows
  arrows = {
    implies = '⟹',
    iff = '⟺',
    to = '→',
    gets = '←',
  },

  -- Misc
  misc = {
    trademark = '™',
    copyright = '©',
    dot = '·',
    n = '\\n',
    sec = '§'
  },
}

for _, category in pairs(symbols) do
  setup_symbols(category)
end

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

  { 'Julian/lean.nvim', event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim', },
    opts = { lsp = {}, mappings = true, }
  },
})
