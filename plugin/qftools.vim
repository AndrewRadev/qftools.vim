if exists('g:loaded_qftools') || &cp
  finish
endif

let g:loaded_qftools = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:qftools_no_buffer_mappings')
  let g:qftools_no_buffer_mappings = 0
endif

if !exists('g:qftools_no_buffer_commands')
  let g:qftools_no_buffer_commands = 0
endif

command! -nargs=* -complete=command Qfappend  call qftools#Append(<q-args>)
command! -nargs=* -complete=command Qfprepend call qftools#Prepend(<q-args>)
command! -nargs=* -complete=command Qfsort    call qftools#Sort(<q-args>)
command! -nargs=* -complete=command Qfmerge   call qftools#Merge(<q-args>)

let &cpo = s:keepcpo
unlet s:keepcpo
