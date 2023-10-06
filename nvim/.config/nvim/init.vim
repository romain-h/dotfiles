call plug#begin('~/.config/nvim/plugged')
  Plug 'bling/vim-airline'                        " Powerline with colors
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'                         " Search
  Plug 'tpope/vim-vinegar'                        " Vinegar
  Plug 'preservim/nerdcommenter'                  " the missing comment tool
  Plug 'gruvbox-community/gruvbox'
  Plug 'tpope/vim-fugitive'                       " Git for git blame..
  Plug 'tpope/vim-rhubarb'                        " Required by vim fugitive to integrate with Github
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
  Plug 'nvim-lua/plenary.nvim'
  Plug 'jose-elias-alvarez/null-ls.nvim'

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'

  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }

  " Plug 'puremourning/vimspector'
  Plug 'mfussenegger/nvim-dap'
  Plug 'leoluz/nvim-dap-go'


  Plug 'vim-scripts/scratch.vim'                  " Block note into buffer
  Plug 'mattn/gist-vim'                           " Publish / edit Gist on Github from buffer
  Plug 'mattn/webapi-vim'                         " Required to use gist-vim
  Plug 'github/copilot.vim'
call plug#end()            " required


set termguicolors
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
let g:gruvbox_improved_warnings = 1

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
set backup                        " enable backup
set backupcopy=yes                " auto mode bug with a watcher task

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
  ensure_installed = "all", -- { "bash", "go", "javascript" }, one of "all", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}

local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')
local null_ls = require('null-ls')


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
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end
-- TODO find a way to run test from test block
-- lua vim.lsp.codelens.refresh()
-- lua vim.lsp.codelens.run()
-- How can we render the result in another page?

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

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

nvim_lsp.gopls.setup{
    on_init = function(client)
      local path = client.workspace_folders[1].name

      if string.find(path, "monzo/wearedev") then
         client.config.settings.gopls['local'] = 'github.com/monzo/wearedev'
      end

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      return true
    end,
    cmd = {"gopls", "-remote=auto"},
    capabilities = capabilities,
    filetypes = {"go", "gomod"},

    -- Ignore typical project roots which cause gopls to ingest large monorepos.
    --root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    root_dir = util.root_pattern("main.go", "README.md", "LICENSE"),

    settings = {
      gopls = {
        -- Don't try to find the go.mod file, otherwise we ingest large monorepos
        expandWorkspaceToModule = false,
        memoryMode = "DegradeClosed",
        directoryFilters = {
          "-vendor",
          "-manifests",
        },
        codelenses = {
          generate = true,
          gc_details = true,
          test = true,
          tidy = true,
        },
      },
    },
    on_attach = on_attach
}

nvim_lsp.flow.setup{
  on_attach = on_attach
}

nvim_lsp.tsserver.setup{
  on_attach = on_attach
}

nvim_lsp.pyright.setup{
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
  require('dap-go').setup()

-- Spellcheck / Vale syntax
null_ls.setup({
 sources = {
   null_ls.builtins.diagnostics.vale,
 },
 on_attach = on_attach
})
EOF

" nmap <silent> <leader>td :lua require('dap-go').debug_test()<CR>
autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = false })
autocmd BufWritePre *.go lua goimp(1000)

" Trim trailing whitespace when saving a document
autocmd BufWritePre * :%s/\s\+$//e
autocmd FileType go set colorcolumn=120

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
nnoremap <Leader>m :Marks<CR>
nnoremap <Leader>h :!handlertool '. getpos('.')<CR>
vnoremap <Leader>j :%!python -m json.tool<CR>

imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" Replace base64 content
vnoremap <leader>64 c<c-r>=system('base64 --decode', @")<cr><esc>
" S101 exec
nmap <leader>8 :exec "r !£ -e s101 \'".getline('.')."\'"
function! S101()
  execute "r !£ -e s101 \'".getline('.')."\'"
endfunction

nnoremap gh :let pp=getpos('.')<CR>:let res=split(system('handlertool '.shellescape(expand('%:p').':'.line('.').':'.col('.'))), ':')<CR>:e <C-R>=res[0]<CR><CR>:call setpos('.',[pp[0],res[1],res[2],0])<CR>

let g:airline_theme = 'gruvbox'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" Gist
let g:gist_post_private = 1
let g:gist_detect_filetype = 1

" Nerdcommenter
let NERDSpaceDelims = 1

" Prettier
" let g:prettier#autoformat = 1
" let g:prettier#autoformat_require_pragma = 0

autocmd FileType markdown setlocal spell
autocmd FileType markdown setlocal linebreak " wrap on words, not characters

