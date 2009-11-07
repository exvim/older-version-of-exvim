" ======================================================================================
" File         : exCscope.vim
" Author       : Wu Jie 
" Last Change  : 10/18/2008 | 18:56:31 PM | Saturday,October
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_excscope') || &cp
    finish
endif
let loaded_excscope=1

"/////////////////////////////////////////////////////////////////////////////
" Variables
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" gloable varialbe initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: window height for horizon window mode
" ------------------------------------------------------------------ 

if !exists('g:exCS_window_height')
    let g:exCS_window_height = 20
endif

" ------------------------------------------------------------------ 
" Desc: window width for vertical window mode
" ------------------------------------------------------------------ 

if !exists('g:exCS_window_width')
    let g:exCS_window_width = 48
endif

" ------------------------------------------------------------------ 
" Desc: window height increment value
" ------------------------------------------------------------------ 

if !exists('g:exCS_window_height_increment')
    let g:exCS_window_height_increment = 30
endif

" ------------------------------------------------------------------ 
" Desc: window width increment value
" ------------------------------------------------------------------ 

if !exists('g:exCS_window_width_increment')
    let g:exCS_window_width_increment = 50
endif

" ------------------------------------------------------------------ 
" Desc: placement of the window
" 'topleft','botright','belowright'
" ------------------------------------------------------------------ 

if !exists('g:exCS_window_direction')
    let g:exCS_window_direction = 'belowright'
endif

" ------------------------------------------------------------------ 
" Desc: use vertical or not
" ------------------------------------------------------------------ 

if !exists('g:exCS_use_vertical_window')
    let g:exCS_use_vertical_window = 0
endif

" ------------------------------------------------------------------ 
" Desc: go back to edit buffer
" ------------------------------------------------------------------ 

if !exists('g:exCS_backto_editbuf')
    let g:exCS_backto_editbuf = 0
endif

" ------------------------------------------------------------------ 
" Desc: go and close exTagSelect window
" ------------------------------------------------------------------ 

if !exists('g:exCS_close_when_selected')
    let g:exCS_close_when_selected = 0
endif

" ------------------------------------------------------------------ 
" Desc: set edit mode
" 'none', 'append', 'replace'
" ------------------------------------------------------------------ 

if !exists('g:exCS_edit_mode')
    let g:exCS_edit_mode = 'replace'
endif

" ------------------------------------------------------------------ 
" Desc: use syntax highlight for search result
" ------------------------------------------------------------------ 

if !exists('g:exCS_highlight_result')
    let g:exCS_highlight_result = 0
endif

" ======================================================== 
" local variable initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: titles
" ------------------------------------------------------------------ 

let s:exCS_select_title = '__exCS_SelectWindow__'
let s:exCS_quick_view_title = '__exCS_QuickViewWindow__'
let s:exCS_short_title = 'Select'

" ------------------------------------------------------------------ 
" Desc: general
" ------------------------------------------------------------------ 

let s:exCS_fold_start = '<<<<<<'
let s:exCS_fold_end = '>>>>>>'
let s:exCS_ignore_case = 1
let s:exCS_need_search_again = 0

" ------------------------------------------------------------------ 
" Desc: select variable
" ------------------------------------------------------------------ 

let s:exCS_select_idx = 1

" ------------------------------------------------------------------ 
" Desc: quick view variable
" ------------------------------------------------------------------ 

let s:exCS_quick_view_idx = 1
let s:exCS_picked_search_result = []
let s:exCS_quick_view_search_pattern = ''

"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
"  gerneral functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Open exGlobalSearch window 
" ------------------------------------------------------------------ 
"
function s:exCS_OpenWindow( short_title ) " <<<
    if a:short_title != ''
        let s:exCS_short_title = a:short_title
    endif
    let title = '__exCS_' . s:exCS_short_title . 'Window__'
    " open window
    if g:exCS_use_vertical_window
        call exUtility#OpenWindow( title, g:exCS_window_direction, g:exCS_window_width, g:exCS_use_vertical_window, g:exCS_edit_mode, 1, 'g:exCS_Init'.s:exCS_short_title.'Window', 'g:exCS_Update'.s:exCS_short_title.'Window' )
    else
        call exUtility#OpenWindow( title, g:exCS_window_direction, g:exCS_window_height, g:exCS_use_vertical_window, g:exCS_edit_mode, 1, 'g:exCS_Init'.s:exCS_short_title.'Window', 'g:exCS_Update'.s:exCS_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize the window use the increase value
