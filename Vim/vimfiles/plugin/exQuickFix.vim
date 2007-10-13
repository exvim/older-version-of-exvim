"=============================================================================
" File:        exQuickFix.vim
" Author:      Johnny
" Last Change: 12/15/2006 2:09:05 PM
" Version:     1.0
"=============================================================================
" You may use this code in whatever way you see fit.

if exists('loaded_exquickfix') || &cp
    finish
endif
let loaded_exquickfix = 1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------
" Initialization <<<
" -------------------------------
" gloable varialbe initialization
" -------------------------------

" window height for horizon window mode
if !exists('g:exQF_window_height')
    let g:exQF_window_height = 20
endif

" window width for vertical window mode
if !exists('g:exQF_window_width')
    let g:exQF_window_width = 30
endif

" window height increment value
if !exists('g:exQF_window_height_increment')
    let g:exQF_window_height_increment = 30
endif

" window width increment value
if !exists('g:exQF_window_width_increment')
    let g:exQF_window_width_increment = 100
endif

" go back to edit buffer
" 'topleft','botright'
if !exists('g:exQF_window_direction')
    let g:exQF_window_direction = 'botright'
endif

" use vertical or not
if !exists('g:exQF_use_vertical_window')
    let g:exQF_use_vertical_window = 0
endif

" go back to edit buffer
if !exists('g:exQF_backto_editbuf')
    let g:exQF_backto_editbuf = 1
endif

" go and close exTagSelect window
if !exists('g:exQF_close_when_selected')
    let g:exQF_close_when_selected = 0
endif

" set edit mode
" 'none', 'append', 'replace'
if !exists('g:exQF_edit_mode')
    let g:exQF_edit_mode = 'replace'
endif

" -------------------------------
" local variable initialization
" -------------------------------

" title
let s:exQF_select_title = '__exQF_SelectWindow__'
let s:exQF_quick_view_title = '__exQF_QuickViewWindow__'
let s:exQF_short_title = 'Select'
let s:exQF_cur_filename = '__exQF_SelectWindow__'

" general
let s:exQF_fold_start = '<<<<<<'
let s:exQF_fold_end = '>>>>>>'
let s:exQF_need_search_again = 0
let s:exQF_compile_dir = ''
let s:exQF_error_file_size = 0

" select variable
let s:exQF_select_idx = 1
let s:exQF_need_update_select_window = 0

" quick view variable
let s:exQF_quick_view_idx = 1
let s:exQF_picked_search_result = ''
let s:exQF_quick_view_search_pattern = ''
let s:exQF_need_update_quick_view_window = 0

" >>>

" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------

