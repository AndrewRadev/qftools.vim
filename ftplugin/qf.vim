xnoremap <buffer> d :DeleteLines<cr>
nnoremap <buffer> d :set opfunc=qftools#DeleteMotion<cr>g@
nnoremap <buffer> dd V:DeleteLines<cr>

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

command! -buffer -nargs=1 -bang Delete call qftools#DeleteByPattern(<f-args>, '<bang>')

command! -buffer -range DeleteLines call qftools#DeleteLines(<line1>, <line2>)
command! -buffer -range Only        call qftools#DeleteLinesExcept(<line1>, <line2>)

command! -buffer -nargs=* -complete=command Append  call qftools#Append(<q-args>)
command! -buffer -nargs=* -complete=command Prepend call qftools#Prepend(<q-args>)
command! -buffer -nargs=* -complete=command Sort    call qftools#Sort(<q-args>)
command! -buffer -nargs=* -complete=command Merge   call qftools#Merge(<q-args>)