" ------------------------------------------------------------------ 

function s:exCS_ResizeWindow() " <<<
    if g:exCS_use_vertical_window
        call exUtility#ResizeWindow( g:exCS_use_vertical_window, g:exCS_window_width, g:exCS_window_width_increment )
    else
        call exUtility#ResizeWindow( g:exCS_use_vertical_window, g:exCS_window_height, g:exCS_window_height_increment )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Toggle the window
" ------------------------------------------------------------------ 

function s:exCS_ToggleWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exCS_short_title != a:short_title
            if bufwinnr('__exCS_' . s:exCS_short_title . 'Window__') != -1
                call exUtility#CloseWindow('__exCS_' . s:exCS_short_title . 'Window__')
            endif
            let s:exCS_short_title = a:short_title
        endif
    endif

    " toggle exCS window
    let title = '__exCS_' . s:exCS_short_title . 'Window__'
    if g:exCS_use_vertical_window
        call exUtility#ToggleWindow( title, g:exCS_window_direction, g:exCS_window_width, g:exCS_use_vertical_window, 'none', 0, 'g:exCS_Init'.s:exCS_short_title.'Window', 'g:exCS_Update'.s:exCS_short_title.'Window' )
    else
        call exUtility#ToggleWindow( title, g:exCS_window_direction, g:exCS_window_height, g:exCS_use_vertical_window, 'none', 0, 'g:exCS_Init'.s:exCS_short_title.'Window', 'g:exCS_Update'.s:exCS_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exCS_SwitchWindow( short_title ) " <<<
    let title = '__exCS_' . a:short_title . 'Window__'
    if bufwinnr(title) == -1
        " save the old height & width
        let old_height = g:exCS_window_height
        let old_width = g:exCS_window_width

        " use the width & height of current window if it is same plugin window.
        if bufname ('%') ==# s:exCS_select_title || bufname ('%') ==# s:exCS_quick_view_title 
            let g:exCS_window_height = winheight('.')
            let g:exCS_window_width = winwidth('.')
        endif

        " switch to the new plugin window
        call s:exCS_ToggleWindow(a:short_title)

        " recover the width and height
        let g:exCS_window_height = old_height
        let g:exCS_window_width = old_width
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:exCS_ConnectCscopeFile() " <<<
    " don't show any message
	setlocal nocsverb
    " connect cscope files
    silent exec "cscope add " . g:exES_Cscope
	silent! setlocal cscopequickfix=s-,c-,d-,i-,t-,e-
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exCS_Goto() " <<<
    " check if the line can jump
    let line = getline('.')

    " process jump
    if line =~ '^ \[\d\+\]' " quickfix list jump
        " get the quick fix idx and item
        let start_idx = stridx(line,"[")+1
        let end_idx = stridx(line,"]")
        let qf_idx = str2nr( strpart(line, start_idx, end_idx-start_idx) )
        let qf_list = getqflist()
        let qf_item = qf_list[qf_idx]

        " start jump
        call exUtility#GotoEditBuffer()
        if bufnr('%') != qf_item.bufnr
            exe 'silent e ' . bufname(qf_item.bufnr)
        endif
        call cursor( qf_item.lnum, qf_item.col )
    elseif line =~ '^\S\+:\d\+:\s<<\S\+>>' " g method jump
        " get elements in location line ( file name, line )
        let line = getline('.')
        let elements = split ( line, ':' )

        " start jump
        if !empty(elements)
            call exUtility#GotoEditBuffer()
            exe 'silent e ' . elements[0]
            exec 'call cursor(elements[1], 1)'
        endif
    else
        call exUtility#WarningMsg("could not jump")
        return 0
    endif

    " go back if needed
    let title = '__exCS_' . s:exCS_short_title . 'Window__'
    call exUtility#OperateWindow ( title, g:exCS_close_when_selected, g:exCS_backto_editbuf, 1 )

    return 1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exCS_GoDirect( search_method ) " <<<
    let search_text = ''
    if a:search_method ==# 'i' " including file
        let search_text = expand("<cfile>".":t")
    else
        let search_text = expand("<cword>")
    endif

    call s:exCS_GetSearchResult(search_text, a:search_method)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exCS_ShowQuickFixResult( search_method, g_method_result_list ) " <<<
    " processing search result
    let result_list = getqflist()
    if !empty(a:g_method_result_list) 
        let result_list = a:g_method_result_list
    endif

    " processing result
    if a:search_method ==# 'da' " all called function
        let last_bufnr = -1
        let qf_idx = 0
        for item in result_list
            if last_bufnr != item.bufnr
                let convert_file_name = exUtility#ConvertFileName( bufname(item.bufnr) )
                silent put = convert_file_name 
                let last_bufnr = item.bufnr
            endif
            let start_idx = stridx( item.text, "<<")+2
            let end_idx = stridx( item.text, ">>")
            let len = end_idx - start_idx
            let text_line = printf(" [%03d] %-40s | <%04d> %s", qf_idx, strpart( item.text, start_idx, len ), item.lnum, strpart( item.text, end_idx+2 ) )
            silent put = text_line 
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 'ds' " select called function
        " TODO: " ::\S\+\_s\+(
        let cur_bufnr = exUtility#GetEditBufferNum()
        let qf_idx = 0
        for item in result_list
            if cur_bufnr == item.bufnr
                let start_idx = stridx( item.text, "<<")+2
                let end_idx = stridx( item.text, ">>")
                let len = end_idx - start_idx
                let text_line = printf(" [%03d] %-40s | <%04d> %s", qf_idx, strpart( item.text, start_idx, len ), item.lnum, strpart( item.text, end_idx+2 ) )
                silent put = text_line 
            endif
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 'c' " calling function
        let qf_idx = 0
        for item in result_list
            let start_idx = stridx( item.text, "<<")+2
            let end_idx = stridx( item.text, ">>")
            let len = end_idx - start_idx
            let text_line = printf(" [%03d] %s:%d: <<%s>> %s", qf_idx, bufname(item.bufnr), item.lnum, strpart( item.text, start_idx, len ), strpart( item.text, end_idx+2 ) )
            silent put = text_line 
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 'i' " including file
        let qf_idx = 0
        for item in result_list
            let convert_file_name = exUtility#ConvertFileName( bufname(item.bufnr) )
            let start_idx = stridx( convert_file_name, "(")
            let short_name = strpart( convert_file_name, 0, start_idx )
            let path_name = strpart( convert_file_name, start_idx )
            let text_line = printf(" [%03d] %-36s <%02d> %s", qf_idx, short_name, item.lnum, path_name )
            silent put = text_line 
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 's' " C symbol
        let qf_idx = 0
        for item in result_list
            let start_idx = stridx( item.text, "<<")+2
            let end_idx = stridx( item.text, ">>")
            let len = end_idx - start_idx
            let text_line = printf(" [%03d] %s:%d: <<%s>> %s", qf_idx, bufname(item.bufnr), item.lnum, strpart( item.text, start_idx, len ), strpart( item.text, end_idx+3 ) )
            silent put = text_line 
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 'g' " definition
        let text = ''
        for item in result_list
            if item =~# '^\S\+' || item =~# '^\s\+\#\s\+line\s\+filename \/ context \/ line'
                continue
            endif

            " if this is a location line
            if item =~# '^\s\+\d\+\s\+\d\+\s\+\S\+\s\+<<\S\+>>'
                let elements = split ( item, '\s\+' )
                if len(elements) == 4  
                    let text = elements[2].':'.elements[1].':'.' '.elements[3]
                else
                    call exUtility#WarningMsg ('invalid line')
                endif
                continue
            endif

            " put context line
            let context = strpart( item, match(item, '\S') )
            silent put = text . ' ' . context 
        endfor
    elseif a:search_method ==# 'e' " egrep
        let qf_idx = 0
        for item in result_list
            let end_idx = stridx( item.text, ">>")
            let text_line = printf(" [%03d] %s:%d: %s", qf_idx, bufname(item.bufnr), item.lnum, strpart( item.text, end_idx+3 ) )
            silent put = text_line 
            let qf_idx += 1
        endfor
    else
        call exUtility#WarningMsg("Wrong search method")
        return
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exCS_ParseFunction() " <<<
    " if we have taglist use it
    if exists(':Tlist')
        silent exec "TlistUpdate"
        let search_text = Tlist_Get_Tagname_By_Line()
        if search_text == ""
            call exUtility#WarningMsg("pattern not found, you're not in a function")
            return
        endif
    else
        let search_text = expand("<cword>")
    endif
    call s:exCS_GetSearchResult(search_text, 'ds')
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exCS_MapPickupResultKeys() " <<<
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exCS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exCS_SwitchWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <Leader>r :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <Leader>d :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'pattern', 1)<CR>
    " DISABLE { 
    " nnoremap <buffer> <silent> <Leader>ar :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'pattern', 0)<CR>
    " nnoremap <buffer> <silent> <Leader>ad :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'pattern', 1)<CR>
    " vnoremap <buffer> <silent> <Leader>r <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'pattern', 0)<CR>
    " vnoremap <buffer> <silent> <Leader>d <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'pattern', 1)<CR>
    " vnoremap <buffer> <silent> <Leader>ar <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'pattern', 0)<CR>
    " vnoremap <buffer> <silent> <Leader>ad <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'pattern', 1)<CR>

    " nnoremap <buffer> <silent> <Leader>fr :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'file', 0)<CR>
    " nnoremap <buffer> <silent> <Leader>fd :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'file', 1)<CR>
    " nnoremap <buffer> <silent> <Leader>far :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'file', 0)<CR>
    " nnoremap <buffer> <silent> <Leader>fad :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'file', 1)<CR>
    " vnoremap <buffer> <silent> <Leader>fr <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'file', 0)<CR>
    " vnoremap <buffer> <silent> <Leader>fd <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'file', 1)<CR>
    " vnoremap <buffer> <silent> <Leader>far <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'file', 0)<CR>
    " vnoremap <buffer> <silent> <Leader>fad <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'file', 1)<CR>

    " nnoremap <buffer> <silent> <Leader>gr :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', '', 0)<CR>
    " nnoremap <buffer> <silent> <Leader>gd :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', '', 1)<CR>
    " nnoremap <buffer> <silent> <Leader>gar :call <SID>exCS_ShowPickedResultNormalMode('', 'append', '', 0)<CR>
    " nnoremap <buffer> <silent> <Leader>gad :call <SID>exCS_ShowPickedResultNormalMode('', 'append', '', 1)<CR>
    " vnoremap <buffer> <silent> <Leader>gr <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', '', 0)<CR>
    " vnoremap <buffer> <silent> <Leader>gd <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', '', 1)<CR>
    " vnoremap <buffer> <silent> <Leader>gar <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', '', 0)<CR>
    " vnoremap <buffer> <silent> <Leader>gad <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', '', 1)<CR>
    " } DISABLE end 
