" ======================================================================================
" File         : exJumpStack.vim
" Author       : Wu Jie 
" Last Change  : 06/02/2009 | 06:50:40 AM | Tuesday,June
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_exjumpstack') || &cp
    finish
endif
let loaded_exjumpstack=1

"/////////////////////////////////////////////////////////////////////////////
"
"/////////////////////////////////////////////////////////////////////////////


"/////////////////////////////////////////////////////////////////////////////
" variables
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" gloable varialbe initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: window height for horizon window mode
" ------------------------------------------------------------------ 

if !exists('g:exJS_window_height')
    let g:exJS_window_height = 20
endif

" ------------------------------------------------------------------ 
" Desc: window width for vertical window mode
" ------------------------------------------------------------------ 

if !exists('g:exJS_window_width')
    let g:exJS_window_width = 30
endif

" ------------------------------------------------------------------ 
" Desc: window height increment value
" ------------------------------------------------------------------ 

if !exists('g:exJS_window_height_increment')
    let g:exJS_window_height_increment = 30
endif

" ------------------------------------------------------------------ 
" Desc: window width increment value
" ------------------------------------------------------------------ 

if !exists('g:exJS_window_width_increment')
    let g:exJS_window_width_increment = 100
endif

" ------------------------------------------------------------------ 
" Desc: placement of the window
" 'topleft','botright'
" ------------------------------------------------------------------ 

if !exists('g:exJS_window_direction')
    let g:exJS_window_direction = 'belowright'
endif

" ------------------------------------------------------------------ 
" Desc: use vertical or not
" ------------------------------------------------------------------ 

if !exists('g:exJS_use_vertical_window')
    let g:exJS_use_vertical_window = 0
endif

" ------------------------------------------------------------------ 
" Desc: go back to edit buffer
" ------------------------------------------------------------------ 

if !exists('g:exJS_backto_editbuf')
    let g:exJS_backto_editbuf = 0
endif

" ------------------------------------------------------------------ 
" Desc: go and close exTagSelect window
" ------------------------------------------------------------------ 

if !exists('g:exJS_close_when_selected')
    let g:exJS_close_when_selected = 0
endif

" ------------------------------------------------------------------ 
" Desc: set edit mode
" 'none', 'append', 'replace'
" ------------------------------------------------------------------ 

if !exists('g:exJS_edit_mode')
    let g:exJS_edit_mode = 'replace'
endif

" ======================================================== 
" local variable initialization
" ======================================================== 


" ------------------------------------------------------------------ 
" Desc: title
" ------------------------------------------------------------------ 

let s:exJS_select_title = "__exJS_SelectWindow__"
let s:exJS_short_title = 'Select'

" ------------------------------------------------------------------ 
" Desc: variables
" ------------------------------------------------------------------ 

let s:exJS_select_idx = 1
let s:exJS_cursor_idx = 1
let s:exJS_stack_idx = 0

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

let s:exJS_stack_list = [{}]

" TODO { 
" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

let s:exJS_stack_info = {}
let s:exJS_stack_info.preview = 'current line preview'
let s:exJS_stack_info.file_name = '' " current file name
let s:exJS_stack_info.cursor_pos = [-1,-1] " lnum, col
let s:exJS_stack_info.jump_method = 'GS/TS/GG/TG'
let s:exJS_stack_info.jump_direction = 'from/to'
" let s:exJS_stack_info.tag_name = ''
" let s:exJS_stack_info.tag_idx = -1
" let s:exJS_stack_info.tag_list = []
" } TODO end 

"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" global function defines
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:exJS_PushJumpStack( state_from, state_to ) " <<<
    " if list empty, check the direction
    if !empty (s:exJS_stack_list)
        let cur_stack_info = s:exJS_stack_list[s:exJS_stack_idx]

        " move the cursor position first
        if cur_stack_info.jump_direction ==# 'to'
            let s:exJS_stack_idx -= 1
        endif
    endif

    " clear extra stack infos
    let list_len = len(s:exJS_stack_list)
    if list_len > s:exJS_stack_idx
        call remove(s:exJS_stack_list, s:exJS_stack_idx, list_len-1)
    endif

    "
    silent call add ( s:exJS_stack_list, state_from )
    silent call add ( s:exJS_stack_list, state_to )
    let s:exJS_stack_idx += 2
endfunction " >>>

" DELME: do we have the concept of pop jump stack???? { 
" " ------------------------------------------------------------------ 
" " Desc: 
" " ------------------------------------------------------------------ 

" function g:exJS_PopJumpStack() " <<<
" endfunction " >>>
" } DELME end 

" ======================================================== 
" general function defines
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Open exTagSelect window 
" ------------------------------------------------------------------ 

function s:exJS_OpenWindow( short_title ) " <<<
    if a:short_title != ''
        let s:exJS_short_title = a:short_title
    endif
    let title = '__exJS_' . s:exJS_short_title . 'Window__'
    " open window
    if g:exJS_use_vertical_window
        call exUtility#OpenWindow( title, g:exJS_window_direction, g:exJS_window_width, g:exJS_use_vertical_window, g:exJS_edit_mode, 1, 'g:exJS_Init'.s:exJS_short_title.'Window', 'g:exJS_Update'.s:exJS_short_title.'Window' )
    else
        call exUtility#OpenWindow( title, g:exJS_window_direction, g:exJS_window_height, g:exJS_use_vertical_window, g:exJS_edit_mode, 1, 'g:exJS_Init'.s:exJS_short_title.'Window', 'g:exJS_Update'.s:exJS_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize the window use the increase value
" ------------------------------------------------------------------ 

