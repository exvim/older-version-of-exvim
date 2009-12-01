" ======================================================================================
" File         : maxscript.vim
" Author       : Wu Jie 
" Last Change  : 05/10/2009 | 00:41:49 AM | Sunday,May
" Description  : Based on the hlsl.vim syntax file by Mark Ferrell
" ======================================================================================

"/////////////////////////////////////////////////////////////////////////////
"
"/////////////////////////////////////////////////////////////////////////////

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

"/////////////////////////////////////////////////////////////////////////////
" syntax define
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" Comment
" ======================================================== 

syn keyword	msTodo		contained TODO FIXME XXX
syn cluster	msCommentGroup	contains=msTodo
syn region      msCommentL	start="--" skip="\\$" end="$" keepend contains=@msCommentGroup
syn region	msComment	start="/\*" end="\*/" contains=@msCommentGroup

" ======================================================== 
" string
" ======================================================== 

syn match	msSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn match	msSpecial	display contained "\\\(u\x\{4}\|U\x\{8}\)"
syn match	msFormat	display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjzt]\|ll\|hh\)\=\([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
syn match	msFormat	display "%%" contained
syn region	msString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=msSpecial

" ======================================================== 
" statement 
" ======================================================== 

syn keyword msConstant      true false
syn keyword msStatement     return break continue
syn keyword msRepeat        for to do by in where while collect
syn keyword msConditional   if then else exit on and or not
syn keyword msCase          case of
syn keyword msTry           try catch

" ======================================================== 
" keywords
" ======================================================== 

syn keyword msAbout         about
syn keyword msAnimate       animate 
syn keyword msAs            as
syn keyword msAt            at
syn keyword msCoordsys      coordsys
syn keyword msFunction      fn function mapped
syn keyword msStruct        struct[ure]*
syn keyword msScope         local global rollout utility group plugin
syn keyword msGUI           checkbox button label edittext pickbutton spinner
syn keyword msGUIState      pressed changed
syn keyword msMacroscript   macroscript
syn keyword msMax           max

"/////////////////////////////////////////////////////////////////////////////
" external
"/////////////////////////////////////////////////////////////////////////////

if !exists('g:ex_todo_keyword')
    let g:ex_todo_keyword = 'NOTE REF EXAMPLE'
endif
if !exists('g:ex_comment_lable_keyword')
    let g:ex_comment_lable_keyword = 'TEMP CRASH MODIFY DEBUG DUMMY DELME TESTME OPTME REFACTORING DUPLICATE REDUNDANCY'
endif
silent exec ':syn keyword msTodo contained ' . g:ex_todo_keyword
silent exec ':syn keyword exCommentLable contained ' . g:ex_comment_lable_keyword
syn cluster msCommentGroup contains=msTodo,exCommentLable

"/////////////////////////////////////////////////////////////////////////////
" Default highlighting
"/////////////////////////////////////////////////////////////////////////////

" Define the default highlighting.
if version >= 508 || !exists("did_ms_syntax_inits")
  if version < 508
    let did_ms_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  "
  HiLink msTodo         Todo
  HiLink msCommentL     msComment
  HiLink msComment      Comment

  "
  HiLink msFormat       msSpecial       
  HiLink msSpecial      SpecialChar             
  HiLink msString       String 

  "
  HiLink msConstant     Constant
  HiLink msStatement    Statement
  HiLink msRepeat	Repeat
  HiLink msConditional	Conditional
  HiLink msCase         Conditional 
  HiLink msTry          Statement 

  HiLink msAbout        Type 
  HiLink msAnimate      Type 
  HiLink msAs           Type 
  HiLink msAt           Type 
  HiLink msConditional  Type 
  HiLink msCoordsys     Type 
  HiLink msFunction     Type 
  HiLink msStruct       Type 
  HiLink msScope        Type 
  HiLink msGUI          Type 
  HiLink msGUIState     Type 
  HiLink msMacroscript  Type 
  HiLink msMax          Type 
  delcommand HiLink
endif


let b:current_syntax = "maxscript"
" vim: ts=8
