" reset vim  to vim-defaults
if &compatible          " only if not set before:
  set nocompatible      " use vim-defaults instead of vi-defaults (easier, more user friendly)
endif

" Plugins Manager
call plug#begin('~/.vim/plugged')
" Vundle manage
Plug 'gmarik/vundle'
Plug 'bling/vim-airline'                        " Powerline with colors
Plug 'sjl/vitality.vim'                         " AutoReload
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                         " Search
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP client
Plug 'tpope/vim-vinegar'                        " Vinegar
Plug 'preservim/nerdcommenter'                  " the missing comment tool
Plug 'w0rp/ale'                                 " Linter
Plug 'tpope/vim-surround'                       " Surrounder
Plug 'vim-scripts/scratch.vim'                  " Block note into buffer
Plug 'tpope/vim-fugitive'                       " Git for git blame..
Plug 'tpope/vim-rhubarb'                        " Required by vim fugitive to integrate with Github
Plug 'junegunn/vim-easy-align'                  " Align with ga
Plug 'mattn/gist-vim'                           " Publish / edit Gist on Github from buffer
Plug 'mattn/webapi-vim'                         " Required to use gist-vim
Plug 'mattn/emmet-vim'                          " html tags

" Theme
" -----
Plug 'gruvbox-community/gruvbox'
Plug 'w0ng/vim-hybrid'
Plug 'joshdick/onedark.vim'

" Languages
Plug 'sheerun/vim-polyglot'
call plug#end()            " required

filetype plugin on
filetype indent on
syntax on

" Color
set termguicolors
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
let g:gruvbox_improved_warnings = 1
" let g:gruvbox_guisp_fallback = 'bg' " Show error with background until iTerm2 supports undercurl
" https://gitlab.com/gnachman/iterm2/-/issues/6382

colorscheme gruvbox

" display settings
set background=dark     " enable for dark terminals
set cursorline          " Higlight the current line
set scrolloff=2         " 2 lines above/below cursor when scrolling
set sidescrolloff=5
set display+=lastline
set number              " show line numbers
set showmatch           " show matching bracket (briefly jump)
set showmode            " show mode in status bar (insert/replace/...)
set showcmd             " show typed command in status bar
set ruler               " show cursor position in status bar
set title               " show file in titlebar
set wildmenu            " completion with menu
set wildmode=longest:full,full
set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn,.git
set laststatus=2        " use 2 lines for the status bar
set matchtime=2         " show matching bracket for 0.2 seconds
set matchpairs+=<:>     " specially for html

" editor settings
set colorcolumn=80             " Colum lenght
set autoindent smartindent     " turn on auto/smart indenting
set smarttab                   " smart tab handling for indenting
set magic                      " change the way backslashes are used in search patterns
set backspace=indent,eol,start " Allow backspacing over everything in insert mode
set tabstop=2                  " number of spaces a tab counts for
set shiftwidth=2               " spaces for autoindents
set expandtab                  " turn a tabs into spaces
set undolevels=10000           " number of forgivable mistakes
set ttimeout
set ttimeoutlen=100
set timeoutlen=3000
set fileformat=unix            " file mode is unix
set diffopt=filler,iwhite      " ignore all whitespace and sync
set relativenumber             " relative number (check auto switch into mapping)
set nrformats-=octal

set encoding=utf-8
set fileencoding=utf-8

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Trim trailing whitespace when saving a document
autocmd BufWritePre * :%s/\s\+$//e

"Better line wrapping
set wrap
set textwidth=80
set formatoptions=qrn1

"Enable code folding
set foldenable

" Search options
set ignorecase
set hlsearch
set incsearch
set showmatch
set smartcase           " but become case sensitive if you type uppercase characters

" system settings
set lazyredraw          " no redraws in macros
set confirm             " get a dialog when :q, :w, or :wq fails
set viminfo='20,\"500   " remember copy registers after quitting in the .viminfo file -- 20 jump links, regs up to 500 lines'
set hidden              " remember undo after quitting
set history=1000        " keep 1000 lines of command history
set mouse=a             " use mouse in all modes
set mousehide           " Hide mouse when typing
set splitright          " the new window is created on the right

if &tabpagemax < 50
  set tabpagemax=50
endif

if !empty(&viminfo)
  set viminfo^=!
endif

set sessionoptions-=options
set viewoptions-=options

