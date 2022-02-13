call plug#begin('~/.config/nvim/plugged')
  Plug 'bling/vim-airline'                        " Powerline with colors
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'                         " Search
  Plug 'tpope/vim-vinegar'                        " Vinegar
  Plug 'preservim/nerdcommenter'                  " the missing comment tool
  Plug 'gruvbox-community/gruvbox'
  Plug 'tpope/vim-fugitive'                       " Git for git blame..
  Plug 'tpope/vim-rhubarb'                        " Required by vim fugitive to integrate with Github

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'

  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  " Plug 'puremourning/vimspector'
  Plug 'mfussenegger/nvim-dap'
  Plug 'leoluz/nvim-dap-go'


  Plug 'vim-scripts/scratch.vim'                  " Block note into buffer
  Plug 'mattn/gist-vim'                           " Publish / edit Gist on Github from buffer
  Plug 'mattn/webapi-vim'                         " Required to use gist-vim
call plug#end()            " required

set termguicolors
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
let g:gruvbox_improved_warnings = 1
colorscheme gruvbox

set cursorline          " Higlight the current line
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
set formatoptions+=j " Delete comment character when joining commented lines

" Search options
set ignorecase
set hlsearch
set incsearch
set showmatch
set smartcase           " but become case sensitive if you type uppercase characters
set history=1000        " keep 1000 lines of command history
set splitright          " the new window is created on the right

set clipboard=unnamed

lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- { "bash", "go", "javascript" }, one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        virtual_text = false
    }
)

function goimp(waitms) 
  wait_ms = wait_ms
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { 'source.organizeImports' } }

  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, wait_ms)
  for client_id, res in pairs(result or {}) do
    local client = vim.lsp.get_client_by_id(client_id)
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
      end
    end
  end
end

function goimports(timeoutms)
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, "t", true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  -- See the implementation of the textDocument/codeAction callback
  -- (lua/vim/lsp/handler.lua) for how to do this properly.
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  if not result or next(result) == nil then return end
  local actions = result[1].result
  if not actions then return end
  local action = actions[1]

  -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
  -- is a CodeAction, it can have either an edit, a command or both. Edits
  -- should be executed first.
  if action.edit or type(action.command) == "table" then
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit)
    end
    if type(action.command) == "table" then
      vim.lsp.buf.execute_command(action.command)
    end
  else
    vim.lsp.buf.execute_command(action)
  end
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

nvim_lsp.gopls.setup{
  cmd = {"gopls", "--remote=auto"},
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  root_dir = nvim_lsp.util.root_pattern("go.mod", "main.go", ".git", "README.md", "LICENSE"),
  ignoredRootPaths = { "$HOME/src/github.com/monzo/wearedev/" },
  memoryMode = "DegradeClosed",
  on_attach = on_attach
}

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      -- behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
--    ['<S-Tab>'] = function(fallback)
--      if vim.fn.pumvisible() == 1 then
--        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
--      else
--        fallback()
--      end
--    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
  },
}

-- Golang debugger
-- https://github.com/leoluz/nvim-dap-go
--require('dap-go').setup()
EOF

" nmap <silent> <leader>td :lua require('dap-go').debug_test()<CR>
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()
autocmd BufWritePre *.go lua goimp(1000)

nnoremap <C-P> :Files<CR>

let g:fzf_layout = { 'down': '40%' }
let g:fzf_history_dir = '~/.local/share/fzf-history-nvim'

" command! -bang -nargs=* AllFiles call FZFAllFiles()
" command! -bang -nargs=? -complete=dir Files
"
function! Zoekt(...)
    return system('zoekt ' . join(a:000, ' '))
endfunction

command! -nargs=+ -complete=file -bar Zoekt cgetexpr Zoekt(<f-args>)|botright cw|redraw!
nnoremap <Leader>z :Zoekt<Space>

if executable('rg')
  set grepprg=rg\ -H\ --no-heading\ --vimgrep
  command -nargs=+ -complete=file -bar Crg silent! grep! <args>|botright cw|redraw!

  nnoremap <Leader>f :Crg<Space>
  " grep word under cursor
  nnoremap <Leader>F :Crg <C-R><C-W><CR>
endif

nnoremap <Leader>p :Buffers<CR>

let g:airline_theme = 'gruvbox'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" Gist
let g:gist_post_private = 1
let g:gist_detect_filetype = 1

" Nerdcommenter
let NERDSpaceDelims = 1

autocmd FileType markdown setlocal spell
autocmd FileType markdown setlocal linebreak " wrap on words, not characters

