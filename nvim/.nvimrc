" '##::::'##:'####:'##::::'##:'########:::'######::
"  ##:::: ##:. ##:: ###::'###: ##.... ##:'##... ##:
"  ##:::: ##:: ##:: ####'####: ##:::: ##: ##:::..::
"  ##:::: ##:: ##:: ## ### ##: ########:: ##:::::::
" . ##:: ##::: ##:: ##. #: ##: ##.. ##::: ##:::::::
" :. ## ##:::: ##:: ##:.:: ##: ##::. ##:: ##::: ##:
" ::. ###::::'####: ##:::: ##: ##:::. ##:. ######::
" :::...:::::....::..:::::..::..:::::..:::......:::

"
" PLUGINS
"
call plug#begin('~/.local/share/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
" Plug 'Valloric/YouCompleteMe'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
" JAVASCRIPT
Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'
Plug 'leafgarland/typescript-vim'
Plug 'prettier/vim-prettier'
let g:coc_global_extensions = ['coc-tsserver',
\ 'coc-json',
\ 'coc-html-css-support',
\ 'coc-css',
\ 'coc-sql',
\ 'coc-yaml']
"/ JAVASCRIPT
Plug 'jparise/vim-graphql'
Plug 'preservim/nerdcommenter'


" EDITOR
Plug 'szw/vim-maximizer'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kassio/neoterm'
" /EDITOR

" Later in the config I'll bind this plugin to "gc"
" Typing "gc" will comment out a block or line of code in any language
Plug 'tpope/vim-commentary'
" A Git plugin with a crazy useful command :GitBlame
" Don't wait, blame someone else!
Plug 'tpope/vim-fugitive'
" A collection of colorschemes. Doesn't include my favorite one though.
Plug 'flazz/vim-colorschemes'

" If you prefer Ctrl+h/j/k/l for navigating across vim/tmux splits,
" this plugin will integrate Vim and Tmux, so that you can seamlessly
" Jump across the border of a vim/tmux split
" Plug 'christoomey/vim-tmux-navigator'

" This is the interesting one: it generates a Tmux config that makes
" a tmux status line look like a vim airline with an applied theme
Plug 'edkolev/tmuxline.vim'
" A wrapper around silversearcher-ag
Plug 'rking/ag.vim'

" Never got used to this one, but it allows for wrapping a piece of
" text into "", '', or custom tags
Plug 'tpope/vim-surround'

" Fzf for ffffuzzzy search~
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Neomake for asynchronous linting and building
Plug 'neomake/neomake'
call plug#end()


" PLUGIN CONFIGURATION
" szw/vim-maximizer
nnoremap <leader>m :MaximizerToggle!<CR>

" kassio/neoterm
let g:neoterm_default_mod = 'vertical'
let g:neoterm_size = 60
let g:neoterm_autoinsert = 1
nnoremap <c-q> :Ttoggle<CR>
inoremap <c-q> <ESC>:Ttoggle<CR>
tnoremap <c-q> <c-\><c-n>:Ttoggle<CR>


set updatetime=500

" Airline setup

set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme = "jellybeans"



" :'######:::'########:'##::: ##:'########:'########:::::'###::::'##:::::::::
" '##... ##:: ##.....:: ###:: ##: ##.....:: ##.... ##:::'## ##::: ##:::::::::
"  ##:::..::: ##::::::: ####: ##: ##::::::: ##:::: ##::'##:. ##:: ##:::::::::
"  ##::'####: ######::: ## ## ##: ######::: ########::'##:::. ##: ##:::::::::
"  ##::: ##:: ##...:::: ##. ####: ##...:::: ##.. ##::: #########: ##:::::::::
"  ##::: ##:: ##::::::: ##:. ###: ##::::::: ##::. ##:: ##.... ##: ##:::::::::
" . ######::: ########: ##::. ##: ########: ##:::. ##: ##:::: ##: ########:::
" :......::::........::..::::..::........::..:::::..::..:::::..::........::::
" set completeopt=menuone, noinsert, noselect  " insert mode completition
set signcolumn=yes                           " ? find more
set nobackup                                 " no backup
set nowritebackup                            " no backup
set nocompatible                             " disable compatibility to old-time vi
set showmatch                                " show matching
set cursorline                               " highlight current line
set mouse=a                                  " enables to use mouse in editor
set title                                    " show file title
set wildmenu                                 " show better autocomplete
set scrolloff=8                              " how much to scroll after scrolling with CTRL + [ or ]  
set clipboard=unnamedplus                    " using system clipboard
set wildmode=longest,list                    " get bash-like tab completions
set autoindent                               " indent a new line the same amount as the line just typed
set ttyfast                                  " Speed up scrolling in Vim
set noswapfile                               " disable creating swap file
set splitright                               " open new split panes to right
set splitbelow                               " open new split panes below
set foldmethod=manual                        " how to fold methods, classes, etc.
set tabstop=2                                " tab character will be 4 spaces long
set shiftwidth=2                             " make shift to be 4 spaces long
set expandtab                                " expands TABs into whitespaces
set smartindent                              " set automatic indentation for new line
set nu                                       " turn on line numbers
set number relativenumber                    " turn on relative numbers
syntax on                                    " turn on syntax highlighting
" It hides buffers instead of closing them.
" https://medium.com/usevim/vim-101-set-hidden-f78800142855
set hidden
set incsearch               " highlights search results as you type vs after you press Enter
set ignorecase              " ignore case when searching
set smartcase               " turns search highlighting on
set hlsearch                " highlight search results
set termguicolors           " turn on TrueColor


