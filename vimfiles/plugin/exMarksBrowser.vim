" ======================================================================================
" File         : exMarksBrowser.vim
" Author       : Wu Jie 
" Last Change  : 04/12/2009 | 00:52:33 AM | Sunday,April
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_exmarksbrowser') || &cp
    finish
endif
let loaded_exmarksbrowser=1

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

if !exists('g:exMB_window_height')
    let g:exMB_window_height = 20
endif

" ------------------------------------------------------------------ 
" Desc: window width for vertical window mode
" ------------------------------------------------------------------ 

if !exists('g:exMB_window_width')
    let g:exMB_window_width = 30
endif

" ------------------------------------------------------------------ 
" Desc: window height increment value
" ------------------------------------------------------------------ 

if !exists('g:exMB_window_height_increment')
    let g:exMB_window_height_increment = 30
endif

" ------------------------------------------------------------------ 
" Desc: window width increment value
" ------------------------------------------------------------------ 

if !exists('g:exMB_window_width_increment')
    let g:exMB_window_width_increment = 50
endif

" ------------------------------------------------------------------ 
" Desc: placement of the window
" 'topleft','botright'
" ------------------------------------------------------------------ 

if !exists('g:exMB_window_direction')
    let g:exMB_window_direction = 'belowright'
endif

" ------------------------------------------------------------------ 
" Desc: use vertical or not
" ------------------------------------------------------------------ 

if !exists('g:exMB_use_vertical_window')
    let g:exMB_use_vertical_window = 0
endif

" ------------------------------------------------------------------ 
" Desc: go back to edit buffer
" ------------------------------------------------------------------ 

if !exists('g:exMB_backto_editbuf')
    let g:exMB_backto_editbuf = 0
endif

" ------------------------------------------------------------------ 
" Desc: go and close exTagSelect window
" ------------------------------------------------------------------ 

if !exists('g:exMB_close_when_selected')
    let g:exMB_close_when_selected = 0
endif

" ------------------------------------------------------------------ 
" Desc: set edit mode
" 'none', 'append', 'replace'
" ------------------------------------------------------------------ 

if !exists('g:exMB_edit_mode')
    let g:exMB_edit_mode = 'replace'
endif

" ======================================================== 
" local variable initialization
" ======================================================== 


" ------------------------------------------------------------------ 
" Desc: title
" ------------------------------------------------------------------ 

let s:exMB_select_title = "__exMB_SelectWindow__"
let s:exMB_short_title = 'Select'

" ------------------------------------------------------------------ 
" Desc: variables
" ------------------------------------------------------------------ 

let s:exMB_select_idx = 1
let s:exMB_cursor_idx = 1

" TODO: custumize what marks to show
let s:exMB_all_marks = "abcdefghijklmnopqrstuvwxyz.'`^<>\""
"let s:exMB_all_marks = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.'`^<>\""

"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" general function defines
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Open exTagSelect window 
" ------------------------------------------------------------------ 

function s:exMB_OpenWindow( short_title ) " <<<
    if a:short_title != ''
        let s:exMB_short_title = a:short_title
    endif
    let title = '__exMB_' . s:exMB_short_title . 'Window__'
    " open window
    if g:exMB_use_vertical_window
        call exUtility#OpenWindow( title, g:exMB_window_direction, g:exMB_window_width, g:exMB_use_vertical_window, g:exMB_edit_mode, 1, 'g:exMB_Init'.s:exMB_short_title.'Window', 'g:exMB_Update'.s:exMB_short_title.'Window' )
    else
        call exUtility#OpenWindow( title, g:exMB_window_direction, g:exMB_window_height, g:exMB_use_vertical_window, g:exMB_edit_mode, 1, 'g:exMB_Init'.s:exMB_short_title.'Window', 'g:exMB_Update'.s:exMB_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize the window use the increase value
" ------------------------------------------------------------------ 

function s:exMB_ResizeWindow() " <<<
    if g:exMB_use_vertical_window
        call exUtility#ResizeWindow( g:exMB_use_vertical_window, g:exMB_window_width, g:exMB_window_width_increment )
    else
        call exUtility#ResizeWindow( g:exMB_use_vertical_window, g:exMB_window_height, g:exMB_window_height_increment )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Toggle the window
" ------------------------------------------------------------------ 

