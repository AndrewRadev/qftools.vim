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

if !exists('g:qftools_autosave')
  let g:qftools_autosave = 0
endif

if !exists('g:qftools_autosave_dir')
  let g:qftools_autosave_dir = expand('$HOME/.vim-qftools/')
endif

if !exists('g:qftools_autosave_max_count')
  let g:qftools_autosave_max_count = 1
endif

command! -nargs=* -complete=command Qfappend  call qftools#Append(<q-args>)
command! -nargs=* -complete=command Qfprepend call qftools#Prepend(<q-args>)
command! -nargs=* -complete=command Qfsort    call qftools#Sort(<q-args>)
command! -nargs=* -complete=command Qfmerge   call qftools#Merge(<q-args>)

command! -nargs=0 Qfcompact call qftools#Compact()

command! -nargs=1 -complete=file Qfsave call qftools#Save(<f-args>, getqflist())
command! -nargs=1 -complete=file Qfload call qftools#Load(<f-args>, {'open': 1})

autocmd VimLeave * if g:qftools_autosave | silent call qftools#AutoSave() | endif
if g:qftools_autosave
  autocmd VimEnter * silent call qftools#AutoLoad()
endif

let &cpo = s:keepcpo
unlet s:keepcpo
