" ======================================================================================
" File         : exQuickFix.vim
" Author       : Wu Jie 
" Last Change  : 10/18/2008 | 18:57:12 PM | Saturday,October
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_exquickfix') || &cp
    finish
endif
let loaded_exquickfix = 1

"/////////////////////////////////////////////////////////////////////////////
" variables
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" gloable varialbe initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: window height for horizon window mode
" ------------------------------------------------------------------ 

if !exists('g:exQF_window_height')
    let g:exQF_window_height = 20
endif

" ------------------------------------------------------------------ 
" Desc: window width for vertical window mode
" ------------------------------------------------------------------ 

if !exists('g:exQF_window_width')
    let g:exQF_window_width = 30
endif

" ------------------------------------------------------------------ 
" Desc: window height increment value
" ------------------------------------------------------------------ 

if !exists('g:exQF_window_height_increment')
    let g:exQF_window_height_increment = 30
endif

" ------------------------------------------------------------------ 
" Desc: window width increment value
" ------------------------------------------------------------------ 

if !exists('g:exQF_window_width_increment')
    let g:exQF_window_width_increment = 100
endif

" ------------------------------------------------------------------ 
" Desc: go back to edit buffer
" 'topleft','botright'
" ------------------------------------------------------------------ 

if !exists('g:exQF_window_direction')
    let g:exQF_window_direction = 'botright'
endif

" ------------------------------------------------------------------ 
" Desc: use vertical or not
" ------------------------------------------------------------------ 

if !exists('g:exQF_use_vertical_window')
    let g:exQF_use_vertical_window = 0
endif

" ------------------------------------------------------------------ 
" Desc: go back to edit buffer
" ------------------------------------------------------------------ 

if !exists('g:exQF_backto_editbuf')
    let g:exQF_backto_editbuf = 1
endif

" ------------------------------------------------------------------ 
" Desc: go and close exTagSelect window
" ------------------------------------------------------------------ 

if !exists('g:exQF_close_when_selected')
    let g:exQF_close_when_selected = 0
endif

" ------------------------------------------------------------------ 
" Desc: set edit mode
" 'none', 'append', 'replace'
" ------------------------------------------------------------------ 

if !exists('g:exQF_edit_mode')
    let g:exQF_edit_mode = 'replace'
endif

" ======================================================== 
" local variable initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: title
" ------------------------------------------------------------------ 

let s:exQF_select_title = '__exQF_SelectWindow__'
let s:exQF_quick_view_title = '__exQF_QuickViewWindow__'
let s:exQF_short_title = 'Select'
let s:exQF_cur_filename = '__exQF_SelectWindow__'

" ------------------------------------------------------------------ 
" Desc: general
" ------------------------------------------------------------------ 

let s:exQF_fold_start = '<<<<<<'
let s:exQF_fold_end = '>>>>>>'
let s:exQF_need_search_again = 0
let s:exQF_compile_dir = ''
let s:exQF_error_file_size = 0
let s:exQF_compiler = 'gcc'

" ------------------------------------------------------------------ 
" Desc: select variable
" ------------------------------------------------------------------ 

let s:exQF_select_idx = 1
let s:exQF_need_update_select_window = 0

" ------------------------------------------------------------------ 
" Desc: quick view variable
" ------------------------------------------------------------------ 

let s:exQF_quick_view_idx = 1
let s:exQF_picked_search_result = []
let s:exQF_quick_view_search_pattern = ''
let s:exQF_need_update_quick_view_window = 0

"/////////////////////////////////////////////////////////////////////////////
" function defins
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" general functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Open exQuickFix window 
" ------------------------------------------------------------------ 

