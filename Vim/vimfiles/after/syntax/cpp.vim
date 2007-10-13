" ==========================================
" Vim syntax file
" Language:	C++ externtions
" Maintainer:	Wu Jie
" Last Change:	2007/10/12
" ==========================================

" the extertion syntax define

" ==========================================
" EX_ENGINE extentions
syn keyword exType              SIZE_T
syn keyword exType              UINT INT UINT8 INT8 UINT16 INT16 UINT32 INT32 UINT64 INT64
syn keyword exType              FLOAT DOUBLE
syn keyword exType              CHAR WCHAR TCHAR TEXT
syn keyword exType              INLINE NOINLINE
syn keyword exType              UBOOL
syn keyword exStatement         ex_malloc ex_malloc_use ex_malloc_nomanage
syn keyword exStatement         ex_realloc ex_realloc_use ex_realloc_nomanage
syn keyword exStatement         ex_free ex_free_use ex_free_nomanage
syn keyword exStatement         ex_new ex_new_use ex_new_nomanage ex_new_in ex_new_add ex_new_insert ex_stack_malloc
syn keyword exStatement         ex_delete ex_delete_use ex_delete_nomanage ex_delete_in
syn keyword exStatement         ex_delete_array ex_delete_array_use ex_delete_array_nomanage
syn keyword exBoolean		TRUE FALSE
" ==========================================

" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  " ==========================================
  " EX_ENGINE extentions
  HiLink exType                 Type
  HiLink exStatement            Statement
  HiLink exBoolean              Boolean
  " ==========================================
  delcommand HiLink
endif

let b:current_syntax = "cpp"

" vim: ts=8
