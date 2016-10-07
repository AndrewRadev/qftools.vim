function! qftools#DeleteByPattern(pattern, bang)
  let saved_view = winsaveview()
  let deleted    = []

  let new_qflist = []
  for entry in getqflist()
    if (!s:EntryMatches(entry, a:pattern) && a:bang == '') ||
          \ (s:EntryMatches(entry, a:pattern) && a:bang == '!')
      call add(new_qflist, entry)
    else
      call add(deleted, entry)
    endif
  endfor

  call setqflist(new_qflist)
  call winrestview(saved_view)
  echo
endfunction

function! qftools#DeleteMotion(_type)
  call qftools#DeleteLines(line("'["), line("']"))
endfunction

function! qftools#DeleteLines(start, end)
  let saved_view = winsaveview()
  let start        = a:start - 1
  let end          = a:end - 1

  let qflist  = getqflist()
  call remove(qflist, start, end)
  call setqflist(qflist)

  call winrestview(saved_view)
  echo
endfunction

function! qftools#DeleteLinesExcept(start, end)
  let saved_view = winsaveview()
  let start        = a:start - 1
  let end          = a:end - 1

  let qflist = getqflist()
  let last_index = len(qflist) - 1
  let new_qflist = qflist[start:end]

  call setqflist(new_qflist)
  call winrestview(saved_view)
  echo
endfunction

function! s:EntryMatches(entry, pattern)
  return (a:entry.text =~ a:pattern) || (bufname(a:entry.bufnr) =~ a:pattern)
endfunction