function s:exQF_OpenWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exQF_short_title != a:short_title
            let _title = '__exQF_' . s:exQF_short_title . 'Window__'
            if bufwinnr(_title) != -1
                call g:ex_CloseWindow(_title)
            endif
            let s:exQF_short_title = a:short_title
        endif
    endif

    let title = '__exQF_' . s:exQF_short_title . 'Window__'
    " open window
    if g:exQF_use_vertical_window
        call g:ex_OpenWindow( title, g:exQF_window_direction, g:exQF_window_width, g:exQF_use_vertical_window, g:exQF_edit_mode, g:exQF_backto_editbuf, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    else
        call g:ex_OpenWindow( title, g:exQF_window_direction, g:exQF_window_height, g:exQF_use_vertical_window, g:exQF_edit_mode, g:exQF_backto_editbuf, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize the window use the increase value
" ------------------------------------------------------------------ 

function s:exQF_ResizeWindow() " <<<
    if g:exQF_use_vertical_window
        call g:ex_ResizeWindow( g:exQF_use_vertical_window, g:exQF_window_width, g:exQF_window_width_increment )
    else
        call g:ex_ResizeWindow( g:exQF_use_vertical_window, g:exQF_window_height, g:exQF_window_height_increment )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Toggle the window
" ------------------------------------------------------------------ 

function s:exQF_ToggleWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exQF_short_title != a:short_title
            let _title = '__exQF_' . s:exQF_short_title . 'Window__'
            if bufwinnr(_title) != -1
                call g:ex_CloseWindow(_title)
            endif
            let s:exQF_short_title = a:short_title
        endif
    endif

    let title = '__exQF_' . s:exQF_short_title . 'Window__'
    " toggle exQF window
    if g:exQF_use_vertical_window
        call g:ex_ToggleWindow( title, g:exQF_window_direction, g:exQF_window_width, g:exQF_use_vertical_window, 'none', g:exQF_backto_editbuf, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    else
        call g:ex_ToggleWindow( title, g:exQF_window_direction, g:exQF_window_height, g:exQF_use_vertical_window, 'none', g:exQF_backto_editbuf, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exQF_SwitchWindow( short_title ) " <<<
    let title = '__exQF_' . a:short_title . 'Window__'
    if bufwinnr(title) == -1
        call s:exQF_ToggleWindow(a:short_title)
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exQF_Goto(idx) " <<<
    let idx = a:idx
    if idx == -1
        let idx = line(".")
    endif

    " start jump
    call g:ex_GotoEditBuffer()
    try
        silent exec "cr".idx
    catch /^Vim\%((\a\+)\)\=:E42/
        call g:ex_WarningMsg('No Errors')
    endtry

    " go back if needed
    let title = '__exQF_' . s:exQF_short_title . 'Window__'
    call g:ex_OperateWindow ( title, g:exQF_close_when_selected, g:exQF_backto_editbuf, 1 )
endfunction " >>>

" ======================================================== 
" select window part
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Init exQuickFix window
" ------------------------------------------------------------------ 

function g:exQF_InitSelectWindow() " <<<
    silent! setlocal number
    silent! setlocal autoread
    setlocal foldmethod=marker foldmarker=<<<<<<,>>>>>> foldlevel=1

    " syntax highlight
    syntax match ex_SynFold '^<<<<<< \S\+: '
    syntax match ex_SynFold '^>>>>>>'
    syntax match ex_SynTitle '^<<<<<< \S\+ error log >>>>>>'

    syntax region exQF_FileLineRegion start='^[^:<].*:\(\d\+:\|(\d\+)\)*'  end="$" contains=ex_SynFileName,ex_SynLineNr
    syntax match ex_SynFileName contained  '^[^:]*:'
    syntax match ex_SynFileName contained '.*\ze(\d\+)'
    syntax match ex_SynLineNr contained '\d\+:'
    syntax match ex_SynLineNr contained '(\d\+)'

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exQF_GotoInSelectWindow()<CR>
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exQF_GotoInSelectWindow()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exQF_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exQF_ToggleWindow('Select')<CR>

    nnoremap <buffer> <silent> <C-Right>   :call <SID>exQF_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exQF_SwitchWindow('QuickView')<CR>

    nnoremap <silent> <buffer> <C-Up> :call g:ex_CursorJump( '\(error\\|warning\)', 'up' )<CR>
    nnoremap <silent> <buffer> <C-Down> :call g:ex_CursorJump( '\(error\\|warning\)', 'down' )<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exQF_GotoInSelectWindow() " <<<
    let s:exQF_select_idx = line(".")
    call g:ex_HighlightConfirmLine()
    call s:exQF_Goto(-1)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update exQuickFix window 
" ------------------------------------------------------------------ 

function g:exQF_UpdateSelectWindow() " <<<
    silent call cursor(s:exQF_select_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: get error file and load quick fix list
" ------------------------------------------------------------------ 

function s:exQF_GetQuickFixResult( file_name ) " <<<
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
        
        " choose compiler
        let s:exQF_compiler = 'gcc'
        for line in readfile( full_file_name, '', 2 )
            " process gcc error log formation
            if match(line, '^<<<<<< \S\+: ' . "'" . '\a\+\' . "'" ) != -1
                let s:exQF_compiler = 'exgcc'
            elseif match(line, '^<<<<<< \S\+ error log >>>>>>') != -1
                " TODO: use the text choose compiler
                let s:exQF_compiler = 'msvc2005'
            elseif match(line, '^.*------ Build started.*------') != -1
                let s:exQF_compiler = 'msvc2005'
            endif
        endfor

        " load the quick fix list
        let g:test = s:exQF_compiler
        let s:exQF_compile_dir = g:exES_PWD
        let cur_dir = getcwd()

        " FIXME: this is a bug, the :comiler! xxx not have effect at second time
        silent! exec 'compiler! '.s:exQF_compiler
        if s:exQF_compiler == 'exgcc'
            silent set errorformat=\%*[^\"]\"%f\"%*\\D%l:\ %m
            silent set errorformat+=\"%f\"%*\\D%l:\ %m
            silent set errorformat+=%-G%f:%l:\ %trror:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once
            silent set errorformat+=%-G%f:%l:\ %trror:\ for\ each\ function\ it\ appears\ in.)
            silent set errorformat+=%f:%l:\ %m
            silent set errorformat+=\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m
            silent set errorformat+=%D%\\S%\\+:\ Entering\ directory\ '%f'%.%#
            silent set errorformat+=%X%\\S%\\+:\ Leaving\ directory\ '%f'%.%#
            silent set errorformat+=%DEntering\ directory\ '%f'%.%#
            silent set errorformat+=%XLeaving\ directory\ '%f'%.%#
            silent set errorformat+=%D\<\<\<\<\<\<\ %\\S%\\+:\ '%f'%.%#
            silent set errorformat+=%X\>\>\>\>\>\>\ %\\S%\\+:\ '%f'%.%#
        elseif s:exQF_compiler == 'msvc2005'
            silent set errorformat=%D%\\d%\\+\>------\ %.%#Project:\ %f%.%#%\\,%.%#
            silent set errorformat+=%X%\\d%\\+\>%.%#%\\d%\\+\ error(s)%.%#%\\d%\\+\ warning(s)
            silent set errorformat+=%\\d%\\+\>%f(%l)\ :\ %t%*\\D%n:\ %m
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
        else
            exe gs_winnr . 'wincmd w'
        endif

        " clear all the text and put the text to the buffer, by YJR
        normal! gg"_dG
        silent call append( 0 , readfile( full_file_name ) )
        silent normal gg

        "
        if s:exQF_compiler != 'exgcc'
            silent exec 'sort /^\d\+>/ or'
        endif

        " get the quick fix result
        silent exec 'cd '.s:exQF_compile_dir
        silent exec 'cgetb'
        silent exec 'cd '.cur_dir
    else
        call g:ex_WarningMsg('file: ' . full_file_name . ' not found')
    endif
endfunction " >>>

" ======================================================== 
" quick view window functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Init exQuickFix select window
" ------------------------------------------------------------------ 

function g:exQF_InitQuickViewWindow() " <<<
    setlocal number
    " syntax highlight
    syntax region exQF_FileLineRegion start='^[^:<].*:\(\d\+:\|(\d\+)\)*'  end="$" contains=ex_SynFileName,ex_SynLineNr
    syntax match ex_SynFileName contained  '^[^:]*:'
    syntax match ex_SynFileName contained '.*\ze(\d\+)'
    syntax match ex_SynLineNr contained '\d\+:'
    syntax match ex_SynLineNr contained '(\d\+)'

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

" ------------------------------------------------------------------ 
" Desc: Update exQuickFix window 
" ------------------------------------------------------------------ 

function g:exQF_UpdateQuickViewWindow() " <<<
    silent call cursor(s:exQF_quick_view_idx, 1)
    call g:ex_HighlightConfirmLine()
    if s:exQF_need_update_quick_view_window
        let s:exQF_need_update_quick_view_window = 0

        "
        let reg_q = @q
        silent redir @q
        silent! exec 'cl'
        silent redir END
        silent exec 'normal! G"_dgg'
        silent put! = @q
        let @q = reg_q
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exQF_GotoInQuickViewWindow() " <<<
    let s:exQF_quick_view_idx = line(".")
    call g:ex_HighlightConfirmLine()
    let cur_line = getline('.')
    let idx_start = match(cur_line, '\d\+' )
    let idx_end = matchend(cur_line, '\d\+' )
    let idx = eval(strpart(getline('.'),idx_start,idx_end))
    call s:exQF_Goto(idx)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: copy the quick view result with search pattern
" ------------------------------------------------------------------ 

function s:exQF_CopyPickedLine( search_pattern, line_start, line_end, search_method ) " <<<
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
            silent exec 'normal! j"_dG'
        endif
        " clear up lines
        if a:line_start > 1
            silent call cursor( a:line_start, 1 )
            silent exec 'normal! k"_dgg'
        endif
        silent call cursor( 1, 1 )

        " clear the last search result
        if !empty( s:exQF_picked_search_result )
            silent call remove( s:exQF_picked_search_result, 0, len(s:exQF_picked_search_result)-1 )
        endif

        silent exec 'v/' . full_search_pattern . '/d'

        " clear pattern result
        while search('----------.\+----------', 'w') != 0
            silent exec 'normal! "_dd'
        endwhile

        " copy picked result
        let s:exQF_picked_search_result = getline(1,'$')

        " recover
        silent exec 'normal! u'

        " go back to the original position
        silent call setpos(".", save_cursor)
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: show the picked result in the quick view window
" ------------------------------------------------------------------ 

function s:exQF_ShowPickedResult( search_pattern, line_start, line_end, edit_mode, search_method ) " <<<
    call s:exQF_CopyPickedLine( a:search_pattern, a:line_start, a:line_end, a:search_method )
    call s:exQF_SwitchWindow('QuickView')
    if a:edit_mode == 'replace'
        silent exec 'normal! G"_dgg'
        silent put = s:exQF_quick_view_search_pattern
        "silent put = s:exQF_fold_start
        silent put = s:exQF_picked_search_result
        "silent put = s:exQF_fold_end
    elseif a:edit_mode == 'append'
        silent exec 'normal! G'
        silent put = ''
        silent put = s:exQF_quick_view_search_pattern
        "silent put = s:exQF_fold_start
        silent put = s:exQF_picked_search_result
        "silent put = s:exQF_fold_end
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: show the picked result in the quick view window
" ------------------------------------------------------------------ 

function s:exQF_ShowPickedResultNormalMode( search_pattern, edit_mode, search_method ) " <<<
    let line_start = 1
    let line_end = line('$')
    call s:exQF_ShowPickedResult( a:search_pattern, line_start, line_end, a:edit_mode, a:search_method )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: show the picked result in the quick view window
" ------------------------------------------------------------------ 

function s:exQF_ShowPickedResultVisualMode( search_pattern, edit_mode, search_method ) " <<<
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

"/////////////////////////////////////////////////////////////////////////////
" Commands
"/////////////////////////////////////////////////////////////////////////////

command -nargs=1 QF call s:exQF_GetQuickFixResult('<args>')
command ExqfToggle call s:exQF_ToggleWindow('')
command ExqfSelectToggle call s:exQF_ToggleWindow('Select')
command ExqfQuickViewToggle call s:exQF_ToggleWindow('QuickView')

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
