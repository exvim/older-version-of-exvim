" ======================================================================================
" File         : cpp.vim
" Author       : Wu Jie 
" Last Change  : 10/21/2008 | 22:56:38 PM | Tuesday,October
" Description  : 
" ======================================================================================

"/////////////////////////////////////////////////////////////////////////////
" check syntax load and inherits
"/////////////////////////////////////////////////////////////////////////////

" Read the after C syntax to start with
if version < 600
    so $VIM/vimfiles/after/syntax/c.vim
else
    runtime! $VIM/vimfiles/after/syntax/c.vim
    unlet b:current_syntax
endif

"/////////////////////////////////////////////////////////////////////////////
" syntax defines
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" EX_ENGINE extentions
" ======================================================== 

syn keyword cStatement  ex_new ex_new_use ex_new_tag ex_new_tag_use ex_new_nomng ex_new_in ex_new_at ex_stack_malloc
syn keyword cStatement  ex_new_array ex_new_array_use ex_new_array_tag ex_new_array_tag_use ex_new_array_nomng
syn keyword cStatement  ex_delete ex_delete_use ex_delete_nomng ex_delete_in
syn keyword cStatement  ex_safe_delete ex_safe_delete_use ex_safe_delete_nomng ex_safe_delete_in
syn keyword cStatement  ex_delete_array ex_delete_array_use ex_delete_array_nomng
syn keyword cStatement  ex_safe_delete_array ex_safe_delete_array_use ex_safe_delete_array_nomng
syn keyword cStatement  ex_try ex_catch ex_catch_exp ex_throw

" ======================================================== 
" QT extentions
" ======================================================== 

syn keyword cSpecial    slots signals emit

" ======================================================== 
" exMacroHighlight Predeined Syntax
" ======================================================== 

" add cpp enable group
syn cluster exEnableContainedGroup add=cppStatement,cppAccess,cppType,cppExceptions,cppOperator,cppCast,cppStorageClass,cppStructure,cppNumber,cppBoolean,cppMinMax

"/////////////////////////////////////////////////////////////////////////////
" Default highlighting
"/////////////////////////////////////////////////////////////////////////////

if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " ======================================================== 
  " EX_ENGINE hilight defines
  " ======================================================== 

  " ======================================================== 
  " exMacroHilight hilight defines
  " ======================================================== 

  delcommand HiLink
endif

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

let b:current_syntax = "cpp"

" vim: ts=8
