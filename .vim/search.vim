" yay!
" trying my hand at vim scripting!

if exists('s:search_pos_save')
  unlet s:search_pos_save
end

function! s:search(wut)
  call setqflist([])
  copen
  call jobstart('search', 'ag', split(a:wut))
  echo string('searching for ' . l:items[0])
endfunction

command! -bang -nargs=1 -complete=help Find call s:search('<args>')

function! s:add_matches()
  if v:job_data[1] == 'stdout'
    caddexpr v:job_data[2]
  endif
endfunction

if !exists('g:find_init')
  let g:find_init = 1
  au JobActivity search call s:add_matches()
end
