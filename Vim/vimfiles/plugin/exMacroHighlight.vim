"=============================================================================
" File:        exMacroHighlight.vim
" Author:      Wu Jie
" Last Change: 2007-10-12
" Version:     1.0
"  
" Copyright (c) 2006, Wu Jie
" All rights reserved.
"=============================================================================
"

if exists('loaded_exmacrohighlight') || &cp
    finish
endif
let loaded_exmacrohighlight=1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------

" Initialization <<<

" -------------------------------
" gloable varialbe initialization
" -------------------------------

" window height for horizon window mode
if !exists('g:exMH_window_height')
    let g:exMH_window_height = 20
endif

" window width for vertical window mode
if !exists('g:exMH_window_width')
    let g:exMH_window_width = 30
endif

" window height increment value
if !exists('g:exMH_window_height_increment')
    let g:exMH_window_height_increment = 30
endif

" window width increment value
if !exists('g:exMH_window_width_increment')
    let g:exMH_window_width_increment = 100
endif

" go back to edit buffer
" 'topleft','botright'
if !exists('g:exMH_window_direction')
    let g:exMH_window_direction = 'botright'
endif

" use vertical or not
if !exists('g:exMH_use_vertical_window')
    let g:exMH_use_vertical_window = 1
endif

" set edit mode
" 'none', 'append', 'replace'
if !exists('g:exMH_edit_mode')
    let g:exMH_edit_mode = 'replace'
endif

" set tag select command
if !exists('g:exMH_SymbolSelectCmd')
    let g:exMH_SymbolSelectCmd = 'ts'
endif

" -------------------------------
" local variable initialization
" -------------------------------
" title
let s:exMH_select_title = "__exMH_SelectWindow__"
let s:exMH_short_title = 'Select'

" general
let s:exMH_backto_editbuf = 0
let s:exMH_get_macro_file = 1

" select
let s:exMH_select_idx = 1

" >>>

" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------

" --exMH_OpenWindow--
" Open exMacroHighlight select window 
function! s:exMH_OpenWindow( short_title ) " <<<
    if a:short_title != ''
        let s:exMH_short_title = a:short_title
    endif
    let title = '__exMH_' . s:exMH_short_title . 'Window__'
    " open window
    if g:exMH_use_vertical_window
        call g:ex_OpenWindow( title, g:exMH_window_direction, g:exMH_window_width, g:exMH_use_vertical_window, g:exMH_edit_mode, s:exMH_backto_editbuf, 'g:exMH_Init'.s:exMH_short_title.'Window', 'g:exMH_Update'.s:exMH_short_title.'Window' )
    else
        call g:ex_OpenWindow( title, g:exMH_window_direction, g:exMH_window_height, g:exMH_use_vertical_window, g:exMH_edit_mode, s:exMH_backto_editbuf, 'g:exMH_Init'.s:exMH_short_title.'Window', 'g:exMH_Update'.s:exMH_short_title.'Window' )
    endif
endfunction " >>>

" --exMH_ResizeWindow--
" Resize the window use the increase value
function! s:exMH_ResizeWindow() " <<<
    if g:exMH_use_vertical_window
        call g:ex_ResizeWindow( g:exMH_use_vertical_window, g:exMH_window_width, g:exMH_window_width_increment )
    else
        call g:ex_ResizeWindow( g:exMH_use_vertical_window, g:exMH_window_height, g:exMH_window_height_increment )
    endif
endfunction " >>>

" --exMH_ToggleWindow--
" Toggle the window
function! s:exMH_ToggleWindow( short_title ) " <<<
    " read the file first
    if s:exMH_get_macro_file
        let s:exMH_get_macro_file = 0
        if exists('g:exES_Macro')
            let s:exMH_select_title = g:exES_Macro
        else
            call g:ex_WarningMsg('not found macro highlight file')
        endif
    endif

    " assignment the title
    if s:exMH_short_title == 'Select'
        let s:exMH_cur_title = s:exMH_select_title
    " elseif s:exMH_short_title == 'QuickView'
    "     let s:exMH_cur_title = s:exMH_quick_view_title
    endif

    " if need switch window
    if a:short_title != ''
        if s:exMH_short_title != a:short_title
            if bufwinnr('__exMH_' . s:exMH_short_title . 'Window__') != -1
                call g:ex_CloseWindow('__exMH_' . s:exMH_short_title . 'Window__')
            endif
            let s:exMH_short_title = a:short_title
        endif
    endif

    " toggle exMH window
    let title = '__exMH_' . s:exMH_short_title . 'Window__'
    if g:exMH_use_vertical_window
        call g:ex_ToggleWindow( title, g:exMH_window_direction, g:exMH_window_width, g:exMH_use_vertical_window, 'none', s:exMH_backto_editbuf, 'g:exMH_Init'.s:exMH_short_title.'Window', 'g:exMH_Update'.s:exMH_short_title.'Window' )
    else
        call g:ex_ToggleWindow( title, g:exMH_window_direction, g:exMH_window_height, g:exMH_use_vertical_window, 'none', s:exMH_backto_editbuf, 'g:exMH_Init'.s:exMH_short_title.'Window', 'g:exMH_Update'.s:exMH_short_title.'Window' )
    endif
endfunction " >>>

" --exMH_SwitchWindow
function! s:exMH_SwitchWindow( short_title ) " <<<
    let title = '__exMH_' . a:short_title . 'Window__'
    if bufwinnr(title) == -1
        call s:exMH_ToggleWindow(a:short_title)
    endif
endfunction " >>>

" ------------------------------
"  select window part
" ------------------------------

" --exMH_InitSelectWindow--
" Init exSymbolList window
function! g:exMH_InitSelectWindow() " <<<
    " set buffer no modifiable
    silent! setlocal nonumber
    " this will help Update symbol relate with it.
    silent! setlocal buftype=
    
    " key map
    nnoremap <buffer> <silent> <Space>   :call <SID>exMH_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exMH_ToggleWindow('Select')<CR>

    "nnoremap <buffer> <silent> <Return>   \|:call <SID>exMH_ShowPickedResult(getline('.'), 0)<CR>
    "nnoremap <buffer> <silent> <C-Return> :call <SID>exMH_GotoResultInSelectWindow()<CR>
    "nnoremap <buffer> <silent> <C-Left>   :call <SID>exMH_SwitchWindow('QuickView')<CR>
    "nnoremap <buffer> <silent> <C-Right>   :call <SID>exMH_SwitchWindow('Select')<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" --exMH_UpdateSelectWindow--
" Update exMacroHighlight window
function! g:exMH_UpdateSelectWindow() " <<<
    call cursor( s:exMH_select_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" -------------------------------------------------------------------------
" Command part
" -------------------------------------------------------------------------
command ExmhSelectToggle call s:exMH_ToggleWindow('Select')
command ExmhToggle call s:exMH_ToggleWindow('')

finish
" vim600: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
