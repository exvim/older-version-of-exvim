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
let s:exJS_jump_stack_title = '---------- Jump Stack ----------'

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

let s:exJS_need_update_select_window = 1

" ------------------------------------------------------------------ 
" Desc: variables
" ------------------------------------------------------------------ 

let s:exJS_cursor_idx = 0
let s:exJS_stack_idx = -1

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

let s:exJS_stack_list = []
let s:exJS_entry_list = []

" KEEPME: keys in stack info { 
" " ------------------------------------------------------------------ 
" " Desc: 
" " ------------------------------------------------------------------ 

" let s:exJS_stack_info = {}
" let s:exJS_stack_info.preview = 'current line preview'
" let s:exJS_stack_info.file_name = '' " current file name
" let s:exJS_stack_info.cursor_pos = [-1,-1] " lnum, col
" let s:exJS_stack_info.jump_method = 'GS/TS/GG/TG' SG???
" let s:exJS_stack_info.keyword = ''
" let s:exJS_stack_info.taglist = []
" let s:exJS_stack_info.tagidx = 1
" } KEEPME end 

"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" global function defines
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: exJS_PushJumpStack
" ------------------------------------------------------------------ 

function g:exJS_PushJumpStack( state ) " <<<
    " truncate stack first
    call s:exJS_TruncateStack ()

    " push all items in the entry list.
    for item in s:exJS_entry_list
        silent call add ( s:exJS_stack_list, item )
        let s:exJS_stack_idx += 1
    endfor

    " clear entry list
    if !empty(s:exJS_entry_list)
        silent call remove ( s:exJS_entry_list, 0, len(s:exJS_entry_list)-1 )
    endif

    " push jump to state.
    silent call add ( s:exJS_stack_list, a:state )
    let s:exJS_stack_idx += 1

    " set need update 
    let s:exJS_need_update_select_window = 1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:exJS_SetLastJumpStack( state ) " <<<
    " truncate stack first
    call s:exJS_TruncateStack ()

    "
    let s:exJS_stack_list[len(s:exJS_stack_list)-1] = a:state

    " set need update 
    let s:exJS_need_update_select_window = 1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: exJS_PushEntryState
" ------------------------------------------------------------------ 

function g:exJS_PushEntryState ( state ) " <<<
    " truncate stack first
    call s:exJS_TruncateStack ()

    " check if we start a new entry list
    " if the file_name is empty, that means we are in ex_plugin window. ( at least I require programmer to check and set the state ).
    if a:state.file_name != ''
        " clear entry list
        if !empty(s:exJS_entry_list)
            silent call remove ( s:exJS_entry_list, 0, len(s:exJS_entry_list)-1 )
        endif
    endif

    " if we use tg, confirm, and ts, in the select window tg again, we don't create new jump entry
    if a:state.file_name == '' && empty(s:exJS_entry_list)  
        call g:exJS_SetLastJumpStack (a:state)
    else
        " push the state to the entry list 
        silent call add ( s:exJS_entry_list, a:state )
    endif

    " set need update 
    let s:exJS_need_update_select_window = 1
endfunction " >>>

" ======================================================== 
" general function defines
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: exJS_PushJumpStack
" ------------------------------------------------------------------ 

function s:exJS_TruncateStack() " <<<
    " if list empty, check the direction
    if !empty (s:exJS_stack_list)
        "
        let cur_stack_info = s:exJS_stack_list[s:exJS_stack_idx]
        let list_len = len(s:exJS_stack_list)
        let trunctaeIdx = s:exJS_stack_idx 

        " if this is 'to' stack
        if cur_stack_info.jump_method == '' && cur_stack_info.file_name != ''
            let trunctaeIdx += 1
        endif

        " clear extra stack infos
        if trunctaeIdx < list_len-1 
            silent call remove(s:exJS_stack_list, trunctaeIdx, list_len-1)
            let s:exJS_stack_idx = len(s:exJS_stack_list)-1
        endif
    endif
endfunction " >>>

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
    " TODO { 
    syntax region ex_SynSearchPattern start="^----------" end="----------"
    syntax region ex_SynJumpMethodS start="\[\C\(GS\|TS\)\]" end=":" keepend contains=ex_SynKeyWord
    syntax region ex_SynJumpMethodG start="\[\C\(GG\|TG\)\]" end=":" keepend contains=ex_SynKeyWord
    syntax match ex_SynKeyWord contained '\[\C\(GS\|TS\|GG\|TG\)\]\zs\S\+'
    syntax match ex_SynJumpSymbol '^ =>'
    " syntax region ex_SynDisable start='^ |-' end="$" contains=ex_SynJumpMethodS,ex_SynJumpMethodG
    syntax region ex_SynDisable start='^ |-' end="$"
    syntax match exPJ_TreeLine '^ |='
    hi link ex_SynKeyWord Preproc
    hi ex_SynDisable term=none cterm=none ctermfg=DarkGray gui=none guifg=DarkGray
    " } TODO end 

    " key map
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exJS_ToggleWindow('Select')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exJS_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exJS_GotoSelectResult()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exJS_GotoSelectResult()<CR>

    " autocmd
    au CursorMoved <buffer> :call s:exJS_SelectCursorMoved()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update window
