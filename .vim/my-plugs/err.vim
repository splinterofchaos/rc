
inoremap <Cr> <Esc>:call Do()<Cr>i
au! InsertCharPre * call Do()

au! JobActivity xxx $put =v:job_data[1]

let s:j = 0
let g:r = []
function! Do()
  if s:j == 0
    let s:j = jobstart('xxx', 'echo', ['hi']) 
    call feedkeys("A")
  else
    call feedkeys("A")
    call extend(g:r,[jobsend(s:j, 'x')])
    if len(g:r) > 2
      au!
      iunmap
    end
  end
endf
