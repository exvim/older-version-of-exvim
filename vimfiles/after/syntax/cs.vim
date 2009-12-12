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
syn match csComment "//.*$" contains=@csCommentHook,csTodo,@Spell,exCommentLable


"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

let b:current_syntax = "python"

" vim: ts=8

