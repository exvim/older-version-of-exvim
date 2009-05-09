" ======================================================================================
" File         : maxscript.vim
" Author       : Wu Jie 
" Last Change  : 05/10/2009 | 00:41:49 AM | Sunday,May
" Description  : Based on the hlsl.vim syntax file by Mark Ferrell
" ======================================================================================

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Comment
syn keyword	msTodo		contained TODO FIXME XXX
syn cluster	msCommentGroup	contains=msTodo
syn region      msCommentL	start="--" skip="\\$" end="$" keepend contains=@msCommentGroup
syn region	msComment	start="/\*" end="\*/" contains=@msCommentGroup

" string
syn match	msSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn match	msSpecial	display contained "\\\(u\x\{4}\|U\x\{8}\)"
syn match	msFormat	display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjzt]\|ll\|hh\)\=\([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
syn match	msFormat	display "%%" contained
syn region	msString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=msSpecial

" keywords
syn keyword msAbout         about
syn keyword msAnd           and or not
syn keyword msAnimate       animate 
syn keyword msAs            as
syn keyword msAt            at
syn keyword msConditional   for to do by in where while collect if then else continue exit on
syn keyword msCase          case of
syn keyword msTry           try catch
syn keyword msCoordsys      coordsys
syn keyword msFunction      fn function mapped
syn keyword msStruct        structure
syn keyword msScope         local global rollout utility group
syn keyword msGUI           checkbox button label
syn keyword msGUIState      pressed changed
syn keyword msMacroscript   macroscript
syn keyword msMax           max

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
  HiLink msAbout        Type 
  HiLink msAnd          Type 
  HiLink msAnimate      Type 
  HiLink msAs           Type 
  HiLink msAt           Type 
  HiLink msConditional  Type 
  HiLink msCase         Type 
  HiLink msTry          Type 
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
