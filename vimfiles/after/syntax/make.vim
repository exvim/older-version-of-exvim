" ======================================================================================
" File         : make.vim
" Author       : Wu Jie 
" Last Change  : 09/27/2009 | 15:43:27 PM | Sunday,September
" Description  : 
" ======================================================================================

"/////////////////////////////////////////////////////////////////////////////
" external
"/////////////////////////////////////////////////////////////////////////////

if !exists('g:ex_todo_keyword')
    let g:ex_todo_keyword = 'NOTE REF EXAMPLE'
endif
if !exists('g:ex_comment_lable_keyword')
    let g:ex_comment_lable_keyword = 'TEMP CRASH MODIFY DEBUG DUMMY DELME TESTME OPTME REFACTORING DUPLICATE REDUNDANCY'
endif
silent exec ':syn keyword makeTodo contained ' . g:ex_todo_keyword
silent exec ':syn keyword exCommentLable contained ' . g:ex_comment_lable_keyword

" redefin makeComment

if exists("make_microsoft")
   syn match  makeComment "#.*" contains=@Spell,makeTodo,exCommentLable
elseif !exists("make_no_comments")
   syn region  makeComment	start="#" end="^$" end="[^\\]$" keepend contains=@Spell,makeTodo,exCommentLable
   syn match   makeComment	"#$" contains=@Spell
endif

"/////////////////////////////////////////////////////////////////////////////
"
"/////////////////////////////////////////////////////////////////////////////

let b:current_syntax = "make"
