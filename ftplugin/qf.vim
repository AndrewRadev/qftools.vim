xnoremap <buffer> d :RemoveLines<cr>
nnoremap <buffer> d :set opfunc=qftools#DeleteMotion<cr>g@
nnoremap <buffer> dd V:RemoveLines<cr>

nnoremap <silent> <buffer> u     :silent! colder<cr>
nnoremap <silent> <buffer> <c-r> :silent! cnewer<cr>

" open
nnoremap <buffer> o <cr>
" open in a tab
nnoremap <buffer> t <c-w><cr><c-w>T
" open in a tab without switching to it
nnoremap <buffer> T <c-w><cr><c-w>TgT<c-w>j
" open in a horizontal split
nnoremap <buffer> i <c-w><cr><c-w>K
" open in a vertical split
nnoremap <buffer> S <C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t

command! -buffer -nargs=1 -complete=custom,qftools#CompleteText
      \ RemoveText
      \ call qftools#RemovePattern(<f-args>, {'source': 'text', 'invert': 0})

command! -buffer -nargs=1 -complete=file
      \ RemoveFile
      \ call qftools#RemovePattern(<f-args>, {'source': 'file', 'invert': 0})

command! -buffer -nargs=1 -complete=custom,qftools#CompleteText
      \ KeepText
      \ call qftools#RemovePattern(<f-args>, {'source': 'text', 'invert': 1})

command! -buffer -nargs=1 -complete=file
      \ KeepFile
      \ call qftools#RemovePattern(<f-args>, {'source': 'file', 'invert': 1})

command! -buffer -range RemoveLines call qftools#RemoveLines(<line1>, <line2>)
command! -buffer -range KeepLines   call qftools#KeepLines(<line1>, <line2>)

command! -buffer -nargs=* -complete=command Append  call qftools#Append(<q-args>)
command! -buffer -nargs=* -complete=command Prepend call qftools#Prepend(<q-args>)
command! -buffer -nargs=* -complete=command Sort    call qftools#Sort(<q-args>)
command! -buffer -nargs=* -complete=command Merge   call qftools#Merge(<q-args>)
