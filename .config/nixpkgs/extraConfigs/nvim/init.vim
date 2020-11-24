call plug#begin('~/.local/share/nvim/plugged')
Plug 'kaicataldo/material.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'lambdalisue/suda.vim'
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

nmap == :Neoformat<CR>

if (has("termguicolors"))
  set termguicolors
endif