function s:exMB_ToggleWindow( short_title ) " <<<
    " KEEPME: we don't have two windows, so needn't this { 
    " " if need switch window
    " if a:short_title != ''
    "     if s:exMB_short_title != a:short_title
    "         if bufwinnr('__exMB_' . s:exMB_short_title . 'Window__') != -1
    "             call exUtility#CloseWindow('__exMB_' . s:exMB_short_title . 'Window__')
    "         endif
    "         let s:exMB_short_title = a:short_title
    "     endif
    " endif
    " } KEEPME end 

    " toggle exMB window
    let title = '__exMB_' . s:exMB_short_title . 'Window__'
    if g:exMB_use_vertical_window
        call exUtility#ToggleWindow( title, g:exMB_window_direction, g:exMB_window_width, g:exMB_use_vertical_window, 'none', 0, 'g:exMB_Init'.s:exMB_short_title.'Window', 'g:exMB_Update'.s:exMB_short_title.'Window' )
    else
        call exUtility#ToggleWindow( title, g:exMB_window_direction, g:exMB_window_height, g:exMB_use_vertical_window, 'none', 0, 'g:exMB_Init'.s:exMB_short_title.'Window', 'g:exMB_Update'.s:exMB_short_title.'Window' )
    endif
endfunction " >>>

" ======================================================== 
"  select window functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Init exTagSelect window
" ------------------------------------------------------------------ 

function g:exMB_InitSelectWindow() " <<<
    " syntax match
    syntax match ex_SynFileName '|\S|'
    syntax match ex_SynLineNr '(\d\+,\d\+):'
    syntax region ex_SynSearchPattern start="^--------------------" end="--------------------"
    syntax match ex_SynTitle '^<<<<<< .* >>>>>>'

    " key map
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exMB_ToggleWindow('Select')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exMB_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exMB_GotoSelectResult()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exMB_GotoSelectResult()<CR>

    " dummy mapping
    nnoremap <buffer> <silent> <C-Left>   :call exUtility#WarningMsg("only select window")<CR>
    nnoremap <buffer> <silent> <C-Right>   :call exUtility#WarningMsg("only select window")<CR>

    " autocmd
    au CursorMoved <buffer> :call s:exMB_SelectCursorMoved()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update window
" ------------------------------------------------------------------ 

function g:exMB_UpdateSelectWindow() " <<<
    " we alwasy clear confirmed highlight, every time we open the browse window
    call exUtility#ClearConfirmHighlight ()

    let results = s:exMB_FetchMarks()
    call sort( results, "s:exMB_SortMarks" )
    call s:exMB_Fill( results )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: call when cursor moved
" ------------------------------------------------------------------ 

function s:exMB_SelectCursorMoved() " <<<
    let line_num = line('.')

    if line_num == s:exMB_cursor_idx
        call exUtility#HighlightSelectLine()
        return
    endif

    while match(getline('.'), '^|\S| (\d\+,\d\+): .*') == -1
        if line_num > s:exMB_cursor_idx
            if line('.') == line('$')
                break
            endif
            silent exec 'normal! j'
        else
            if line('.') == 1
                silent exec 'normal! 2j'
                let s:exMB_cursor_idx = line_num - 1
            endif
            silent exec 'normal! k'
        endif
    endwhile

    let s:exMB_cursor_idx = line('.')
    call exUtility#HighlightSelectLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exMB_GotoSelectResult() " <<<
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
    let s:exMB_select_idx = line('.')
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
        call g:exMB_UpdateSelectWindow ()
    endif

    "
    call exUtility#OperateWindow ( s:exMB_select_title, g:exMB_close_when_selected, g:exMB_backto_editbuf, 1 )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exMB_FetchMarks() " <<<
    " EXAMPLE: :marks command example { 
    " mark line  col file/text
    "  '    432    0 -invalid-
    "  a    297   46 elseif did_buf_marks_sep == 0 && item[2] =~# '[a-z]'  
    "  0    124   15 D:\exdev\vim\vimfiles\plugin\marksbrowser.vim
    "  1   1648    1 D:\Project\Engine\nomad\main\code\Core\purs\Examples\LZOCompression\LZO_UnComp\MiniLZO\minilzo.c
    "  2     18    0 D:\Project\Dev\exUtility\src\exLibs\exLibs.vimentry
    "  3    369    4 D:\Project\Dev\exUtility\src\exLibs\exLibs\Container\BitArray.h
    "  4     24    0 D:\Project\Dev\exUtility\src\exLibs\.vimfiles\symbol
    "  5      1    0 D:\Project\Dev\exUtility\src\exLibs\.vimfiles\exLibs.exproject
    "  6    156    4 D:\Project\Dev\exUtility\src\exLibs\exLibs\Container\HashMapPool.h
    "  7     17    0 D:\Project\Dev\exUtility\src\exLibs\exLibs.vimentry
    "  8     15    0 D:\Project\Dev\exUtility\src\exLibs\exLibs.vimentry
    "  9     72    0 D:\Project\Dev\exUtility\src\exLibs\exLibs\GF\Debug.cpp
    "  "    258    4 silent redir END
    "  [      1    0 " ======================================================================================
    "  ]    330    0 " vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
    "  ^    256   29 silent redir =>marks_list
    "  .    256    0 silent redir =>marks_list
    "  <    256    8 silent redir =>marks_list
    "  >    256    8 silent redir =>marks_list
    " } EXAMPLE end 

    call exUtility#GotoEditBuffer()
    silent redir =>marks_text
    silent! exec 'marks'
    silent redir END
    call exUtility#GotoPluginBuffer()

    let marks_list = split (marks_text,'\n')
    let result_list = []
    for item in marks_list[1:]
        let raw_string = item 
        let mark_info = {}

        " get mark name
        let string = raw_string 
        let idx_start = match ( string, '\S' )
        let string = strpart ( string, idx_start )
        let idx_end = match ( string, '\s' )
        let mark_info.name = strpart ( raw_string, idx_start, idx_end )
        let raw_string = strpart ( string, idx_end ) 

        " get mark line
        let string = raw_string
        let idx_start = match ( string, '\S' )
        let string = strpart ( string, idx_start )
        let idx_end = match ( string, '\s' )
        let mark_info.line = strpart ( raw_string, idx_start, idx_end )
        let raw_string = strpart ( string, idx_end ) 

        " get mark col
        let string = raw_string
        let idx_start = match ( string, '\S' )
        let string = strpart ( string, idx_start )
        let idx_end = match ( string, '\s' )
        let mark_info.col = strpart ( raw_string, idx_start, idx_end )
        let raw_string = strpart ( string, idx_end ) 

        " get mark text/file
        let string = raw_string
        let idx_start = match ( string, '\S' )
        let string = strpart ( string, idx_start )
        let mark_info.text = strpart ( raw_string, idx_start )

        "
        silent call add ( result_list, mark_info )
    endfor

    return result_list
