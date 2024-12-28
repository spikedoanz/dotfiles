---------------------------
-- spike's neovim config --
---------------------------

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

map("n", "<C-b>", ":NvimTreeToggle<CR>", { silent = true })

map({ 'n', 'i', 'v' }, '<C-J>', '10j', { noremap = true, silent = true })
map({ 'n', 'i', 'v' }, '<C-K>', '10k', { noremap = true, silent = true })

map('n', '<leader>n', ':set number!<CR>', { noremap = true, silent = true })
map('n', '<leader>r', ':set relativenumber!<CR>', { noremap = true, silent = true })

map('n','<leader>t2',function() set_tab_width(2) end,{ noremap=true, silent=true })
map('n','<leader>t4',function() set_tab_width(4) end,{ noremap=true, silent=true })

-- Greek
-- Lowercase
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

-- Uppercase
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

-- Automatically detect and match terminal background
local function update_background()
  local stdout = vim.fn.system('printf "%d" "$(id -u)"')
  local is_dark = vim.fn.system("osascript -e 'tell application \"Terminal\" to get dark mode of window 1'")
  
  -- Default to dark if we can't detect
  if is_dark == "true\n" then
    vim.opt.background = "dark"
  else
    vim.opt.background = "light"
  end
end

-- Set initial background
update_background()

-- Create an autocommand to update on focus gain
vim.api.nvim_create_autocmd("FocusGained", {
  callback = update_background
})

-- Disable true colors to use terminal colors
opt.termguicolors = false

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
