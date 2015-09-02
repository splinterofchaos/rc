SCRIPT  /home/admin/.vim/bundle/ag/autoload/ag.vim
Sourced 1 time
Total time:   0.000630
 Self time:   0.000630

count  total (s)   self (s)
                            " NOTE: You must, of course, install ag / the_silver_searcher
                            
                            " Location of the ag utility
    1              0.000013 if !exists("g:agprg")
    1              0.000010   let g:agprg="ag --column"
    1              0.000004 endif
                            
    1              0.000011 if !exists("g:ag_apply_qmappings")
    1              0.000009   let g:ag_apply_qmappings=1
    1              0.000004 endif
                            
    1              0.000010 if !exists("g:ag_apply_lmappings")
    1              0.000009   let g:ag_apply_lmappings=1
    1              0.000004 endif
                            
    1              0.000009 if !exists("g:ag_qhandler")
    1              0.000009   let g:ag_qhandler="botright copen"
    1              0.000004 endif
                            
    1              0.000009 if !exists("g:ag_lhandler")
    1              0.000009   let g:ag_lhandler="botright lopen"
    1              0.000004 endif
                            
    1              0.000010 if !exists("g:ag_mapping_message")
    1              0.000008   let g:ag_mapping_message=1
    1              0.000004 endif
                            
    1              0.000012 function! ag#Ag(cmd, args)
                              let l:ag_executable = get(split(g:agprg, " "), 0)
                            
                              " Ensure that `ag` is installed
                              if !executable(l:ag_executable)
                                echoe "Ag command '" . l:ag_executable . "' was not found. Is the silver searcher installed and on your $PATH?"
                                return
                              endif
                            
                              " If no pattern is provided, search for the word under the cursor
                              if empty(a:args)
                                let l:grepargs = expand("<cword>")
                              else
                                let l:grepargs = a:args . join(a:000, ' ')
                              end
                            
                              " Format, used to manage column jump
                              if a:cmd =~# '-g$'
                                let s:agformat_backup=g:agformat
                                let g:agformat="%f"
                              elseif exists("s:agformat_backup")
                                let g:agformat=s:agformat_backup
                              elseif !exists("g:agformat")
                                let g:agformat="%f:%l:%c:%m"
                              endif
                            
                              let grepprg_bak=&grepprg
                              let grepformat_bak=&grepformat
                              try
                                let &grepprg=g:agprg
                                let &grepformat=g:agformat
                                silent execute a:cmd . " " . escape(l:grepargs, '|')
                              finally
                                let &grepprg=grepprg_bak
                                let &grepformat=grepformat_bak
                              endtry
                            
                              if a:cmd =~# '^l'
                                let l:match_count = len(getloclist(winnr()))
                              else
                                let l:match_count = len(getqflist())
                              endif
                            
                              if a:cmd =~# '^l' && l:match_count
                                exe g:ag_lhandler
                                let l:apply_mappings = g:ag_apply_lmappings
                                let l:matches_window_prefix = 'l' " we're using the location list
                              elseif l:match_count
                                exe g:ag_qhandler
                                let l:apply_mappings = g:ag_apply_qmappings
                                let l:matches_window_prefix = 'c' " we're using the quickfix window
                              endif
                            
                              " If highlighting is on, highlight the search keyword.
                              if exists("g:aghighlight")
                                let @/=a:args
                                set hlsearch
                              end
                            
                              redraw!
                            
                              if l:match_count
                                if l:apply_mappings
                                  nnoremap <silent> <buffer> h  <C-W><CR><C-w>K
                                  nnoremap <silent> <buffer> H  <C-W><CR><C-w>K<C-w>b
                                  nnoremap <silent> <buffer> o  <CR>
                                  nnoremap <silent> <buffer> t  <C-w><CR><C-w>T
                                  nnoremap <silent> <buffer> T  <C-w><CR><C-w>TgT<C-W><C-W>
                                  nnoremap <silent> <buffer> v  <C-w><CR><C-w>H<C-W>b<C-W>J<C-W>t
                            
                                  exe 'nnoremap <silent> <buffer> e <CR><C-w><C-w>:' . l:matches_window_prefix .'close<CR>'
                                  exe 'nnoremap <silent> <buffer> go <CR>:' . l:matches_window_prefix . 'open<CR>'
                                  exe 'nnoremap <silent> <buffer> q  :' . l:matches_window_prefix . 'close<CR>'
                            
                                  exe 'nnoremap <silent> <buffer> gv :let b:height=winheight(0)<CR><C-w><CR><C-w>H:' . l:matches_window_prefix . 'open<CR><C-w>J:exe printf(":normal %d\<lt>c-w>_", b:height)<CR>'
                                  " Interpretation:
                                  " :let b:height=winheight(0)<CR>                      Get the height of the quickfix/location list window
                                  " <CR><C-w>                                           Open the current item in a new split
                                  " <C-w>H                                              Slam the newly opened window against the left edge
                                  " :copen<CR> -or- :lopen<CR>                          Open either the quickfix window or the location list (whichever we were using)
                                  " <C-w>J                                              Slam the quickfix/location list window against the bottom edge
                                  " :exe printf(":normal %d\<lt>c-w>_", b:height)<CR>   Restore the quickfix/location list window's height from before we opened the match
                            
                                  if g:ag_mapping_message && l:apply_mappings
                                    echom "ag.vim keys: q=quit <cr>/e/t/h/v=enter/edit/tab/split/vsplit go/T/H/gv=preview versions of same"
                                  endif
                                endif
                              else
                                echom 'No matches for "'.a:args.'"'
                              endif
                            endfunction
                            
    1              0.000011 function! ag#AgFromSearch(cmd, args)
                              let search =  getreg('/')
                              " translate vim regular expression to perl regular expression.
                              let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
                              call ag#Ag(a:cmd, '"' .  search .'" '. a:args)
                            endfunction
                            
    1              0.000017 function! ag#GetDocLocations()
                              let dp = ''
                              for p in split(&runtimepath,',')
                                let p = p.'/doc/'
                                if isdirectory(p)
                                  let dp = p.'*.txt '.dp
                                endif
                              endfor
                              return dp
                            endfunction
                            
    1              0.000009 function! ag#AgHelp(cmd,args)
                              let args = a:args.' '.ag#GetDocLocations()
                              call ag#Ag(a:cmd,args)
                            endfunction

