" ==========================================
" Vim syntax file
" Language:	C++ externtions
" Maintainer:	Wu Jie
" Last Change:	2007/10/12
" ==========================================

" Read the after C syntax to start with
if version < 600
    so $VIM/vimfiles/after/syntax/c.vim
else
    runtime! $VIM/vimfiles/after/syntax/c.vim
    unlet b:current_syntax
endif

" ==========================================
" the extertion syntax define
" ==========================================
" EX_ENGINE extentions
syn keyword cStatement         ex_new ex_new_use ex_new_nomanage ex_new_in ex_new_at ex_stack_malloc
syn keyword cStatement         ex_delete ex_delete_use ex_delete_nomanage ex_delete_in
syn keyword cStatement         ex_delete_array ex_delete_array_use ex_delete_array_nomanage

" ==========================================
" exMacroHighlight Predeined Syntax
" ==========================================

" add cpp enable group
syn cluster exEnableContainedGroup add=cppStatement,cppAccess,cppType,cppExceptions,cppOperator,cppCast,cppStorageClass,cppStructure,cppNumber,cppBoolean,cppMinMax

" ==========================================
" Default highlighting
" ==========================================
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  " ------------------------------------------
  " EX_ENGINE hilight defines
  " ------------------------------------------

  " ------------------------------------------
  " exMacroHilight hilight defines
  " ------------------------------------------

  delcommand HiLink
endif

let b:current_syntax = "cpp"

" vim: ts=8
