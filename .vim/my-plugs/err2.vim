
let s:buf = 0  " The buffer we use to write/send data.
let s:job = 0  " The job that runs the commands.
let s:inbuf = ''  " Data pending, sending to s:job.

command! Proc call s:new()
command! -nargs=* ProcDoLine call s:do_cmd(<f-args>)
command! ProcStop call jobstop(s:job)
command! ProcPressEnter call s:on_enter()

" TODO: Only when in a shell buffer.
au FileType procvim inoremap <Cr> <Esc>:ProcPressEnter<Cr>i

function! s:on_enter()
  if s:buf != bufnr('%') 
    let keys = "\<Cr>"
  else
    if s:job > 0
      call s:proc_send("\n")
    else
      exe 'ProcDoLine ' . getline(line('.'))
    end
    let keys = "A\<Cr>"
  end
  call feedkeys(keys)
endfunction

" Initializes a new proc window
function! s:new()
  if s:buf != 0
    echoerr 'TODO: Allow more than one buffer.'
    return
  end
  new +set\ ft=procvim
  let s:buf = bufnr('%')
  setlocal buftype=nofile
  setlocal noswapfile
  set syntax=sh  " Nice syntax hilighting for most shells.
  call s:prompt()

  au! InsertCharPre * let v:char = s:proc_send(v:char)
endfunction

" Enable the <Cr> mapping and place a '$' prompt on the last line.
function! s:prompt()
  let s:job = 0
  sign define prompt text=$
  exe 'sign place 1 line='.line('$').' name=prompt buffer='.s:buf
  call cursor(cursor(line('$'),3))
endfunction

" Run a:cmd.
function! s:do_cmd(...)
  if a:0 == 0 | return | end

  if s:job != 0
    echoerr 'TODO: Allow more than one job.'
    return
  end

  if bufnr('%') != s:buf | exe 'buffer ' . s:buf | end

  au! JobActivity procvim call s:on_activity()
  let s:job = jobstart('procvim', a:1, a:000[1:])
endfunction

" Ran every time a (printable) key is pressed.
function! s:proc_send(c)
  if bufnr('%') == s:buf && s:job > 0
    " Send data linewise. (Makes `cat -` less surprising.)
    let s:inbuf .= a:c
    if a:c == "\n"
      call jobsend(s:job, v:c)
      let s:inbuf = ''
    end
  end
  return a:c
endfunction

function! s:on_activity()
  if v:job_data[1] == 'stdout' || v:job_data[1] == 'stderr'
    " TODO: How do I make sure this only writes to s:buf?
    call append('$', split(v:job_data[2], "\n"))
    call cursor(cursor(line('$'),999))
  elseif v:job_data[1] == 'exit'
    $put =''
    call s:prompt()
    let s:job = 0
  else
    echoerr 'Unrecognized job_data[1]' . v:job_data[1]
  end
endfunction


