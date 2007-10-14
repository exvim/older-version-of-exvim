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
let s:exMH_IsEnable = 0

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
            call g:exMH_InitMacroList(g:exES_Macro)
        else
            call g:ex_WarningMsg('macro file not found, please create one in vimentry')
            call g:exMH_InitMacroList(s:exMH_select_title)
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
            call g:exMH_InitMacroList(g:exES_Macro)
        else
            call g:ex_WarningMsg('macro file not found, please create one in vimentry')
            call g:exMH_InitMacroList(s:exMH_select_title)
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
function! g:exMH_InitMacroList(macrofile_name) " <<<
    " init file name and read the file into line_list
    let s:exMH_cur_filename = a:macrofile_name
    let line_list = []
    if filereadable(s:exMH_cur_filename) == 1
        let line_list = readfile(s:exMH_cur_filename)
        let s:exMH_IsEnable = 1
    endif

    " update macro list
    call s:exMH_UpdateMacroList(line_list)

    " define syntax
    call s:exMH_DefineSyntax()

    " highlight link
    hi def link exCppSkip   exCppOut
    hi def link exCppOut2   exCppOut
    hi def link exCppOut    exMacroDisable
    hi def link exCppNegOut exCppOut
    hi def link exCppNotOut Normal

    " define autocmd for update syntax
    autocmd BufEnter * call s:exMH_UpdateSyntax()
endfunction " >>>

