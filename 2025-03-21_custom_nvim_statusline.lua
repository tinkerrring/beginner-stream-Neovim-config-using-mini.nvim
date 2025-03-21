-- Welcome! Today creating my own statusline

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
vim.keymap.set("n", "<Leader>dl", ":lua vim.diagnostic.setloclist()<CR>", { desc = "list LSP messages" })
vim.keymap.set("n", "<Leader>dn", ":lua vim.diagnostic.goto_next()<CR>", { desc = "next LSP message" })
vim.keymap.set("n", "<Leader>dp", ":lua vim.diagnostic.goto_prev()<CR>", { desc = "previous LSP message" })
vim.keymap.set("n", "<Leader>ff", ":Pick files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<Leader>fb", ":Pick buffers<CR>", { desc = "Find Buffer" })
vim.keymap.set("n", "<Leader>ms", ":lua My_strikethrough()<CR>", { desc = "strikethrough" })
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
vim.cmd("colorscheme habamax")
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
      { mode = "n", keys = "<Leader>d", desc = "+ Diagnostic" },
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
          globals = { "vim", "MiniDeps" },
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
-- mini.diff {{{
now(function()
  require('mini.diff').setup()
end)
--}}}
-- mini.jump2d {{{
now(function()
  require('mini.jump2d').setup()
end)
-- }}}
-- mini.statusline {{{
-- now(function()
--   require('mini.statusline').setup({
--     use_icons = false,
--   })
-- end)
-- }}}
-- my own statusline {{{
-- list all modes {{{
local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}
-- }}}
-- get mode and match to all modes above {{{
local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[current_mode])
end
-- }}}
-- get filepath {{{
local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
  if fpath == "" or fpath == "." then
    return " "
  end
  return string.format(" %%<%s/", fpath)
end
-- }}}
-- get filename {{{
local function filename()
  local fname = vim.fn.expand("%:t")
  if fname == "" then
    return ""
  end
  return fname .. " "
end
--}}}
-- define highlights {{{
vim.cmd([[highlight MyLspErrors guifg=#ff0000]])
vim.cmd([[highlight MyLspWarnings guifg=#ffa500]])
vim.cmd([[highlight MyLspHints guifg=#ffff00]])
vim.cmd([[highlight MyLspInfo guifg=#ffffff]])
vim.cmd([[highlight MyGreen guifg=#008000]])
--}}}
-- lsp errors, warnings, hints and info {{{
local lsp_errors = function()
  local lsp_errors = vim.tbl_count(vim.diagnostic.count(0, { severity = vim.diagnostic.severity.ERROR }))
  if lsp_errors ~= 0 then
    local lsp_errors_output = "%#MyLspErrors#" .. "E:" .. lsp_errors .. " "
    return lsp_errors_output
  else
    return ""
  end
end

local lsp_warnings = function()
  local lsp_warnings = vim.tbl_count(vim.diagnostic.count(0, { vim.diagnostic.severity.WARN }))
  if lsp_warnings ~= 0 then
    local lsp_warnings_output = "%#MyLspWarnings#" .. "W:" .. lsp_warnings .. " "
    return lsp_warnings_output
  else
    return ""
  end
end

local lsp_hints = function()
  local lsp_hints = vim.tbl_count(vim.diagnostic.count(0, { vim.diagnostic.severity.HINT }))
  if lsp_hints ~= 0 then
    local lsp_hints_output = "%#MyLspHints#" .. "H:" .. lsp_hints .. " "
    return lsp_hints_output
  else
    return ""
  end
end

local lsp_info = function()
  local lsp_info = vim.tbl_count(vim.diagnostic.count(0, { vim.diagnostic.severity.INFO }))
  if lsp_info ~= 0 then
    local lsp_info_output = "%#MyLspInfo#" .. "I:" .. lsp_info .. " "
    return lsp_info_output
  else
    return ""
  end
end
--}}}
-- get line info {{{
local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %l "
  -- return " %P %l:%c "
end
--}}}
-- git status {{{
local function git_status()
  local handle = io.popen("git diff --shortstat 2>/dev/null")
  if not handle then
    return ""
  end
  local result = handle:read("*a")
  handle:close()

  if result == "" then
    return ""
  end

  local added = result:match("(%d+) insert")
  local deleted = result:match("(%d+) delet")
  -- local changed = result:match("(%d+) file")

  added = added or "0"
  deleted = deleted or "0"
  -- changed = changed or "0"
  local green = "%#MyGreen#"
  local red = "%#MyLspErrors#"
  -- local yellow = "%#MyLspHints#"

  -- return string.format("%s+%s %s~%s %s-%s", green, added, yellow, changed, red, deleted)
  return string.format("%s+%s %s-%s", green, added, red, deleted)
end
--}}}
-- build statusline {{{
Statusline = {}

Statusline.active = function()
  return table.concat({
    "%#Statusline#",
    mode(),
    "%#Normal# ",
    filepath(),
    filename(),
    lsp_errors(),
    lsp_warnings(),
    lsp_hints(),
    lsp_info(),
    git_status(),
    "%=%#StatusLineExtra#",
    lineinfo(),
  })
end

function Statusline.inactive()
  return " %F"
end

vim.api.nvim_exec2(
  [[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  augroup END
]],
  {} -- false
)
--}}}
--}}}
-- My little functions {{{
function My_strikethrough()
  vim.cmd('normal ^i~~')
  vim.cmd('normal $a~~')
end

function My_list_todos()
  vim.cmd('vimgrep TODO %')
  vim.cmd('copen')
end

-- }}}