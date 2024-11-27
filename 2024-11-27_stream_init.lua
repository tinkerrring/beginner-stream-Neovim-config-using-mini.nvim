-- DONE is sound working and is zoom 220%?
-- DONE mini.hues
-- DONE mini.colors
-- DONE mini.icons
-- TODO mini.highlights

-- Mapping {{{
-- mapleader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("v", "jk", "<Esc>")

vim.keymap.set("n", "<Leader>k", ":bd<CR>", { desc = "kill buffer" })
vim.keymap.set("n", "<Leader>s", ":w<CR>:so %<CR>", { desc = "source this file" })
vim.keymap.set("n", "<Leader>w", ":w<CR>", { desc = "save" })
vim.keymap.set("n", "<Leader>q", ":q<CR>", { desc = "quit" })
vim.keymap.set("n", "<Leader>ff", ":Pick files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<Leader>fb", ":Pick buffers<CR>", { desc = "Find Buffer" })
vim.keymap.set("n", "U", "<C-r>")
vim.keymap.set("n", "-", "ddp")
vim.keymap.set("n", "_", "ddkP")
vim.keymap.set("n", "<Tab>", "za")
-- }}}
-- Options {{{
vim.opt.termguicolors = true
vim.opt.foldmethod = 'marker'
vim.cmd 'syntax on'
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.bo.expandtab = true
vim.opt.number = true
vim.cmd("colorscheme tinkerrring")
-- }}}
-- mini.deps {{{
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

-- helpers
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
-- }}}
-- mini.clue {{{
later(function()
  require('mini.clue').setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      require('mini.clue').gen_clues.builtin_completion(),
      require('mini.clue').gen_clues.g(),
      require('mini.clue').gen_clues.marks(),
      require('mini.clue').gen_clues.registers(),
      require('mini.clue').gen_clues.windows(),
      require('mini.clue').gen_clues.z(),
      { mode = "n", keys = "<Leader>f", desc = "+ Find" },
    },
    window = {
      delay = 300,
      config = { anchor = 'SW', row = 'auto', col = 'auto' },
    }
  })
end)
-- }}}
-- mini.pick {{{
later(function()
  local win_config = function()
    local height = math.floor(0.9 * vim.o.lines)
    local width = math.floor(0.9 * vim.o.columns)
    --row = math.floor(0.1 * (vim.o.lines - height)),
    --col = math.floor(0.1 * (vim.o.columns - width)),
    return {
      height = height,
      width = width,
      border = "single",
    }
  end
  require("mini.pick").setup({
    options = {
      content_from_bottom = true,
    },
    window = {
      config = win_config,
    },
    -- remove icons from mini.pick
    source = { show = require('mini.pick').default_show },
  })
end)
-- }}}
-- mini.pairs {{{
now(function()
  require('mini.pairs').setup()
end)
--}}}
-- LSP {{{
now(function()
  add({
    source = "neovim/nvim-lspconfig",
  })
  require 'lspconfig'.lua_ls.setup {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  }
end)
-- }}}
-- Treesitter {{{
later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- run update after checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc', 'markdown', 'markdown_inline' },
    highlight = { enable = true },
  })
end)
--}}}
-- conform.nvim {{{
later(function()
  add({
    source = 'stevearc/conform.nvim',
  })
  require('conform').setup({
    formatters_by_ft = {
      lua = { "stylua" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  })
end)
--}}}
-- mini.tabline {{{
now(function()
  require('mini.tabline').setup()
end)
--}}}
-- mini.icons -- {{{
-- later(function()
--   require('mini.icons').setup({
--     style = 'ascii'
--   })
-- end)
-- --}}}
-- mini.highlights -- {{{
later(function()
  require('mini.hipatterns').setup({
    highlighters = {
      tinkerrring_todo = {
        pattern = '%f[%w]()TODO()%f[%W]',
        group = 'TinkerrringTodoHighlightGroupName',
      },
      tinkerrring_done = {
        pattern = '%f[%w]()DONE()%f[%W]',
        group = 'TinkerrringDoneHighlightGroupName',
      },
    },
  })
end)
vim.cmd [[highlight TinkerrringTodoHighlightGroupName guifg=#FFFFFF guibg=#FF0000 gui=bold]]
vim.cmd [[highlight TinkerrringDoneHighlightGroupName guifg=#FFFFFF guibg=#00CC00 gui=bold]]
--}}}
