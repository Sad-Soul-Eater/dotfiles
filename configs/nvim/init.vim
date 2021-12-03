call plug#begin('~/.vim/plugged')

" Basic plugins
Plug 'w0rp/ale'
Plug 'Chiel92/vim-autoformat'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'romainl/vim-qf'
Plug '/bin/fzf'

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" Autocomplete plugins
Plug 'autozimu/LanguageClient-neovim', {
			\ 'branch': 'next',
			\ 'do': 'bash install.sh',
			\ }

Plug 'Shougo/echodoc.vim'

Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'

Plug 'ncm2/ncm2-neosnippet'
Plug 'ncm2/ncm2-bufword'
Plug 'fgrsnau/ncm2-otherbuf'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-html-subscope'
Plug 'ncm2/ncm2-markdown-subscope'
Plug 'ncm2/ncm2-syntax'     | Plug 'Shougo/neco-syntax'
Plug 'ncm2/ncm2-neoinclude' | Plug 'Shougo/neoinclude.vim'
Plug 'ncm2/ncm2-vim'        | Plug 'Shougo/neco-vim'

" Version control (mostly git) plugins
Plug 'mhinz/vim-signify'
Plug 'gregsexton/gitv', {'on': ['Gitv']}
Plug 'tpope/vim-fugitive'

" Not so important and used plugins
Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'corntrace/bufexplorer'
Plug 'rbgrouleff/bclose.vim'

" Visual/interface plugins, themes
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ntpeters/vim-better-whitespace'
Plug '~/.config/nvim/plugins/cs'

" Language specific plugins
Plug 'sheerun/vim-polyglot'

Plug 'sebdah/vim-delve'

Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}

Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'

Plug 'stephpy/vim-yaml'
Plug 'mrk21/yaml-vim'
Plug 'tarekbecker/vim-yaml-formatter'

Plug 'lifepillar/pgsql.vim'

Plug 'zdharma-continuum/zinit-vim-syntax'

call plug#end()

"------------------------------------------------------------------------------
" General
"------------------------------------------------------------------------------
" let's make sure we are in noncompatble mode
set nocompatible

" Sets how many lines of history VIM has to remember
set history=1024

set ttyfast

" Enable filetype plugins
filetype plugin on
filetype indent on

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
map <Leader>w :w<CR>
vmap <Leader>w <ESC><ESC>:w<CR>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

noremap <F3> :Autoformat<CR>

" Copy/paste from system clipboard only when it needed
function! ClipboardYank()
	call system('xclip -i -selection clipboard', @@)
endfunction
function! ClipboardPaste()
	let @@ = system('xclip -o -selection clipboard')
endfunction

vnoremap <silent><leader>y y:call ClipboardYank()<cr>
vnoremap <silent><leader>d d:call ClipboardYank()<cr>
nnoremap <silent><leader>p :call ClipboardPaste()<cr>p


"------------------------------------------------------------------------------
" VIM user interface
"------------------------------------------------------------------------------
set autoindent
set autowrite

" Make sure that cursor is always vertically centered on j/k moves
set so=999

" add vertical lines on columns
set colorcolumn=80,120

" Highlight current line - allows you to track cursor position more easily
set cursorline

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,.git\*,.hg\*,.svn\*

" Show line, column number, and relative position within a file in the status line
set ruler

" Show line numbers
set number

" Show (partial) commands (or size of selection in Visual mode) in the status line
set showcmd

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Allow smarter completion by infering the case
set infercase

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Make sure that extra margin on left is removed
set foldcolumn=0

" Enable Ctrl-A/Ctrl-X to work on octal and hex numbers, as well as characters
set nrformats=octal,hex,alpha

" Avoiding the 'Hit ENTER to continue' prompts
set shortmess=a
set cmdheight=2

" Use Unix as the standard file type
set ffs=unix,dos,mac


