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
    let g:exCS_window_width = 30
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
    let g:exCS_window_width_increment = 100
endif

" ------------------------------------------------------------------ 
" Desc: go back to edit buffer
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
    let g:exCS_backto_editbuf = 1
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

" ======================================================== 
" syntax highlight
" ======================================================== 

hi def exCS_SynQfNumber gui=none guifg=Red term=none cterm=none ctermfg=Red

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
        call exUtility#OpenWindow( title, g:exCS_window_direction, g:exCS_window_width, g:exCS_use_vertical_window, g:exCS_edit_mode, g:exCS_backto_editbuf, 'g:exCS_Init'.s:exCS_short_title.'Window', 'g:exCS_Update'.s:exCS_short_title.'Window' )
    else
        call exUtility#OpenWindow( title, g:exCS_window_direction, g:exCS_window_height, g:exCS_use_vertical_window, g:exCS_edit_mode, g:exCS_backto_editbuf, 'g:exCS_Init'.s:exCS_short_title.'Window', 'g:exCS_Update'.s:exCS_short_title.'Window' )
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
        call exUtility#ToggleWindow( title, g:exCS_window_direction, g:exCS_window_width, g:exCS_use_vertical_window, 'none', g:exCS_backto_editbuf, 'g:exCS_Init'.s:exCS_short_title.'Window', 'g:exCS_Update'.s:exCS_short_title.'Window' )
    else
        call exUtility#ToggleWindow( title, g:exCS_window_direction, g:exCS_window_height, g:exCS_use_vertical_window, 'none', g:exCS_backto_editbuf, 'g:exCS_Init'.s:exCS_short_title.'Window', 'g:exCS_Update'.s:exCS_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exCS_SwitchWindow( short_title ) " <<<
    let title = '__exCS_' . a:short_title . 'Window__'
    if bufwinnr(title) == -1
        let tmp_backup = g:exCS_backto_editbuf
        let g:exCS_backto_editbuf = 0
        call s:exCS_ToggleWindow(a:short_title)
        let g:exCS_backto_editbuf = tmp_backup
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
    if line !~ '^ \[\d\+\]'
        call exUtility#WarningMsg("could not jump")
        return 0
    endif

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

