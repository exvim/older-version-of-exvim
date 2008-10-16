"=============================================================================
" File:        exProject.vim
" Author:      Johnny
" Last Change: Wed 25 Oct 2006 01:05:03 PM EDT
" Version:     1.0
"=============================================================================
" You may use this code in whatever way you see fit.

if exists('loaded_exproject') || &cp
    finish
endif
let loaded_exproject=1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------

" Initialization <<<

" -------------------------------
" gloable varialbe initialization
" -------------------------------

" window height for horizon window mode
if !exists('g:exPJ_window_height')
    let g:exPJ_window_height = 20
endif

" window width for vertical window mode
if !exists('g:exPJ_window_width')
    let g:exPJ_window_width = 30
endif

" window height increment value
if !exists('g:exPJ_window_height_increment')
    let g:exPJ_window_height_increment = 30
endif

" window width increment value
if !exists('g:exPJ_window_width_increment')
    let g:exPJ_window_width_increment = 100
endif

" go back to edit buffer
" 'topleft','botright'
if !exists('g:exPJ_window_direction')
    let g:exPJ_window_direction = 'topleft'
endif

" use vertical or not
if !exists('g:exPJ_use_vertical_window')
    let g:exPJ_use_vertical_window = 1
endif

" go back to edit buffer
if !exists('g:exPJ_backto_editbuf')
    let g:exPJ_backto_editbuf = 1
endif

" set edit mode
" 'none', 'append', 'replace'
if !exists('g:exPJ_edit_mode')
    let g:exPJ_edit_mode = 'replace'
endif

" set defualt filter
if !exists('g:exPJ_defualt_filter')
    let g:exPJ_defualt_filter  = 'c cpp cxx '
    let g:exPJ_defualt_filter .= 'h hpp inl '
    let g:exPJ_defualt_filter .= 'uc '
    let g:exPJ_defualt_filter .= 'hlsl vsh psh glsl '
    let g:exPJ_defualt_filter .= 'dox doxygen '
    let g:exPJ_defualt_filter .= 'ini cfg '
    let g:exPJ_defualt_filter .= 'mk err exe '
endif
" -------------------------------
" local variable initialization
" -------------------------------

" title
let s:exPJ_select_title = "__exPJ_SelectWindow__"
let s:exPJ_short_title = 'Select'
let s:exPJ_cur_filename = '__exPJ_SelectWindow__'

" select variable
let s:exPJ_cursor_line = 0
let s:exPJ_cursor_col = 0
let s:exPJ_need_update_select_window = 0

" >>>

" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------

" --exPJ_OpenWindow--
" Open exTagSelect window 
function! s:exPJ_OpenWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exPJ_short_title != a:short_title
            let _title = '__exPJ_' . s:exPJ_short_title . 'Window__'
            if s:exPJ_short_title == 'Select'
                let _title = s:exPJ_cur_filename
            endif
            if bufwinnr(_title) != -1
                call g:ex_CloseWindow(_title)
            endif
            let s:exPJ_short_title = a:short_title
        endif
    endif

    let title = '__exPJ_' . s:exPJ_short_title . 'Window__'
    " toggle exPJ window
    if a:short_title == 'Select'
        let title = s:exPJ_cur_filename
    endif
    " open window
    if g:exPJ_use_vertical_window
        call g:ex_OpenWindow( title, g:exPJ_window_direction, g:exPJ_window_width, g:exPJ_use_vertical_window, g:exPJ_edit_mode, g:exPJ_backto_editbuf, 'g:exPJ_Init'.s:exPJ_short_title.'Window', 'g:exPJ_Update'.s:exPJ_short_title.'Window' )
    else
        call g:ex_OpenWindow( title, g:exPJ_window_direction, g:exPJ_window_height, g:exPJ_use_vertical_window, g:exPJ_edit_mode, g:exPJ_backto_editbuf, 'g:exPJ_Init'.s:exPJ_short_title.'Window', 'g:exPJ_Update'.s:exPJ_short_title.'Window' )
    endif
endfunction " >>>

