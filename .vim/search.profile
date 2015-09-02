SCRIPT  /home/admin/.vim/search.vim
Sourced 1 time
Total time:   0.000261
 Self time:   0.000261

count  total (s)   self (s)
                            " yay!
                            " trying my hand at vim scripting!
                            
    1              0.000013 if exists('s:search_pos_save')
                              unlet s:search_pos_save
                            end
                            
    1              0.000011 function! s:search(wut)
                              let s:search_term = get(split(a:wut), 0)
                              call setqflist([])
                              copen
                              let l:prg = 'ag' " TODO: Use &grepprg
                              let l:items = split(a:wut)
                              call jobstart('search', l:prg, l:items)
                            
                              let msg = 'searching for ' . l:items[0]
                              if len(l:items) > 1
                                let msg = msg . ' in ' . join(l:items[1:])
                              end
                              echo msg
                            endfunction
                            
    1              0.000048 command! -bang -nargs=1 -complete=help Find call s:search('<args>')
                            
    1              0.000007 function! s:add_matches()
                              if v:job_data[1] == 'stdout'
                                caddexpr v:job_data[2]
                              elseif v:job_data[1] == 'stderr'
                                let msg = 'Error: ' . v:job_data[2]
                                echoerr msg
                              else
                                " End of output
                              endif
                            endfunction
                            
    1              0.000009 if !exists('g:find_init')
    1              0.000009   let g:find_init = 1
    1              0.000031   au JobActivity search call s:add_matches()
    1              0.000007 end

FUNCTION  <SNR>40_search()
Called 1 time
Total time:   0.026070
 Self time:   0.004078

count  total (s)   self (s)
    1              0.000041   let s:search_term = get(split(a:wut), 0)
    1              0.000018   call setqflist([])
    1   0.022444   0.000453   copen
    1              0.000007   let l:prg = 'ag' " TODO: Use &grepprg
    1              0.000027   let l:items = split(a:wut)
    1              0.003279   call jobstart('search', l:prg, l:items)
                            
    1              0.000063   let msg = 'searching for ' . l:items[0]
    1              0.000016   if len(l:items) > 1
                                let msg = msg . ' in ' . join(l:items[1:])
                              end
    1              0.000121   echo msg

FUNCTION  <SNR>40_add_matches()
Called 2 times
Total time:   0.034708
 Self time:   0.028572

count  total (s)   self (s)
    2              0.000030   if v:job_data[1] == 'stdout'
    1   0.034605   0.028468     caddexpr v:job_data[2]
    1              0.000008   elseif v:job_data[1] == 'stderr'
                                let msg = 'Error: ' . v:job_data[2]
                                echoerr msg
                              else
                                " End of output
    1              0.000003   endif

FUNCTIONS SORTED ON TOTAL TIME
count  total (s)   self (s)  function
    2   0.034708   0.028572  <SNR>40_add_matches()
    1   0.026070   0.004078  <SNR>40_search()

FUNCTIONS SORTED ON SELF TIME
count  total (s)   self (s)  function
    2   0.034708   0.028572  <SNR>40_add_matches()
    1   0.026070   0.004078  <SNR>40_search()