function s:exCS_ShowQuickFixResult( search_method ) " <<<
    " processing search result
    let result_list = getqflist()

    " processing result
    if a:search_method ==# 'da' " all calling function
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
    elseif a:search_method ==# 'ds' " select calling function
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
    elseif a:search_method ==# 'c' " called function
        let qf_idx = 0
        for item in result_list
            let start_idx = stridx( item.text, "<<")+2
            let end_idx = stridx( item.text, ">>")
            let len = end_idx - start_idx
            let text_line = printf(" [%03d] %-40s | %s", qf_idx, strpart( item.text, start_idx, len ), strpart( item.text, end_idx+2 ) )
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
            let end_idx = stridx( item.text, ">>")
            let text_line = printf(" [%03d]%s<%d> %s", qf_idx, bufname(item.bufnr), item.lnum, strpart( item.text, end_idx+3 ) )
            silent put = text_line 
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 'g' " definition
        let qf_idx = 0
        for item in result_list
            let end_idx = stridx( item.text, ">>")
            let text_line = printf(" [%03d]%s<%d> %s", qf_idx, bufname(item.bufnr), item.lnum, strpart( item.text, end_idx+3 ) )
            silent put = text_line 
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 'e' " egrep
        let qf_idx = 0
        for item in result_list
            let end_idx = stridx( item.text, ">>")
            let text_line = printf(" [%03d]%s<%d> %s", qf_idx, bufname(item.bufnr), item.lnum, strpart( item.text, end_idx+3 ) )
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
        let g:exES_Cscope = './'.g:exES_vimfile_dir.'/cscope.out'
    endif
    if cscope_connection(4, "cscope.out", g:exES_Cscope ) == 0
        call g:exCS_ConnectCscopeFile()
    endif

    " syntax highlight
    if g:exCS_highlight_result
        " this will load the syntax highlight as cpp for search result
        silent exec "so $VIM/vimfiles/after/syntax/exUtility.vim"
    endif

    syntax match ex_SynFileName '^.*\s\+(.*)$'
    syntax region ex_SynSearchPattern start="^----------" end="----------"
    syntax match ex_SynLineNr '<\d\+>'
    syntax match exCS_SynQfNumber '^ \[\d\+\]'

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exCS_GotoInSelectWindow()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exCS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exCS_ToggleWindow('Select')<CR>

    nnoremap <buffer> <silent> <C-Right>   :call <SID>exCS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exCS_SwitchWindow('QuickView')<CR>

    " TODO: shrink text for d method

    nnoremap <buffer> <silent> <Leader>r :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <Leader>d :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'pattern', 1)<CR>
    nnoremap <buffer> <silent> <Leader>ar :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <Leader>ad :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <Leader>r <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <Leader>d <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <Leader>ar <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <Leader>ad <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'pattern', 1)<CR>

    nnoremap <buffer> <silent> <Leader>fr :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'file', 0)<CR>
    nnoremap <buffer> <silent> <Leader>fd :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'file', 1)<CR>
    nnoremap <buffer> <silent> <Leader>far :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'file', 0)<CR>
    nnoremap <buffer> <silent> <Leader>fad :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'file', 1)<CR>
    vnoremap <buffer> <silent> <Leader>fr <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'file', 0)<CR>
    vnoremap <buffer> <silent> <Leader>fd <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'file', 1)<CR>
    vnoremap <buffer> <silent> <Leader>far <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'file', 0)<CR>
    vnoremap <buffer> <silent> <Leader>fad <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'file', 1)<CR>

    nnoremap <buffer> <silent> <Leader>gr :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', '', 0)<CR>
    nnoremap <buffer> <silent> <Leader>gd :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', '', 1)<CR>
    nnoremap <buffer> <silent> <Leader>gar :call <SID>exCS_ShowPickedResultNormalMode('', 'append', '', 0)<CR>
    nnoremap <buffer> <silent> <Leader>gad :call <SID>exCS_ShowPickedResultNormalMode('', 'append', '', 1)<CR>
    vnoremap <buffer> <silent> <Leader>gr <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', '', 0)<CR>
    vnoremap <buffer> <silent> <Leader>gd <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', '', 1)<CR>
    vnoremap <buffer> <silent> <Leader>gar <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', '', 0)<CR>
    vnoremap <buffer> <silent> <Leader>gad <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', '', 1)<CR>

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
    " this will fix the jump error when tagselect in the same window
    if &filetype == "ex_filetype"
        silent exec "normal \<Esc>"
    endif

    " if cscope file not connect, connect it
    if cscope_connection(4, "cscope.out", g:exES_Cscope ) == 0
        call g:exCS_ConnectCscopeFile()
    endif

    " jump back to edit buffer first
    call exUtility#GotoEditBuffer()

    " change window for suitable search method
    if a:search_method =~# '\(d\|i\)'
        let g:exCS_use_vertical_window = 1
        let g:exCS_window_direction = 'botright'
    else
        let g:exCS_use_vertical_window = 0
        let g:exCS_window_direction = 'bel'
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

    " go back 
    silent exec "normal! \<c-o>"

    " open and goto search window first
    let gs_winnr = bufwinnr(s:exCS_select_title)
    let bufnr = bufnr('%')
    if gs_winnr == -1
        " open window
        let old_opt = g:exCS_backto_editbuf
        let g:exCS_backto_editbuf = 0
        call s:exCS_ToggleWindow('Select')
        let g:exCS_backto_editbuf = old_opt
    else
        exe gs_winnr . 'wincmd w'
    endif

    " clear screen and put new result
    silent exec 'normal! G"_dgg'

    " processing search result
    let pattern_title = '----------' . a:search_pattern . '----------'
    silent put = pattern_title 
    call s:exCS_ShowQuickFixResult(a:search_method)

    " Init search state
    let line_num = search(pattern_title)
    let s:exCS_select_idx = line_num+1
    silent call cursor( s:exCS_select_idx, 1 )
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
    " syntax highlight
    syntax match ex_SynFileName '^[^:]*:'
    syntax match ex_SynSearchPattern '^----------.\+----------'
    syntax match ex_SynLineNr '\d\+:'
    syntax match ex_SynFold '<<<<<<'
    syntax match ex_SynFold '>>>>>>'

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exCS_GotoInQuickViewWindow()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exCS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exCS_ToggleWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <C-Right>   :call <SID>exCS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exCS_SwitchWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <Leader>r :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <Leader>d :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'pattern', 1)<CR>
    nnoremap <buffer> <silent> <Leader>ar :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <Leader>ad :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <Leader>r <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <Leader>d <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <Leader>ar <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <Leader>ad <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'pattern', 1)<CR>

    nnoremap <buffer> <silent> <Leader>fr :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'file', 0)<CR>
    nnoremap <buffer> <silent> <Leader>fd :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', 'file', 1)<CR>
    nnoremap <buffer> <silent> <Leader>far :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'file', 0)<CR>
    nnoremap <buffer> <silent> <Leader>fad :call <SID>exCS_ShowPickedResultNormalMode('', 'append', 'file', 1)<CR>
    vnoremap <buffer> <silent> <Leader>fr <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'file', 0)<CR>
    vnoremap <buffer> <silent> <Leader>fd <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', 'file', 1)<CR>
    vnoremap <buffer> <silent> <Leader>far <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'file', 0)<CR>
    vnoremap <buffer> <silent> <Leader>fad <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', 'file', 1)<CR>

    nnoremap <buffer> <silent> <Leader>gr :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', '', 0)<CR>
    nnoremap <buffer> <silent> <Leader>gd :call <SID>exCS_ShowPickedResultNormalMode('', 'replace', '', 1)<CR>
    nnoremap <buffer> <silent> <Leader>gar :call <SID>exCS_ShowPickedResultNormalMode('', 'append', '', 0)<CR>
    nnoremap <buffer> <silent> <Leader>gad :call <SID>exCS_ShowPickedResultNormalMode('', 'append', '', 1)<CR>
    vnoremap <buffer> <silent> <Leader>gr <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', '', 0)<CR>
    vnoremap <buffer> <silent> <Leader>gd <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'replace', '', 1)<CR>
    vnoremap <buffer> <silent> <Leader>gar <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', '', 0)<CR>
    vnoremap <buffer> <silent> <Leader>gad <ESC>:call <SID>exCS_ShowPickedResultVisualMode('', 'append', '', 1)<CR>

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
        if a:search_method == 'pattern'
            let full_search_pattern = '^.\+:\d\+:.*\zs' . search_pattern
        elseif a:search_method == 'file'
            let full_search_pattern = '\(.\+:\d\+:\)\&' . search_pattern
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
        if !empty( s:exCS_picked_search_result )
            silent call remove( s:exCS_picked_search_result, 0, len(s:exCS_picked_search_result)-1 )
        endif

        " if inverse search, we first filter out not pattern line, then
        " then filter pattern
        if a:inverse_search
            let search_results = '\(.\+:\d\+:\).*'
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
        silent exec 'normal! G"_dgg'
        let s:exCS_quick_view_idx = 1
        call exUtility#HighlightConfirmLine()
        silent put = s:exCS_quick_view_search_pattern
        silent put = s:exCS_fold_start
        silent put = s:exCS_picked_search_result
        silent put = s:exCS_fold_end
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
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