" --exPJ_ResizeWindow--
" Resize the window use the increase value
function! s:exPJ_ResizeWindow() " <<<
    if g:exPJ_use_vertical_window
        call g:ex_ResizeWindow( g:exPJ_use_vertical_window, g:exPJ_window_width, g:exPJ_window_width_increment )
    else
        call g:ex_ResizeWindow( g:exPJ_use_vertical_window, g:exPJ_window_height, g:exPJ_window_height_increment )
    endif
endfunction " >>>

" --exPJ_ToggleWindow--
" Toggle the window
function! s:exPJ_ToggleWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exPJ_short_title != a:short_title
            let _title = '__exPJ_' . s:exPJ_short_title . 'Window__'
            if s:exPJ_short_title == 'Select'
                let _title = s:exPJ_cur_filename
            endif
            if bufwinnr(_title) != -1
                call g:ex_CloseWindow(_title)
            endif
            let s:exPJ_short_title = a:short_title
        endif
    endif

    let title = '__exPJ_' . s:exPJ_short_title . 'Window__'
    " toggle exPJ window
    if a:short_title == 'Select'
        let title = s:exPJ_cur_filename
    endif
    if g:exPJ_use_vertical_window
        call g:ex_ToggleWindow( title, g:exPJ_window_direction, g:exPJ_window_width, g:exPJ_use_vertical_window, 'none', g:exPJ_backto_editbuf, 'g:exPJ_Init'.s:exPJ_short_title.'Window', 'g:exPJ_Update'.s:exPJ_short_title.'Window' )
    else
        call g:ex_ToggleWindow( title, g:exPJ_window_direction, g:exPJ_window_height, g:exPJ_use_vertical_window, 'none', g:exPJ_backto_editbuf, 'g:exPJ_Init'.s:exPJ_short_title.'Window', 'g:exPJ_Update'.s:exPJ_short_title.'Window' )
    endif
endfunction " >>>

" --exPJ_SwitchWindow--
function! s:exPJ_SwitchWindow( short_title ) " <<<
    let title = '__exPJ_' . a:short_title . 'Window__'
    if a:short_title == 'Select'
        let title = s:exPJ_cur_filename
    endif
    if bufwinnr(title) == -1
        call s:exPJ_ToggleWindow(a:short_title)
    endif
endfunction " >>>

" --exPJ_GetName--
function! s:exPJ_GetName( line_num )
    let line = getline(a:line_num)
    let line = substitute(line,'.*\[.*\]\(.\{-}\)','\1','')
    let idx_end_1 = stridx(line,' {')
    let idx_end_2 = stridx(line,' }')
    if idx_end_1 != -1
        let line = strpart(line,0,idx_end_1)
    elseif idx_end_2 != -1
        let line = strpart(line,0,idx_end_2)
    endif
    return line
endfunction

" --exPJ_RefreshWindow--
function! s:exPJ_RefreshWindow()
    " silent! wincmd H
    silent exe 'vertical resize ' . g:exPJ_window_width
endfunction

" ------------------------------
"  select window part
" ------------------------------

