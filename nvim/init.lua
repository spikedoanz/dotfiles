vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

require "nvchad.autocmds"

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
vim.schedule(function()
  require "mappings"
end)


-- llm --
require('llm').setup({
  -- How long to wait for the request to start returning data.
  timeout_ms = 10000,
  services = {
      -- Supported services configured by default
      -- groq = {
      --     url = "https://api.groq.com/openai/v1/chat/completions",
      --     model = "llama3-70b-8192",
      --     api_key_name = "GROQ_API_KEY",
      -- },
      -- openai = {
      --     url = "https://api.openai.com/v1/chat/completions",
      --     model = "gpt-4o",
      --     api_key_name = "OPENAI_API_KEY",
      -- },
      -- anthropic = {
      --     url = "https://api.anthropic.com/v1/messages",
      --     model = "claude-3-5-sonnet-20240620",
      --     api_key_name = "ANTHROPIC_API_KEY",
      -- },

      -- Extra OpenAI-compatible services to add (optional)
      other_provider = {
          url = "https://example.com/other-provider/v1/chat/completions",
          model = "llama3",
          api_key_name = "OTHER_PROVIDER_API_KEY",
      }
  }

})


-- keybinds for prompting with groq
vim.keymap.set("n", "<leader>m", function() require("llm").create_llm_md() end, { desc = "Create llm.md" })
vim.keymap.set("n", "<leader>,", function() require("llm").prompt({ replace = false, service = "groq" }) end, { desc = "Prompt with groq" })
vim.keymap.set("v", "<leader>,", function() require("llm").prompt({ replace = false, service = "groq" }) end, { desc = "Prompt with groq" })
vim.keymap.set("v", "<leader>.", function() require("llm").prompt({ replace = true, service = "groq" }) end, { desc = "Prompt while replacing with groq" })


-- end of llm --
--
require("brainrot").setup()