endfunction " >>>

" ======================================================== 
" select window functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Init exGlobalSearch window
" ------------------------------------------------------------------ 

function g:exCS_InitSelectWindow() " <<<
    silent! setlocal nonumber
    
    " if no scope connect yet, connect it
    if !exists('g:exES_Cscope')
        let g:exES_Cscope = './'.g:exES_vimfiles_dirname.'/cscope.out'
    endif
    if cscope_connection(4, "cscope.out", g:exES_Cscope ) == 0
        call g:exCS_ConnectCscopeFile()
    endif

    " code highlight
    if g:exCS_highlight_result
        " this will load the syntax highlight as cpp for search result
        silent exec "so $VIM/vimfiles/after/syntax/exUtility.vim"
    endif

    " syntax highlights
    syntax region ex_SynSearchPattern start="^----------" end="----------"

    " syntax for pattern [qf_nr] preview <<line>> | context
    syntax region exCS_SynDummy start='^ \[\d\+\]\s' end='<\d\+>' oneline keepend contains=exCS_SynQfNumber,ex_SynLineNr
    syntax match exCS_SynQfNumber '^ \[\d\+\]' contained
    syntax match ex_SynLineNr '<\d\+>' contained

    " syntax for pattern [qf_nr] file_name:line: <<fn>> context
    syntax match exCS_SynDummy '^\S\+:\d\+:\s<<\S\+>>' contains=exCS_SynLineNr2,ex_SynFileName,exCS_DefType
    syntax match exCS_SynDummy '^ \[\d\+\]\s\S\+:\d\+:\(\s<<\S\+>>\)*' contains=exCS_SynQfNumber,exCS_SynLineNr2,exCS_SynFileName2,exCS_DefType
    syntax match exCS_SynLineNr2 '\d\+:' contained
    syntax region ex_SynFileName start="^[^:]*" end=":" keepend oneline contained
    syntax region exCS_SynFileName2 start="^ \[\d\+\]\s[^:]*" end=":" keepend oneline contained contains=exCS_SynQfNumber
    syntax match exCS_DefType '<<\S\+>>' contained

    "
    hi link exCS_SynFileName2 ex_SynFileName
    hi link exCS_SynLineNr2 ex_SynLineNr
    hi link exCS_DefType Special

    " key map
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exCS_ToggleWindow('Select')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exCS_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exCS_GotoInSelectWindow()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exCS_GotoInSelectWindow()<CR>

    "
    call s:exCS_MapPickupResultKeys()


    " TODO: shrink text for d method

    " autocmd
    au CursorMoved <buffer> :call exUtility#HighlightSelectLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exCS_GotoInSelectWindow() " <<<
    let s:exCS_select_idx = line(".")
    call exUtility#HighlightConfirmLine()
    call s:exCS_Goto()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update exGlobalSearch window 