" --exPJ_InitSelectWindow--
" Init exTagSelect window
function! g:exPJ_InitSelectWindow() " <<<
    silent! setlocal filetype=ft_exproject
    silent! setlocal buftype=

    " +++++++++++++++++++++++++++++++
    " silent! setlocal foldmethod=expr
    " silent! setlocal foldexpr=g:ex_GetFoldLevel(v:lnum)
    " silent! setlocal foldtext=g:ex_FoldText()
    " +++++++++++++++++++++++++++++++
    silent! setlocal foldmethod=marker foldmarker={,} foldlevel=1
    silent! setlocal foldtext=g:ex_FoldText()
    silent! setlocal foldminlines=0
    silent! setlocal foldlevel=9999
    syntax match ex_SynTransparent '{'
    syntax match ex_SynTransparent '}'
    " +++++++++++++++++++++++++++++++

    " syntax highlight
    syntax match exPJ_SynDir '\[\CF\]'
    syntax match exPJ_TreeLine '\( |\)\+-*\ze'
    syntax match exPJ_SynFile '\[[^\CF]*\]'
    syntax match exPJ_SynSrcFile '\[c\]'
    syntax match exPJ_SynHeaderFile '\[\(h\|i\)\]'
    syntax match exPJ_SynErrorFile '\[e\]'
    
    hi def exPJ_TreeLine gui=none guifg=DarkGray term=none cterm=none ctermfg=Gray
    hi def exPJ_SynDir gui=bold guifg=Brown term=bold cterm=bold ctermfg=DarkRed
    hi def exPJ_SynFile gui=none guifg=Magenta term=none cterm=none ctermfg=Magenta

    hi def exPJ_SynSrcFile gui=none guifg=Blue term=none cterm=none ctermfg=Blue
    hi def exPJ_SynHeaderFile gui=none guifg=DarkGreen term=none cterm=none ctermfg=DarkGreen
    hi def exPJ_SynErrorFile gui=none guifg=Red term=none cterm=none ctermfg=Red

    " key map
    nnoremap <silent> <buffer> <Return>   :call <SID>exPJ_GotoSelectResult('e')<CR>
    nnoremap <silent> <buffer> <S-Return> :call <SID>exPJ_GotoSelectResult('bel sp')<CR>
    nnoremap <silent> <buffer> <2-LeftMouse>   :call <SID>exPJ_GotoSelectResult('e')<CR>
    nnoremap <silent> <buffer> <S-2-LeftMouse> :call <SID>exPJ_GotoSelectResult('bel sp')<CR>

    nnoremap <silent> <buffer> <Space>   :call <SID>exPJ_ResizeWindow()<CR>
    nnoremap <silent> <buffer> <localleader>C    :call <SID>exPJ_CreateProject('','')<CR>
    nnoremap <silent> <buffer> <localleader>R    :call <SID>exPJ_RefreshProject()<CR>
    nnoremap <silent> <buffer> <localleader>r    :call <SID>exPJ_QuickRefreshProject()<CR>
    nnoremap <silent> <buffer> <C-Left>   :echo 'project buffer only'<CR>
    nnoremap <silent> <buffer> <C-Right>  :echo 'project buffer only'<CR>

    nnoremap <silent> <buffer> <C-Up> :call g:ex_CursorJump( 'ErrorLog.err', 'up' )<CR>
    nnoremap <silent> <buffer> <C-Down> :call g:ex_CursorJump( 'ErrorLog.err', 'down' )<CR>

    "
    nnoremap <silent> <buffer> o  :call <SID>exPJ_CreateNewFile()<CR>
    nnoremap <silent> <buffer> O  :call <SID>exPJ_CreateNewFold()<CR>

    " Autocommands to keep the window the specified size
    au WinLeave <buffer> :call s:exPJ_RefreshWindow()
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()

    " buffer command
    command -buffer RM call s:exPJ_RemoveEmptyDir()
endfunction " >>>

" --exPJ_UpdateSelectWindow--
" Update window
function! g:exPJ_UpdateSelectWindow() " <<<
endfunction " >>>

" --exPJ_OpenProject--
function! s:exPJ_OpenProject(project_name) " <<<
    " set and find project file
    if a:project_name != ''
        let s:exPJ_cur_filename = a:project_name
        let s:exPJ_select_title = s:exPJ_cur_filename
    endif

    " open project select window
    let old_edit_mode = g:exPJ_edit_mode
    let old_bacto_editbuf = g:exPJ_backto_editbuf

    let g:exPJ_edit_mode = 'none'
    let g:exPJ_backto_editbuf = 0
    call s:exPJ_OpenWindow('Select')
    let g:exPJ_edit_mode = old_edit_mode
    let g:exPJ_backto_editbuf = old_bacto_editbuf
endfunction " >>>

