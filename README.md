Note: *Some* of the functionality of this plugin overlaps with [vim-qf](https://github.com/romainl/vim-qf). At this time, vim-qf seems more mature, so you might want to consider using that one instead.

## Usage

This plugin provides various commands and mappings to work with the contents of the quickfix window.

### Append, sort, merge

If you've executed a grep/ack command and you have a bunch of stuff in your quickfix window, but want to add another grep to it, this could help:

``` vim
:Ack ProjectCollaborator
:Qfappend Ack UserCollaborator
```

This will add the new search results to the end of the quickfix list, instead of replacing it. You could also swap the order by using `:Qfprepend`:

``` vim
:Ack ProjectCollaborator
:Qfprepend Ack UserCollaborator
```

Duplicates should automatically be removed (two hits on the same line in the same file). However, the order is going to be the exact order of the first list + second list. To sort the current quickfix list alphabetically on the filename, use `:Qfsort`:

``` vim
:Ack ProjectCollaborator
:Qfappend Ack UserCollaborator
:Qfsort
```

You can also provide `:Qfsort` with a command and it'll execute that first, allowing you to do:

``` vim
:Ack ProjectCollaborator
:Qfsort Qfappend Ack UserCollaborator
```

The same commands are available without the "Qf" prefix within the actual buffer:

``` vim
:Append
:Prepend
:Sort
:Merge
```


### Filtering entries

The plugin defines commands to remove lines by pattern:

``` vim
:RemoveText <some-pattern> -> matches the text entries
:RemoveFile <some-pattern> -> matches the file entries
```

You can also do the opposite and only keep files/text entries matching a particular pattern:

``` vim
:KeepText <some-pattern>
:KeepFile <some-pattern>
```

As an example, if you're searching for some code that gives you results in both javascript and handlebars files, you can remove all files with the `.hbs` extension from the quickfix list like so:

``` vim
:RemoveFile \.hbs$
```

Alternatively, you can keep only javascript files with:

``` vim
:KeepFile \.js$
```

This way, you can filter out test files, or narrow down the pattern you searched for within the found matches.

If you'd like to just remove, or keep, a range of lines, you can use these two commands:

``` vim
<start>,<end>RemoveLines
<start>,<end>KeepLines
```

The range is a perfectly normal range, so visual mode works with both of these. You can mark a visual-mode selection and run `:RemoveLines` to remove the selection from the quickfix window.

You can disable these commands by setting `g:qftools_no_buffer_commands` to 1.

You can also use the `d` mapping similar to the built-in one:

- `dd` removes a single line
- visual-mode d removes the selected lines
- `d{motion}` deletes the lines affected by the motion (for instance, `dG` would delete all lines till the end of the buffer)

You can "undo" and "redo" deletions by using `u` and `<c-r>`. These mappings are not as powerful as Vim's built-in undo mechanism, but they should work mostly as expected. Currently, all they do is provide a thin wrapper to `:colder` and `:cnewer`.

You can disable these mappings by setting `g:qftools_no_buffer_mappings` to 1.

### Open mappings

There are buffer-specific mappings defined that help you open files in different ways:

- `o` opens the file the same way as `<cr>`, but it's closer to the home row
- `t` opens the file in a new tab
- `T` opens the file in a new tab, without switching to it
- `i` opens the file in a new horizontal split
- `S` opens the file in a new vertical split

They've been taken pretty much as-is from the [ack.vim plugin](https://github.com/mileszs/ack.vim). You can disable them by setting `g:qftools_no_buffer_mappings` to 1.