" ------------------------------------------------------------------ 

function g:exCS_UpdateSelectWindow() " <<<
    silent call cursor(s:exCS_select_idx, 1)
    call exUtility#HighlightConfirmLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Get Global Search Result
" search_pattern = ''
" search_method = -s / -r / -w
" ------------------------------------------------------------------ 

function s:exCS_GetSearchResult(search_pattern, search_method) " <<<
    " if cscope file not connect, connect it
    if cscope_connection(4, "cscope.out", g:exES_Cscope ) == 0
        call g:exCS_ConnectCscopeFile()
    endif

    " jump back to edit buffer first
    call exUtility#GotoEditBuffer()

    " change window for suitable search method
    let search_result = ''
    let g:exCS_use_vertical_window = 0
    let g:exCS_window_direction = 'bel'

    if a:search_method =~# '\(d\|i\)'
        let g:exCS_use_vertical_window = 1
        let g:exCS_window_direction = 'botright'
    elseif a:search_method ==# 'g' " NOTE: the defination result not go into quickfix list
        silent redir =>search_result
    endif

    " start processing cscope
    let search_cmd = 'cscope find ' . a:search_method . ' ' . a:search_pattern
    try
        silent exec search_cmd
    catch /^Vim\%((\a\+)\)\=:E259/
        "call exUtility#WarningMsg("no matches found for " . a:search_pattern )
        echohl WarningMsg
        echon "no matches found for " . a:search_pattern . "\r"
        echohl None
        return
    endtry

    " finish redir if it is method 'g'
    let result_list = []
    if a:search_method ==# 'g' 
        silent redir END
        let result_list = split( search_result, "\n" ) 

        " NOTE: in cscope find g, if there is no search result, that means it
        "       only have one result, and it will perform a jump directly
        if len(result_list) == 1
            return
        endif
    else
        " go back 
        silent exec "normal! \<c-o>"
    endif

    " open and goto search window first
    let cs_winnr = bufwinnr(s:exCS_select_title)
    if cs_winnr != -1
        call exUtility#CloseWindow(s:exCS_select_title)
    endif
    call s:exCS_ToggleWindow('Select')

    " clear screen and put new result
    silent exec '1,$d _'
    call exUtility#HighlightConfirmLine()

    " processing search result
    let search_method_text = 'unknown'
    if a:search_method ==# 'da' " all called function
        let search_method_text = '(called functions all)'
    elseif a:search_method ==# 'ds' " select called function
        let search_method_text = '(called functions current)'
    elseif a:search_method ==# 'c' " calling function
        let search_method_text = '(calling functions)'
    elseif a:search_method ==# 'i' " including file
        let search_method_text = '(including files)'
    elseif a:search_method ==# 's' " C symbol
        let search_method_text = '(C symbols)'
    elseif a:search_method ==# 'g' " definition
        let search_method_text = '(definitions)'
    elseif a:search_method ==# 'e' " egrep
        let search_method_text = '(egrep results)'
    endif

    let pattern_title = '----------' . a:search_pattern . ' ' . search_method_text . '----------'
    silent put = pattern_title 
    call s:exCS_ShowQuickFixResult( a:search_method, result_list )

    " Init search state
    silent normal gg
    let line_num = search(pattern_title)
    let s:exCS_select_idx = line_num+1
    silent call cursor( s:exCS_select_idx, 1 )
    silent normal zz