filetype plugin indent on 
" press one of these to exit INSERT MODE
:inoremap ii <Esc>
:inoremap jk <Esc>
:inoremap kj <Esc>
:vnoremap jk <Esc>
:vnoremap kj <Esc>

let mapleader = ","
nnoremap <leader>v :e $MYVIMRC<CR>
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open terminal on ctrl+n
function! OpenTerminal()
  split term://zsh
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>



if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --ignore .git --ignore build-out --ignore build-opt --ignore build-dbg -g ""'
endif

" This colorscheme mimics a default Atom colorscheme which I quite like
" colorscheme onedark

" Ctrl+P opens a fuzzy filesearch window (powered by Fzf)
nnoremap <C-p> :Files<CR>

" '##::: ##:'########:'########::'########::'########:'########::'########:'########:
"  ###:: ##: ##.....:: ##.... ##: ##.... ##:... ##..:: ##.... ##: ##.....:: ##.....::
"  ####: ##: ##::::::: ##:::: ##: ##:::: ##:::: ##:::: ##:::: ##: ##::::::: ##:::::::
"  ## ## ##: ######::: ########:: ##:::: ##:::: ##:::: ########:: ######::: ######:::
"  ##. ####: ##...:::: ##.. ##::: ##:::: ##:::: ##:::: ##.. ##::: ##...:::: ##...::::
"  ##:. ###: ##::::::: ##::. ##:: ##:::: ##:::: ##:::: ##::. ##:: ##::::::: ##:::::::
"  ##::. ##: ########: ##:::. ##: ########::::: ##:::: ##:::. ##: ########: ########:
" ..::::..::........::..:::::..::........::::::..:::::..:::::..::........::........::

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 0
let g:NERDTreeIgnore = ['node_modules']
let NERDTreeStatusLine='NERDTree'



" '########:'##::::'##:'########:'##::::'##:'########::'######::
" ... ##..:: ##:::: ##: ##.....:: ###::'###: ##.....::'##... ##:
" ::: ##:::: ##:::: ##: ##::::::: ####'####: ##::::::: ##:::..::
" ::: ##:::: #########: ######::: ## ### ##: ######:::. ######::
" ::: ##:::: ##.... ##: ##...:::: ##. #: ##: ##...:::::..... ##:
" ::: ##:::: ##:::: ##: ##::::::: ##:.:: ##: ##:::::::'##::: ##:
" ::: ##:::: ##:::: ##: ########: ##:::: ##: ########:. ######::
" :::..:::::..:::::..::........::..:::::..::........:::......:::

if(has("termguicolors"))
  set termguicolors
endif

syntax enable


" Switch to last active tab
let g:lasttab = 1
" I really like tt for switching between recent tabs
nmap tt :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" This is a quick way to call search-and-replace on a current word
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
" cc now hides those annoying search highlihghts after you're done searching
nnoremap cc :let @/ = ""<cr>
" \e to open a NerdTree at in the directory of the currently viewed file
nnoremap <Leader>e :Ex<CR>
" I said write it!
cmap w!! w !sudo tee % >/dev/null

" Don't expland tabs for Go
autocmd BufRead,BufNewFile   *.go setlocal noexpandtabd


