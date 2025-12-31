--------------------------------------------------------------------------------
--                            spike's neovim config                           --
--------------------------------------------------------------------------------
local opt = vim.opt
local map = vim.keymap.set

-- editor settings
--------------------------------------------------------------------------------
opt.lazyredraw = true
opt.shortmess:append("I")  -- disable intro screen
opt.showmode = true
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.clipboard = "unnamedplus"
opt.scrolloff = 999
opt.sidescrolloff = 8
opt.termguicolors = false
opt.signcolumn = "no"

-- leaders (set before lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- persistent undo
local undodir = vim.fn.stdpath("data") .. "/undodir"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir
opt.undofile = true
opt.undolevels = 10000
opt.undoreload = 10000

-- disable swap/backup
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- make comments pop
vim.cmd("highlight Comment ctermfg=3 gui=none")

-- basic keymaps

-- line numbers
map('n', '<leader>n', ':set number!<CR>', { silent = true, desc = "Toggle line numbers" })
map('n', '<leader>r', ':set relativenumber!<CR>', { silent = true, desc = "Toggle relative numbers" })

-- tab spacing
local function set_tab_width(width)
  opt.tabstop = width
  opt.shiftwidth = width
  print("Tab spacing set to " .. width)
end
map('n', '<leader>2', function() set_tab_width(2) end, { silent = true, desc = "Set tab width 2" })
map('n', '<leader>4', function() set_tab_width(4) end, { silent = true, desc = "Set tab width 4" })

-- path copying
map('n', '<leader>dr', function()
  vim.fn.setreg('+', vim.fn.expand('%'))
end, { desc = 'Copy relative path' })

map('n', '<leader>da', function()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
end, { desc = 'Copy absolute path' })

-- colorcolumn toggle
map('n', '<leader>c', function()
  if vim.opt.colorcolumn:get()[1] then
    vim.opt.colorcolumn = ""
    print("Colorcolumn off")
  else
    vim.opt.colorcolumn = "80"
    print("Colorcolumn on")
  end
end, { desc = "Toggle colorcolumn" })
--------------------------------------------------------------------------------

-- bootstrap lazy.nvim
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.fzf_layout = { window = { width = 1, height = 1 } }
--------------------------------------------------------------------------------

-- plugins
--------------------------------------------------------------------------------
require("lazy").setup({
  -- fzf
  { 'junegunn/fzf', build = './install --bin', },
  {
  'junegunn/fzf.vim',
  config = function()
    map("n", "<leader>f", ":Files<cr>", { desc = "Find files" })
    map("n", "<leader>/", ":Rg<cr>", { desc = "Live grep" })
    map("n", "<leader>b", ":Buffers<cr>", { desc = "Buffers" })
  end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- global diagnostic keymap
      map('n', '<leader>d', vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

      -- LSP attach keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local o = function(desc)
            return { buffer = ev.buf, desc = desc }
          end

          -- goto (g-prefix)
          map('n', 'gd', vim.lsp.buf.definition, o("Definition"))
          map('n', 'gD', vim.lsp.buf.declaration, o("Declaration"))
          map('n', 'gi', vim.lsp.buf.implementation, o("Implementation"))
          map('n', 'gr', vim.lsp.buf.references, o("References"))
          map('n', 'gy', vim.lsp.buf.type_definition, o("Type definition"))

          -- space mode actions
          map('n', '<leader>r', vim.lsp.buf.rename, o("Rename symbol"))
          map({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, o("Code action"))
          map('n', '<leader>F', function()
            vim.lsp.buf.format({ async = true })
          end, o("Format buffer"))

          -- hover / signature
          map('n', 'K', vim.lsp.buf.hover, o("Hover"))
          map({ 'n', 'i' }, '<M-k>', vim.lsp.buf.signature_help, o("Signature help"))

          -- diagnostics
          map('n', '[d', vim.diagnostic.goto_prev, o("Prev diagnostic"))
          map('n', ']d', vim.diagnostic.goto_next, o("Next diagnostic"))
          map('n', 'gh', function()
            vim.diagnostic.open_float(nil, { border = "rounded", scope = "line" })
          end, o("Line diagnostics"))
        end,
      })

      -- server configs
      vim.lsp.config('pyright', {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = {
          'pyproject.toml', 'setup.py', 'setup.cfg',
          'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git'
        },
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

      vim.lsp.enable({ 'pyright', 'ts_ls' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    -- parsers managed by Nix; plugin provides queries
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    -- incremental selection (removed from nvim-treesitter main branch)
    'MeanderingProgrammer/treesitter-modules.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          node_decremental = '<BS>',
        },
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
    opts = { mappings = true },
  },

  -- idris2
  {
    'ShinKage/idris2-nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'MunifTanjim/nui.nvim',
    },
    ft = { 'idris2' },
    config = function()
      require('idris2').setup({
        client = {
          hover = {
            use_split = false,
            split_size = '30%',
            auto_resize_split = false,
            split_position = 'bottom',
            with_history = false,
          },
        },
        server = {},
        autostart_semantic = true,
        code_action_post_hook = function() vim.cmd('silent write') end,
        use_default_semantic_hl_groups = true,
      })
    end,
  },

  -- llama completion
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
