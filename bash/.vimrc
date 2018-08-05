"-----------------------------------------------------------------------------
" VIM configuration file
"-----------------------------------------------------------------------------
" Copyright (C) 2018 Christian Jean
" All Rights Reserved
"-----------------------------------------------------------------------------
" This configuration has mappings which provide VIM support in web based
" consoles (ie: Google Cloud or Glitch.com) which would otherwise not allow
" for CTRL-C or CTRL-W.
"-----------------------------------------------------------------------------
"

set number
set nowrap
set ruler
set ignorecase
set tabstop=2

" Type ':retab' to fix all existing tabs
set expandtab

" Navigate to next pane
map <F2> <C-w><C-w>

" List the buffers
map <F5> :ls<CR>

" Move focus to next/previous vsplit pane
map <C-Left> <C-w>h
map <C-Right> <C-w>l

" Rotate between buffers
map <C-Up> :bn<CR>
map <C-Down> :bp<CR>
