" ======================================================================================
" File         : javascript.vim
" Author       : Wu Jie 
" Last Change  : 05/29/2010 | 01:18:38 AM | Saturday,May
" Description  : 
" ======================================================================================

"/////////////////////////////////////////////////////////////////////////////
" syntax defines
"/////////////////////////////////////////////////////////////////////////////

" NOTE: the original javscript syntax file use 'syn case ignore'.
syn case match

if !exists('g:ex_todo_keyword')
    let g:ex_todo_keyword = 'NOTE REF EXAMPLE'
endif
if !exists('g:ex_comment_lable_keyword')
    let g:ex_comment_lable_keyword = 'TEMP CRASH MODIFY DEBUG DUMMY DELME TESTME OPTME REFACTORING DUPLICATE REDUNDANCY'
endif
silent exec ':syn keyword javaScriptCommentTodo contained ' . g:ex_todo_keyword
silent exec ':syn keyword exCommentLable contained ' . g:ex_comment_lable_keyword

syn match javaScriptLineComment "\/\/.*" contains=@Spell,javaScriptCommentTodo,exCommentLable
syn region javaScriptComment start="/\*"  end="\*/" contains=@Spell,javaScriptCommentTodo,exCommentLable

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

let b:current_syntax = "javascript"

" vim: ts=8

