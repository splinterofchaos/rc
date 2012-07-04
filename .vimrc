
set nocompatible
filetype plugin indent on

syntax on
set background=dark

" RANDOM SETTINGS "
set formatoptions=croq
set linebreak     " Break lines instead of letting them run off the screen.
set showbreak=... " Show ... at the start of a broken line.
set ruler " Show line 
set spell " Spell checking.
set complete=.,w,b,u,U,t,i,d    " do lots of scanning on tab completionnumber on bar.

" INDENTING "
set tabstop=4    " <Tab> = 4 spaces
set shiftwidth=4 " Indents 4 spaces for blocks.
set expandtab    " Expand \t into spaces.
set smarttab     " Not sure what this does, yet.
set autoindent 

" switch( x ) {
" <indent/2>case x:
" <2 * indent/2>do_stuff();
" <indent/2>break;
" }
set cinoptions=:.5s,=.5s,b1 

" class X {
" <indent/2>public:
" <2 * indent/2>X();
" };
set cinoptions+=g.5s,h.5s

" do_something(
" <indent>
" )
" Without m1, ) would have an indent.
set cinoptions+=(0,W4,m1


" Searching "
set hlsearch  " Globally enable search highlight.
set incsearch " Show matches ASAP.

" For xpt (snippets) plugin:
"g:xptemplate_vars="$author=SoC"
"g:xptemplate_vars="$email=hakusa@gmail.com"

" C Macros
ab #i #include
ab #d #define

" git-branch-info options.
set laststatus=2 " Enables the status line at the bottom of Vim

set backspace=2 " make backspace work like most other apps

" Make status line show (f) filename,  (l) line, (c) character.
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%)

" For spell checking. 
" s â    move to the next mispelled word
" [s â   move to the previous mispelled word
" zg â   add a word to the dictionary
" zug â  undo the addition of a word to the dictionary
" z= â   view spelling suggestions for a mispelled word
setlocal spell spelllang=en
set mouse=a