" --exPJ_CreateProject--
function! s:exPJ_CreateProject(entry_dir,filter) " <<<
    call g:ex_SetLevelList(-1, 1)

    "
    let entry_dir = a:entry_dir
    let filter = a:filter
    if strlen(entry_dir) == 0
        let ex_pwd = getcwd()
        if exists('g:exES_PWD')
            let ex_pwd = g:exES_PWD
        endif
        let entry_dir = inputdialog( 'Enter the entry directory:', ex_pwd, 'cancle' )
        if entry_dir == ''
            call g:ex_WarningMsg('Entry dir is empty')
            return
        elseif entry_dir == 'cancle'
            return
        endif
    endif
    if strlen(filter) == 0
        let filter = inputdialog( 'Enter the filters: sample(cpp c inl)', g:exPJ_defualt_filter, 'cancle')
        if filter == 'cancle'
            return
        endif
    endif


    let old_bacto_editbuf = g:exPJ_backto_editbuf
    let g:exPJ_backto_editbuf = 0
    echon "Creating exProject: " . entry_dir . "\r"
    call s:exPJ_OpenWindow('Select')
    call g:ex_Browse(entry_dir,g:ex_GetFileFilterPattern(filter))
    let g:exPJ_backto_editbuf = old_bacto_editbuf
    echon "Creating exProject: " . entry_dir . " done!\r"
endfunction " >>>

" --exPJ_QuickRefreshProject
function! s:exPJ_QuickRefreshProject() " <<<
    " get filter
    let filter = inputdialog( 'Enter the filters: sample(cpp c inl)', g:exPJ_defualt_filter, 'cancle')
    if filter == 'cancle'
        return
    endif

    let file_line = getline('.')
    " if fold, open it else if not a file return
    if foldclosed('.') != -1
        normal! zr
    endif

    " initial variable
    let fold_level = g:ex_GetFoldLevel(line('.'))
    let fold_level -= 1
    let level_pattern = repeat('.',fold_level*2)
    let full_path_name = ''
    let fold_pattern = '^'.level_pattern.'-\[F\]'

    " get first fold name
    if match(file_line, '\C\[F\]') == -1
        if search(fold_pattern,'b')
            let full_path_name = s:exPJ_GetName(line('.'))
        else
            call g:ex_WarningMsg('Fold not found')
            return
        endif
    else
        let full_path_name = s:exPJ_GetName(line('.'))
        let fold_level += 1
    endif
    let short_dir = full_path_name

    " fold_level 0 will not set path name
    if fold_level == 0
        let full_path_name = ''
    endif

    " save the position
    let s:exPJ_cursor_line = line('.')
    let s:exPJ_cursor_col = col('.')

    " recursively make full path
    let need_set_list = 1
    if fold_level == 0
        let need_set_list = 0
    else
        while fold_level > 1
            let fold_level -= 1
            let level_pattern = repeat('.',fold_level*2)
            let fold_pattern = '^'.level_pattern.'-\[F\]'
            if search(fold_pattern,'b')
                let full_path_name = s:exPJ_GetName(line('.')).'/'.full_path_name
            else
                call g:ex_WarningMsg('Fold not found')
                break
            endif
        endwhile
    endif
    silent call cursor(s:exPJ_cursor_line,s:exPJ_cursor_col)

    " simplify the file name
    let full_path_name = fnamemodify( full_path_name, ":p" )
    " do not escape, or the directory with white-space can't be found
    "let full_path_name = escape(simplify(full_path_name),' ')
    let full_path_name = strpart( full_path_name, 0, strlen(full_path_name)-1 )
    echon "Update directory: " . full_path_name . "\r"

    " select it first to record in '<,'>
    silent exec 'normal! $vaB[{v'
    let fold_start = line("'<")
    let fold_end = line("'>")
    let space_cout = (g:ex_GetFoldLevel(line('.'))+1)*2+1
    let pattern_dot = repeat('.', space_cout)
    let file_pattern = pattern_dot . '-\[.\]'

    " start search
    let line_idx = search(file_pattern)

    while (line_idx>fold_start) && (line_idx<=fold_end) && (line_idx!=-1)
        let cur_line = getline(line_idx)

        let idx = stridx(cur_line, '}')
        if idx == -1
            silent exec "normal! ddk"
            let fold_end -= 1
            let line_idx = search(file_pattern)
        else
            " TODO <<<
            let surfix = strpart(cur_line,idx-1)
            silent call setline('.',strpart(cur_line,0,idx-1))
            let file_line = strpart(cur_line, 0, stridx(cur_line,'-')) . " |-[]" . surfix
            put = file_line
            silent call search(']')
            " TODO >>>
        endif
    endwhile

    " reset position
    silent call cursor(s:exPJ_cursor_line,s:exPJ_cursor_col)

