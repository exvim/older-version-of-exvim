" ======================================================================================
" File         : python.vim
" Author       : Wu Jie 
" Last Change  : 10/21/2008 | 22:41:48 PM | Tuesday,October
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
silent exec ':syn keyword pythonTodo contained ' . g:ex_todo_keyword
silent exec ':syn keyword exCommentLable contained ' . g:ex_comment_lable_keyword
syn match   pythonComment	"#.*$" contains=pythonTodo,exCommentLable,@Spell

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

let b:current_syntax = "python"

" vim: ts=8
