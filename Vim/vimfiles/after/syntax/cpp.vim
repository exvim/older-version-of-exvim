" ==========================================
" Vim syntax file
" Language:	C++ externtions
" Maintainer:	Wu Jie
" Last Change:	2007/10/12
" ==========================================

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
" exMacroHighlight Predeined Syntax
" ==========================================

" the cPreCondit conflict with exMacroInside, use exPreCondit instead
syn region exMacroInside contained matchgroup=cPreProc start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\).*\/\/"rs=e-2 start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\).*" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" extend contains=@exEnableContainedGroup
syn match exPreCondit display "^\s*\(%:\|#\)\s*\(else\|elif\)\>.*" contains=cComment,cCommentL

" the bug is the exElseDisable and exIfxEnable share the same end.
syn region exElseDisable contained start="^\s*\(%:\|#\)\s*else\>" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" keepend contains=exCppSkip
syn region exElseEnable contained matchgroup=cPreProc start="^\s*\(%:\|#\)\s*else\>" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" keepend contains=@exEnableContainedGroup
syn region exCppSkip contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" extend contains=cSpaceError,exCppSkip

" add c enable group
syn cluster exEnableContainedGroup contains=cStatement,cLabel,cConditional,cRepeat,cString,cCppString,cCharacter,cSpecialError,cSpecialCharacter,cSpaceError,cBlock,cParen,cParenError,cBracket,cNumbers,cComment,cCommentL,cCommentError,cOperator,cType,cStructure,cStorageClass,cConstant,cCppOut,cInclude,cDefine,cPreProc,cMulti,cUserCont,cBitField
" add cpp enable group
syn cluster exEnableContainedGroup add=cppStatement,cppAccess,cppType,cppExceptions,cppOperator,cppCast,cppStorageClass,cppStructure,cppNumber,cppBoolean,cppMinMax
" add hlsl enable group
syn cluster exEnableContainedGroup add=hlslStorage,hlslType,hlslShaderType,hlslBaseFunction,hlslBaseFunction,hlslFunction
" add exMacroHighlight enable group
syn cluster exEnableContainedGroup add=exPreCondit,exMacroInside
syn cluster exEnableContainedGroup add=exIfDisableStart,exIfnDisableStart,exIfEnableStart,exIfnEnableStart
syn cluster exEnableContainedGroup add=exElifEnableStart,exElifnEnableStart,exElifDisableStart,exElifnDisableStart

" add to original c_syntax groups
" don't add exXXXStart in, or we will lose effect in Paren --> ( ... )
syn cluster cParenGroup add=exCppSkip,exMacroInside,exIfEnable,exIfDisable,exIfnEnable,exIfnDisable,exElifEnable,exElifnEnable,exElifDisable,exElifnDisable,exElseDisable,exElseEnable,exAndEnable,exAndnotEnable,exOrDisable,exOrnotDisable
syn cluster cPreProcGroup add=exCppSkip,exMacroInside,exIfEnable,exIfDisable,exIfnEnable,exIfnDisable,exElifEnable,exElifnEnable,exElifDisable,exElifnDisable,exElseDisable,exElseEnable,exAndEnable,exAndnotEnable,exOrDisable,exOrnotDisable
syn cluster cMultiGroup add=exCppSkip,exMacroInside,exIfEnable,exIfDisable,exIfnEnable,exIfnDisable,exElifEnable,exElifnEnable,exElifDisable,exElifnDisable,exElseDisable,exElseEnable,exAndEnable,exAndnotEnable,exOrDisable,exOrnotDisable 

" define groups
" group seems may slow down the perforce, especially in run-time
"syn cluster exSkipGroup contains=exCppSkip,exMacroInside
"syn cluster exIfGroup contains=exIfEnable,exIfDisable,exIfnEnable,exIfnDisable
"syn cluster exElifGroup contains=exElifEnable,exElifnEnable,exElifDisable,exElifnDisable
"syn cluster exElesGroup contains=exElseDisable,exElseEnable

" group seems may slow down the perforce, especially in run-time
"syn cluster cParenGroup add=@exSkipGroup,@exIfGroup,@exElifGroup,@exElseGroup
"syn cluster cPreProcGroup add=@exSkipGroup,@exIfGroup,@exElifGroup,@exElseGroup
"syn cluster cMultiGroup add=@exSkipGroup,@exIfGroup,@exElifGroup,@exElseGroup

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
  HiLink exType                 Type
  HiLink exStatement            Statement
  HiLink exBoolean              Boolean

  " ------------------------------------------
  " exMacroHilight hilight defines
  " ------------------------------------------
  " inside pattern
  HiLink exCppSkip              exMacroDisable
  HiLink exMacroInside          Normal
  HiLink exPreCondit            cPreProc

  " else disable/enable
  HiLink exElseDisable          exMacroDisable
  HiLink exElseEnable           Normal

  " logic 
  HiLink exAndEnable            Normal
  HiLink exAndnotEnable         Normal
  HiLink exOrDisable            exMacroDisable
  HiLink exOrnotDisable         exMacroDisable

  " if/ifn eanble
  HiLink exIfEnableStart        cPreProc
  HiLink exIfEnable             Normal
  HiLink exIfnEnableStart       cPreProc
  HiLink exIfnEnable            Normal

  " if/ifn disable
  HiLink exIfDisable            exMacroDisable
  HiLink exIfDisableStart       exMacroDisable
  HiLink exIfnDisable           exMacroDisable
  HiLink exIfnDisableStart      exMacroDisable

  " elif/elifn enable
  HiLink exElifEnableStart      cPreProc
  HiLink exElifEnable           Normal
  HiLink exElifnEnableStart     cPreProc
  HiLink exElifnEnable          Normal

  " elif/elifn disable
  HiLink exElifDisableStart     exMacroDisable 
  HiLink exElifDisable          exMacroDisable 
  HiLink exElifnDisableStart    exMacroDisable 
  HiLink exElifnDisable         exMacroDisable 

  delcommand HiLink
endif

let b:current_syntax = "cpp"

" vim: ts=8
