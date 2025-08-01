---------------------------
-- spike's neovim config --
---------------------------
local opt = vim.opt

-- editor settings
opt.number = false
opt.expandtab = true opt.shiftwidth = 2
opt.tabstop = 2
opt.signcolumn = "no"
opt.shortmess:append("I")
opt.autoread = true
opt.clipboard = "unnamedplus" -- use shared system clipboard
opt.scrolloff = 999           -- Keep cursor centered vertically
opt.sidescrolloff = 8         -- Keep some horizontal context visible
opt.termguicolors = false     -- inherit terminal colors

-- disable swap/backup
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Share status line with cmd line
opt.cmdheight = 0             -- Make command line float (requires Neovim 0.8+)
opt.laststatus = 3            -- Global statusline

-- Make statusline blend with background
vim.cmd("highlight StatusLine cterm=NONE ctermbg=NONE ctermfg=NONE gui=NONE guibg=NONE guifg=NONE")
vim.cmd("highlight StatusLineNC cterm=NONE ctermbg=NONE ctermfg=NONE gui=NONE guibg=NONE guifg=NONE")

-- persistent undo
local undodir = vim.fn.stdpath("data") .. "/undodir"
if not vim.fn.isdirectory(undodir) then
  vim.fn.mkdir(undodir, "p")
end

vim.cmd("highlight Comment ctermfg=3 gui=none")


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

-- backspace hurts my fingers
map('i', '<C-h>', '<BS>', { noremap = true, silent = true })
map('i', '<C-S-H>', '<C-w>', { noremap = true, silent = true })

map("n","<C-b>",":NvimTreeToggle<CR>",{silent=true})

map({'n','v'},'<C-J>','10j',{noremap=true,silent=true})
map({'n','v'},'<C-K>','10k',{noremap=true,silent=true})
map({'n','v'},'<C-H>','_',{noremap=true,silent=true})
map({'n','v'},'<C-L>','$',{noremap=true,silent=true})

map('n', '<leader>n', ':set number!<CR>', { noremap = true, silent = true })
map('n', '<leader>r', ':set relativenumber!<CR>', { noremap = true, silent = true })

map('n','<leader>t2',function()set_tab_width(2)end,{noremap=true,silent=true})
map('n','<leader>t4',function()set_tab_width(4)end,{noremap=true,silent=true})

-- CWD Management
map('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', { noremap = true, silent = false, desc = "cd to current file's directory" })
map('n', '<leader>cD', ':cd ..<CR>:pwd<CR>', { noremap = true, silent = false, desc = "cd to parent directory" })
map('n', '<leader>cr', ':cd -<CR>:pwd<CR>', { noremap = true, silent = false, desc = "cd to previous directory" })
map('n', '<leader>cp', ':pwd<CR>', { noremap = true, silent = false, desc = "print working directory" })

