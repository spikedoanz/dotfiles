---------------------------
-- spike's neovim config --
---------------------------
local opt = vim.opt

-- editor settings
opt.showmode = true
opt.autoindent = true
opt.expandtab = true            -- use spaces instead of tabs
opt.tabstop = 2                 -- how many spaces a tab character displays as
opt.shiftwidth = 2              -- how many spaces for each indent level
opt.softtabstop = 2             -- how many spaces inserted when pressing tab
opt.clipboard = "unnamedplus" 	-- use shared system clipboard
opt.scrolloff = 999           	-- keep cursor centered vertically
opt.sidescrolloff = 8         	-- keep some horizontal context visible
opt.termguicolors = false     	-- inherit terminal colors

-- persistent undo
opt.undofile = true
opt.undodir = undodir      			-- set undo directory
opt.undolevels = 10000     			-- maximum number of changes that can be undone
opt.undoreload = 10000     			-- maximum number lines to save for undo on buffer reload
local undodir = vim.fn.stdpath("data") .. "/undodir"
if not vim.fn.isdirectory(undodir) then
  vim.fn.mkdir(undodir, "p")
end

-- disable swap file
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- status line
vim.cmd("highlight Comment      ctermfg=3 gui=none") -- make comments pop

-- keymaps
local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = ","
map("n","<C-b>",":NvimTreeToggle<CR>",{silent=true})

-- line numbers
map('n', '<leader>n', ':set number!<CR>', { noremap = true, silent = true })
map('n', '<leader>r', ':set relativenumber!<CR>', { noremap = true, silent = true })

-- tab spacing shortcuts
local function set_tab_width(width)
  opt.tabstop = width
  opt.shiftwidth = width
  print("Tab spacing set to " .. width)
end
map('n','<leader>2',function()set_tab_width(2)end,{noremap=true,silent=true})
map('n','<leader>4',function()set_tab_width(4)end,{noremap=true,silent=true})

-- terminal mode mappings (applies to all terminals, including floaterm)
map('t', '<C-[>', '<C-\\><C-n>', { noremap = true, silent = true })
map('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- better terminal window navigation from terminal mode
map('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
map('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
map('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
map('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })

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
  local opts = { border = "double", max_width = 80, pad_left = 1, pad_right = 1}
  vim.lsp.buf.hover(opts)
end, { noremap = true, silent = true })

-- plugins
require("lazy").setup({

{
  'Julian/lean.nvim',
  event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
  },
  opts = {mappings = true,}
},

{
  'ShinKage/idris2-nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'MunifTanjim/nui.nvim',
  },
  ft = { 'idris2' },
  config = function()
    vim.g.maplocalleader = vim.g.maplocalleader or ','
    local function save_hook(action)
      vim.cmd('silent write')
    end

    local opts = {
      client = {
        hover = {
          use_split = false, -- Persistent split instead of popups for hover
          split_size = '30%', -- Size of persistent split, if used
          auto_resize_split = false, -- Should resize split to use minimum space
          split_position = 'bottom', -- bottom, top, left or right
          with_history = false, -- Show history of hovers instead of only last
        },
      },
      server = {}, 
      autostart_semantic = true, -- Should start and refresh semantic highlight automatically
      code_action_post_hook = save_hook, -- Function to execute after a code action is performed
      use_default_semantic_hl_groups = true, -- Set default highlight groups for semantic tokens
    }
    require('idris2').setup(opts)
  end,
},

{ "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({ })
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

-- activitywatch
"lowitea/aw-watcher.nvim",
opts = {
    aw_server = {
        host = "127.0.0.1",
        port = 5600,
    },
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
        ['<C-p>'] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources(
          {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          },
          { { name = 'buffer' }, { name = 'path' }, }
        ),
      completion = {autocomplete = false,},-- Disable completion menu from automatically showing
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

    -- Pyright configuration
    vim.lsp.config('pyright', {
      cmd = { 'pyright-langserver', '--stdio' },
      filetypes = { 'python' },
      root_markers = { 
        'pyproject.toml', 
        'setup.py', 
        'setup.cfg', 
        'requirements.txt', 
        'Pipfile', 
        'pyrightconfig.json', 
        '.git' 
      },
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

    -- Enable the configured LSP servers
    vim.lsp.enable({ 'pyright', 'ts_ls' })
    local opts = { noremap = true, silent = true }
    map('n', 'gD', vim.lsp.buf.declaration, opts)   -- BINDING :: [g]oto [D]efinition
    map('n', 'gd', vim.lsp.buf.definition, opts)    -- BINDING :: [g]oto [d]efinition
    map('n', '[d', vim.diagnostic.goto_prev, opts)  -- BINDING :: [[]next [d]iagnostic
    map('n', ']d', vim.diagnostic.goto_next, opts)  -- BINDING :: []]last [d]iagnostic 
    map('n', 'K', vim.lsp.buf.hover, opts)          -- BINDING :: hover
  end,
},

{
  'ggml-org/llama.vim',
    init = function()
      vim.g.llama_config = {
        keymap_accept_full = "<C-F>",
        show_info = false,
      }
    end,
},

})

-- BINDING :: [d]irectory [r]elative
vim.keymap.set('n', '<leader>dr', function() 
  vim.fn.setreg('+', vim.fn.expand('%'))
end, { desc = 'Copy relative path' })

-- BINDING :: [d]irectory [a]bsolute
vim.keymap.set('n', '<leader>da', function() 
  vim.fn.setreg('+', vim.fn.expand('%:p'))
end, { desc = 'Copy absolute path' })

-- BINDING :: [c]olor [c]olumn
map('n', '<leader>cc', function()
  if vim.opt.colorcolumn:get()[1] then
    vim.opt.colorcolumn = ""
    print("Colorcolumn off")
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
