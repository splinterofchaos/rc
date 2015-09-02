
if has('nvim')
  let &t_Co = 256
else
  set t_Co=256
endif
let g:terminal_color_255=1

execute pathogen#infect()

call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'ervandew/ag'
Plug 'vim-scripts/gprof.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'tpope/vim-fugitive'
Plug 'lambdalisue/vim-gita'
Plug 'tpope/vim-git'
Plug 'int3/vim-extradite'  " Extends vim-fugitive
Plug 'tpope/vim-surround'
"Plug 'bling/vim-airline'
Plug 'mattn/gist-vim'
Plug 'vim-scripts/kib_darktango.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tomtom/tcomment_vim'
Plug 'mattn/webapi-vim'
Plug 'junegunn/vim-easy-align'
Plug 'benekastah/neomake'
Plug 'zah/nimrod.vim'
Plug 'bruno-/vim-man'
Plug 'justinmk/diffchar.vim'

" Testing framework for vital-VCS
Plug 'thinca/vim-themis'

"set sh=sh

so ~/.nvim/my-plugs/proc.vim

if $COLORTERM == 'gnome-terminal' 
  au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
  au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
  au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
end

call plug#end()

set nocompatible
filetype plugin indent on

syntax enable
let g:multi_cursor_next_key='Q'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" RANDOM SETTINGS "
set formatoptions=tcroqj
set linebreak     " Break lines instead of letting them run off the screen.
set showbreak=... " Show ... at the start of a broken line.
set ruler " Show line 
set spell " Spell checking.
set complete=.,w,b,u,U,t,i,d    " do lots of scanning on tab completionnumber on bar.
"set synmaxcol=200

" INDENTING "
set tabstop=2    " <Tab> = 4 spaces
set shiftwidth=2 " Indents 4 spaces for blocks.
set softtabstop=2 " Indents 4 spaces for blocks.
set expandtab    " Expand \t into spaces.
set smarttab     " Not sure what this does, yet.
set autoindent 
set textwidth=79

set wildmenu                 " Turn on the WiLd menu
set wildignore=*.o,*~,*.pyc  " Ignore compiled files

" Vim Pulse
let g:vim_search_pulse_mode = 'pattern'
set nohlsearch
let g:vim_search_pulse_duration = 100

" SESSIONS "
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

set nobackup   " no need for backup files(use undo files instead)
set nowb
set noswapfile
set undofile   " create '.<FILENAME>.un~' for persiting undo history
set dir=/tmp " swap files storage, first try in the cwd then in /tmp
set undodir=/tmp  " undo files storage, only allow the same directory

" do_something(
" <indent>
" )
" Without m1, ) would have an indent.
set cinoptions+=(0,W4,m1


" Searching "
set hlsearch  " Globally enable search highlight.
set incsearch " Show matches ASAP.
map <silent> <leader><cr> :nohl<Cr>

" For xpt (snippets) plugin:
"g:xptemplate_vars="$author=SoC"
"g:xptemplate_vars="$email=hakusa@gmail.com"

" C Macros
ab #i #include
ab #d #define

set laststatus=2 " Enables the status line at the bottom of Vim

set backspace=2 " make backspace work like most other apps

" Make status line show (f) filename,  (l) line, (c) character.
" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%)

set background=dark

"colorscheme seoul256
colorscheme tango2
"colorscheme 256-jungle
"color CodeFactoryv3
"color hybrid

let g:solarized_termcolors=256
"let g:solarized_degrage = 1
"colorscheme solarized

set bg=dark

autocmd WinEnter * doautocmd FileType
"au FileType c*        color hybrid
au FileType c*        color tango2
au FileType vim       color wombat256
au FileType gitcommit color hybrid
au FileType lua       color jellybeans
au FileType xxxx      color kib_darktango/xoria256 
au FileType python    color molokai

" For spell checking. 
" s â    move to the next mispelled word
" [s â   move to the previous mispelled word
" zg â   add a word to the dictionary
" zug â  undo the addition of a word to the dictionary
" z= â   view spelling suggestions for a mispelled word
setlocal spell spelllang=en
set mouse=a

" AIRLINE (https://github.com/bling/vim-airline)
" let g:airline#extensions#tabline#enabled = 1

" SYNTASTIC
let g:syntastic_enable_signs  = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_cpp_compiler_options = '-std=c++1y'
let g:syntastic_cpp_check_header = 1
let g:syntastic_c_check_header = 1
" let g:syntastic_cpp_remove_include_errors = 1
" let g:syntastic_c_compiler ='clang'
"let g:syntastic_c_compiler_options ='-std=gnu99 -I../include'
"let b:syntastic_c_cflags = '-I../include'
"let g:syntastic_c_include_dirs = [ '../include' ]
let g:syntastic_c_remove_include_errors = 1
"let g:syntastic_c_compiler_options ='-i../include/'

" HASKEL MODE
" use ghc functionality for haskell files
" au Bufenter *.hs compiler ghc

" configure browser for haskell_doc.vim
let g:haddock_browser = "C:/Program Files/Mozilla Firefox/firefox.exe"

au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>
au FileType haskell set nospell

au FileType haskell colorscheme inkpot


" set cmdheight=0
"au FileType c++ set path+=,/usr/include,/usr/include/c++/

set diffopt=filler,iwhite,vertical
nmap <leader>< :diffget<CR>
vmap <leader>< :diffget<CR>
nmap <leader>> :diffput<CR>
vmap <leader>> :diffput<CR>

" Ex-mode sucks!
" http://www.reddit.com/r/vim/comments/shtto/what_are_the_main_single_keys_that_you_remap_in/c4e5xfi
map Q @q

" zfz
set rtp+=~/.fzf
nnoremap <leader>f :FZF<cr>

let g:load_doxygen_syntax=1
let g:doxygen_enhanced_colour=1
let g:doxygen_enhanced_colour=0

" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    silent let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
"nnoremap <leader>f :call SelectaCommand("find * -type f", "", ":e")<cr>

augroup filetype
  au! BufRead,BufNewFile *.ll     set filetype=llvm
augroup END

augroup filetype
  au! BufRead,BufNewFile *.td     set filetype=tablegen
augroup END

au BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['c++=cpp']

let g:nvim#defaults#maps#leave_term_mode = 0

