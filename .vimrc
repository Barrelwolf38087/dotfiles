set nocompatible
filetype off

set shell=/usr/bin/zsh

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'tpope/vim-surround'

call vundle#end()
filetype plugin indent on

set exrc
set secure

set rnu
syntax on
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set incsearch

" Autoinsert matching characters
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" YCM Options
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_confirm_extra_conf = 0

" YCM Keybinds
nnoremap <leader>jd :YcmCompleter GoTo<CR> 
nnoremap <leader>jq :YcmCompleter GotoImprecise<CR>
nnoremap <leader>jD :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>ji :YcmCompleter GotoInclude<CR>
nnoremap <leader>jr :YcmCompleter GoToReferences<CR>

" Window title setting using a homemade zsh function
autocmd BufEnter * :silent !source ~/.zshrc && set_title "%:p - Vim"

" Reset the title on exit
autocmd VimLeave * :silent !source ~/.zshrc && preexec
