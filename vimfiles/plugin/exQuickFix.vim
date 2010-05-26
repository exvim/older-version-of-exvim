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
    let g:exQF_window_width_increment = 50
endif

" ------------------------------------------------------------------ 
" Desc: placement of the window
" 'topleft','botright','belowright'
" ------------------------------------------------------------------ 

if !exists('g:exQF_window_direction')
    let g:exQF_window_direction = 'belowright'
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
    let g:exQF_backto_editbuf = 0
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
let s:exQF_cur_filename = ''

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
                call exUtility#CloseWindow(_title)
            endif
            let s:exQF_short_title = a:short_title
        endif
    endif

    let title = '__exQF_' . s:exQF_short_title . 'Window__'
    " open window
    if g:exQF_use_vertical_window
        call exUtility#OpenWindow( title, g:exQF_window_direction, g:exQF_window_width, g:exQF_use_vertical_window, g:exQF_edit_mode, 1, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    else
        call exUtility#OpenWindow( title, g:exQF_window_direction, g:exQF_window_height, g:exQF_use_vertical_window, g:exQF_edit_mode, 1, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize the window use the increase value
" ------------------------------------------------------------------ 

function s:exQF_ResizeWindow() " <<<
    if g:exQF_use_vertical_window
        call exUtility#ResizeWindow( g:exQF_use_vertical_window, g:exQF_window_width, g:exQF_window_width_increment )
    else
        call exUtility#ResizeWindow( g:exQF_use_vertical_window, g:exQF_window_height, g:exQF_window_height_increment )
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
                call exUtility#CloseWindow(_title)
            endif
            let s:exQF_short_title = a:short_title
        endif
    endif

    let title = '__exQF_' . s:exQF_short_title . 'Window__'
    " toggle exQF window
    if g:exQF_use_vertical_window
        call exUtility#ToggleWindow( title, g:exQF_window_direction, g:exQF_window_width, g:exQF_use_vertical_window, 'none', 0, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    else
        call exUtility#ToggleWindow( title, g:exQF_window_direction, g:exQF_window_height, g:exQF_use_vertical_window, 'none', 0, 'g:exQF_Init'.s:exQF_short_title.'Window', 'g:exQF_Update'.s:exQF_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exQF_SwitchWindow( short_title ) " <<<
    let title = '__exQF_' . a:short_title . 'Window__'
    if bufwinnr(title) == -1
        " save the old height & width
        let old_height = g:exQF_window_height
        let old_width = g:exQF_window_width

        " use the width & height of current window if it is same plugin window.
        if bufname ('%') ==# s:exQF_select_title || bufname ('%') ==# s:exQF_quick_view_title
            let g:exQF_window_height = winheight('.')
            let g:exQF_window_width = winwidth('.')
        endif

        " switch to the new plugin window
        call s:exQF_ToggleWindow(a:short_title)

        " recover the width and height
        let g:exQF_window_height = old_height
        let g:exQF_window_width = old_width
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
    call exUtility#GotoEditBuffer()
    try
        silent exec "cr".idx
    catch /^Vim\%((\a\+)\)\=:E42/
        call exUtility#WarningMsg('No Errors')
    catch /^Vim\%((\a\+)\)\=:E325/ " this would happen when editting the same file with another programme.
        call exUtility#WarningMsg('Another programme is edit the same file.')
        try " now we try this again.
            silent exec "cr".idx
        catch /^Vim\%((\a\+)\)\=:E42/
            call exUtility#WarningMsg('No Errors')
        endtry
    endtry

    " go back if needed
    let title = '__exQF_' . s:exQF_short_title . 'Window__'
    call exUtility#OperateWindow ( title, g:exQF_close_when_selected, g:exQF_backto_editbuf, 1 )
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
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exQF_ToggleWindow('Select')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exQF_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exQF_GotoInSelectWindow()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exQF_GotoInSelectWindow()<CR>

    nnoremap <buffer> <silent> <C-Right>   :call <SID>exQF_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exQF_SwitchWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <C-Up> :call exUtility#CursorJump( '\(error\\|warning\)', 'up' )<CR>
    nnoremap <buffer> <silent> <C-Down> :call exUtility#CursorJump( '\(error\\|warning\)', 'down' )<CR>

    " let \p, p (including visual) can paste error and read to the quick fix list.
    nnoremap <buffer> <silent> <leader>p :call <SID>exQF_PasteQuickFixResult('*')<CR>
    nnoremap <buffer> <silent> p :call <SID>exQF_PasteQuickFixResult('"')<CR>
    vnoremap <buffer> <silent> <leader>p :call <SID>exQF_VisualPasteQuickFixResult('*')<CR>
    vnoremap <buffer> <silent> p :call <SID>exQF_VisualPasteQuickFixResult('"')<CR>

    " autocmd
    au CursorMoved <buffer> :call exUtility#HighlightSelectLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exQF_GotoInSelectWindow() " <<<
    let s:exQF_select_idx = line(".")
    call exUtility#HighlightConfirmLine()
    call s:exQF_Goto(-1)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update exQuickFix window 
