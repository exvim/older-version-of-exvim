" Vim syntax file
" Language:	C++
" Maintainer:	Ken Shan <ccshan@post.harvard.edu>
" Last Change:	2002 Jul 15

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/c.vim
else
  runtime! syntax/c.vim
  unlet b:current_syntax
endif

" C++ extentions
syn keyword cppStatement	new delete this friend using
syn keyword cppAccess		public protected private
syn keyword cppType		inline virtual explicit export bool wchar_t
syn keyword cppExceptions	throw try catch
syn keyword cppOperator		operator typeid
syn keyword cppOperator		and bitor or xor compl bitand and_eq or_eq xor_eq not not_eq
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*<"me=e-1
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*$"
syn keyword cppStorageClass	mutable
syn keyword cppStructure	class typename template namespace
syn keyword cppNumber		NPOS
syn keyword cppBoolean		true false

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
syn keyword exStatement         ex_new ex_new_use ex_new_nomanage ex_new_in
syn keyword exStatement         ex_delete ex_delete_use ex_delete_nomanage ex_delete_in
syn keyword exStatement         ex_delete_array ex_delete_array_use ex_delete_array_nomanage
syn keyword exBoolean		TRUE FALSE
" ==========================================

" The minimum and maximum operators in GNU C++
syn match cppMinMax "[<>]?"

" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink cppAccess		cppStatement
  HiLink cppCast		cppStatement
  HiLink cppExceptions		Exception
  HiLink cppOperator		Operator
  HiLink cppStatement		Statement
  HiLink cppType		Type
  HiLink cppStorageClass	StorageClass
  HiLink cppStructure		Structure
  HiLink cppNumber		Number
  HiLink cppBoolean		Boolean
  " ==========================================
  HiLink exType                 Type
  HiLink exStatement            Statement
  HiLink exBoolean              Boolean
  " ==========================================
  delcommand HiLink
endif

let b:current_syntax = "cpp"

" vim: ts=8