" ------------------------------------------------------------------ 

function g:exJS_UpdateSelectWindow() " <<<
    " if need update stack window 
    if s:exJS_need_update_select_window
        let s:exJS_need_update_select_window = 0
        call s:exJS_ShowStackList()
    endif

    " go to current stack
    let start_line = search(s:exJS_jump_stack_title, 'nw') + 1
    let stack_line_idx = s:exJS_stack_idx + start_line 
    silent call cursor ( stack_line_idx, 0 )
    call exUtility#HighlightConfirmLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exJS_ShowStackList() " <<<
    " get stack info
    let new_entry = 1
    let line_list = []
    for stack_info in s:exJS_stack_list
        let line = ''

        " if not new entry, add |- for the line.
        if new_entry == 1 
            let new_entry = 0 
            let line = ' => '
            silent call add ( line_list, line )
        endif

        " add preview section
        let line_list[len(line_list)-1] .= stack_info.preview 

        " add jump method line if we have 
        if stack_info.jump_method ==# ''
            let new_entry = 1 
            let line_list[len(line_list)-1] = substitute( line_list[len(line_list)-1], '|-', '|=', "" )
        else
            let line = ' |-' . '[' . stack_info.jump_method . ']' . stack_info.keyword . ': '
            silent call add ( line_list, line )
        endif
    endfor

    " clear screen and put the new context
    silent exec '1,$d _'
    silent call append( line('$'), s:exJS_jump_stack_title )
    silent call append( line('$'), line_list )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: call when cursor moved
" ------------------------------------------------------------------ 

function s:exJS_SelectCursorMoved()
    let line_num = line('.')

    if line_num == s:exJS_cursor_idx
        call exUtility#HighlightSelectLine()
        return
    endif

    while match(getline('.'), '^ \(=>\||=\)') == -1
        if line_num > s:exJS_cursor_idx
            if line('.') == line('$')
                break
            endif
            silent exec 'normal! j'
        else
            if line('.') == 1
                silent exec 'normal! 2j'
                let s:exJS_cursor_idx = line_num - 1
            endif
            silent exec 'normal! k'
        endif
    endwhile

    let s:exJS_cursor_idx = line('.')
    call exUtility#HighlightSelectLine()
endfunction

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exJS_GotoSelectResult() " <<<
    " calculate index
    let start_line = search(s:exJS_jump_stack_title, 'nw') + 1
    let cur_line = line('.')
    let idx = cur_line - start_line  
    if idx < 0
        call exUtility#WarningMsg("Can't jump in this line")
        return
    endif

    " jump to the select result
    call s:exJS_GotoStackByIndex (idx)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exJS_GotoStackByIndex( index ) " <<<
    if a:index < 0 
        call exUtility#WarningMsg ( "at the bottom of the stack" )
        return
    elseif a:index > (len(s:exJS_stack_list)-1)
        call exUtility#WarningMsg ( "at the top of the stack" )
        return
    endif

    " check if the index store the jump info
    if s:exJS_stack_list[a:index].file_name == ''
        call exUtility#WarningMsg("Can't jump in this line")
        return
    endif

    "
    let s:exJS_stack_idx = a:index
    call exUtility#HighlightConfirmLine()

    " open and go to stack window first
    let background_op = 0
    if bufwinnr(s:exJS_select_title) == -1
        call s:exJS_ToggleWindow('Stack')
        let background_op = 1
    else
        call g:exJS_UpdateSelectWindow ()
    endif

    " process the jump
    call exUtility#GotoEditBuffer()
    silent exec 'e ' . s:exJS_stack_list[a:index].file_name
    silent call cursor(s:exJS_stack_list[a:index].cursor_pos)

    " if we have taglist, set it
    let idx = a:index
    while empty(s:exJS_stack_list[idx].taglist) && idx > 0
        let idx -= 1
    endwhile
    if !empty(s:exJS_stack_list[idx].taglist)
        call g:exTS_ResetTaglist ( 
                    \ s:exJS_stack_list[idx].taglist,
                    \ s:exJS_stack_list[idx].keyword,
                    \ s:exJS_stack_list[idx].tagidx )
    endif

    " general window operation 
    call exUtility#OperateWindow ( s:exJS_select_title, g:exJS_close_when_selected || background_op, g:exJS_backto_editbuf, 1 )
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" Commands
"/////////////////////////////////////////////////////////////////////////////

command ExjsToggle call s:exJS_ToggleWindow('')
command BackwardStack call s:exJS_GotoStackByIndex(s:exJS_stack_idx-1)
command ForwardStack call s:exJS_GotoStackByIndex(s:exJS_stack_idx+1)

nnoremap <unique> <silent> <Leader>tt :ExjsToggle<CR>
nnoremap <unique> <silent> <Leader>tb :BackwardStack<CR>
nnoremap <unique> <silent> <Leader>tf :ForwardStack<CR>

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
