
" From an embedded instance, evaluates an expression and sends the result back
" to the parent instance to be executed by a callback.
function! nasync#up(expr, callback)
  call rpcnotify(1, 'vim_eval', a:callback . '(' . string(eval(a:expr)) . ')')
endfunction

function! s:arg_str(...)
  return join(map(copy(a:000), "string(v:val)"), ',')
endfunction

function! s:do_rpc(async, id, method, args)
  if a:async == 0
    let rpc = 'rpcrequest'
  else
    let rpc = 'rpcnotify'
  end
  return call(rpc, [a:id, a:method] + a:args)
endfunction

" Spawns a new nvim instance via rpcstart. Returns a dictionary with functions
" to execute commands in the child process.
function! nasync#new()
  let vim = { 'id'    : rpcstart(v:progpath, ['--embed'])
          \ , 'async' : 1
          \ }

  function vim.do(method, args) dict
    return s:do_rpc(self.async, self.id, a:method, a:args)
  endfunction

  function vim.req(method, ...) dict
    return s:do_rpc(0, self.id, a:method, a:000)
  endfunction

  function vim.notify(method, ...) dict
    return s:do_rpc(1, self.id, a:method, a:000)
  endfunction

  function vim.vim(method, ...) dict
    return self.do('vim_' . a:method, a:000)
  endfunction

  function vim.cmd(cmd) dict
    return self.vim('command', a:cmd)
  endfunction

  function vim.eval(expr) dict
    return self.vim('eval', a:expr)
  endfunction

  function vim.eval_cb(expr, callback) dict
    return self.vim('eval', 'nasync#up(' . s:arg_str(a:expr,a:callback) . ')')
  endfunction

  function vim.buf(method, ...) dict
    return self.do('buffer_' . a:method, a:000)
  endfunction

  function vim.win(method, ...) dict
    return self.do('window_' . a:method, a:000)
  endfunction

  function vim.tab(method, ...) dict
    return self.do('tabpage_' . a:method, a:000)
  endfunction

  function vim.wait() dict
    call self.req('vim_eval', '0')
  endfunction

  function vim.close() dict
    call rpcstop(self.id)
  endfunction

  return vim
endfunction

function! nasync#get_api(vim)
  let res = []
  for f in a:vim.req('vim_get_api_info')[1]['functions']
    let args = []
    for a in f['parameters']
      call add(args, a[1])
    endfor
    let fstr = f['name'].'('.join(args, ',').')  -> ' . f['return_type']
    call add(res, fstr)
  endfor
  return res
endfunction

function! nasync#copy_bufs(vim)
  let save_async = a:vim.async
  let a:vim.async = 0
  for b in a:vim.vim('get_buffers')
    let lines = a:vim.buf('line_count', b)

    " Avoid copying invalid/empty buffers
    if lines == 0
      continue
    endif

    let fname = a:vim.buf('get_name', b)
    echo 'Copying ' . fname
    new
    call append(0, a:vim.buf('get_line_slice', b, 0, lines, 1, 1))
      
  endfor
  let a:vim.async = save_async
endfunction