"------------------------------------------------------------------------------
" Colors and Fonts
"------------------------------------------------------------------------------
" Enable syntax highlighting
colorscheme cs
set termguicolors

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Show status bar by default.
set laststatus=2

" Enable top tabline.
let g:airline#extensions#tabline#enabled = 1

" Disable showing tabs in the tabline. This will ensure that the buffers are
" what is shown in the tabline at all times.
let g:airline#extensions#tabline#show_tabs = 0

" Enable powerline fonts.
let g:airline_powerline_fonts = 1

let g:airline_theme='cs'

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

"------------------------------------------------------------------------------
" Files, backups and undo
"------------------------------------------------------------------------------
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Remember things between sessions
"
" '20  - remember marks for 20 previous files
" \"50 - save 50 lines for each register
" :20  - remember 20 items in command-line history
" /20  - remember 20 items in search history
" %    - remember the buffer list (if vim started without a file arg)
" n    - set name of viminfo file
set viminfo='20,\"50,:20,%,n~/.cache/.viminfo.tmp

" Define what to save with :mksession
" blank - empty windows
" buffers - all buffers not only ones in a window
" curdir - the current directory
" folds - including manually created ones
" help - the help window
" options - all options and mapping
" winsize - window sizes
" tabpages - all tab pages
set sessionoptions=blank,buffers,curdir,folds,help,options,winsize,tabpages


"------------------------------------------------------------------------------
" Text, tab and indent related
"------------------------------------------------------------------------------
" Use tabs instead of spaces
set noexpandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Round indent to multiple of 'shiftwidth' for > and < commands
set shiftround

" Linebreak on 500 characters
set linebreak
set tw=500

set smartindent
set nowrap "Don't Wrap lines (it is stupid)


"------------------------------------------------------------------------------
" Visual mode related
"------------------------------------------------------------------------------
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>


"------------------------------------------------------------------------------
" Moving around, tabs, windows and buffers
"------------------------------------------------------------------------------
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tj :tabnext<cr>
map <leader>tk :tabprevious<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

"" Close the current buffer (w/o closing the current window)
map <leader>bd :Bclose<cr>

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
	set switchbuf=useopen,usetab,newtab
	set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\   exe "normal! g`\"" |
			\ endif


"------------------------------------------------------------------------------
" Editing mappings
"------------------------------------------------------------------------------
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk]
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv


"------------------------------------------------------------------------------
" Ack searching and cope displaying
" (requires ack.vim - it's much better than vimgrep/grep)
"------------------------------------------------------------------------------
" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
map <leader>a :Ack<space>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
"map <leader>n :cn<cr>
"map <leader>p :cp<cr>


"------------------------------------------------------------------------------
" Spell checking
"------------------------------------------------------------------------------
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"------------------------------------------------------------------------------
" Misc
"------------------------------------------------------------------------------
" Easy way to edit reload .vimrc
nmap <leader>V :source $MYVIMRC<cr>
nmap <leader>v :vsp $MYVIMRC<cr>


"------------------------------------------------------------------------------
" Helper functions
"------------------------------------------------------------------------------
function! CmdLine(str)
	exe "menu Foo.Bar :" . a:str
	emenu Foo.Bar
	unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
	let l:saved_reg = @"
	execute "normal! vgvy"

	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")

	if a:direction == 'b'
		execute "normal ?" . l:pattern . "^M"
	elseif a:direction == 'gv'
		call CmdLine("Ack \"" . l:pattern . "\" " )
	elseif a:direction == 'replace'
		call CmdLine("%s" . '/'. l:pattern . '/')
	elseif a:direction == 'f'
		execute "normal /" . l:pattern . "^M"
	endif

	let @/ = l:pattern
	let @" = l:saved_reg
endfunction


"------------------------------------------------------------------------------
" NERDTree
"------------------------------------------------------------------------------
" General properties
let NERDTreeDirArrows=1
let NERDTreeIgnore=['\.o$', '\.pyc$', '\.php\~$']
let NERDTreeWinSize = 35