FUNCTION  ag#Ag()
Called 1 time
Total time:   0.074047
 Self time:   0.074047

count  total (s)   self (s)
    1              0.000027   let l:ag_executable = get(split(g:agprg, " "), 0)
                            
                              " Ensure that `ag` is installed
    1              0.000046   if !executable(l:ag_executable)
                                echoe "Ag command '" . l:ag_executable . "' was not found. Is the silver searcher installed and on your $PATH?"
                                return
                              endif
                            
                              " If no pattern is provided, search for the word under the cursor
    1              0.000008   if empty(a:args)
                                let l:grepargs = expand("<cword>")
                              else
    1              0.000128     let l:grepargs = a:args . join(a:000, ' ')
    1              0.000004   end
                            
                              " Format, used to manage column jump
    1              0.000047   if a:cmd =~# '-g$'
                                let s:agformat_backup=g:agformat
                                let g:agformat="%f"
                              elseif exists("s:agformat_backup")
                                let g:agformat=s:agformat_backup
                              elseif !exists("g:agformat")
    1              0.000010     let g:agformat="%f:%l:%c:%m"
    1              0.000003   endif
                            
    1              0.000010   let grepprg_bak=&grepprg
    1              0.000008   let grepformat_bak=&grepformat
    1              0.000005   try
    1              0.000020     let &grepprg=g:agprg
    1              0.000008     let &grepformat=g:agformat
    1              0.073167     silent execute a:cmd . " " . escape(l:grepargs, '|')
                              finally
    1              0.000057     let &grepprg=grepprg_bak
    1              0.000014     let &grepformat=grepformat_bak
                              endtry
                            
                              if a:cmd =~# '^l'
                                let l:match_count = len(getloclist(winnr()))
                              else
                                let l:match_count = len(getqflist())
                              endif
                            
                              if a:cmd =~# '^l' && l:match_count
                                exe g:ag_lhandler
                                let l:apply_mappings = g:ag_apply_lmappings
                                let l:matches_window_prefix = 'l' " we're using the location list
                              elseif l:match_count
                                exe g:ag_qhandler
                                let l:apply_mappings = g:ag_apply_qmappings
                                let l:matches_window_prefix = 'c' " we're using the quickfix window
                              endif
                            
                              " If highlighting is on, highlight the search keyword.
                              if exists("g:aghighlight")
                                let @/=a:args
                                set hlsearch
                              end
                            
                              redraw!
                            
                              if l:match_count
                                if l:apply_mappings
                                  nnoremap <silent> <buffer> h  <C-W><CR><C-w>K
                                  nnoremap <silent> <buffer> H  <C-W><CR><C-w>K<C-w>b
                                  nnoremap <silent> <buffer> o  <CR>
                                  nnoremap <silent> <buffer> t  <C-w><CR><C-w>T
                                  nnoremap <silent> <buffer> T  <C-w><CR><C-w>TgT<C-W><C-W>
                                  nnoremap <silent> <buffer> v  <C-w><CR><C-w>H<C-W>b<C-W>J<C-W>t
                            
                                  exe 'nnoremap <silent> <buffer> e <CR><C-w><C-w>:' . l:matches_window_prefix .'close<CR>'
                                  exe 'nnoremap <silent> <buffer> go <CR>:' . l:matches_window_prefix . 'open<CR>'
                                  exe 'nnoremap <silent> <buffer> q  :' . l:matches_window_prefix . 'close<CR>'
                            
                                  exe 'nnoremap <silent> <buffer> gv :let b:height=winheight(0)<CR><C-w><CR><C-w>H:' . l:matches_window_prefix . 'open<CR><C-w>J:exe printf(":normal %d\<lt>c-w>_", b:height)<CR>'
                                  " Interpretation:
                                  " :let b:height=winheight(0)<CR>                      Get the height of the quickfix/location list window
                                  " <CR><C-w>                                           Open the current item in a new split
                                  " <C-w>H                                              Slam the newly opened window against the left edge
                                  " :copen<CR> -or- :lopen<CR>                          Open either the quickfix window or the location list (whichever we were using)
                                  " <C-w>J                                              Slam the quickfix/location list window against the bottom edge
                                  " :exe printf(":normal %d\<lt>c-w>_", b:height)<CR>   Restore the quickfix/location list window's height from before we opened the match
                            
                                  if g:ag_mapping_message && l:apply_mappings
                                    echom "ag.vim keys: q=quit <cr>/e/t/h/v=enter/edit/tab/split/vsplit go/T/H/gv=preview versions of same"
                                  endif
                                endif
                              else
                                echom 'No matches for "'.a:args.'"'
                              endif

FUNCTION  ag#AgFromSearch()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                              let search =  getreg('/')
                              " translate vim regular expression to perl regular expression.
                              let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
                              call ag#Ag(a:cmd, '"' .  search .'" '. a:args)

FUNCTION  ag#GetDocLocations()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                              let dp = ''
                              for p in split(&runtimepath,',')
                                let p = p.'/doc/'
                                if isdirectory(p)
                                  let dp = p.'*.txt '.dp
                                endif
                              endfor
                              return dp

FUNCTION  ag#AgHelp()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                              let args = a:args.' '.ag#GetDocLocations()
                              call ag#Ag(a:cmd,args)

FUNCTIONS SORTED ON TOTAL TIME
count  total (s)   self (s)  function
    1   0.074047             ag#Ag()
                             ag#AgFromSearch()
                             ag#GetDocLocations()
                             ag#AgHelp()

FUNCTIONS SORTED ON SELF TIME
count  total (s)   self (s)  function
    1              0.074047  ag#Ag()
                             ag#AgFromSearch()
                             ag#GetDocLocations()
                             ag#AgHelp()

