filetype off

call plug#begin()

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'ap/vim-css-color'
Plug 'ervandew/supertab'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'jiangmiao/auto-pairs'
Plug 'joshdick/onedark.vim'
Plug 'jacoborus/tender.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yggdroot/indentline'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }
Plug 'NLKNguyen/papercolor-theme'
Plug 'lervag/vimtex'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'rhysd/vim-clang-format'
Plug 'ryanoasis/vim-devicons'

call plug#end()

let g:tex_flavor = 'latex'

syntax on
filetype plugin indent on

set path=$PWD/**
set mouse=a
set cursorline
set encoding=utf-8
set laststatus=2
set number
set showcmd
set wildmenu
set ignorecase
set cindent
set tabstop=2
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start
set termguicolors
set relativenumber
set grepprg=rg\ --vimgrep

colorscheme onedark

" global variables
let g:clang_format#auto_format = 1
let g:clang_format#detect_style_file = 1

let g:netrw_liststyle = 3
let g:netrw_banner = 0

let g:go_fmt_command = "goimports"

let g:rustfmt_autosave = 1
let g:rustfmt_tab_spaces = 2

" close preview window automatically
let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabDefaultCompletionType = '<C-n>'

" nvim-gdb 
function! NvimGdbNoTKeymaps()
  tnoremap <silent> <buffer> <esc> <c-\><c-n>
endfunction

let g:nvimgdb_config_override = {
  \ 'key_next': 'n',
  \ 'key_step': 's',
  \ 'key_finish': 'f',
  \ 'key_continue': 'c',
  \ 'key_until': 'u',
  \ 'key_breakpoint': 'b',
  \ 'set_tkeymaps': "NvimGdbNoTKeymaps",
  \ }

" coc bindings
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <leader> rn <Plug>(coc-rename)
nmap <silent> fx  <Plug>(coc-fix-current)

nnoremap <silent> ge  :<C-u>CocList extensions<cr>
nnoremap <silent> go  :<C-u>CocList outline<cr>
nnoremap <silent> gD :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" key bindings
map <C-b> :NERDTreeToggle<CR>

nnoremap <leader>oc :edit ~/.config/nvim/init.vim<CR>
nnoremap th :set hlsearch!<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <C-right> <C-w><right>
nnoremap <C-left> <C-w><left>
nnoremap <C-up> <C-w><up>
nnoremap <C-down> <C-w><down>
tnoremap <Esc> <C-\><C-n>

" function! Formatonsave()
"   let l:formatdiff = 1
"   py3file /usr/share/clang/clang-format.py
" endfunction
" autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()

autocmd FileType cpp nnoremap <buffer> <F5> :!g++ -g3 -std=c++17 %:p -o %:r <CR>
autocmd FileType go nnoremap <buffer> <F5> :GoRun<CR>
" autocmd FileType rust nnoremap <buffer> <F5> :Crun<CR>


augroup filetype
  au! BufRead,BufNewFile *.ll     set filetype=llvm
  au! BufRead,BufNewFile *.td     set filetype=tablegen
augroup END

