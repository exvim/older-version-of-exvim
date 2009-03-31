" ======================================================================================
" File         : exUtility.vim
" Author       : Wu Jie 
" Last Change  : 10/21/2008 | 22:55:35 PM | Tuesday,October
" Description  : 
" ======================================================================================

"/////////////////////////////////////////////////////////////////////////////
" check script load
"/////////////////////////////////////////////////////////////////////////////

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/cpp.vim
else
  runtime! syntax/cpp.vim
  unlet b:current_syntax
endif

"/////////////////////////////////////////////////////////////////////////////
" syntax defines
"/////////////////////////////////////////////////////////////////////////////

" don't highlight error pattern
let c_no_bracket_error = 1
let c_no_curly_error = 1

" for exUtility, the search result just show the string in one line
if exists("c_no_cformat")
    syn region	cString		start=+L\="+ end=+"+ end='$' contains=cSpecial,@Spell
else
    syn region	cString		start=+L\="+ end=+"+ end='$' contains=cSpecial,cFormat,@Spell
endif

" for exUtility, the search result just show the comment in one line
if exists("c_comment_strings")
    syntax region cComment	matchgroup=cCommentStart start="/\*" end="\*/" end="$" contains=@cCommentGroup,cCommentStartError,cCommentString,cCharacter,cNumbersCom,cSpaceError,@Spell extend
else
    syntax region cComment	matchgroup=cCommentStart start="/\*" end="\*/" end="$" contains=@cCommentGroup,cCommentStartError,cSpaceError,@Spell
endif

" jwu modify, don't start # at the front of the line. cause our search result not start from beginning of the line
syn region	cPreCondit	start="\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" end="$" end="//"me=s-1 contains=cComment,cCppString,cCharacter,cCppParen,cParenError,cNumbers,cCommentError,cSpaceError
syn match	cPreCondit	display "\s*\(%:\|#\)\s*\(else\|endif\)\>"
syn region	cDefine		start="\s*\(%:\|#\)\s*\(define\|undef\)\>" end="$" end="//"me=s-1 keepend contains=ALLBUT,@cPreProcGroup,@Spell
syn region	cPreProc	start="\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" end="$" keepend contains=ALLBUT,@cPreProcGroup,@Spell
syn region	cIncluded	display contained start=+"+ end=+"+
syn match	cIncluded	display contained "<[^>]*>"
syn match	cInclude	display "\s*\(%:\|#\)\s*include\>\s*["<]" contains=cIncluded

"/////////////////////////////////////////////////////////////////////////////
" highlight defines
"/////////////////////////////////////////////////////////////////////////////

" link the cParenError to normal to avoid disaply paren error
hi def link cParenError		Normal

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

let b:current_syntax = "exUtility"

" vim: ts=8
