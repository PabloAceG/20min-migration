" URL:
" Authors: PabloAceG <https://github.com/PabloAceG>
" Description: My personal setup to use Vim comfortably.
" Disclaimer: This is a basic .vimrc, feel free to include or delete anything 
" you need. It's been inspired by:
" https://gist.github.com/simonista/8703722
" https://vim.fandom.com/wiki/Example_vimrc

" Don't try to be vi compatible
set nocompatible

" ----------------------------------------
" ---------------- EDITOR ----------------
" Turn on syntax highlight
syntax on

" Security
set modelines=0

" Show line number
set number

" Highlight cursor line underneath curso (horizontally)
set cursorline
" Remove the underline from enabling cursorline
:highlight clear CursorLine 
:highlight clear CursorLineNR
" Color customization:
" https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
" Set cursor line to have lighter background
:highlight CursorLine ctermbg=233
" Set line numbering to lighter background
:highlight CursorLineNR ctermbg=236

" Show file stats
set ruler

" Blink curson on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Completion
set wildmenu
set wildmode=longest,list:lastused " Complee longest common string, then list alternatives sorted by last used

" Whitespace
set wrap
set textwidth=80
set colorcolumn=80
set formatoptions=tcon1j
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent " When new line or no file-specific indenting, keep same indent as current

" Cursor motion
set mouse=a " Enable mouse for all modes
if $TERM == 'alacritty' " Avoid Vim bug not detecting mouse terminal events
    set ttymouse=sgr
endif

set scrolloff=5
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Allow hidden buffers
se hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2 " Always display status bar, even if one window displayed

" Last line
set noshowmode " Get rid of -- INSERT -- below lightline
set showcmd " Show partial commands in the last line of the screen
set cmdheight=2

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬

" ----------------------------------------
" -------------- SEARCHING ---------------
set hlsearch " When previous search patterm, highlight all its matches
set incsearch " While typing search, show pattern as typed so far
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " Clear search

" ----------------------------------------
" ---------------- PLUGINS ---------------
"  To install the plugins just run :PlugInstall in Vim
" Helps force plugins to load correclty when it is turned back on below
filetype off

" NOTE: Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" GitHub: https://github.com/itchyny/lightline.vim
Plug 'itchyny/lightline.vim'
" GitHub: https://github.com/dense-analysis/ale
Plug 'dense-analysis/ale'
" GitHub: https://github.com/maximbaz/lightline-ale
Plug 'maximbaz/lightline-ale'

" GitHub: https://github.com/preservim/nerdtree
Plug 'preservim/nerdtree'
" GitHub: https://github.com/Xuyuanp/nerdtree-git-plugin
Plug 'Xuyuanp/nerdtree-git-plugin'
" GitHub: https://github.com/ryanoasis/vim-devicons
Plug 'ryanoasis/vim-devicons'
" GitHub: https://github.com/tiagofumo/vim-nerdtree-syntax-highlight
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" GitHub: https://github.com/PhilRunninger/nerdtree-visual-selection
Plug 'PhilRunninger/nerdtree-visual-selection'
" GitHub: https://github.com/preservim/nerdcommenter
Plug 'preservim/nerdcommenter'

" GitHub: https://github.com/airblade/vim-gitgutter/
Plug 'airblade/vim-gitgutter'
" GitHub: https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'
" GitHub: https://github.com/itchyny/vim-gitbranch
Plug 'itchyny/vim-gitbranch'

" GitHub: https://github.com/frazrepo/vim-rainbow
Plug 'frazrepo/vim-rainbow'
" GitHub: https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

" GitHub: https://github.com/mg979/vim-visual-multi
Plug 'mg979/vim-visual-multi'

" GitHub: https://github.com/hashivim/vim-terraform
Plug 'hashivim/vim-terraform'

" GitHub: https://github.com/ycm-core/YouCompleteMe
" NOTE: After installation need to trigger compilation manually:
"       cd ~/.vim/bundle/YouCompleteMe
"       python3 install.py --****-completer
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }

call plug#end()

" For plugins to load correctly
filetype plugin indent on

" Terraform identation
autocmd FileType terraform 
    \ set tabstop=2 | 
    \ set softtabstop=2 | 
    \ set shiftwidth=2 | 
    \ set smarttab |
    \ set expandtab

" ----------------------------------------
" -------- Plugins Configuration ---------

" Change lightline colorschema and include plugins
let g:lightline = {
        \ 'colorscheme': 'wombat',
    \ 'active': {
        \   'left': [ 
        \     [ 'mode', 'paste' ],
    \     [ 'gitbranch', 'readonly', 'filename', 'modified' ]
    \   ],
    \   'right': [
        \     [ 'lineinfo' ],
    \     [ 'percent' ],
    \     [ 'fileencodig', 'fileformat', 'filetype', 'charvaluehex' ],
    \     [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ]
    \   ]
    \ },
    \ 'component': {
        \   'charvaluehex': '0x%B'
    \ },
    \ 'component_function': {
        \   'gitbranch': 'FugitiveHead'
    \ },
    \ 'component_expand': {
        \   'linter_checking': 'lightline#ale#checking',
    \   'linter_infos': 'lightline#ale#infos',
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok', 
    \ },
    \ 'component_type': {
        \   'linter_checking': 'right',
    \   'linter_infos': 'right',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'right',
    \ }
    \ }

" Specify unicode icons for lightline#ale integration
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_infos = "\uf129"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Change NERDTree Git plugin symbols
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ 'Modified'  :'✹',
    \ 'Staged'    :'✚',
    \ 'Untracked' :'✭',
    \ 'Renamed'   :'➜',
    \ 'Unmerged'  :'═',
    \ 'Deleted'   :'✖',
    \ 'Dirty'     :'✗',
    \ 'Ignored'   :'☒',
    \ 'Clean'     :'✔︎',
    \ 'Unknown'   :'?',
    \ }

" NERDTree Synta highlight
" Full files name
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
" Highlight folders using exact match
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
" Disable uncommon file extension highlighting (this is a good idea if
" experiencing lag when scrolling).
" Limits the extensions to these:
" .bmp, .c,   .coffee, .cpp,   .cs,   .css, .erb,      .go,  .hs,  .html,
" .java, 
" .jpg, .js,  .json,   .jsx,   .less, .lua, .markdown, .md,  .php, .png, .pl,   
" .py,  .rb,  .rs,     .scala, .scss, .sh,  .sql,      .vim
" let g:NERDTreeLimitedSyntax = 1

" =====> Vim Rainbow
" Enable Vim Rainbow globally
let g:rainbow_active = 1