endfunction " >>>

" --exPJ_RefreshProject--
function! s:exPJ_RefreshProject() " <<<
    " get filter
    let filter = inputdialog( 'Enter the filters: sample(cpp c inl)', g:exPJ_defualt_filter, 'cancle')
    if filter == 'cancle'
        return
    endif

    let file_line = getline('.')
    " if fold, open it else if not a file return
    if foldclosed('.') != -1
        normal! zr
    endif

    " initial variable
    let fold_level = g:ex_GetFoldLevel(line('.'))
    let fold_level -= 1
    let level_pattern = repeat('.',fold_level*2)
    let full_path_name = ''
    let fold_pattern = '^'.level_pattern.'-\[F\]'

    " get first fold name
    if match(file_line, '\C\[F\]') == -1
        if search(fold_pattern,'b')
            let full_path_name = s:exPJ_GetName(line('.'))
        else
            call g:ex_WarningMsg('Fold not found')
            return
        endif
    else
        let full_path_name = s:exPJ_GetName(line('.'))
        let fold_level += 1
    endif
    let short_dir = full_path_name

    " fold_level 0 will not set path name
    if fold_level == 0
        let full_path_name = ''
    endif

    " save the position
    let s:exPJ_cursor_line = line('.')
    let s:exPJ_cursor_col = col('.')

    " recursively make full path
    let need_set_list = 1
    if fold_level == 0
        let need_set_list = 0
    else
        while fold_level > 1
            let fold_level -= 1
            let level_pattern = repeat('.',fold_level*2)
            let fold_pattern = '^'.level_pattern.'-\[F\]'
            if search(fold_pattern,'b')
                let full_path_name = s:exPJ_GetName(line('.')).'/'.full_path_name
            else
                call g:ex_WarningMsg('Fold not found')
                break
            endif
        endwhile
    endif
    silent call cursor(s:exPJ_cursor_line,s:exPJ_cursor_col)

    " simplify the file name
    let full_path_name = fnamemodify( full_path_name, ":p" )
    " do not escape, or the directory with white-space can't be found
    "let full_path_name = escape(simplify(full_path_name),' ')
    let full_path_name = strpart( full_path_name, 0, strlen(full_path_name)-1 )
    echon "Update directory: " . full_path_name . "\r"

    " set level list if not the root dir
    if need_set_list
        call g:ex_SetLevelList(line('.'), 1)
    endif
    " delete the whole fold
    silent exec "normal! zc"
    silent exec "normal! 2dd"
    " broswing
    call g:ex_Browse(full_path_name,g:ex_GetFileFilterPattern(filter))
    " reset level list
    call g:ex_SetLevelList(-1, 1)

    echon "Update directory: " . full_path_name . " done!\r"

    " at the end, we need to rename the folder as simple one
    if need_set_list
        " rename the folder
        let cur_line = getline('.')

        " if this is a empty directory, return
        let pattern = '\C\[F\].*\<' . short_dir . '\> {'
        if match(cur_line, pattern) == -1
            call g:ex_WarningMsg("The directory is empty")
            return
        endif

        let idx_start = stridx(cur_line, ']')
        let start_part = strpart(cur_line,0,idx_start+1)

        let idx_end = stridx(cur_line, ' {')
        let end_part = strpart(cur_line,idx_end)

        silent call setline('.', start_part . short_dir . end_part)
    else
        " delete the first empty line then go to the root dir
        silent exec "normal! ggddj"
    endif
endfunction " >>>

