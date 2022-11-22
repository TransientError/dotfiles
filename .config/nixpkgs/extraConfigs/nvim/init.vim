call plug#begin('~/.local/share/nvim/plugged')
Plug 'kaicataldo/material.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'lambdalisue/suda.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sbdchd/neoformat'
Plug 'itchyny/lightline.vim'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'dag/vim-fish'
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'cespare/vim-toml'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'easymotion/vim-easymotion'
Plug 'jparise/vim-graphql'
Plug 'wellle/targets.vim'
call plug#end()

set expandtab shiftwidth=2
set mouse=a
set smartcase

let g:closetag_filenames = '*.html,*.xml,*.plist,*.*proj'

if exists('g:vscode')
  luafile vscode.lua
else
  set colorcolumn=120
  set number relativenumber
  set list listchars=tab:▸▸,trail:·

  let g:lightline = { 'colorscheme': 'material_vim' }
  let g:material_theme_style = 'dark'
  set background=dark
  colorscheme material

  let mapleader = "\<Space>"
  map <leader>wh :wincmd h<CR>
  map <leader>wj :wincmd j<CR>
  map <leader>wk :wincmd k<CR>
  map <leader>wl :wincmd l<CR>
  map <leader>ws :wincmd s<CR>
  map <leader>wv :wincmd v<CR>
  map <leader>wd :q<CR>
  map <leader>cf :Neoformat<CR>
endif

if (has("termguicolors"))
  set termguicolors
endif


let g:EasyMotion_smartcase = 1
" search 
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

" snipe
nmap s <Plug>(easymotion-s2)