" ------------------------------------------------------------------ 

function g:exQF_UpdateSelectWindow() " <<<
    silent call cursor(s:exQF_select_idx, 1)
    call exUtility#HighlightConfirmLine()
    if s:exQF_cur_filename != ''
        silent exec 'QF ' . s:exQF_cur_filename
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Paste the error result ro quickfix
" ------------------------------------------------------------------ 

function s:exQF_PasteQuickFixResult(register) " <<<
    silent exec '1,$d _'
    silent put! = getreg(a:register)
    silent normal gg

    " choose compiler automatically
    call s:exQF_ChooseCompiler ()

    " init compiler dir and current working dir
    let s:exQF_compile_dir = g:exES_CWD
    let cur_dir = getcwd()

    " get the quick fix result
    silent exec 'cd '.s:exQF_compile_dir
    silent exec 'cgetb'
    silent exec 'cd '.cur_dir
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Visual Paste the error result ro quickfix
" ------------------------------------------------------------------ 

function s:exQF_VisualPasteQuickFixResult(register) range " <<<
    call exUtility#WarningMsg('visual-paste not allowed! change to paste operation.')
    call s:exQF_PasteQuickFixResult(a:register)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: choose compiler 
" ------------------------------------------------------------------ 

function s:exQF_ChooseCompiler() " <<<
    " choose compiler
    let s:exQF_compiler = 'gcc'
    let multi_core = 0
    for line in getline( 1, 4 ) " actual we just need to check line 1-2, but give a protected buffer check to 4 in case. 
        " process gcc error log formation
        if match(line, '^<<<<<< \S\+: ' . "'" . '\a\+\' . "'" ) != -1
            let s:exQF_compiler = 'exgcc'
        elseif match(line, '^<<<<<< \S\+ error log >>>>>>') != -1
            " TODO: use the text choose compiler
            let s:exQF_compiler = 'exmsvc'
        elseif match(line, '^.*------ Build started.*------') != -1
            let s:exQF_compiler = 'exmsvc'
            if match(line, '^\d\+>') != -1
                let multi_core = 1
            endif
        elseif match(line, '^<<<<<< SWIG: ' ) != -1
            let s:exQF_compiler = 'swig'
        endif
    endfor

    " FIXME: this is a bug, the :comiler! xxx not have effect at second time
    " NOTE: the errorformat matches by order, so the first matches order will
    "       be used. That's why we put %f:%l:%c in front of %f:%l
    silent! exec 'compiler! '.s:exQF_compiler
    if s:exQF_compiler == 'exgcc'
        silent set errorformat=\%*[^\"]\"%f\"%*\\D%l:\ %m
        silent set errorformat+=\"%f\"%*\\D%l:\ %m
        silent set errorformat+=%-G%f:%l:\ %trror:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once
        silent set errorformat+=%-G%f:%l:\ %trror:\ for\ each\ function\ it\ appears\ in.)
        silent set errorformat+=%f:%l:%c:\ %m
        silent set errorformat+=%f:%l:\ %m
        silent set errorformat+=\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m
        silent set errorformat+=%D%\\S%\\+:\ Entering\ directory\ '%f'%.%#
        silent set errorformat+=%X%\\S%\\+:\ Leaving\ directory\ '%f'%.%#
        silent set errorformat+=%DEntering\ directory\ '%f'%.%#
        silent set errorformat+=%XLeaving\ directory\ '%f'%.%#
        silent set errorformat+=%D\<\<\<\<\<\<\ %\\S%\\+:\ '%f'%.%#
        silent set errorformat+=%X\>\>\>\>\>\>\ %\\S%\\+:\ '%f'%.%#
    elseif s:exQF_compiler == 'exmsvc'
        if multi_core
            silent set errorformat=%D%\\d%\\+\>------\ %.%#Project:\ %f%.%#%\\,%.%#
            silent set errorformat+=%X%\\d%\\+\>%.%#%\\d%\\+\ error(s)%.%#%\\d%\\+\ warning(s)
            silent set errorformat+=%\\d%\\+\>%f(%l)\ :\ %t%*\\D%n:\ %m
            silent set errorformat+=%\\d%\\+\>\ %#%f(%l)\ :\ %m
        else
            silent set errorformat=%D------\ %.%#Project:\ %f%.%#%\\,%.%#
            silent set errorformat+=%X%%.%#%\\d%\\+\ error(s)%.%#%\\d%\\+\ warning(s)
            silent set errorformat+=%f(%l)\ :\ %t%*\\D%n:\ %m
            silent set errorformat+=\ %#%f(%l)\ :\ %m
        endif
        silent set errorformat+=%f(%l\\,%c):\ %m " csharp error-format
    elseif s:exQF_compiler == 'swig'
        silent set errorformat+=%f(%l):\ %m
    elseif s:exQF_compiler == 'gcc'
        " this is for exGlobaSearch result, some one may copy the global search result to exQuickFix
        silent set errorformat+=%f:%l:%m
        silent set errorformat+=%f(%l\\,%c):\ %m " fxc shader error-format
        silent set errorformat+=%f:%l:\ %t:\ %m
    endif

    "
    let error_pattern = '^\d\+>'
    if s:exQF_compiler != 'exgcc' && search(error_pattern, 'W') != 0
        silent exec 'sort nr /'.error_pattern.'/'
    endif
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
        " save the file size end file name
        let s:exQF_error_file_size = getfsize(full_file_name)
        let s:exQF_cur_filename = full_file_name

        " update quick view window
        let s:exQF_need_update_quick_view_window = 1

        " open and goto search window first
        let gs_winnr = bufwinnr(s:exQF_select_title)
        if gs_winnr == -1
            " open window
            call s:exQF_ToggleWindow('Select')
        else
            exe gs_winnr . 'wincmd w'
        endif

        " clear all the text and put the text to the buffer, by YJR
        silent exec '1,$d _'
        silent call append( 0 , readfile( full_file_name ) )
        silent normal gg
        
        " choose compiler automatically
        call s:exQF_ChooseCompiler ()

        " init compiler dir and current working dir
        let s:exQF_compile_dir = g:exES_CWD
        let cur_dir = getcwd()

        " get the quick fix result
        silent exec 'cd '.s:exQF_compile_dir
        silent exec 'cgetb'
        silent exec 'cd '.cur_dir
    else
        call exUtility#WarningMsg('file: ' . full_file_name . ' not found')
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
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exQF_ToggleWindow('QuickView')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exQF_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exQF_GotoInQuickViewWindow()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exQF_GotoInQuickViewWindow()<CR>

    nnoremap <buffer> <silent> <C-Right>   :call <SID>exQF_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exQF_SwitchWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <Leader>r :call <SID>exQF_ShowPickedResultNormalMode('', 'replace', 'pattern')<CR>
    vnoremap <buffer> <silent> <Leader>r <ESC>:call <SID>exQF_ShowPickedResultVisualMode('', 'replace', 'pattern')<CR>

    " autocmd
    au CursorMoved <buffer> :call exUtility#HighlightSelectLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update exQuickFix window 
" ------------------------------------------------------------------ 

function g:exQF_UpdateQuickViewWindow() " <<<
    silent call cursor(s:exQF_quick_view_idx, 1)
    call exUtility#HighlightConfirmLine()
    if s:exQF_need_update_quick_view_window
        let s:exQF_need_update_quick_view_window = 0

        "
        silent redir =>quickfix_list
        silent! exec 'cl'
        silent redir END
        silent exec '1,$d _'
        silent put! = quickfix_list
        silent exec 'normal! gg'
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exQF_GotoInQuickViewWindow() " <<<
    let s:exQF_quick_view_idx = line(".")
    call exUtility#HighlightConfirmLine()
    let cur_line = getline('.')
    " if this is empty line, skip check
    if cur_line == ""
        call exUtility#WarningMsg('pls select a quickfix result')
        return
    endif
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
        call exUtility#WarningMsg('search pattern not exists')
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
        silent exec '1,$d _'
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

command -nargs=1 -complete=file QF call s:exQF_GetQuickFixResult('<args>')
command ExqfToggle call s:exQF_ToggleWindow('')
command ExqfSelectToggle call s:exQF_ToggleWindow('Select')
command ExqfQuickViewToggle call s:exQF_ToggleWindow('QuickView')

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