" --exPJ_CreateNewFile--
function! s:exPJ_CreateNewFile() " <<<
    let reg_t = @t
    if foldclosed('.') != -1
        silent exec 'normal! j"tyy"t2p$a-[]'
        return
    endif

    let cur_line = getline('.')
    if match(cur_line, '\C\[F\]') != -1 " if this is directory
        let idx = stridx(cur_line, '}')
        if idx == -1
            silent exec 'normal! j"tyy"tP'
            silent call search('[')
            silent exec 'normal! "tc$[]'
        else
            let surfix = strpart(cur_line,idx-1)
            silent call setline('.',strpart(cur_line,0,idx-1))
            let file_line = strpart(cur_line, 0, stridx(cur_line,'-')) . " |-[]" . surfix
            put = file_line
            silent call search(']')
        endif
    else " else if this is file
        let idx = stridx(cur_line, '}')
        if idx == -1
            silent exec 'normal! "tyyj"tP'
            silent call search('[')
            silent exec 'normal! "tc$[]'
        else
            let surfix = strpart(cur_line,idx-1)
            silent call setline('.',strpart(cur_line,0,idx-1))
            let file_line = strpart(cur_line, 0, stridx(cur_line,'-')) . "-[]" . surfix
            put = file_line
            silent call search(']')
        endif
    endif
    let @t = reg_t
endfunction " >>>

" --exPJ_CreateNewFold--
function! s:exPJ_CreateNewFold() " <<<
    let reg_t = @t
    if foldclosed('.') != -1
        silent exec 'normal! j"tyy"t2p$a-[]'
        return
    endif

    let cur_line = getline('.')
    if match(cur_line, '\C\[F\]') != -1 " if this is directory
        let idx = stridx(cur_line, '}')
        if idx == -1
            silent exec 'normal! j"tyy"tP'
            silent call search('[')
            silent exec "normal! c$[F] { }"

            silent exec "normal! yyjP"
            silent call search('-')
            silent exec 'normal! "tc$'
        else
            let surfix = strpart(cur_line,idx-1)
            silent call setline('.',strpart(cur_line,0,idx-1))
            let file_line = strpart(cur_line, 0, stridx(cur_line,'-')) . " |-[F] { }" . surfix
            put = file_line
            silent call search(']')

            silent exec 'normal! "tyyj"tP'
            silent call search('|-')
            silent exec "normal! c$"
        endif
    " else " else if this is file
    "     let idx = stridx(cur_line, '}')
    "     if idx == -1
    "         silent exec 'normal! "tyyj"tP'
    "         silent call search('[')
    "         silent exec 'normal! "tc$[F] { }'
    "     else
    "         let surfix = strpart(cur_line,idx-1)
    "         silent call setline('.',strpart(cur_line,0,idx-1))
    "         let file_line = strpart(cur_line, 0, stridx(cur_line,'-')) . "-[F] { }" . surfix
    "         put = file_line
    "         silent call search(']')
    "     endif
    endif
    let @t = reg_t
endfunction " >>>