endfunction " >>>


" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exMB_SortMarks( i1, i2 ) " <<<
    let name1 = a:i1.name
    let name2 = a:i2.name

    " lowercase:0, uppercase:1, special:2, digital:3 
    " init as special
    let type_order1 = 2 
    let type_order2 = 2 

    " get order1
    if name1 =~# '[a-z]'
        let type_order1 = 0
    elseif name1 =~# '[A-Z]'
        let type_order1 = 1
    elseif name1 =~# '[0-9]'
        let type_order1 = 3
    endif

    " get order2
    if name2 =~# '[a-z]'
        let type_order2 = 0
    elseif name2 =~# '[A-Z]'
        let type_order2 = 1
    elseif name2 =~# '[0-9]'
        let type_order2 = 3
    endif

    if type_order1 !=# type_order2
        return type_order1 ==# type_order2 ? 0 : type_order1 ># type_order2 ? 1 : -1
    else
        return name1 ==# name2 ? 0 : name1 ># name2 ? 1 : -1
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exMB_Fill( results ) " <<<
    silent! setlocal modifiable

    " clear window
    silent exec '1,$d _'

    " put header
    put = '<<<<<< \|mark\| (line,col): file/text >>>>>>'
    let did_special_sep = 0
    let did_digital_sep = 0
    let did_lowercase_sep = 0
    let did_uppercase_sep = 0

    let save_pos = getpos('.')

    "
    for item in a:results
        if did_special_sep == 0 && item.name !~# '[0-9a-zA-Z]'  
            let did_special_sep = 1
            silent put =''
            silent put ='-------------------- special marks --------------------'
        elseif did_lowercase_sep == 0 && item.name =~# '[a-z]'  
            let did_lowercase_sep = 1
            silent put =''
            silent put ='-------------------- lowercase marks --------------------'
        elseif did_uppercase_sep == 0 && item.name =~# '[A-Z]'  
            let did_uppercase_sep = 1
            silent put =''
            silent put ='-------------------- uppercase marks --------------------'
        elseif did_digital_sep == 0 && item.name =~# '[0-9]'  
            let did_digital_sep = 1
            silent put =''
            silent put ='-------------------- number marks --------------------'
        endif

        "
        silent put = '\|'.item.name.'\| '.'('.item.line.','.item.col.'): '.item.text
    endfor

    silent call setpos('.', save_pos)
    silent! setlocal nomodifiable
endf


"/////////////////////////////////////////////////////////////////////////////
" Commands
"/////////////////////////////////////////////////////////////////////////////

command ExmbToggle call s:exMB_ToggleWindow('')

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
