
function! provider#rpc#test(chan, id, x)
  call rpcnotify(a:chan, 'test2', a:x, 10)
endfunction

function! provider#rpc#test2(chan, id, ...)
  echom 'GOT '.join(a:000, ', ')
endfunction

function! provider#rpc#PressEnter(chan, id)
  call rpcnotify(0, 'vim_feedkeys', '<Cr>')
  echom 'Got Press Enter'
endf

function! provider#rpc#vim_get_current_line(chan, id)
  call rpcnotify(0, 'GotSet')
  return 'HAHAHA'
endfunction

function! provider#rpc#GotSet(chan, id)
  echom 'GOT set_current_line'
endfunction

function! provider#rpc#emsg(chan, id, msg)
  echom 'Got EMSG: ' . a:msg
endf

