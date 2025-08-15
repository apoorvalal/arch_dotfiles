filetype plugin indent on 
syntax on

"---------- REMAPS-------------------------------------------------- 
" map jj to esc 
imap jj <Esc>
" Remap space to command modifier
noremap <space> :
" map insert toggle to ctrl + spc
"nnoremap <C-space> a
"imap <C-space> <Esc>
" copy path to clipboard
noremap <silent> <F4> :let @+=expand("%:p")<CR>
" paste over
vmap r "_dP       
imap <leader>m %>%
" shortcut to delete in the black hole register
nnoremap <leader>d "_d
vnoremap <leader>d "_d
" shortcut to paste but keep current register
vnoremap <leader>p "_dP

inoremap <C-b> %>%
inoremap <C-n> # %% <Esc>O

set nocompatible
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
" ----- Making Vim look good ------------------------------------------
Plugin 'flazz/vim-colorschemes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'itchyny/lightline.vim'
Plugin 'whatyouhide/vim-gotham'
Plugin 'dylanaraps/wal'
Plugin 'vimoxide/vim-cinnabar'
" ----- Vim as a programmer's text editor -----------------------------
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/nerdcommenter'
Plugin 'terryma/vim-multiple-cursors'
"-----Snippets--------------------------------------------------------
"Plugin 'sirVer/ultisnips'
"Plugin 'honza/vim-snippets'
"Plugin 'roxma/nvim-completion-manager'
" ----- Programming / Latex setup------------------------------------- 
Plugin 'jpalardy/vim-slime'
Plugin 'vim-scripts/indentpython.vim'
"Plugin 'hanschen/vim-ipython-cell'
"Plugin 'python-mode/python-mode'
"Plugin 'jalvesaq/vimcmdline'

"------ Pandoc-------------------------------------------------------- 
Plugin 'lervag/vimtex'
Plugin 'KeitaNakamura/tex-conceal.vim'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-rmarkdown'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'kaarmu/typst.vim'
"------ linter etc --------------------------------------------------- 
Plugin 'vim-scripts/a.vim'
Plugin 'w0rp/ale'
" ----- Working with Git ----------------------------------------------
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
" ----- Other text editing features -----------------------------------
Plugin 'Raimondi/delimitMate'
Plugin 'christoomey/vim-tmux-navigator'

call vundle#end()

" -- general settings -----
"colorscheme gotham256
set bg=dark
colorscheme cinnabar

set number 
set backspace=indent,eol,start
set ruler
set showcmd
set incsearch
set hlsearch
set wrap
set linebreak
set nolist 
"set cursorcolumn
set cursorline

hi pythonSelf  ctermfg=68  guifg=#5f87d7 cterm=bold gui=bold

set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set matchpairs+=<:> " use % to jump between pairs
set laststatus=2

if !has('gui_running')
    set t_Co=256
    set gfn=Liberation\ Mono\12,Inconsolata\ 12 
  endif
" Pandoc settings
let g:pandoc#command#latex_engine="xelatex"
let g:pandoc#command#autoexec_on_writes=0
let g:pandoc#command#autoexec_command="Pandoc pdf"
let g:pandoc#syntax#conceal#use = 0
let g:pandoc#modules#disabled = ["folding", "spell"]

let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_conceal = 1

" Latex settings
let g:tex_flavor='xelatex'
"let g:vimtex_view_method='okular'
let g:vimtex_quickfix_mode=0
let g:vimtex_compiler_latexmk={'callback' : 0}
set conceallevel=1
let g:tex_conceal='abdmg'
hi Conceal ctermbg=none

""""""""""""""""""""""""""""""""""""""""""""""""""""
" Slime settings
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}

let g:slime_dont_ask_default = 1
let g:slime_python_ipython = 1

nmap <Leader>s <Plug>SlimeRegionSend
nmap <Leader>s <Plug>SlimeParagraphSend
nmap <Leader>w <Plug>SlimeLineSend

vnoremap <Leader>s <Plug>SlimeRegionSend
vnoremap <Leader>s <Plug>SlimeParagraphSend
vnoremap <Leader>w <Plug>SlimeLineSend

""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:pymode_python='/home/alal/anaconda3/bin/python'

" ----- jistr/vim-nerdtree-tabs -----
" Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
let NERDTreeWinSize=23
let NERDTreeDirArrows=0 
" To have NERDTree always open on startup
let g:nerdtree_tabs_open_on_console_startup =0 

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" ----- scrooloose/syntastic settings -----
let g:syntastic_error_symbol = 'X'
:let g:syntastic_warning_symbol = 'O'
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END

" ----- airblade/vim-gitgutter settings -----
" Required after having changed the colorscheme
hi clear SignColumn
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" ----- Raimondi/delimitMate settings -----
let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
  au FileType java let b:delimitMate_matchpairs = "(:),[:],{:}"
  au FileType java let b:delimitMate_nesting_quotes = ['"', "'"]
  au FileType scala let b:delimitMate_matchpairs = "(:),[:],{:}"
  au FileType scala let b:delimitMate_nesting_quotes = ['"', "'"]
  au FileType js let b:delimitMate_matchpairs = "(:),[:],{:}"
  au FileType js let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" Enable folding (za)
set foldmethod=indent
set foldlevel=99

" width of a tab space
set tabstop=4
set shiftwidth=4
" expand tabs with spaces
set et
" ignore case in search 
set ic
set smartcase
" set lightline to include git-branch
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ,
      \             [ 'venv', 'readonly'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \    'venv': 'virtualenv#statusline'
      \ },
      \ }

" pip install flake8
let g:ale_linters = {'python': [],'r':[]}
let g:ale_fixers = {
\    'python': ['yapf', 'remove_trailing_lines', 'trim_whitespace'],
\    'r': ['remove_trailing_lines', 'trim_whitespace'],
\} 
"let g:ale_fix_on_save = 1
let g:python_host_prog = '/home/alal/anaconda3/bin/python'
let g:python3_host_prog = '/home/alal/anaconda3/bin/python'


" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let undo_dir = expand('$HOME/.vim/undo_dir')
    if !isdirectory(undo_dir)
        call mkdir(undo_dir, "", 0700)
    endif
    set undodir=$HOME/.vim/undo_dir
    set undofile
endif