endfunction " >>>

" ======================================================== 
"  quick view window part
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Init exGlobalSearch select window
" ------------------------------------------------------------------ 

function g:exCS_InitQuickViewWindow() " <<<
    silent! setlocal nonumber
    setlocal foldmethod=marker foldmarker=<<<<<<,>>>>>> foldlevel=1

    " syntax highlights
    syntax match ex_SynFold '<<<<<<'
    syntax match ex_SynFold '>>>>>>'
    syntax region ex_SynSearchPattern start="^----------" end="----------"

    " syntax for pattern [qf_nr] preview <<line>> | context
    syntax region exCS_SynDummy start='^ \[\d\+\]\s' end='<\d\+>' oneline keepend contains=exCS_SynQfNumber,ex_SynLineNr
    syntax match exCS_SynQfNumber '^ \[\d\+\]' contained
    syntax match ex_SynLineNr '<\d\+>' contained

    " syntax for pattern [qf_nr] file_name:line: <<fn>> context
    syntax match exCS_SynDummy '^\S\+:\d\+:\s<<\S\+>>' contains=exCS_SynLineNr2,ex_SynFileName,exCS_DefType
    syntax match exCS_SynDummy '^ \[\d\+\]\s\S\+:\d\+:\(\s<<\S\+>>\)*' contains=exCS_SynQfNumber,exCS_SynLineNr2,exCS_SynFileName2,exCS_DefType
    syntax match exCS_SynLineNr2 '\d\+:' contained
    syntax region ex_SynFileName start="^[^:]*" end=":" oneline contained
    syntax region exCS_SynFileName2 start=" [^:]*" end=":" oneline contained contains=exCS_SynQfNumber
    syntax match exCS_DefType '<<\S\+>>' contained

    "
    hi link exCS_SynFileName2 ex_SynFileName
    hi link exCS_SynLineNr2 ex_SynLineNr
    hi link exCS_DefType Special

    " key map
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exCS_ToggleWindow('QuickView')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exCS_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exCS_GotoInQuickViewWindow()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exCS_GotoInQuickViewWindow()<CR>

    "
    call s:exCS_MapPickupResultKeys()

    " autocmd
    au CursorMoved <buffer> :call exUtility#HighlightSelectLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update exGlobalSearch QuickView window 