" Backups
if !isdirectory($HOME."/.vim/tmp/backup")
  call mkdir($HOME."/.vim/tmp/backup", "p")
endif
set backupdir=~/.vim/tmp/backup// " backups
if !isdirectory($HOME."/.vim/tmp/swap")
  call mkdir($HOME."/.vim/tmp/swap", "p")
endif
set directory=~/.vim/tmp/swap//   " swap files
if !isdirectory($HOME."/.vim/tmp/undo")
  call mkdir($HOME."/.vim/tmp/undo", "p")
endif
set undodir=~/.vim/tmp/undo//     " undo files
set backup                        " enable backup
set backupcopy=yes                " auto mode bug with a watcher task

" auto file reloading
set autoread
if !has('gui_running')
  " working thanks to vitality plugin and `set -g focus-events on` in tmux conf
 autocmd FocusGained,BufEnter * :silent! checktime
endif

" Remove bell beeping
set vb
set noeb vb t_vb=

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --hidden --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* RG call RipgrepFzf(<q-args>, <bang>0)
  " let g:fzf_layout = { 'tmux': '-p90%,60%' }
  " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
  " let g:fzf_preview_window = 'right:50%'

" ==== Mappings ====================
" ==================================
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Disable useless and annoying keys
noremap Q <Nop>

nnoremap <C-P> :Files<CR>
nnoremap <Leader>p :Buffers<CR>
" grep word under cursor
nnoremap <Leader>F :RG <C-R><C-W><CR>
nnoremap <Leader>f :RG<CR>
vnoremap <Leader>j :%!python -m json.tool<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"Shortcut for editing  vimrc file in a new tab
nmap <leader>ev :tabedit $MYVIMRC<cr>
nmap <leader>le :set spell spelllang=en_gb<cr>
nmap <leader>lf :set spell spelllang=fr_fr<cr>

" line number
nnoremap <silent><leader>n :set rnu! rnu? <cr>

autocmd FocusLost * :set number
autocmd FocusGained * :set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

"----------------------
" Plugins configuration
"----------------------

" Airline
let g:airline_theme = 'gruvbox'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
" let g:airline#extensions#syntastic#enabled = 0

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete colorcolumn=100
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType gitcommit setlocal spell

inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" Gist
let g:gist_post_private = 1
let g:gist_detect_filetype = 1

" UltiSnips
let g:UltiSnipsEditSplit="vertical"

autocmd BufNewFile,BufRead *{-spec,Spec,-test}.js set ft=javascript.jasmine
autocmd BufNewFile,BufRead *.scala set ft=scala

" JSX
let g:jsx_ext_required = 0

" Go
let g:go_fmt_command = "goimports"
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_auto_sameids = 1

" Rust
let g:rustfmt_autosave = 1

" handlebars templates
autocmd BufNewFile,BufRead *.hb set ft=handlebars

" Nerdcommenter
let NERDSpaceDelims = 1

" Typescript
let g:typescript_indent_disable = 1

autocmd FileType sh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType yml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType make setlocal noexpandtab

" Linter / Fixer [ALE config]
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = "[%linter%] %severity% - %s"
let g:ale_linters = {
    \   'javascript': ['eslint', 'flow'],
    \   'javascript.jsx': ['eslint', 'flow'],
    \   'typescript': ['eslint', 'tsserver'],
    \   'typescriptreact': ['eslint', 'tsserver'],
    \   'css': ['prettier'],
    \   'sh': ['shellcheck'],
    \   'python': ['flake8'],
    \}
let g:ale_fixers = {
    \   'javascript': ['prettier'],
    \   'javascript.jsx': ['prettier'],
    \   'typescript': ['prettier'],
    \   'typescriptreact': ['prettier'],
    \   'css': ['prettier'],
    \   'sh': ['shfmt'],
    \   'python': ['black'],
    \}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0

if filereadable(expand($HOME . "/.vim/cfg/coc.vim"))
  source $HOME/.vim/cfg/coc.vim
endif

" Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
if has("autocmd")
 augroup myvimrchooks
  au!
  autocmd bufwritepost .vimrc source $HOME/.vimrc
 augroup END
endif

set clipboard=unnamed
" To see all leader mappings currently in use:
" grep -R leader .vimrc .vim/bundle | perl -pe 's/.+(<leader>\w+).+/\1/' | sort | uniq
