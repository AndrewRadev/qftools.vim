function! qftools#RemovePattern(pattern, params)
  let pattern = a:pattern
  let source  = a:params.source
  let invert  = a:params.invert

  let saved_view = winsaveview()
  let deleted    = []

  let new_qflist = []
  for entry in getqflist()
    if source == 'text'
      let pattern_matches = (entry.text =~ pattern)
    elseif source == 'file'
      let pattern_matches = (bufname(entry.bufnr) =~ pattern)
    else
      echoerr "Unknown 'source': ".source
      return
    endif

    if (pattern_matches && !invert) || (!pattern_matches && invert)
      call add(deleted, entry)
    else
      call add(new_qflist, entry)
    endif
  endfor

  call setqflist(new_qflist)
  call winrestview(saved_view)
  echo
endfunction

function! qftools#DeleteMotion(_type)
  call qftools#RemoveLines(line("'["), line("']"))
endfunction

function! qftools#RemoveLines(start, end)
  let saved_view = winsaveview()
  let start      = a:start - 1
  let end        = a:end - 1

  let qflist = getqflist()
  call remove(qflist, start, end)
  call setqflist(qflist)

  call winrestview(saved_view)
  echo
endfunction

function! qftools#KeepLines(start, end)
  let saved_view = winsaveview()
  let start      = a:start - 1
  let end        = a:end - 1

  let qflist = getqflist()
  let last_index = len(qflist) - 1
  let new_qflist = qflist[start:end]

  call setqflist(new_qflist)
  call winrestview(saved_view)
  echo
endfunction

function! qftools#Append(command)
  let qflist = getqflist()

  try
    exe a:command
  catch
    " don't try to sort if there's an error, just bail out
    echoerr v:exception
    return
  endtry

  call extend(qflist, getqflist())
  call setqflist(qflist)
endfunction

function! qftools#Prepend(command)
  let qflist = getqflist()

  try
    exe a:command
  catch
    " don't try to sort if there's an error, just bail out
    echoerr v:exception
    return
  endtry

  call extend(qflist, getqflist(), 0)
  call setqflist(qflist)
endfunction

function! qftools#Sort(command)
  if a:command != ''
    " there's a quickfix-related command given, execute it first
    try
      exe a:command
    catch
      " don't try to sort if there's an error, just bail out
      echoerr v:exception
      return
    endtry
  endif

  let qflist = copy(getqflist())
  call sort(qflist, function('qftools#SortCompare'))
  call setqflist(qflist)
endfunction

function! qftools#Merge(command)
  let qflist = getqflist()

  try
    exe a:command
  catch
    " don't try to sort if there's an error, just bail out
    echoerr v:exception
    return
  endtry

  call extend(qflist, getqflist(), 0)
  call sort(qflist, function('qftools#SortCompare'))
  call setqflist(qflist)
endfunction

function! qftools#Compact()
  let new_qflist = []

  for entry in getqflist()
    if entry.lnum > 0
      call add(new_qflist, entry)
    endif
  endfor

  call uniq(new_qflist)
  call setqflist(new_qflist)
endfunction

function! qftools#CompleteText(argument_lead, command_line, cursor_position)
  let text = join(map(getqflist(), 'v:val.text'), " ")
  let words = qftools#Scan(text, '\k\+')
  call uniq(sort(words))
  return join(words, "\n")
endfunction

function! qftools#SortCompare(x, y)
  let x_name = bufname(a:x.bufnr)
  let y_name = bufname(a:y.bufnr)

  if x_name < y_name
    return -1
  elseif x_name > y_name
    return 1
  else
    return 0
  else
endfunction

function! qftools#Scan(text, pattern)
  let offset = 0
  let matches = []

  let [match, start, end] = matchstrpos(a:text, a:pattern, offset)

  while start > 0
    call add(matches, match)
    let offset = end + 1
    let [match, start, end] = matchstrpos(a:text, a:pattern, offset)
  endwhile

  return matches
endfunction

function! qftools#Save(filename, items) abort
  for entry in a:items
    " Resolve each buffer to a filename, modify to take the absolute path
    let entry.filename = fnamemodify(bufname(entry.bufnr), ':p')
    " Remove bufnr to make sure Vim will deserialize the filename instead
    unlet entry.bufnr
  endfor

  let serialized_list = map(a:items, {_, entry -> json_encode(entry) })
  call writefile(serialized_list, a:filename)
endfunction

function! qftools#Load(filename) abort
  if !filereadable(a:filename)
    echoerr "File not readable: " .. a:filename
    return
  endif

  let file_contents = readfile(a:filename)
  let quickfix_entries = map(file_contents, {_, line -> json_decode(line) })

  call setqflist(quickfix_entries)
  copen
endfunction

function! qftools#AutoSave() abort
  if !g:qftools_autosave
    return
  endif

  let dir       = g:qftools_autosave_dir
  let max_count = g:qftools_autosave_max_count

  if isdirectory(dir)
    for file in glob(dir..'/???.jsonl', 0, 1)
      call delete(file)
    endfor
  else
    call mkdir(dir, 'p')
  endif

  let list_ids = range(1, getqflist({'nr': '$', 'id': 0 }).id)
  call sort(list_ids)
  call reverse(list_ids)
  let list_ids = list_ids[0:max_count]

  let index = len(list_ids)
  for list_id in list_ids
    let list = getqflist({'id': list_id, 'items': 0})

    let items = list.items
    if len(items) == 0
      continue
    endif
    let filename = dir..'/'..printf("%03d", index)..'.jsonl'
    let index -= 1

    call qftools#Save(filename, items)
  endfor
endfunction

function! qftools#AutoLoad() abort
  if !g:qftools_autosave
    return
  endif

  if !isdirectory(g:qftools_autosave_dir)
    return
  endif

  let loaded = 0

  for file in glob(g:qftools_autosave_dir..'/???.jsonl', 0, 1)
    silent call qftools#Load(file)
    let loaded = 1
  endfor

  if loaded
    " Don't open quickfix window by default
    cclose
  endif
endfunction
