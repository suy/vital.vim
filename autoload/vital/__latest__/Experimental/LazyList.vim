let s:save_cpo = &cpo
set cpo&vim

function! s:_vital_loaded(V)
  let s:V = a:V
  let s:L = s:V.import('Data.List')
endfunction

function! s:_vital_depends()
  return ['Data.List']
endfunction

function! s:from_list(xs)
  if len(a:xs) == 0
    return 'nil'
  else
    return [{'value': a:xs[0], 'fs': []}, s:from_list(a:xs[1 :])]
  endif
endfunction

function! s:is_empty(xs)
  return s:V.is_string(a:xs) && a:xs ==# 'nil'
endfunction

function! s:_eval(x)
  if has_key(a:x, 'thunk')
    let x = a:x.thunk()
  elseif has_key(a:x, 'value')
    let x = a:x.value
  else
    throw 'must not happen'
  endif
  return s:L.foldl('v:val(v:memo)', [x], a:x.fs)
endfunction

function! s:unapply(xs)
  return [a:xs[0], a:xs[1]]
endfunction

function! s:take(xs, n)
  if a:n == 0 || s:is_empty(a:xs)
    return []
  else
    let [x, xs] = s:unapply(a:xs)
    return s:_eval(x) + s:take(xs, a:n - 1)
  endif
endfunction

"let xs = s:L.file_readlines('/tmp/a.txt')
"let xs = s:L.map(xs, 'split(v:val, ":")')
"let xs = s:L.filter(xs, 'v:val[1] < 3')
"echo s:L.take(xs, 3)

call s:_vital_loaded(g:V)
echo s:from_list([3, 1, 4])
echo s:take(s:from_list([3, 1, 4]), 2)
echo s:take(s:from_list([3, 1, 4]), 2) == [3, 1]

"echo s:take(s:filter(s:from_list([3, 1, 4], 'v:val < 2'), 2), 1)

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