" Make sure that when NT root is changed, Vim's pwd is also updated
let NERDTreeChDirMode = 2
let NERDTreeShowLineNumbers = 1
let NERDTreeAutoCenter = 1

" Open NERDTree on startup, when no file has been specified
autocmd VimEnter * if !argc() | NERDTree | endif

" Locate file in hierarchy quickly
map <leader>T :NERDTreeFind<cr>

" Toogle on/off
nmap <leader>o :NERDTreeToggle<cr>

" Allow NERDTree to change session root.
let g:NERDTreeChDirMode = 2


"------------------------------------------------------------------------------
" BufExplorer
"------------------------------------------------------------------------------
" Shortcuts, type <leader>l to quickly navigate to necessary buffer
map <leader>l :BufExplorer<cr>
vmap <leader>l <esc>:BufExplorer<cr>


"------------------------------------------------------------------------------
" Fugitive
"------------------------------------------------------------------------------
map ]] ]c
map [[ [c
map <leader>gdi :Gdiff<cr>
map <leader>gst :Gstatus<cr>


"------------------------------------------------------------------------------
" LanguageClient-neovim
"------------------------------------------------------------------------------
let g:LanguageClient_diagnosticsEnable=1

let g:LanguageClient_serverCommands = {
			\ 'html': ['html-languageserver', '--stdio'],
			\ 'css': ['css-languageserver', '--stdio'],
			\ 'json': ['json-languageserver', '--stdio'],
			\ }


"------------------------------------------------------------------------------
" ncm2
"------------------------------------------------------------------------------
" Enable ncm2 for all buffers
autocmd BufEnter  *  call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu
inoremap <expr> <CR> (pumvisible() ? "\<c-y>" : "\<CR>")

" Press enter key to trigger snippet expansion
inoremap <silent> <expr> <CR> ncm2_neosnippet#expand_or("\<CR>", 'n')

" Use <TAB> to select the popup menu
imap <expr> <Tab> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

smap <expr> <Tab> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


"------------------------------------------------------------------------------
" Neosnippet
"------------------------------------------------------------------------------
" Hide snippet symbols
set conceallevel=2 concealcursor=niv


"------------------------------------------------------------------------------
" Ale
"------------------------------------------------------------------------------
let g:ale_fixers = {
			\ '*': ['remove_trailing_lines', 'trim_whitespace']
			\}
let g:ale_fix_on_save = 1

let g:ale_sign_column_always = 0
let g:ale_sign_warning = '•'
let g:ale_sign_error = '✖'

let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0
let g:ale_list_window_size = 10
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1


"------------------------------------------------------------------------------
" Tagbar'
"------------------------------------------------------------------------------
nmap <F8> :TagbarToggle<CR>

"------------------------------------------------------------------------------
" vim-delve
"------------------------------------------------------------------------------
" Set the Delve backend.
let g:delve_backend = 'native'


"------------------------------------------------------------------------------
" vim-markdown
"------------------------------------------------------------------------------
" Disable folding
let g:vim_markdown_folding_disabled = 1

" In markdown it option conceals html tags, so need to turn-off it back
au FileType markdown set conceallevel=0 concealcursor=


"------------------------------------------------------------------------------
" markdown-preview
"------------------------------------------------------------------------------
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1


"------------------------------------------------------------------------------
" vim-qf
"------------------------------------------------------------------------------
nmap <buffer> <Left>  <Plug>(qf_older)
nmap <buffer> <Right> <Plug>(qf_newer)


"------------------------------------------------------------------------------
" yaml formatter
"------------------------------------------------------------------------------
au FileType yaml noremap <F3> :YAMLFormat<CR>


"------------------------------------------------------------------------------
" vim-indent-guides
"------------------------------------------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0


"------------------------------------------------------------------------------
" vim-better-whitespace
"------------------------------------------------------------------------------
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 0


let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'