" ------------------------------------------------------------------ 

function g:exCS_UpdateQuickViewWindow() " <<<
    silent call cursor(s:exCS_quick_view_idx, 1)
    call exUtility#HighlightConfirmLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exCS_GotoInQuickViewWindow() " <<<
    let s:exCS_quick_view_idx = line(".")
    call exUtility#HighlightConfirmLine()
    call s:exCS_Goto()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: copy the quick view result with search pattern
" ------------------------------------------------------------------ 

function s:exCS_CopyPickedLine( search_pattern, line_start, line_end, search_method, inverse_search ) " <<<
    if a:search_pattern == ''
        let search_pattern = @/
    else
        let search_pattern = a:search_pattern
    endif
    if search_pattern == ''
        let s:exCS_quick_view_search_pattern = ''
        call exUtility#WarningMsg('search pattern not exists')
        return
    else
        let s:exCS_quick_view_search_pattern = '----------' . search_pattern . '----------'
        let full_search_pattern = search_pattern
        " DISABLE { 
        " if a:search_method == 'pattern'
        "     let full_search_pattern = '^ \[\d\+\]\S\+<\d\+>.*\zs' . search_pattern
        " elseif a:search_method == 'file'
        "     let full_search_pattern = '\(.\+<\d\+>\)\&' . search_pattern
        " endif
        " } DISABLE end 
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
        if !empty( s:exCS_picked_search_result )
            silent call remove( s:exCS_picked_search_result, 0, len(s:exCS_picked_search_result)-1 )
        endif

        " if inverse search, we first filter out not pattern line, then
        " then filter pattern
        if a:inverse_search
            " DISABLE: let search_results = '\(.\+<\d\+>\).*'
            let search_results = '\S\+'
            silent exec 'v/' . search_results . '/d'
            silent exec 'g/' . full_search_pattern . '/d'
        else
            silent exec 'v/' . full_search_pattern . '/d'
        endif

        " clear pattern result
        while search('----------.\+----------', 'w') != 0
            silent exec 'normal! "_dd'
        endwhile

        " copy picked result
        let s:exCS_picked_search_result = getline(1,'$')

        " recover
        silent exec 'normal! u'

        " go back to the original position
        silent call setpos(".", save_cursor)
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: show the picked result in the quick view window
" ------------------------------------------------------------------ 

