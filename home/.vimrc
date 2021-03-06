set nocompatible
filetype off

set encoding=utf-8

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

colo koehler

let mapleader = ","

" Autoinsert matching characters.
" Turns out this is more annoying than useful.
"inoremap " ""<left>
"inoremap ' ''<left>
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
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

" YCM highlight colors
" #ff1764
"highlight YcmWarningLine ctermbg=red
"highlight YcmWarningSign ctermbg=red
"highlight YcmWarningSection ctermbg=red

" Window title setting using a homemade zsh function.
" At the time this was written, I didn't know this was a built-in feature.
"autocmd BufEnter * :silent !source ~/.zshrc && set_title "%:p - Vim"
set title

" Reset the title on exit
autocmd VimLeave * :silent !source ~/.zshrc && preexec

au BufRead,BufNewFile *.sh,*.zsh setfiletype zsh