" --exQF_OpenWindow--
" Open exQuickFix window 
function! s:exQF_OpenWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exQF_short_title != a:short_title
            let _title = '__exQF_' . s:exQF_short_title . 'Window__'
            if s:exQF_short_title == 'Select'
                let _title = s:exQF_cur_filename
            endif
            if bufwinnr(_title) != -1
                call g:ex_CloseWindow(_title)
            endif
            let s:exQF_short_title = a:short_title
        endif
    endif

    let title = '__exQF_' . s:exQF_short_title . 'Window__'
    " toggle exQF window
    if a:short_title == 'Select'
        let title = s:exQF_cur_filename
    endif
    " open window
    if g:exQF_use_vertical_window
        call g:ex_OpenWindow( title, g:exQF_window_direction, g:exQF_window_width, g:exQF_use_vertical_window, g:exQF_edit_mode, g:exQF_backto_editbuf, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    else
        call g:ex_OpenWindow( title, g:exQF_window_direction, g:exQF_window_height, g:exQF_use_vertical_window, g:exQF_edit_mode, g:exQF_backto_editbuf, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    endif
endfunction " >>>

" --exQF_ResizeWindow--
" Resize the window use the increase value
function! s:exQF_ResizeWindow() " <<<
    if g:exQF_use_vertical_window
        call g:ex_ResizeWindow( g:exQF_use_vertical_window, g:exQF_window_width, g:exQF_window_width_increment )
    else
        call g:ex_ResizeWindow( g:exQF_use_vertical_window, g:exQF_window_height, g:exQF_window_height_increment )
    endif
endfunction " >>>

" --exQF_ToggleWindow--
" Toggle the window
function! s:exQF_ToggleWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exQF_short_title != a:short_title
            let _title = '__exQF_' . s:exQF_short_title . 'Window__'
            if s:exQF_short_title == 'Select'
                let _title = s:exQF_cur_filename
            endif
            if bufwinnr(_title) != -1
                call g:ex_CloseWindow(_title)
            endif
            let s:exQF_short_title = a:short_title
        endif
    endif

    let title = '__exQF_' . s:exQF_short_title . 'Window__'
    " toggle exQF window
    if a:short_title == 'Select'
        let title = s:exQF_cur_filename
    endif
    if g:exQF_use_vertical_window
        call g:ex_ToggleWindow( title, g:exQF_window_direction, g:exQF_window_width, g:exQF_use_vertical_window, 'none', g:exQF_backto_editbuf, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    else
        call g:ex_ToggleWindow( title, g:exQF_window_direction, g:exQF_window_height, g:exQF_use_vertical_window, 'none', g:exQF_backto_editbuf, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    endif
endfunction " >>>

" --exQF_SwitchWindow
function! s:exQF_SwitchWindow( short_title ) " <<<
    let title = '__exQF_' . a:short_title . 'Window__'
    if a:short_title == 'Select'
        let title = s:exQF_cur_filename
    endif
    if bufwinnr(title) == -1
        call s:exQF_ToggleWindow(a:short_title)
    endif
endfunction " >>>

" --exQF_Goto--
"  goto select line
function! s:exQF_Goto(idx) " <<<
    let idx = a:idx
    if idx == -1
        let idx = line(".")
    endif

    " start jump
    call g:ex_GotoEditBuffer()
    silent exec "cr".idx
    call g:ex_HighlightObjectLine()
    exe 'normal zz'

    " go back if needed
    let title = '__exQF_' . s:exQF_short_title . 'Window__'
    if !g:exQF_close_when_selected
        if !g:exQF_backto_editbuf
            let winnum = bufwinnr(title)
            if winnr() != winnum
                exe winnum . 'wincmd w'
            endif
            return
        endif
    else
        let winnum = bufwinnr(title)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
        close
        call g:ex_GotoEditBuffer()
    endif
endfunction " >>>

" ------------------------------
"  select window part
" ------------------------------

" --exQF_InitSelectWindow--
" Init exQuickFix window
function! g:exQF_InitSelectWindow() " <<<
    silent! setlocal number
    silent! setlocal autoread
    silent! setlocal buftype=
    " syntax highlight
    syntax match exQF_SynFileTag '^--\[.\+\].\+--'
    syntax match exQF_SynFileName '^[^:]*:'
    syntax match exQF_SynFileName '.*\ze(\d\+)'
    syntax match exQF_SynLineNumber '\d\+:'
    syntax match exQF_SynLineNumber '(\d\+)'

    highlight def exQF_SynFileTag term=none cterm=none ctermfg=DarkRed ctermbg=LightGray gui=none guifg=DarkRed guibg=LightGray
    highlight def exQF_SynFileName term=none cterm=none ctermfg=Blue gui=none guifg=Blue 
    highlight def exQF_SynLineNumber term=none cterm=none ctermfg=DarkRed gui=none guifg=Brown 

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exQF_GotoInSelectWindow()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exQF_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exQF_ToggleWindow('Select')<CR>

    nnoremap <buffer> <silent> <C-Right>   :call <SID>exQF_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exQF_SwitchWindow('QuickView')<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" --exQF_GotoSelectLine--
"  goto select line
function! s:exQF_GotoInSelectWindow() " <<<
    let s:exQF_select_idx = line(".")
    call g:ex_HighlightConfirmLine()
    call s:exQF_Goto(-1)
endfunction " >>>

" TODO fuck you just not update like this
" --exQF_UpdateSelectWindow--
" Update exQuickFix window 
function! g:exQF_UpdateSelectWindow() " <<<
    if s:exQF_need_update_select_window
        let s:exQF_need_update_select_window = 0
        silent exec "cg error.txt"
        let reg_e = @e
        silent redir @e
        silent exec "cl"
        silent redir END
        silent exec "normal Gdgg"
        silent put = @e
        let @e = reg_e
    endif

    " ++++++++++++++++++++++++++++++++++++++++++++
    " the :cope command is arrange by line_num
    " ++++++++++++++++++++++++++++++++++++++++++++

    silent call cursor(s:exQF_select_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exQF_GetQuickFixResult--
"  get error file and load quick fix list
function! s:exQF_GetQuickFixResult( file_name ) " <<<
    let full_file_name = globpath( getcwd(), a:file_name )
    if full_file_name == ''
        let full_file_name = a:file_name
    endif
    if findfile(full_file_name) != ''
        " if we have other exUtility window, close it
        " this code can't be disable, or the window jump will be wrong
        if &filetype == "ex_filetype"
            silent exec "normal \<Esc>"
        endif
        
        " get the compile dir
        let s:exQF_compile_dir = ''
        if exists('g:exES_PWD')
            for line in readfile( full_file_name, '', 2 )
                if match(line, '^--\[.\+\].\+--') != -1
                    let idx_start = stridx(line,"[")+1
                    let idx_end = stridx(line,"]")
                    let s:exQF_compile_dir = g:exES_PWD.'/'.strpart( line, idx_start, idx_end-idx_start )
                    break
                endif
            endfor
        endif

        " load the quick fix list
        if s:exQF_compile_dir != '' && isdirectory(s:exQF_compile_dir) != ''
            let cur_dir = getcwd()
            silent exec 'cd '.s:exQF_compile_dir
            silent exec "cg " . full_file_name
            silent exec 'cd '.cur_dir
        else
            silent exec "cg " . full_file_name
        endif

        " save the file size end file name
        let s:exQF_error_file_size = getfsize(full_file_name)
        let s:exQF_cur_filename = full_file_name

        " update quick view window
        let s:exQF_need_update_quick_view_window = 1

        " open and goto search window first
        let gs_winnr = bufwinnr(s:exQF_select_title)
        if gs_winnr == -1
            " open window
            let old_opt = g:exQF_backto_editbuf
            let g:exQF_backto_editbuf = 0
            call s:exQF_ToggleWindow('Select')
            let g:exQF_backto_editbuf = old_opt
            silent! exec '%s/\r//g'
            silent! exec "w!"
            silent! exec 'normal gg'
        else
            exe gs_winnr . 'wincmd w'
        endif
    else
        call g:ex_WarningMsg('file: ' . full_file_name . ' not found')
    endif
endfunction " >>>

"TODO delete
" --exQF_UpdateQuickFixResult--
" Update Quick Fix Result
function! s:exQF_UpdateQuickFixResult() " <<<
    " open and goto search window first
    let gs_winnr = bufwinnr(s:exQF_select_title)
    if gs_winnr == -1
        " open window
        let old_opt = g:exQF_backto_editbuf
        let g:exQF_backto_editbuf = 0
        call s:exQF_ToggleWindow('Select')
        let g:exQF_backto_editbuf = old_opt
    else
        exe gs_winnr . 'wincmd w'
    endif

    call g:exQF_UpdateSelectWindow()
endfunction " >>>

" ------------------------------
"  quick view window part
" ------------------------------
" --exQF_InitQuickViewWindow--
" Init exQuickFix select window
function! g:exQF_InitQuickViewWindow() " <<<
    set number
    " syntax highlight
    syntax match exQF_SynFileName '^[^:]*:'
    syntax match exQF_SynSearchPattern '^----------.\+----------'
    syntax match exQF_SynFileName '^[^:]*:'
    syntax match exQF_SynFileName '.*\ze(\d\+)'
    syntax match exQF_SynFileName '.*\ze:\d\+'
    syntax match exQF_SynLineNumber '\d\+:'
    syntax match exQF_SynLineNumber '(\d\+)'
    syntax match exQF_SynLineNumber ':\d\+'

    highlight def exQF_SynFileName term=none cterm=none ctermfg=Blue gui=none guifg=Blue 
    highlight def exQF_SynSearchPattern term=blod cterm=bold ctermfg=DarkRed ctermbg=LightGray gui=bold guifg=DarkRed guibg=LightGray
    highlight def exQF_SynLineNumber term=none cterm=none ctermfg=Brown gui=none guifg=Brown 

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exQF_GotoInQuickViewWindow()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exQF_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exQF_ToggleWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <C-Right>   :call <SID>exQF_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exQF_SwitchWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <Leader>r :call <SID>exQF_ShowPickedResultNormalMode('', 'replace', 'pattern')<CR>
    vnoremap <buffer> <silent> <Leader>r <ESC>:call <SID>exQF_ShowPickedResultVisualMode('', 'replace', 'pattern')<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" --exQF_UpdateQuickViewWindow--
" Update exQuickFix window 
function! g:exQF_UpdateQuickViewWindow() " <<<
    silent call cursor(s:exQF_quick_view_idx, 1)
    call g:ex_HighlightConfirmLine()
    if s:exQF_need_update_quick_view_window
        let s:exQF_need_update_quick_view_window = 0
        let reg_q = @q
        silent redir @q
        silent! exec 'cl'
        silent redir END
        silent exec "normal Gdgg"
        silent put! = @q
        let @q = reg_q
    endif
endfunction " >>>

" --exQF_GotoInQuickViewWindow--
"  goto select line
function! s:exQF_GotoInQuickViewWindow() " <<<
    let s:exQF_quick_view_idx = line(".")
    call g:ex_HighlightConfirmLine()
    let cur_line = getline('.')
    let idx = stridx(cur_line,' ')
    let idx = eval(strpart(getline('.'),0,idx))
    call s:exQF_Goto(idx)
endfunction " >>>

" --exQF_CopyPickedLine--
" copy the quick view result with search pattern
function! s:exQF_CopyPickedLine( search_pattern, line_start, line_end, search_method ) " <<<
    if a:search_pattern == ''
        let search_pattern = @/
    else
        let search_pattern = a:search_pattern
    endif
    if search_pattern == ''
        let s:exQF_quick_view_search_pattern = ''
        call g:ex_WarningMsg('search pattern not exists')
        return
    else
        let s:exQF_quick_view_search_pattern = '----------' . search_pattern . '----------'
        let full_search_pattern = search_pattern
        if a:search_method == 'pattern'
            "let full_search_pattern = '^.\+:\d.\+:.*\zs' . search_pattern
            let full_search_pattern = search_pattern
        elseif a:search_method == 'file'
            let full_search_pattern = '\(.\+:\d.\+:\)\&' . search_pattern
        endif
        " save current cursor position
        let save_cursor = getpos(".")
        " clear down lines
        if a:line_end < line('$')
            silent call cursor( a:line_end, 1 )
            silent exec 'normal jdG'
        endif
        " clear up lines
        if a:line_start > 1
            silent call cursor( a:line_start, 1 )
            silent exec 'normal kdgg'
        endif
        silent call cursor( 1, 1 )

        " clear the last search result
        let s:exQF_picked_search_result = ''
        silent exec 'v/' . full_search_pattern . '/d'

        " clear pattern result
        while search('----------.\+----------', 'w') != 0
            silent exec 'normal dd'
        endwhile

        " copy picked result
        let reg_q = @q
        silent exec 'normal gg"qyG'
        let s:exQF_picked_search_result = @q
        let @q = reg_q
        " recover
        silent exec 'normal u'

        " this two algorithm was slow
        " -------------------------
        " let cmd = 'let s:exQF_picked_search_result = s:exQF_picked_search_result . "\n" . getline(".")'
        " silent exec '1,$' . 'g/' . search_pattern . '/' . cmd
        " -------------------------
        " let cur_line = a:line_start - 1 
        " while search( search_pattern, 'W', a:line_end ) != 0
        "     if cur_line != line(".")
        "         let cur_line = line(".")
        "         let s:exQF_picked_search_result = s:exQF_picked_search_result . "\n" . getline(".")
        "     else
        "         continue
        "     endif
        " endwhile

        " go back to the original position
        silent call setpos(".", save_cursor)
    endif
endfunction " >>>

" --exQF_ShowPickedResult--
"  show the picked result in the quick view window
function! s:exQF_ShowPickedResult( search_pattern, line_start, line_end, edit_mode, search_method ) " <<<
    call s:exQF_CopyPickedLine( a:search_pattern, a:line_start, a:line_end, a:search_method )
    call s:exQF_SwitchWindow('QuickView')
    if a:edit_mode == 'replace'
        silent exec 'normal Gdgg'
        silent put = s:exQF_quick_view_search_pattern
        "silent put = s:exQF_fold_start
        silent put = s:exQF_picked_search_result
        "silent put = s:exQF_fold_end
    elseif a:edit_mode == 'append'
        silent exec 'normal G'
        silent put = ''
        silent put = s:exQF_quick_view_search_pattern
        "silent put = s:exQF_fold_start
        silent put = s:exQF_picked_search_result
        "silent put = s:exQF_fold_end
    elseif a:edit_mode == 'new'
        return
    endif
endfunction " >>>

" --exQF_ShowPickedResultNormalMode--
"  show the picked result in the quick view window
function! s:exQF_ShowPickedResultNormalMode( search_pattern, edit_mode, search_method ) " <<<
    let line_start = 1
    let line_end = line('$')
    call s:exQF_ShowPickedResult( a:search_pattern, line_start, line_end, a:edit_mode, a:search_method )
endfunction " >>>

" --exQF_ShowPickedResult--
"  show the picked result in the quick view window
function! s:exQF_ShowPickedResultVisualMode( search_pattern, edit_mode, search_method ) " <<<
    let line_start = 3
    let line_end = line('$')

    let tmp_start = line("'<")
    let tmp_end = line("'>")
    if line_start < tmp_start
        let line_start = tmp_start
    endif
    if line_end > tmp_end
        let line_end = tmp_end
    endif

    call s:exQF_ShowPickedResult( a:search_pattern, line_start, line_end, a:edit_mode, a:search_method )
endfunction " >>>

" -------------------------------------------------------------------------
" Command part
" -------------------------------------------------------------------------
"command QF call s:exQF_UpdateQuickFixResult()
command -nargs=1 QF call s:exQF_GetQuickFixResult('<args>')
command ExqfToggle call s:exQF_ToggleWindow('')
command ExqfSelectToggle call s:exQF_ToggleWindow('Select')
command ExqfQuickViewToggle call s:exQF_ToggleWindow('QuickView')

finish
" vim600: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