function s:exCS_ShowPickedResult( search_pattern, line_start, line_end, edit_mode, search_method, inverse_search ) " <<<
    call s:exCS_CopyPickedLine( a:search_pattern, a:line_start, a:line_end, a:search_method, a:inverse_search )
    call s:exCS_SwitchWindow('QuickView')
    if a:edit_mode == 'replace'
        silent exec '1,$d _'
        let s:exCS_quick_view_idx = 1
        call exUtility#HighlightConfirmLine()
        silent put = s:exCS_quick_view_search_pattern
        silent put = s:exCS_fold_start
        silent put = s:exCS_picked_search_result
        silent put = s:exCS_fold_end
        silent call search('<<<<<<', 'w')
    elseif a:edit_mode == 'append'
        silent exec 'normal! G'
        silent put = ''
        silent put = s:exCS_quick_view_search_pattern
        silent put = s:exCS_fold_start
        silent put = s:exCS_picked_search_result
        silent put = s:exCS_fold_end
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: show the picked result in the quick view window
" ------------------------------------------------------------------ 

function s:exCS_ShowPickedResultNormalMode( search_pattern, edit_mode, search_method, inverse_search ) " <<<
    let line_start = 1
    let line_end = line('$')
    call s:exCS_ShowPickedResult( a:search_pattern, line_start, line_end, a:edit_mode, a:search_method, a:inverse_search )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: show the picked result in the quick view window
" ------------------------------------------------------------------ 

function s:exCS_ShowPickedResultVisualMode( search_pattern, edit_mode, search_method, inverse_search ) " <<<
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

    call s:exCS_ShowPickedResult( a:search_pattern, line_start, line_end, a:edit_mode, a:search_method, a:inverse_search )
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" Commands
"/////////////////////////////////////////////////////////////////////////////

command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile CSD call s:exCS_GetSearchResult('<args>', 'da')
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile CSC call s:exCS_GetSearchResult('<args>', 'c')
command -nargs=1 -complete=customlist,exUtility#CompleteByProjectFile CSI call s:exCS_GetSearchResult('<args>', 'i')
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile CSS call s:exCS_GetSearchResult('<args>', 's')
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile CSG call s:exCS_GetSearchResult('<args>', 'g')
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile CSE call s:exCS_GetSearchResult('<args>', 'e')

command ExcsToggle call s:exCS_ToggleWindow('')
command ExcsSelectToggle call s:exCS_ToggleWindow('Select')
command ExcsQuickViewToggle call s:exCS_ToggleWindow('QuickView')
command ExcsParseFunction call s:exCS_ParseFunction()

command CSDD call s:exCS_GoDirect('da')
command CSCD call s:exCS_GoDirect('c')
command CSID call s:exCS_GoDirect('i')
command CSIC call s:exCS_GetSearchResult(fnamemodify( bufname("%"), ":p:t" ), 'i')
command CSSD call s:exCS_GoDirect('s')
command CSGD call s:exCS_GoDirect('g')
command CSED call s:exCS_GoDirect('e')

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
