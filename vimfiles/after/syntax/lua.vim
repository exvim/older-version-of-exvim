" ======================================================================================
" File         : lua.vim
" Author       : Wu Jie 
" Last Change  : 08/31/2010 | 20:33:32 PM | Tuesday,August
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
silent exec ':syn keyword luaTodo contained ' . g:ex_todo_keyword
silent exec ':syn keyword exCommentLable contained ' . g:ex_comment_lable_keyword
syn match luaComment "--.*$" contains=@Spell,luaTodo,exCommentLable

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

let b:current_syntax = "lua"

" vim: ts=8

