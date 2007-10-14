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
let s:exMH_cur_filename = ''

" general
let s:exMH_backto_editbuf = 0
let s:exMH_get_macro_file = 1
let s:exMH_macro_list = []
let s:exMH_define_list = [[],[]] " 0: not define group, 1: define group

" select
let s:exMH_select_idx = 1

" >>>

" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------

" --exMH_OpenWindow--
" Open exMacroHighlight select window 
function! s:exMH_OpenWindow( short_title ) " <<<
    " if s:exMH_cur_filename don't load, we load and do MH init 
    if s:exMH_cur_filename == ''
        if exists('g:exES_Macro')
            call s:exMH_InitMacroList(g:exES_Macro)
        else
            call g:ex_WarningMsg('macro file not found, please create one in vimentry')
            call s:exMH_InitMacroList(s:exMH_select_title)
        endif
    endif

    " if need switch window
    if a:short_title != ''
        if s:exMH_short_title != a:short_title
            let _title = '__exMH_' . s:exMH_short_title . 'Window__'
            if s:exMH_short_title == 'Select'
                let _title = s:exMH_cur_filename
            endif
            if bufwinnr(_title) != -1
                call g:ex_CloseWindow(_title)
            endif
            let s:exMH_short_title = a:short_title
        endif
    endif

    let title = '__exMH_' . s:exMH_short_title . 'Window__'
    " toggle exMH window
    if a:short_title == 'Select'
        let title = s:exMH_cur_filename
    endif
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
    " if s:exMH_cur_filename don't load, we load and do MH init 
    if s:exMH_cur_filename == ''
        if exists('g:exES_Macro')
            call s:exMH_InitMacroList(g:exES_Macro)
        else
            call g:ex_WarningMsg('macro file not found, please create one in vimentry')
            call s:exMH_InitMacroList(s:exMH_select_title)
        endif
    endif

    " if need switch window
    if a:short_title != ''
        if s:exMH_short_title != a:short_title
            let _title = '__exMH_' . s:exMH_short_title . 'Window__'
            if s:exMH_short_title == 'Select'
                let _title = s:exMH_cur_filename
            endif
            if bufwinnr(_title) != -1
                call g:ex_CloseWindow(_title)
            endif
            let s:exMH_short_title = a:short_title
        endif
    endif

    let title = '__exMH_' . s:exMH_short_title . 'Window__'
    " toggle exMH window
    if a:short_title == 'Select'
        let title = s:exMH_cur_filename
    endif
    if g:exMH_use_vertical_window
        call g:ex_ToggleWindow( title, g:exMH_window_direction, g:exMH_window_width, g:exMH_use_vertical_window, 'none', s:exMH_backto_editbuf, 'g:exMH_Init'.s:exMH_short_title.'Window', 'g:exMH_Update'.s:exMH_short_title.'Window' )
    else
        call g:ex_ToggleWindow( title, g:exMH_window_direction, g:exMH_window_height, g:exMH_use_vertical_window, 'none', s:exMH_backto_editbuf, 'g:exMH_Init'.s:exMH_short_title.'Window', 'g:exMH_Update'.s:exMH_short_title.'Window' )
    endif
endfunction " >>>

" --exMH_SwitchWindow--
function! s:exMH_SwitchWindow( short_title ) " <<<
    let title = '__exMH_' . a:short_title . 'Window__'
    if a:short_title == 'Select'
        let title = s:exMH_cur_filename
    endif
    if bufwinnr(title) == -1
        call s:exMH_ToggleWindow(a:short_title)
    endif
endfunction " >>>

" --exMH_InitMacroList--
function! s:exMH_InitMacroList(macrofile_name) " <<<
    let s:exMH_cur_filename = a:macrofile_name
    let line_list = []
    if filereadable(s:exMH_cur_filename) == 1
        let line_list = readfile(s:exMH_cur_filename)
    endif

    " update macro list
    call s:exMH_UpdateMacroList(line_list)

    " define syntax
    call s:exMH_DefineSyntax()

    " highlight link
    " 
    hi def link exCppSkip   exCppOut
    hi def link exCppOut2   exCppOut
    hi def link exCppOut    exMacroDisable

    "
    hi def link exCppNegOut exCppOut
    hi def link exCppNotOut Normal

    " define autocmd for update syntax
    autocmd BufEnter * call s:exMH_UpdateSyntax()
endfunction " >>>

" --exMH_UpdateMacroList--
function! s:exMH_UpdateMacroList(line_list) " <<<
    " clear the macro list and define list first
    if !empty(s:exMH_macro_list)
        call remove(s:exMH_macro_list,0)
    endif
    if !empty(s:exMH_define_list)
        call remove(s:exMH_define_list,0)
    endif

    " init group index and group item index
    let group_idx = -1
    let group_list = []
    
    " loop the line_list
    for line in a:line_list
        " skip empty line
        if line == ''
            continue
        endif

        " skip empty line 2
        if match( line, "\s\+" ) != -1
            continue
        endif

        " get group mark
        if match( line, "^Macro Group:" ) != -1
            let group_idx += 1
            call add( s:exMH_macro_list, group_list ) " add the last group to macro list
            if !empty(group_list)
                call remove(group_list) " clear group list for next group
            endif
            continue
        endif

        " put macro item to the group 
        if match( line, "\t\S.*" ) != -1
            let macro = substitute( line, " ", "", "g" ) " skip whitespace
            call add( group_list, macro )

            let is_define = (macro[0] == '*')
            call add( s:exMH_define_list[is_define], macro )
        endif
    endfor
endfunction " >>>

" --exMH_DefineSyntax--
function! s:exMH_DefineSyntax() " <<<
    "let macro_pattern = ''
    "for macro in s:exMH_macro_list
    "    macro_pattern = macro . '\|'
    "endfor

    " update macro pattern
    let macro_pattern = '\(EX_DEBUG\|EX_WIN32\)'
    let start_pattern = '^\s*\(%:\|#\)\s*\(if\|ifdef\)\s\+' . macro_pattern .'\+\>'

    " update the syntax
    exec 'syn region exCppOut  start=' . '"' . start_pattern . '"' . ' end=".\@=\|$" contains=exCppOut2'
    exec 'syn region exCppOut2 contained start=' . '"' . macro_pattern . '"' . ' end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=exCppSkip'
    exec 'syn region exCppSkip contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=exCppSkip'

    " update negative macro pattern
    let macro_pattern = '\(EX_DEBUG\|EX_WIN32\)'
    let start_pattern = '^\s*\(%:\|#\)\s*\(ifndef\)\s\+' . macro_pattern .'\+\>'

    " update negative the syntax
    exec 'syn cluster exPreProcGroup contains=@cPreProcGroup,exCppOut,exCppOut2,exCppSkip'
    exec 'syn region exCppNotOut matchgroup=cPreProc start=' . '"' . start_pattern . '"' . ' end="^\s*\(%:\|#\)\s*\(endif\>\)" contains=ALLBUT,@exPreProcGroup'
    exec 'syn region exCppNegOut contained start="^\s*\(%:\|#\)\s*\(else\>\|elif\>\)"' .  ' end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" keepend contains=exCppSkip'
endfunction " >>>

" --exMH_UpdateSyntax--
function! s:exMH_UpdateSyntax() " <<<
    " make syntax cluster for easy clear
    syntax clear exCppOut exCppOut2 exCppSkip exCppNotOut exCppNegOut
    silent call s:exMH_DefineSyntax() 
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
    au BufWrite <buffer> call s:exMH_UpdateMacroList(getline(1,'$'))
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
