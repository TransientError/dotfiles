call plug#begin('~/.local/share/nvim/plugged')
Plug 'kaicataldo/material.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'itchyny/lightline.vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'dag/vim-fish'
Plug 'lambdalisue/suda.vim'
Plug 'tpope/vim-commentary'
Plug 'vim-scripts/ReplaceWithRegister'
call plug#end()

set colorcolumn=120
set expandtab shiftwidth=2
set mouse=a
set number relativenumber
set list listchars=tab:▸▸,trail:·
set smartcase

let g:closetag_filenames = '*.html,*.xml,*.plist'

let g:lightline = { 'colorscheme': 'material_vim' }
let g:material_theme_style = 'dark'
set background=dark
colorscheme material

if (has("termguicolors"))
  set termguicolors
endif
