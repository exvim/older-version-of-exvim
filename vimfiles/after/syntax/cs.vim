" ======================================================================================
" File         : cs.vim
" Author       : Wu Jie 
" Last Change  : 12/13/2009 | 00:40:17 AM | Sunday,December
" Description  : 
" ======================================================================================

"/////////////////////////////////////////////////////////////////////////////
" syntax defines
"/////////////////////////////////////////////////////////////////////////////

if !exists('g:ex_todo_keyword')
    let g:ex_todo_keyword = 'NOTE REF EXAMPLE'
endif
if !exists('g:ex_comment_lable_keyword')
    let g:ex_comment_lable_keyword = 'TEMP CRASH MODIFY DEBUG DUMMY DELME TESTME OPTME REFACTORING DUPLICATE REDUNDANCY'
endif
silent exec ':syn keyword csTodo contained ' . g:ex_todo_keyword
silent exec ':syn keyword exCommentLable contained ' . g:ex_comment_lable_keyword

syn region csComment start="/\*"  end="\*/" contains=@csCommentHook,csTodo,@Spell,exCommentLable
syn match csComment "//.*$" contains=@csCommentHook,csTodo,@Spell,exCommentLable

" DISABLE: disable macro highlight. have a bug in #if 1 xxxx #else xxxx #endif { 
" " ======================================================== 
" " exMacroHighlight Predeined Syntax
" " ======================================================== 

" " the cPreCondit conflict with exMacroInside, use exPreCondit instead
" syn region exMacroInside contained matchgroup=csPreCondit start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\).*\/\/"rs=e-2 start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\).*" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" extend contains=@exEnableContainedGroup
" syn match exPreCondit display "^\s*\(%:\|#\)\s*\(else\|elif\)\>.*" contains=csComment

" " the bug is the exElseDisable and exIfxEnable share the same end.
" syn region exElseDisable contained start="^\s*\(%:\|#\)\s*else\>" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" keepend contains=exCppSkip
" syn region exElseEnable contained matchgroup=csPreCondit start="^\s*\(%:\|#\)\s*else\>" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" keepend contains=@exEnableContainedGroup
" syn region exCppSkip contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" extend contains=exCppSkip

" " add c enable group
" syn cluster exEnableContainedGroup contains=csType,csStorage,csRepeat,csConditional,csLabel,csModifier,csConstant,csException,csUnspecifiedStatement,csUnsupportedStatement,csUnspecifiedKeyword,csContextualStatement,csTodo,csComment,csString,csVerbatimString,csVerbatimSpec,csPreCondit,csCharacter,csSpecialChar,csNumber,csUnicodeNumber,csUnicodeSpecifier,csXmlCommentLeader,csXmlComment,csXmlTag

" " add exMacroHighlight enable group
" syn cluster exEnableContainedGroup add=exPreCondit,exMacroInside
" syn cluster exEnableContainedGroup add=exIfDisableStart,exIfnDisableStart,exIfEnableStart,exIfnEnableStart
" syn cluster exEnableContainedGroup add=exElifEnableStart,exElifnEnableStart,exElifDisableStart,exElifnDisableStart

" " add to original c_syntax groups
" " don't add exXXXStart in, or we will lose effect in Paren --> ( ... )
" " syn cluster csPreCondit add=exCppSkip,exMacroInside,exIfEnable,exIfDisable,exIfnEnable,exIfnDisable,exElifEnable,exElifnEnable,exElifDisable,exElifnDisable,exElseDisable,exElseEnable,exAndEnable,exAndnotEnable,exOrDisable,exOrnotDisable

" "/////////////////////////////////////////////////////////////////////////////
" " Default highlighting
" "/////////////////////////////////////////////////////////////////////////////

" " ======================================================== 
" " exMacroHilight hilight defines
" " ======================================================== 

" " inside pattern
" hi def link exCppSkip              exMacroDisable
" hi def link exMacroInside          Normal
" hi def link exPreCondit            PreCondit

" " else disable/enable
" hi def link exElseDisable          exMacroDisable
" hi def link exElseEnable           Normal

" " logic 
" hi def link exAndEnable            Normal
" hi def link exAndnotEnable         Normal
" hi def link exOrDisable            exMacroDisable
" hi def link exOrnotDisable         exMacroDisable

" " if/ifn eanble
" hi def link exIfEnableStart        PreCondit
" hi def link exIfEnable             Normal
" hi def link exIfnEnableStart       PreCondit
" hi def link exIfnEnable            Normal

" " if/ifn disable
" hi def link exIfDisable            exMacroDisable
" hi def link exIfDisableStart       exMacroDisable
" hi def link exIfnDisable           exMacroDisable
" hi def link exIfnDisableStart      exMacroDisable

" " elif/elifn enable
" hi def link exElifEnableStart      PreCondit
" hi def link exElifEnable           Normal
" hi def link exElifnEnableStart     PreCondit
" hi def link exElifnEnable          Normal

" " elif/elifn disable
" hi def link exElifDisableStart     exMacroDisable 
" hi def link exElifDisable          exMacroDisable 
" hi def link exElifnDisableStart    exMacroDisable 
" hi def link exElifnDisable         exMacroDisable 
" } DISABLE end 

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

let b:current_syntax = "cs"

" vim: ts=8

