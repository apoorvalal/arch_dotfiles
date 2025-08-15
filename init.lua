-- load plugins file

-- Leader key configuration
vim.g.mapleader = "\\"
vim.g.maplocalleader = "'"

-- Basic Settings
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- General Settings
vim.opt.compatible = false
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true  -- Added from your vimrc
vim.opt.mouse = 'a'
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.wildmode = 'longest,list'
vim.opt.colorcolumn = '85'
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.ttyfast = true

-- Additional settings from your vimrc
vim.opt.scrolloff = 3
vim.opt.matchpairs:append('<:>')
vim.opt.laststatus = 2
vim.opt.backspace = 'indent,eol,start'
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.list = false
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99

-- packer stuff


-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

--return require('packer').startup(function(use)
  --use 'wbthomason/packer.nvim'
  --use 
--end)

-- Plugin Management with vim-plug
vim.call('plug#begin')

vim.cmd([[
  Plug 'dracula/vim'
  Plug 'flazz/vim-colorschemes'
  Plug 'altercation/vim-colors-solarized'
  Plug 'itchyny/lightline.vim'
  Plug 'dylanaraps/wal'
  
  " Development Tools
  Plug 'scrooloose/nerdtree'
  Plug 'jistr/vim-nerdtree-tabs'
  Plug 'preservim/nerdcommenter'
  Plug 'terryma/vim-multiple-cursors'
  
  " Git Integration
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  
  " Text Editing
  Plug 'christoomey/vim-tmux-navigator'
  
  " Language Support
  Plug 'vim-pandoc/vim-pandoc'
  Plug 'vim-pandoc/vim-pandoc-syntax'
  Plug 'lervag/vimtex'
  Plug 'kaarmu/typst.vim'
  
  " REPL Integration
  Plug 'jpalardy/vim-slime'
  Plug 'benlubas/molten-nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'Vigemus/iron.nvim'
]])

vim.call('plug#end')

-- Plugin Configurations
-- Lightline config with git branch
vim.g['lightline'] = {
    active = {
        left = {
            { 'mode', 'paste' },
            { 'gitbranch', 'readonly', 'filename', 'modified' },
            { 'venv', 'readonly' }
        }
    },
    component_function = {
        gitbranch = 'fugitive#head',
        venv = 'virtualenv#statusline'
    }
}

-- ALE Configuration
vim.g.ale_linters = {
    python = {},
    r = {}
}
vim.g.ale_fixers = {
    python = {'yapf', 'remove_trailing_lines', 'trim_whitespace'},
    r = {'remove_trailing_lines', 'trim_whitespace'}
}

-- Slime Configuration
vim.g.slime_target = "tmux"
vim.g.slime_default_config = {socket_name = "default", target_pane = "1"}
vim.g.slime_dont_ask_default = 1
vim.g.slime_python_ipython = 1

-- NERDTree Configuration
vim.g.NERDTreeWinSize = 23
vim.g.NERDTreeDirArrows = 0
vim.g.nerdtree_tabs_open_on_console_startup = 0

-- Key Mappings
-- Basic mappings
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true })
vim.keymap.set('n', '<space>', ':', { noremap = true })
vim.keymap.set('n', '<F4>', ':let @+=expand("%:p")<CR>', { noremap = true, silent = true })
vim.keymap.set('v', 'r', '"_dP', { noremap = true })
vim.keymap.set('n', '<leader>d', '"_d', { noremap = true })
vim.keymap.set('v', '<leader>d', '"_d', { noremap = true })
vim.keymap.set('v', '<leader>p', '"_dP', { noremap = true })

-- Additional mappings from your vimrc
vim.keymap.set('i', '<C-b>', '%>%', { noremap = true })
vim.keymap.set('i', '<C-n>', '# %% <Esc>O', { noremap = true })
vim.keymap.set('n', '<leader>t', ':NERDTreeTabsToggle<CR>', { noremap = true, silent = true })

-- Slime mappings
vim.keymap.set('n', '<Leader>s', '<Plug>SlimeRegionSend', {})
vim.keymap.set('n', '<Leader>w', '<Plug>SlimeLineSend', {})
vim.keymap.set('v', '<Leader>s', '<Plug>SlimeRegionSend', {})
vim.keymap.set('v', '<Leader>w', '<Plug>SlimeLineSend', {})

-- iron bindings
local iron = require("iron.core")

iron.setup {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    repl_definition = {
      sh = {
        command = {"zsh"}
      },
      python = {
        command = { "ipython" },  -- or { "ipython", "--no-autoindent" }
        format = require("iron.fts.common").bracketed_paste_python
      }
    },
    -- How the repl window will be displayed
    -- See below for more information
    repl_open_cmd = require('iron.view').bottom(40),
  },
  -- You can set them here or manually add keymaps to the functions in iron.core
  keymaps = {
    send_motion = "<space>sc",
    visual_send = "<space>sc",
    send_file = "<space>sf",
    send_line = "<space>sl",
    send_paragraph = "<space>sp",
    send_until_cursor = "<space>su",
    send_mark = "<space>sm",
    mark_motion = "<space>mc",
    mark_visual = "<space>mc",
    remove_mark = "<space>md",
    cr = "<space>s<cr>",
    interrupt = "<space>s<space>",
    exit = "<space>sq",
    clear = "<space>cl",
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')

-- Molten (Python REPL) mappings
vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
    { silent = true, desc = "Initialize the plugin" })
vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
    { silent = true, desc = "run operator selection" })
vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>",
    { silent = true, desc = "evaluate line" })
vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>",
    { silent = true, desc = "re-evaluate cell" })
vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
    { silent = true, desc = "evaluate visual selection" })

vim.opt.background = 'dark'
