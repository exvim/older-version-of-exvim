" Vim syntax file
" Language:	3ds Max Script
" Maintainer:	Johnny
" Credits:	Based on the hlsl.vim syntax file by Mark Ferrell
" Last change:	2007 Mat 14

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Comment
syn keyword	msTodo		contained TODO FIXME XXX
syn cluster	msCommentGroup	contains=msTodo
syn region  msCommentL	start="--" skip="\\$" end="$" keepend contains=@msCommentGroup
syn region	msComment	start="/\*" end="\*/" contains=@msCommentGroup

" Conditional
" TODO
"syn match msIf "\<if\>" nextgroup=msDo,msThen skipwhite skipempty skipnl
"syn match msDo "\<do\>" contained
"syn match msThen "\<then\>" contained
"syn cluster msConditionalCluster contains=msIf,msThen,msDo

syn keyword msAbout         about
syn keyword msAnd           and or not
" TODO
syn keyword msAnimate       animate 
syn keyword msAs            as
syn keyword msAt            at
syn keyword msConditional   for to do by in where while collect if then else continue exit
syn keyword msCase          case of
syn keyword msTry           try catch
syn keyword msCoordsys      coordsys
syn keyword msFunction      fn function mapped
syn keyword msScope         locale global
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
  HiLink msTodo            Todo
  HiLink msCommentL        msComment
  HiLink msComment         Comment

  HiLink msAbout        Conditional 
  HiLink msAnd          Conditional 
  HiLink msAnimate      Conditional 
  HiLink msAs           Conditional 
  HiLink msAt           Conditional 
  HiLink msConditional  Conditional 
  HiLink msCase         Conditional 
  HiLink msTry          Conditional 
  HiLink msCoordsys     Conditional 
  HiLink msFunction     Conditional 
  HiLink msScope        Conditional 
  HiLink msMacroscript  Conditional 
  HiLink msMax          Conditional 
  delcommand HiLink
endif


let b:current_syntax = "maxscript"
" vim: ts=8
