set nocompatible
set showmatch
set ignorecase
set mouse=v
set hlsearch
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent
set number

call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sonph/onehalf', {'rtp': 'vim/'}

Plug 'vim-syntastic/syntastic'
Plug 'Chiel92/vim-autoformat'
Plug 'sheerun/vim-polyglot'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

syntax on
colorscheme onehalfdark
set termguicolors
set cursorline
let g:airline_theme='onehalfdark'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:deoplete#enable_at_startup = 1
call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment'])

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