function s:exJS_ResizeWindow() " <<<
    if g:exJS_use_vertical_window
        call exUtility#ResizeWindow( g:exJS_use_vertical_window, g:exJS_window_width, g:exJS_window_width_increment )
    else
        call exUtility#ResizeWindow( g:exJS_use_vertical_window, g:exJS_window_height, g:exJS_window_height_increment )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Toggle the window
" ------------------------------------------------------------------ 

function s:exJS_ToggleWindow( short_title ) " <<<
    " KEEPME: we don't have two windows, so needn't this { 
    " " if need switch window
    " if a:short_title != ''
    "     if s:exJS_short_title != a:short_title
    "         if bufwinnr('__exJS_' . s:exJS_short_title . 'Window__') != -1
    "             call exUtility#CloseWindow('__exJS_' . s:exJS_short_title . 'Window__')
    "         endif
    "         let s:exJS_short_title = a:short_title
    "     endif
    " endif
    " } KEEPME end 

    " toggle exJS window
    let title = '__exJS_' . s:exJS_short_title . 'Window__'
    if g:exJS_use_vertical_window
        call exUtility#ToggleWindow( title, g:exJS_window_direction, g:exJS_window_width, g:exJS_use_vertical_window, 'none', 0, 'g:exJS_Init'.s:exJS_short_title.'Window', 'g:exJS_Update'.s:exJS_short_title.'Window' )
    else
        call exUtility#ToggleWindow( title, g:exJS_window_direction, g:exJS_window_height, g:exJS_use_vertical_window, 'none', 0, 'g:exJS_Init'.s:exJS_short_title.'Window', 'g:exJS_Update'.s:exJS_short_title.'Window' )
    endif
endfunction " >>>

" ======================================================== 
"  select window functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Init exTagSelect window
" ------------------------------------------------------------------ 

function g:exJS_InitSelectWindow() " <<<
    " DELME { 
    " " syntax match
    " syntax match ex_SynFileName '|\S|'
    " syntax match ex_SynLineNr '(\d\+,\d\+):'
    " syntax region ex_SynSearchPattern start="^--------------------" end="--------------------"
    " syntax match ex_SynTitle '^<<<<<< .* >>>>>>'
    " } DELME end 

    " key map
    " KEEPME { 
    " nnoremap <buffer> <silent> <Return>   \|:call <SID>exJS_GotoSelectResult()<CR>
    " nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exJS_GotoSelectResult()<CR>
    " } KEEPME end 
    nnoremap <buffer> <silent> <Space>   :call <SID>exJS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exJS_ToggleWindow('Select')<CR>

    " autocmd
    " DELME { 
    " au CursorMoved <buffer> :call s:exJS_SelectCursorMoved()
    " } DELME end 
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update window
" ------------------------------------------------------------------ 

function g:exJS_UpdateSelectWindow() " <<<
    " we alwasy clear confirmed highlight, every time we open the browse window
    call exUtility#ClearConfirmHighlight ()

    " TODO: add update codes 
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: call when cursor moved
" ------------------------------------------------------------------ 

" DELME { 
" function s:exJS_SelectCursorMoved()
"     let line_num = line('.')

"     if line_num == s:exJS_cursor_idx
"         call exUtility#HighlightSelectLine()
"         return
"     endif

"     while match(getline('.'), '^|\S| (\d\+,\d\+): .*') == -1
"         if line_num > s:exJS_cursor_idx
"             if line('.') == line('$')
"                 break
"             endif
"             silent exec 'normal! j'
"         else
"             if line('.') == 1
"                 silent exec 'normal! 2j'
"                 let s:exJS_cursor_idx = line_num - 1
"             endif
"             silent exec 'normal! k'
"         endif
"     endwhile

"     let s:exJS_cursor_idx = line('.')
"     call exUtility#HighlightSelectLine()
" endfunction
" } DELME end 

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exJS_GotoSelectResult() " <<<
    "
    let select_line = getline('.')
    if match( select_line, '^|\S| (\d\+,\d\+): .*' ) == -1
        call exUtility#WarningMsg ("invalid selection line")
        return
    endif

    " get file name if exisits
    let idx = matchend( select_line, '^|\S| (\d\+,\d\+): ' )
    let text = strpart ( select_line, idx )
    let filename = fnamemodify(text,":p")

    " get line and column
    let idx_start = match( select_line, '(\d\+,\d\+)' )
    let idx_end = matchend( select_line, '(\d\+,\d\+)' )
    let text = strpart ( select_line, idx_start, idx_end-idx_start )
    let line_col = split(text,',')
    let line = line_col[0][1:] 
    let col = line_col[1][0:len(line_col[1])-2] 

    " highlight selected line.
    let s:exJS_select_idx = line('.')
    call exUtility#HighlightConfirmLine()

    " go back to editbuf jump
    call exUtility#GotoEditBuffer()
    let need_refresh_marks = 0

    if findfile ( filename ) != ''
        silent keepjumps exec 'e '.filename
        let need_refresh_marks = 1
    endif
    silent keepjumps call setpos ( '.', [0,line,col,0] )

    " cause different files have different marks (those lower case marks), so we need to refresh mark browser
    if need_refresh_marks
        call exUtility#GotoPluginBuffer()
        call g:exJS_UpdateSelectWindow ()
    endif

    "
    call exUtility#OperateWindow ( s:exJS_select_title, g:exJS_close_when_selected, g:exJS_backto_editbuf, 1 )
endfunction " >>>


"/////////////////////////////////////////////////////////////////////////////
" Commands
"/////////////////////////////////////////////////////////////////////////////

command ExjsToggle call s:exJS_ToggleWindow('')
nnoremap <unique> <silent> <Leader>vv :ExjsToggle<CR>

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
