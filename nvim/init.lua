---------------------------
-- spike's neovim config --
---------------------------
local opt = vim.opt
local map = vim.keymap.set

-- leaders (set before lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- disable unused providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- disable built-in plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1

-------------------------------
-- editor settings
-------------------------------
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

-------------------------------
-- basic keymaps
-------------------------------

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

-------------------------------
-- autocommands
-------------------------------

-- disable diagnostics for markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- set NVIM env vars in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.fn.setenv("NVIM_LISTEN_ADDRESS", vim.v.servername)
    vim.fn.setenv("NVIM", vim.fn.getpid())
  end,
})

-------------------------------
-- bootstrap lazy.nvim
-------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------
-- plugins
-------------------------------
require("lazy").setup({

  -- mini.nvim modules
  {
    "echasnovski/mini.nvim",
    config = function()
      -- mini.files (file explorer)
      require("mini.files").setup({
        mappings = {
          close = "q",
          go_in = "l",
          go_in_plus = "<CR>",
          go_out = "h",
          go_out_plus = "-",
        },
      })
      map("n", "<leader>b", function()
        local mf = require("mini.files")
        if not mf.close() then
          mf.open(vim.api.nvim_buf_get_name(0))
        end
      end, { desc = "Toggle file explorer" })

      -- mini.pick + mini.extra (fuzzy finder)
      require("mini.pick").setup()
      require("mini.extra").setup()

      -- helix-style space bindings
      map("n", "<space>f", "<cmd>Pick files<cr>", { desc = "Find files" })
      map("n", "<space>/", "<cmd>Pick grep_live<cr>", { desc = "Live grep" })
      map("n", "<space>b", "<cmd>Pick buffers<cr>", { desc = "Buffers" })
      map("n", "<space>s", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "Document symbols" })
      map("n", "<space>S", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "Workspace symbols" })

      -- leader-f variants
      map("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "Help tags" })
      map("n", "<leader>fd", function()
        require("mini.pick").builtin.files(nil, { source = { cwd = vim.fn.expand("%:p:h") } })
      end, { desc = "Find in current directory" })

      map("n", "<leader>fc", function()
        require("mini.extra").pickers.explorer({ cwd = vim.fn.getcwd() }, {
          source = {
            choose = function(item)
              vim.cmd('cd ' .. item.path)
              print('Changed directory to: ' .. item.path)
            end
          }
        })
      end, { desc = "Change directory" })

      -- mini.clue (keybind hints - helix style)
      local clue = require("mini.clue")
      clue.setup({
        triggers = {
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },
          { mode = 'n', keys = '<space>' },
          { mode = 'x', keys = '<space>' },
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },
          { mode = 'n', keys = '<C-w>' },
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
          { mode = 'n', keys = '[' },
          { mode = 'n', keys = ']' },
        },
        clues = {
          clue.gen_clues.builtin_completion(),
          clue.gen_clues.g(),
          clue.gen_clues.marks(),
          clue.gen_clues.registers(),
          clue.gen_clues.windows(),
          clue.gen_clues.z(),
          -- custom groups
          { mode = 'n', keys = '<space>', desc = '+space mode' },
          { mode = 'n', keys = '<space>w', desc = '+workspace' },
          { mode = 'n', keys = '<Leader>f', desc = '+find' },
          { mode = 'n', keys = '<Leader>d', desc = '+directory/path' },
        },
        window = {
          delay = 0,
          config = { width = 'auto' },
        },
      })

      -- mini.completion
      require("mini.completion").setup({
        lsp_completion = {
          source_func = 'omnifunc',
          auto_setup = false,
        },
        window = {
          info = { border = 'single' },
          signature = { border = 'single' },
        },
      })
      -- manual trigger with C-p, confirm with C-y
      map('i', '<C-p>', function()
        return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-x><C-o>'
      end, { expr = true, desc = "Trigger completion" })

      -- clear mini highlight groups to inherit terminal colors
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          for _, group in ipairs(vim.fn.getcompletion("Mini", "highlight")) do
            vim.api.nvim_set_hl(0, group, {})
          end
          vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { reverse = true })
        end,
      })
      -- also clear them now
      for _, group in ipairs(vim.fn.getcompletion("Mini", "highlight")) do
        vim.api.nvim_set_hl(0, group, {})
      end
      -- but keep selection visible
      vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { reverse = true })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- global diagnostic keymap
      map('n', '<space>d', vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

      -- LSP attach keymaps (helix-style)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local o = function(desc)
            return { buffer = ev.buf, desc = desc }
          end

          -- enable omnifunc for mini.completion
          vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

          -- goto (g-prefix)
          map('n', 'gd', vim.lsp.buf.definition, o("Definition"))
          map('n', 'gD', vim.lsp.buf.declaration, o("Declaration"))
          map('n', 'gi', vim.lsp.buf.implementation, o("Implementation"))
          map('n', 'gr', vim.lsp.buf.references, o("References"))
          map('n', 'gy', vim.lsp.buf.type_definition, o("Type definition"))

          -- space mode actions
          map('n', '<space>r', vim.lsp.buf.rename, o("Rename symbol"))
          map({ 'n', 'v' }, '<space>a', vim.lsp.buf.code_action, o("Code action"))
          map('n', '<space>F', function()
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

          -- workspace folders (less common, but available)
          map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, o("Add workspace folder"))
          map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, o("Remove workspace folder"))
          map('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, o("List workspace folders"))
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