" --exPJ_GotoSelectResult--
function! s:exPJ_GotoSelectResult(edit_cmd) " <<<
    let file_line = getline('.')
    " if fold, open it else if not a file return
    if foldclosed('.') != -1 || match(getline('.'), '\C\[F\]') != -1
        normal! za
        return
    elseif match(file_line, '\C\[[^F]*\]') == -1
        call g:ex_WarningMsg('Please select a file')
        return
    endif

    " initial variable
    let s:exPJ_cursor_line = line('.')
    let s:exPJ_cursor_col = col('.')
    let fold_level = g:ex_GetFoldLevel(s:exPJ_cursor_line)
    let full_path_name = s:exPJ_GetName(s:exPJ_cursor_line)

    " recursively make full path
    let level_pattern = repeat('.',fold_level-1)
    while fold_level > 1 " don't parse level:0
        let fold_level -= 1
        let level_pattern = repeat('.',fold_level*2)
        let fold_pattern = '^'.level_pattern.'-\[F\]'
        if search(fold_pattern,'b')
            let full_path_name = s:exPJ_GetName(line('.')).'/'.full_path_name
        else
            call g:ex_WarningMsg('Fold not found')
            break
        endif
    endwhile
    silent call cursor(s:exPJ_cursor_line,s:exPJ_cursor_col)

    " simplify the file name
    let full_path_name = fnamemodify( full_path_name, ":p" )
    let full_path_name = escape(simplify(full_path_name),' ')

    " switch file_type
    " let file_type = strpart( full_path_name, strridx(full_path_name,'.')+1 )
    let file_type = fnamemodify( full_path_name, ":e" )
    if file_type == 'err'
        echon 'load quick fix list: ' . full_path_name . "\r"
        call g:ex_GotoPluginBuffer()
        silent exec 'QF '.full_path_name
    elseif file_type == 'mk'
        echon 'set make file: ' . full_path_name . "\r"
        call g:ex_GotoEditBuffer()
        silent exec a:edit_cmd.' '.full_path_name
        """"""""""""""""""""""""""""""""""""""
        " do not show it in buffer list // jwu: show them have more convienience
        " silent! setlocal bufhidden=hide
        " silent! setlocal noswapfile
        " silent! setlocal nobuflisted
        """"""""""""""""""""""""""""""""""""""
    elseif file_type == 'exe'
        echon 'debug: ' . full_path_name . "\r"
        call g:ex_GotoEditBuffer()
        call g:ex_Debug( full_path_name )
    else " default
        " put the edit file
        echon full_path_name . "\r"
        " silent wincmd p
        call g:ex_GotoEditBuffer()
        silent exec a:edit_cmd.' '.full_path_name
    endif

    "
    if !g:exPJ_backto_editbuf
        let winnum = bufwinnr(s:exPJ_select_title)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
        return
    endif
endfunction " >>>

" --exPJ_GotoSelectResult--
function! s:exPJ_GotoCurrentFile() " <<<
    " get current buffer name then jump
    let cur_bufname = bufname("%")

    " go to the project window
    call s:exPJ_OpenProject("")
    " go to the top to begin search
    silent normal! gg

    " split the bufname into list
    let file_name = fnamemodify( cur_bufname, ":t" )

    " store position if we don't find, restore to the position
    let cursor_line = line('.')
    let cursor_col = col('.')

    """
    let pattern_found = 0
    while !pattern_found
        " search file by name.
        if search( file_name, "W" ) > 0

            " get full_path_name
            " -----------------------------
            " initial variable
            let s:exPJ_cursor_line = line('.')
            let s:exPJ_cursor_col = col('.')
            let fold_level = g:ex_GetFoldLevel(s:exPJ_cursor_line)
            let full_path_name = s:exPJ_GetName(s:exPJ_cursor_line)

            " recursively make full path
            let level_pattern = repeat('.',fold_level-1)
            while fold_level > 1 " don't parse level:0
                let fold_level -= 1
                let level_pattern = repeat('.',fold_level*2)
                let fold_pattern = '^'.level_pattern.'-\[F\]'
                if search(fold_pattern,'b')
                    let full_path_name = s:exPJ_GetName(line('.')).'/'.full_path_name
                else
                    call g:ex_WarningMsg('Fold not found')
                    break
                endif
            endwhile
            silent call cursor(s:exPJ_cursor_line,s:exPJ_cursor_col)

            " simplify the file name
            let full_path_name = fnamemodify( full_path_name, ":p" )
            " -----------------------------

            " re-check by directory search
            if full_path_name ==# fnamemodify( cur_bufname, ":p" )
                let pattern_found = 1
            else
                continue
            endif
        else
            silent call cursor( cursor_line, cursor_col )
            call g:ex_WarningMsg("the file: " . cur_bufname . " not found in the project tree")
            return
        endif
    endwhile

    " if find, set the text line in the middel of the window
    silent normal! zz
endfunction " >>>

" -------------------------------------------------------------------------
" Command part
" -------------------------------------------------------------------------
command -narg=? EXProject call s:exPJ_OpenProject("<args>")
command ExpjSelectToggle call s:exPJ_ToggleWindow('Select')
command ExpjGotoCurrentFile call s:exPJ_GotoCurrentFile()

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