" --exMH_UpdateMacroList--
function! s:exMH_UpdateMacroList(line_list) " <<<
    " clear the macro list and define list first
    if !empty(s:exMH_macro_list)
        call remove(s:exMH_macro_list,0,-1)
    endif
    if !empty(s:exMH_define_list)
        call remove(s:exMH_define_list,0,-1)
    endif
    let s:exMH_macro_list = []
    let s:exMH_define_list = [[],[]]

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
        if line =~# ":"
            let group_idx += 1
            call add( s:exMH_macro_list, group_list ) " add the last group to macro list
            if !empty(group_list)
                call remove(group_list,0,-1) " clear group list for next group
            endif
            continue
        endif

        " put macro item to the group 
        if match( line, '   .\S.*' ) != -1
            let macro = substitute( line, " ", "", "g" ) " skip whitespace
            call add( group_list, macro )

            let is_define = (macro =~# '\*')
            call add( s:exMH_define_list[is_define], strpart(macro,1) )
        endif
    endfor
endfunction " >>>

" --exMH_DefineSyntax--
function! s:exMH_DefineSyntax() " <<<
    " update def macro pattern
    if len(s:exMH_define_list[1]) != 0
        let def_macro_pattern = '\('
        for def_macro in s:exMH_define_list[1]
            let def_macro_pattern = def_macro_pattern . def_macro . '\|'
        endfor
        let def_macro_pattern = strpart( def_macro_pattern, 0, strlen(def_macro_pattern)-2 ) . '\)'
    else
        let def_macro_pattern = '__EXMH_NO_DEF_MACRO__'
    endif

    " update ndef macro pattern
    if len(s:exMH_define_list[0]) != 0
        let undef_macro_pattern = '\('
        for undef_macro in s:exMH_define_list[0]
            let undef_macro_pattern = undef_macro_pattern . undef_macro . '\|'
        endfor
        let undef_macro_pattern = strpart( undef_macro_pattern, 0, strlen(undef_macro_pattern)-2 ) . '\)'
    else
        let undef_macro_pattern = '__EXMH_NO_NDEF_MACRO__'
    endif

    " update start pattern
    let def_start_pattern = '^\s*\(%:\|#\)\s*\(if\|ifdef\)\s\+' . def_macro_pattern .'\+\>'
    let undef_start_pattern = '^\s*\(%:\|#\)\s*\(ifndef\)\s\+' . undef_macro_pattern .'\+\>'

    " update def the syntax
    exec 'syn region exCppOut  start=' . '"' . def_start_pattern . '"' . ' end=".\@=\|$" contains=exCppOut2'
    exec 'syn region exCppOut2 contained start=' . '"' . def_macro_pattern . '"' . ' end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=exCppSkip'
    exec 'syn region exCppSkip contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=exCppSkip'

    " update undef the syntax
    exec 'syn cluster exPreProcGroup contains=@cPreProcGroup,exCppOut,exCppOut2,exCppSkip'
    exec 'syn region exCppNotOut matchgroup=cPreProc start=' . '"' . undef_start_pattern . '"' . ' end="^\s*\(%:\|#\)\s*\(endif\>\)" contains=ALLBUT,@exPreProcGroup'
    exec 'syn region exCppNegOut contained start="^\s*\(%:\|#\)\s*\(else\>\|elif\>\)"' .  ' end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" keepend contains=exCppSkip'
endfunction " >>>

" --exMH_UpdateSyntax--
function! s:exMH_UpdateSyntax() " <<<
    " clear syntax group for re-define
    syntax clear exCppOut exCppOut2 exCppSkip exCppNotOut exCppNegOut

    " if enable syntax
    if s:exMH_IsEnable == 1
        " re-define syntax
        silent call s:exMH_DefineSyntax() 
    endif
endfunction " >>>

" --GetMHIndent--
function GetMHIndent() " <<<
    let cur_line = getline(v:lnum)
    " indent group
    if cur_line =~# ":"
        return 0
    endif
    return 4
endfunction " >>>

" --GetMHIndent--
function s:exMH_SyntaxHL(b_enable) " <<<
    let s:exMH_IsEnable = a:b_enable
    if s:exMH_IsEnable == 1
        echomsg "Macro Higlight: ON "
    else
        echomsg "Macro Higlight: OFF "
    endif
    call s:exMH_UpdateSyntax()
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
    nnoremap <buffer> <silent> <Return>   :call <SID>exMH_SelectConfirm()<CR>

    "nnoremap <buffer> <silent> <C-Return> :call <SID>exMH_GotoResultInSelectWindow()<CR>
    "nnoremap <buffer> <silent> <C-Left>   :call <SID>exMH_SwitchWindow('QuickView')<CR>
    "nnoremap <buffer> <silent> <C-Right>   :call <SID>exMH_SwitchWindow('Select')<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
    au BufWrite <buffer> call s:exMH_UpdateMacroList(getline(1,'$'))

    " set indent
    silent! setlocal cindent
    silent! setlocal indentexpr=GetMHIndent() " Set the function to do the work.
    silent! setlocal indentkeys-=: " To make a colon (:) suggest an indentation other than a goto/swich label,
    silent! setlocal indentkeys+=<:> 

    " syntax highlight
    syntax match exMH_GroupName '^.*:'
    syntax match exMH_MacroEnable '^...\zs\*\S\+$'
    syntax match exMH_MacroDisable '^....\zs\S\+$'

    highlight def exMH_GroupName term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray gui=bold guifg=DarkRed guibg=LightGray
    highlight def exMH_MacroEnable term=none cterm=none ctermfg=DarkMagenta gui=none guifg=Purple
    highlight def exMH_MacroDisable term=none cterm=none ctermfg=DarkGray gui=none guifg=DarkGray 
endfunction " >>>

" --exMH_UpdateSelectWindow--
" Update exMacroHighlight window
function! g:exMH_UpdateSelectWindow() " <<<
    call cursor( s:exMH_select_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exMH_SelectConfirm--
" confirm selected macro
function! s:exMH_SelectConfirm() " <<<
    let line = getline(".")

    " if this is a group title
    if line =~# ':'
        call g:ex_WarningMsg("Can't select macro group title")
        return
    endif

    " if this is a empty line 
    if substitute(line, ' ', "", "g" ) == ''
        call g:ex_WarningMsg("Can't select an empty line")
        return
    endif

    " if this is a selected macor, disable the macro
    if line =~# '\*'
        let macro = getline('.')
        let on_to_off = substitute( macro, ' \|\*', "", "g" ) " skip whitespace and '*'
        silent call setline( '.', "    ".on_to_off )

        " update define list on to off
        call add( s:exMH_define_list[0], on_to_off ) " add to off
        " remove from to on
        let idx = index( s:exMH_define_list[1], on_to_off )
        if idx >= 0
            call remove( s:exMH_define_list[1], idx ) 
        endif

        " update syntax immediately
        call g:ex_GotoEditBuffer()
        call s:exMH_UpdateSyntax()
        call g:ex_GotoEditBuffer()
        return
    endif

    " save current postion
    let cur_cursor = getpos(".")

    " get the line of current group title and next group title
    let [next_group_line, dummy_col] = searchpos( '^.*:', 'nW' ) 
    let [cur_group_line, dummy_col] = searchpos( '^.*:', 'bW' ) 
    let [enable_macro_line, dummy_col] = searchpos( '\*', 'nW' ) 

    " init change macro
    let on_to_off = ''
    let off_to_on = ''

    " if not any enable macro in this group
    if enable_macro_line == 0
        " off to on
        silent call setpos( '.', cur_cursor )
        let macro = getline('.')
        let off_to_on = substitute( macro, ' ', "", "g" ) " skip whitespace and '*'
        silent call setline( '.', '   *' . off_to_on )
    elseif next_group_line == 0 || (enable_macro_line < next_group_line)
        " on to off
        let macro = getline(enable_macro_line)
        let on_to_off = substitute( macro, ' \|\*', "", "g" ) " skip whitespace and '*'
        silent call setline( enable_macro_line, "    ".on_to_off )

        " off to on
        silent call setpos( '.', cur_cursor )
        let macro = getline('.')
        let off_to_on = substitute( macro, ' ', "", "g" ) " skip whitespace and '*'
        silent call setline( '.', '   *' . off_to_on )
    else
        " off to on
        silent call setpos( '.', cur_cursor )
        let macro = getline('.')
        let off_to_on = substitute( macro, ' ', "", "g" ) " skip whitespace and '*'
        silent call setline( '.', '   *' . off_to_on )
    endif

    " update define list on to off
    if on_to_off != '' 
        call add( s:exMH_define_list[0], on_to_off ) " add to off
        " remove from to on
        let idx = index( s:exMH_define_list[1], on_to_off )
        if idx >= 0
            call remove( s:exMH_define_list[1], idx ) 
        endif
    endif

    " update define list off to on
    if off_to_on != '' 
        call add( s:exMH_define_list[1], off_to_on ) " add to off
        " remove from to on
        let idx = index( s:exMH_define_list[0], off_to_on )
        if idx >= 0
            call remove( s:exMH_define_list[0], idx ) 
        endif
    endif

    " update syntax immediately
    call g:ex_GotoEditBuffer()
    call s:exMH_UpdateSyntax()
    call g:ex_GotoEditBuffer()

endfunction " >>>

" -------------------------------------------------------------------------
" Command part
" -------------------------------------------------------------------------
command ExmhSelectToggle call s:exMH_ToggleWindow('Select')
command ExmhToggle call s:exMH_ToggleWindow('')
command -narg=? ExmhHL call s:exMH_SyntaxHL("<args>")

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
