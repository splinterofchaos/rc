
function! s:print_it()
  echomsg string(v:job_data[0:1])
endfunction

if !exists('g:did_search_init')
  au! JobActivity xxx call s:print_it()
  let g:did_search_init = 1
end

command! DoIt echomsg 'start' | call jobstart('xxx', 'cat', ['bug.vim'])