-- Terminal mode mappings (applies to all terminals, including floaterm)
map('t', '<C-[>', '<C-\\><C-n>', { noremap = true, silent = true })
map('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Better terminal window navigation from terminal mode
map('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
map('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
map('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
map('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })

local function setup_symbols(symbols)
  for trigger, symbol in pairs(symbols) do
    vim.keymap.set('i', '\\' .. trigger, symbol, {buffer = true})
  end
end

-- split behavior
vim.opt.splitright = true  
vim.opt.splitbelow = true  


-- Define symbols by category
local symbols = {
  -- Greek lowercase
  greek_lower = {
    alpha = 'α', a = 'α',
    beta = 'β', b = 'β',
    gamma = 'γ',
    delta = 'δ',
    epsilon = 'ε',
    zeta = 'ζ',
    eta = 'η',
    theta = 'θ',
    lambda = 'λ', lam = 'λ',
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

  -- Sets
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
    top = '⊤',
    dot = '·',
    n = '\\n',
    sec = '§',
    approx = '≈',
    inf = '∞',
    qed = '□',
    partial = '∂', par = '∂'
  },
  -- Linear algebra
  linear = {
    otimes = '⊗',
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

-- get diagnostics
map('n', 'gh', function()
  vim.diagnostic.open_float(nil, { border = "double", scope = "line" })
end, { noremap = true, silent = true })

-- get type info
map('n', 'gt', function()
  local opts = {
    border = "double",  -- More visible border style
    max_width = 80,
    pad_left = 1,
    pad_right = 1
  }
  vim.lsp.buf.hover(opts)
end, { noremap = true, silent = true })

-- plugins
require("lazy").setup({
{ "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({
      renderer = {
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
          },
        },
        indent_markers = {
          enable = true,
          icons = {
            corner = "└──",
            edge = "│",
            item = "├──",
            none = " ",
          },
        },
      },
    })
  end,
},

{ "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local builtin = require("telescope.builtin")
    map("n", "<leader>ff", builtin.find_files)
    map("n", "<leader>fg", builtin.live_grep)
    map("n", "<leader>fb", builtin.buffers)
    map("n", "<leader>fh", builtin.help_tags)
    
    -- Add more telescope pickers for navigation
    map("n", "<leader>fd", function() 
      builtin.find_files({ cwd = vim.fn.expand("%:p:h") }) 
    end, { desc = "Find files in current directory" })
    
    map("n", "<leader>fc", function()
      builtin.find_files({ 
        prompt_title = "Change Directory",
        find_command = {'fd', '--type', 'd', '--hidden', '--exclude', '.git'},
        attach_mappings = function(prompt_bufnr, map)
          local actions = require('telescope.actions')
          local action_state = require('telescope.actions.state')
          
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection then
              vim.cmd('cd ' .. selection[1])
              print('Changed directory to: ' .. selection[1])
            end
          end)
          return true
        end,
      })
    end, { desc = "Change directory with telescope" })
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

-- Floaterm
{ 
  "voldikss/vim-floaterm",
  config = function()
    -- Floaterm settings
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    vim.g.floaterm_position = 'center'
    vim.g.floaterm_title = ' Terminal '
    
    -- Don't auto close when job exits (so you can see output)
    vim.g.floaterm_autoclose = 0
    
    -- VS Code style toggle with Ctrl-`
    map({'n', 't', 'i'}, '<C-`>', '<Cmd>FloatermToggle<CR>', { noremap = true, silent = true })
    
    -- Additional floaterm keybindings
    map('n', '<leader>tn', ':FloatermNew<CR>', { noremap = true, silent = true, desc = "New floaterm" })
    map('n', '<leader>tt', ':FloatermToggle<CR>', { noremap = true, silent = true, desc = "Toggle floaterm" })
    map('n', '<leader>tk', ':FloatermKill<CR>', { noremap = true, silent = true, desc = "Kill floaterm" })
    map('n', '<leader>t]', ':FloatermNext<CR>', { noremap = true, silent = true, desc = "Next floaterm" })
    map('n', '<leader>t[', ':FloatermPrev<CR>', { noremap = true, silent = true, desc = "Previous floaterm" })
    
    -- Open floaterm in specific directories
    map('n', '<leader>th', function()
      vim.cmd('FloatermNew --cwd=~')
    end, { noremap = true, silent = true, desc = "Floaterm in home" })
    
    map('n', '<leader>t.', function()
      vim.cmd('FloatermNew --cwd=' .. vim.fn.expand('%:p:h'))
    end, { noremap = true, silent = true, desc = "Floaterm in current file's directory" })
    
    -- Send current line or selection to floaterm
    map('n', '<leader>ts', ':FloatermSend<CR>', { noremap = true, silent = true, desc = "Send line to floaterm" })
    map('v', '<leader>ts', ':FloatermSend<CR>', { noremap = true, silent = true, desc = "Send selection to floaterm" })
  end,
},


-- LSP Support
{
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",       -- Buffer completions
    "hrsh7th/cmp-path",         -- Path completions
    "hrsh7th/cmp-cmdline",      -- Cmdline completions
    "L3MON4D3/LuaSnip",         -- Snippet engine
    "saadparwaiz1/cmp_luasnip", -- Snippet completions
  },
  config = function()
    local lspconfig = require('lspconfig')
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    
    -- nvim-cmp setup
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        -- Tab/Shift-Tab to navigate through completion items
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
        { name = 'path' },
      }),
      -- Disable completion menu from automatically showing
      completion = {
        autocomplete = false,  -- This disables auto-popup
      },
    })

    -- Use buffer source for `/` and `?`
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':'
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- AUTO :: Pyright setup
    lspconfig.pyright.setup({
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "standard",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    })

    -- AUTO :: Clangd setup
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
    lspconfig.marksman.setup({
      capabilities = capabilities,
    })

    local opts = { noremap = true, silent = true }
    map('n', 'gD', vim.lsp.buf.declaration, opts)   -- BINDING :: [g]oto [D]efinition
    map('n', 'gd', vim.lsp.buf.definition, opts)    -- BINDING :: [g]oto [d]efinition
    map('n', '[d', vim.diagnostic.goto_prev, opts)  -- BINDING :: [[]next [d]iagnostic
    map('n', ']d', vim.diagnostic.goto_next, opts)  -- BINDING :: []]last [d]iagnostic 
    map('n', 'K', vim.lsp.buf.hover, opts)          -- BINDING :: hover
  end,
},
})
-- BINDING :: [d]irectory [r]elative
vim.keymap.set('n', '<leader>dr', function() 
  vim.fn.setreg('+', vim.fn.expand('%'))
end, { desc = 'Copy relative path' })

-- BINDING :: [d]irectory [a]bsolute
vim.keymap.set('n', '<leader>da', function() 
  vim.fn.setreg('+', vim.fn.expand('%'))
end, { desc = 'Copy relative path' })

-- BINDING :: [c]olor [c]olumn
map('n', '<leader>cc', function()
  if vim.opt.colorcolumn:get()[1] then
    vim.opt.colorcolumn = ""
    print("Colorcolumn off")
  else
    vim.opt.colorcolumn = "80"
    print("Colorcolumn on")
  end
end, { noremap = true, silent = false, desc = "Toggle colorcolumn" })

-- AUTO :: detect if we're running inside neovim terminal and set env var
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.fn.setenv("NVIM_LISTEN_ADDRESS", vim.v.servername)
    vim.fn.setenv("NVIM", vim.fn.getpid())
  end,
})

-- AUTO :: enter insert mode when opening terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
    -- Also set local options for terminal buffers
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- AUTO :: disable error higlighting in markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.cmd("highlight link markdownError NONE")
  end,
})
