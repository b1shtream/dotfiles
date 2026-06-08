" ============================================================================
" ~/.vimrc  —  curated Vim config (vim-plug + sensible defaults)
" ============================================================================

" Leader key (pressed before custom mappings). Space is comfortable & common.
let mapleader = " "
let maplocalleader = " "

" ----------------------------------------------------------------------------
" Plugins (managed by vim-plug — run :PlugInstall after editing this list)
" ----------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'                              " universally agreed defaults
Plug 'morhetz/gruvbox'                                 " dark colorscheme
Plug 'vim-airline/vim-airline'                         " statusline
Plug 'vim-airline/vim-airline-themes'                  " statusline themes
Plug 'preservim/nerdtree'                              " file tree (<leader>n)
Plug 'junegunn/fzf'                                    " fuzzy finder core
Plug 'junegunn/fzf.vim'                                " fzf vim commands
Plug 'tpope/vim-commentary'                            " gcc / gc to toggle comments
Plug 'tpope/vim-surround'                              " cs\"' ds( ysiw) etc.
Plug 'jiangmiao/auto-pairs'                            " auto-close brackets/quotes
Plug 'airblade/vim-gitgutter'                          " git diff signs in gutter
Plug 'tpope/vim-fugitive'                              " :Git commands

call plug#end()

" ----------------------------------------------------------------------------
" General settings
" ----------------------------------------------------------------------------
set number relativenumber        " hybrid line numbers
set cursorline                   " highlight current line
set scrolloff=8                  " keep 8 lines visible above/below cursor
set mouse=a                      " enable mouse in all modes
set hidden                       " switch buffers without saving
set splitbelow splitright        " new splits go below / to the right
set updatetime=300               " faster gitgutter / swap writes
set signcolumn=yes               " always show the sign column (no jitter)
set nowrap                       " don't wrap long lines
set confirm                      " ask instead of failing on :q with changes
set title                        " set terminal title
set noerrorbells visualbell t_vb="  " no beeping

" Indentation: 4 spaces, smart
set expandtab
set tabstop=4 softtabstop=4 shiftwidth=4
set autoindent smartindent
set shiftround                   " round indents to multiples of shiftwidth

" Search
set ignorecase smartcase         " case-insensitive unless you type a capital
set incsearch hlsearch           " incremental + highlighted search
set gdefault                     " :s substitutes all matches on a line by default

" System clipboard (Vim was built with +clipboard)
set clipboard=unnamedplus

" Persistent undo across sessions
set undofile
set undodir=~/.vim/undo
if !isdirectory($HOME . '/.vim/undo')
  call mkdir($HOME . '/.vim/undo', 'p', 0700)
endif

" Keep swap/backup files out of your working dirs
set directory=~/.vim/swap//
set backupdir=~/.vim/backup//
silent! call mkdir($HOME . '/.vim/swap', 'p', 0700)
silent! call mkdir($HOME . '/.vim/backup', 'p', 0700)

" ----------------------------------------------------------------------------
" Colors
" ----------------------------------------------------------------------------
if has('termguicolors')
  set termguicolors              " 24-bit color (Alacritty supports it)
endif
set background=dark
let g:gruvbox_contrast_dark = 'hard'   " darker, near-black background
silent! colorscheme gruvbox            " 'silent!' so first launch (pre-install) doesn't error
syntax enable

" ----------------------------------------------------------------------------
" Statusline (airline) — no Nerd Font installed, so plain glyphs
" ----------------------------------------------------------------------------
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'
let g:airline#extensions#tabline#enabled = 1   " show buffers along the top

" ----------------------------------------------------------------------------
" NERDTree
" ----------------------------------------------------------------------------
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
" close Vim if NERDTree is the only window left
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ----------------------------------------------------------------------------
" Key mappings (<leader> = Space)
" ----------------------------------------------------------------------------
" Files / save / quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>

" Clear search highlight
nnoremap <leader>h :nohlsearch<CR>

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>N :NERDTreeFind<CR>

" fzf: files, buffers, ripgrep content, lines in buffer
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>/ :BLines<CR>

" Buffer navigation
nnoremap <leader><Tab> :bnext<CR>
nnoremap <leader><S-Tab> :bprevious<CR>
nnoremap <leader>x :bdelete<CR>

" Window navigation with Ctrl + h/j/k/l (matches your i3 muscle memory)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move visual selection up/down and keep it selected
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor centered when jumping/searching
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Stay in visual mode after indenting
vnoremap < <gv
vnoremap > >gv

" Edit / reload this config quickly
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" ----------------------------------------------------------------------------
" Filetype niceties
" ----------------------------------------------------------------------------
filetype plugin indent on
" Trim trailing whitespace on save
autocmd BufWritePre * let b:_winview = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(b:_winview)
