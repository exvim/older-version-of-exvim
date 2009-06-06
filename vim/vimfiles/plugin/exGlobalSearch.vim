" ======================================================================================
" File         : exGlobalSearch.vim
" Author       : Wu Jie 
" Last Change  : 10/18/2008 | 18:56:44 PM | Saturday,October
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_exglobalsearch') || &cp
    finish
endif
let loaded_exglobalsearch=1

"/////////////////////////////////////////////////////////////////////////////
" variables
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" gloable varialbe initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: window height for horizon window mode
" ------------------------------------------------------------------ 

if !exists('g:exGS_window_height')
    let g:exGS_window_height = 20
endif

" ------------------------------------------------------------------ 
" Desc: window width for vertical window mode
" ------------------------------------------------------------------ 

if !exists('g:exGS_window_width')
    let g:exGS_window_width = 30
endif

" ------------------------------------------------------------------ 
" Desc: window height increment value
" ------------------------------------------------------------------ 

if !exists('g:exGS_window_height_increment')
    let g:exGS_window_height_increment = 30
endif

" ------------------------------------------------------------------ 
" Desc: window width increment value
" ------------------------------------------------------------------ 

if !exists('g:exGS_window_width_increment')
    let g:exGS_window_width_increment = 100
endif

" ------------------------------------------------------------------ 
" Desc: placement of the window
" 'topleft','botright', 'belowright'
" ------------------------------------------------------------------ 

if !exists('g:exGS_window_direction')
    let g:exGS_window_direction = 'belowright'
endif

" ------------------------------------------------------------------ 
" Desc: use vertical or not
" ------------------------------------------------------------------ 

if !exists('g:exGS_use_vertical_window')
    let g:exGS_use_vertical_window = 0
endif

" ------------------------------------------------------------------ 
" Desc: go back to edit buffer
" ------------------------------------------------------------------ 

if !exists('g:exGS_backto_editbuf')
    let g:exGS_backto_editbuf = 0
endif

" ------------------------------------------------------------------ 
" Desc: go and close exTagSelect window
" ------------------------------------------------------------------ 

if !exists('g:exGS_close_when_selected')
    let g:exGS_close_when_selected = 0
endif

" ------------------------------------------------------------------ 
" Desc: go and close exTagSelect window
" ------------------------------------------------------------------ 

if !exists('g:exGS_stack_close_when_selected')
    let g:exGS_stack_close_when_selected = 0
endif

" ------------------------------------------------------------------ 
" Desc: use syntax highlight for search result
" ------------------------------------------------------------------ 

if !exists('g:exGS_highlight_result')
    let g:exGS_highlight_result = 0
endif

" ------------------------------------------------------------------ 
" Desc: set edit mode
" 'none', 'append', 'replace'
" ------------------------------------------------------------------ 

if !exists('g:exGS_edit_mode')
    let g:exGS_edit_mode = 'replace'
endif

" ------------------------------------------------------------------ 
" Desc: set if auto sort result if the result less than g:exGS_lines_for_autosort lines 
" ------------------------------------------------------------------ 

if !exists('g:exGS_auto_sort')
    let g:exGS_auto_sort = 0
endif

" ------------------------------------------------------------------ 
" Desc: less than ? lines, will trigger auto sort
" ------------------------------------------------------------------ 

if !exists('g:exGS_lines_for_autosort')
    let g:exGS_lines_for_autosort = 500
endif

" ======================================================== 
" local variable initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: title
" ------------------------------------------------------------------ 

let s:exGS_select_title = '__exGS_SelectWindow__'
let s:exGS_stack_title = '__exGS_StackWindow__'
let s:exGS_quick_view_title = '__exGS_QuickViewWindow__'
let s:exGS_short_title = 'Select'

" ------------------------------------------------------------------ 
" Desc: general
" ------------------------------------------------------------------ 

let s:exGS_fold_start = '<<<<<<'
let s:exGS_fold_end = '>>>>>>'
let s:exGS_ignore_case = 1
let s:exGS_need_search_again = 0

" ------------------------------------------------------------------ 
" Desc: select variable
" ------------------------------------------------------------------ 

let s:exGS_select_idx = 1

" ------------------------------------------------------------------ 
" Desc: stack variable
" ------------------------------------------------------------------ 

let s:exGS_need_update_stack_window = 0
let s:exGS_stack_idx = 0
let s:exGS_search_state_tmp = {'pattern':'', 'pattern_cursor_pos':[-1,-1,-1,-1], 'pattern_file_name':'', 'entry_cursor_pos':[-1,-1,-1,-1], 'entry_file_name':'', 'stack_preview':''}
let s:exGS_search_stack_list = [{'pattern':'exGS_StartPoint', 'pattern_cursor_pos':[-1,-1,-1,-1], 'pattern_file_name':'', 'entry_cursor_pos':[-1,-1,-1,-1], 'entry_file_name':'', 'stack_preview':''}]
let s:exGS_need_push_search_result = 0
let s:exGS_last_jump_method = "to_tag"

" ------------------------------------------------------------------ 
" Desc: quick view variable
" ------------------------------------------------------------------ 

let s:exGS_quick_view_idx = 1
let s:exGS_picked_search_result = []
let s:exGS_quick_view_search_pattern = ''

"/////////////////////////////////////////////////////////////////////////////
" function defins
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" general functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Open exGlobalSearch window 
" ------------------------------------------------------------------ 

function s:exGS_OpenWindow( short_title ) " <<<
    if a:short_title != ''
        let s:exGS_short_title = a:short_title
    endif
    let title = '__exGS_' . s:exGS_short_title . 'Window__'
    " open window
    if g:exGS_use_vertical_window
        call exUtility#OpenWindow( title, g:exGS_window_direction, g:exGS_window_width, g:exGS_use_vertical_window, g:exGS_edit_mode, 1, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    else
        call exUtility#OpenWindow( title, g:exGS_window_direction, g:exGS_window_height, g:exGS_use_vertical_window, g:exGS_edit_mode, 1, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize the window use the increase value
" ------------------------------------------------------------------ 

function s:exGS_ResizeWindow() " <<<
    if g:exGS_use_vertical_window
        call exUtility#ResizeWindow( g:exGS_use_vertical_window, g:exGS_window_width, g:exGS_window_width_increment )
    else
        call exUtility#ResizeWindow( g:exGS_use_vertical_window, g:exGS_window_height, g:exGS_window_height_increment )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Toggle the window
" ------------------------------------------------------------------ 

function s:exGS_ToggleWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exGS_short_title != a:short_title
            if bufwinnr('__exGS_' . s:exGS_short_title . 'Window__') != -1
                call exUtility#CloseWindow('__exGS_' . s:exGS_short_title . 'Window__')
            endif
            let s:exGS_short_title = a:short_title
        endif
    endif

    " toggle exGS window
    let title = '__exGS_' . s:exGS_short_title . 'Window__'
    if g:exGS_use_vertical_window
        call exUtility#ToggleWindow( title, g:exGS_window_direction, g:exGS_window_width, g:exGS_use_vertical_window, 'none', 0, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    else
        call exUtility#ToggleWindow( title, g:exGS_window_direction, g:exGS_window_height, g:exGS_use_vertical_window, 'none', 0, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exGS_SwitchWindow( short_title ) " <<<
    let title = '__exGS_' . a:short_title . 'Window__'
    if bufwinnr(title) == -1
        " save the old height & width
        let old_height = g:exGS_window_height
        let old_width = g:exGS_window_width

        " use the width & height of current window if it is same plugin window.
        if bufname ('%') ==# s:exGS_select_title || bufname ('%') ==# s:exGS_quick_view_title || bufname ('%') ==# s:exGS_stack_title
            let g:exGS_window_height = winheight('.')
            let g:exGS_window_width = winwidth('.')
        endif

        " switch to the new plugin window
        call s:exGS_ToggleWindow(a:short_title)

        " recover the width and height
        let g:exGS_window_height = old_height
        let g:exGS_window_width = old_width
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exGS_Goto() " <<<
    let line = getline('.')
    " get file name
    let idx = stridx(line, ":")
    let file_name = strpart(line, 0, idx) " escape(strpart(line, 0, idx), ' ')
    if findfile(file_name) == ''
        call exUtility#WarningMsg( file_name . ' not found' )
        return 0
    endif
    let line = strpart(line, idx+1)

    " get line number
    let idx = stridx(line, ":")
    let line_num  = eval(strpart(line, 0, idx))

    " start jump
    call exUtility#GotoEditBuffer()

    " if we don't start a new stack, we pop the old jump, so that the new one
    " will only take the old stack position while we are selecting our result. 
    let keepjumps_cmd = ''
    if !s:exGS_need_push_search_result
        let keepjumps_cmd = 'keepjumps'
    endif

    "
    if bufnr('%') != bufnr(file_name)
        exe keepjumps_cmd . ' silent e ' . file_name
    endif
    exec keepjumps_cmd . ' call cursor(line_num, 1)'
    let cursor_pos = getpos(".")

    " jump to the pattern if the code have been modified
    let pattern = strpart(line, idx+2)
    let pattern = '\V' . substitute( pattern, '\', '\\\', "g" )
    if search(pattern, 'w') == 0
        call exUtility#WarningMsg('search pattern not found: ' . pattern)
    endif

    " push tag state to tag stack
    if s:exGS_need_push_search_result
        let s:exGS_need_push_search_result = 0

        " set last stack_idx states
        let s:exGS_search_stack_list[s:exGS_stack_idx].entry_file_name = s:exGS_search_state_tmp.entry_file_name 
        let s:exGS_search_stack_list[s:exGS_stack_idx].entry_cursor_pos = s:exGS_search_state_tmp.entry_cursor_pos
        let s:exGS_search_stack_list[s:exGS_stack_idx].stack_preview = s:exGS_search_state_tmp.stack_preview

        " push stack
        let s:exGS_search_state_tmp.entry_file_name = ''
        let s:exGS_search_state_tmp.entry_cursor_pos = [-1,-1,-1,-1]
        let s:exGS_search_state_tmp.stack_preview = ''
        let s:exGS_search_state_tmp.pattern_file_name = file_name
        let s:exGS_search_state_tmp.pattern_cursor_pos = cursor_pos
        call s:exGS_PushStack(s:exGS_search_state_tmp)
    else
        let s:exGS_search_stack_list[s:exGS_stack_idx].pattern_file_name = file_name
        let s:exGS_search_stack_list[s:exGS_stack_idx].pattern_cursor_pos = cursor_pos
    endif

    " go back if needed
    let title = '__exGS_' . s:exGS_short_title . 'Window__'
    call exUtility#OperateWindow ( title, g:exGS_close_when_selected, g:exGS_backto_editbuf, 1 )

    return 1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exGS_GotoResult ( move_method ) " <<<
    " open and goto search window first
    let gs_winnr = bufwinnr(s:exGS_select_title)
    if gs_winnr == -1
        let gs_winnr = bufwinnr(s:exGS_quick_view_title)
        if gs_winnr == -1
            call exUtility#WarningMsg('Please open select/quickview for operating')
            return
        endif
    endif
    exe gs_winnr . 'wincmd w'

    " move cursor
    if a:move_method ==# 'next'
        silent normal! j
    elseif a:move_method ==# 'prev'
        silent normal! k
    endif

    " goto 
    call exUtility#HighlightSelectLine()
    silent exec "normal \<Return>"
    call exUtility#GotoEditBuffer()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: set if ignore case
" ------------------------------------------------------------------ 
"
function s:exGS_SetIgnoreCase(ignore_case) " <<<
    let s:exGS_ignore_case = a:ignore_case
    let s:exGS_need_search_again = 1
    if a:ignore_case
        echomsg 'exGS ignore case'
    else
        echomsg 'exGS no ignore case'
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exGS_GlobalSubstitute( pat, sub, flag ) " <<<
    silent normal! gg
    let last_line = line("$")
    let cur_line_idx = 0
    let cur_line = ''
    while cur_line_idx <= last_line
        let s:exGS_select_idx = line(".")
        if s:exGS_Goto()
            call exUtility#GotoEditBuffer()
            let cur_line = substitute( getline("."), a:pat, a:sub, a:flag )
            if cur_line !=# getline(".")
                silent call setline( ".", cur_line )
            endif
            echon cur_line . "\r"
            call exUtility#GotoPluginBuffer()
        endif
        let cur_line_idx += 1
        silent normal! j
    endwhile
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exGS_ParseSubcmd(cmd) " <<<
    let slash_idx_1 = stridx( a:cmd, "/" )
    while a:cmd[slash_idx_1-1] == '\'
        let slash_idx_1 = stridx( a:cmd, "/", slash_idx_1 + 1 )
    endwhile

    let slash_idx_2 = strridx( a:cmd, "/" )

    let pat = strpart(a:cmd, 0, slash_idx_1 )
    let sub = strpart( a:cmd, slash_idx_1+1, slash_idx_2-slash_idx_1-1 )
    let flag = ""
    if slash_idx_1 != slash_idx_2
        let flag = strpart( a:cmd, slash_idx_2+1 )
    endif

    echon pat . ' ' . sub . ' ' . flag . "\r"
    call s:exGS_GlobalSubstitute( pat, sub, flag )
endfunction " >>>

" ======================================================== 
" select window functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exGS_MapPickupResultKeys() " <<<
    nnoremap <buffer> <silent> <LocalLeader>r :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>d :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'pattern', 1)<CR>
    nnoremap <buffer> <silent> <LocalLeader>ar :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>ad :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>r <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>d <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>ar <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>ad <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'pattern', 1)<CR>

    nnoremap <buffer> <silent> <LocalLeader>fr :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'file', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>fd :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'file', 1)<CR>
    nnoremap <buffer> <silent> <LocalLeader>far :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'file', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>fad :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'file', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>fr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'file', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>fd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'file', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>far <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'file', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>fad <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'file', 1)<CR>

    nnoremap <buffer> <silent> <LocalLeader>gr :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', '', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>gd :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', '', 1)<CR>
    nnoremap <buffer> <silent> <LocalLeader>gar :call <SID>exGS_ShowPickedResultNormalMode('', 'append', '', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>gad :call <SID>exGS_ShowPickedResultNormalMode('', 'append', '', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>gr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', '', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>gd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', '', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>gar <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', '', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>gad <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', '', 1)<CR>

    nnoremap <buffer> <silent> <LocalLeader>sr :call <SID>exGS_SortSearchResults()<CR>
    vnoremap <buffer> <silent> <LocalLeader>sr :call <SID>exGS_SortSearchResultsByRange()<CR>
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Init exGlobalSearch window
" ------------------------------------------------------------------ 

function g:exGS_InitSelectWindow() " <<<
    setlocal number

    " syntax highlight
    if g:exGS_highlight_result
        " this will load the syntax highlight as cpp for search result
        silent exec "so $VIM/vimfiles/after/syntax/exUtility.vim"
    endif

    "
    syntax region ex_SynFileName start="^[^:]*" end=":" oneline
    syntax region ex_SynSearchPattern start="^----------" end="----------"
    syntax match ex_SynLineNr '\d\+:'

    " key map
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exGS_ToggleWindow('Select')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exGS_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exGS_GotoInSelectWindow()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exGS_GotoInSelectWindow()<CR>

    nnoremap <buffer> <silent> <C-Up>   :call <SID>exGS_SwitchWindow('Stack')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exGS_SwitchWindow('QuickView')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exGS_SwitchWindow('Select')<CR>

    call s:exGS_MapPickupResultKeys()

    " autocmd
    au CursorMoved <buffer> :call exUtility#HighlightSelectLine()

    " command
    command -buffer -nargs=1 SUB call s:exGS_ParseSubcmd('<args>')
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 
"
function s:exGS_GotoInSelectWindow() " <<<
    let s:exGS_select_idx = line(".")
    call exUtility#HighlightConfirmLine()
    call s:exGS_Goto()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update exGlobalSearch window 
" ------------------------------------------------------------------ 

function g:exGS_UpdateSelectWindow() " <<<
    silent call cursor(s:exGS_select_idx, 1)
    call exUtility#HighlightConfirmLine()
endfunction " >>>


" ------------------------------------------------------------------ 
" Desc: compare the search result line. (by YJR)
" ------------------------------------------------------------------ 

function! s:exGS_SearchResultComp(line1, line2) " <<<
    let line1lst = matchlist(a:line1 , '^\([^:]*\):\(\d\+\):')
    let line2lst = matchlist(a:line2 , '^\([^:]*\):\(\d\+\):')
    if empty(line1lst) && empty(line2lst)
        return 0
    elseif empty(line1lst)
        return -1
    elseif empty(line2lst)
        return 1
    else
        if line1lst[1]!=line2lst[1]
            return line1lst[1]<line2lst[1]?-1:1
        else
            let linenum1 = eval(line1lst[2])
            let linenum2 = eval(line2lst[2])
            return linenum1==linenum2?0:(linenum1<linenum2?-1:1)
        endif
    endif
endfunction ">>>

" ------------------------------------------------------------------ 
" Desc: Get Global Search Result
" search_pattern = ''
" search_method = -s / -r / -w
" ------------------------------------------------------------------ 

function s:exGS_GetGlobalSearchResult(search_pattern, search_method, direct_jump) " <<<
    " TODO different mode, same things
    " open and goto search window first
    let gs_winnr = bufwinnr(s:exGS_select_title)

    let bufnr = bufnr('%')
    " save the entry point
    let cursor_pos = getpos(".")
    let stack_preview = getline(".")
    let stack_preview = strpart( stack_preview, match(stack_preview, '\S') )
    if a:direct_jump == 0
        let stack_preview = '[GS] ' . stack_preview
    else
        let stack_preview = '[GG] ' . stack_preview
    endif
    let s:exGS_search_state_tmp.entry_file_name = bufname(bufnr)
    let s:exGS_search_state_tmp.entry_cursor_pos = cursor_pos
    let s:exGS_search_state_tmp.stack_preview = stack_preview

    if gs_winnr == -1
        " open window
        call s:exGS_ToggleWindow('Select')
    else
        exe gs_winnr . 'wincmd w'
    endif

    " if the search pattern is same as the last one, open the window
    if a:search_pattern !=# s:exGS_search_stack_list[s:exGS_stack_idx].pattern && s:exGS_need_search_again != 1
        let s:exGS_need_push_search_result = 1
        let s:exGS_select_idx = 1
    else
        let s:exGS_need_push_search_result = 0
        let s:exGS_select_idx = 1
        let s:exGS_need_search_again = 0
    endif

    " create search cmd
    if s:exGS_ignore_case && (match(a:search_pattern, '\u') == -1)
        echomsg 'search ' . a:search_pattern . '...(ignore case)'
        let search_cmd = 'lid --result=grep -i -f' . g:exES_ID . ' ' . a:search_method . ' ' . a:search_pattern
    else
        echomsg 'search ' . a:search_pattern . '...(no ignore case)'
        let search_cmd = 'lid --result=grep -f' . g:exES_ID . ' ' . a:search_method . ' ' . a:search_pattern
    endif
    let search_result = system(search_cmd)
    let search_result = '----------' . a:search_pattern . '----------' . "\n" . search_result

    " clear screen and put new result
    silent exec '1,$d _'
    call exUtility#HighlightConfirmLine()
    let line_num = line('.')
    silent put = search_result

    " auto sort search results if the number of results less than g:exGS_lines_for_autosort lines
    if g:exGS_auto_sort == 1
        if line('$') <= g:exGS_lines_for_autosort
            call s:exGS_SortSearchResults ()
        endif
    endif

    " Init search state
    let s:exGS_search_state_tmp.pattern = a:search_pattern
    let s:exGS_select_idx = line_num+1
    silent call cursor( line_num+1, 1 )
    silent normal zz
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exGS_SortSearchResults() " <<<
    if bufname('%') ==# s:exGS_select_title
        let lines = getline(3, '$')
        silent call sort(lines, "s:exGS_SearchResultComp")
        silent call setline(3, lines)
    elseif bufname('%') ==# s:exGS_quick_view_title
        let save_cursor = getpos(".")
        silent normal gg
        while 1
            let start_ln = search('<<<<<<', 'W')
            let end_ln = search('>>>>>>', 'W')
            if start_ln == 0
                break
            else
                let start_ln += 1 
                let end_ln -= 1 
                let lines = getline(start_ln, end_ln)
                silent call sort(lines, "s:exGS_SearchResultComp")
                silent call setline(start_ln, lines)
            endif
        endwhile
        silent call setpos(".", save_cursor)
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 
"
function s:exGS_SortSearchResultsByRange() range " <<<
    let lines = getline(a:firstline, a:lastline)
    silent call sort(lines, "s:exGS_SearchResultComp")
    silent call setline(a:firstline, lines)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" search_pattern = ''
" search_method = -s / -w
" ------------------------------------------------------------------ 

function s:exGS_GetFilenameSearchResult(search_pattern, search_method) " <<<
    " open and goto search window first
    let gs_winnr = bufwinnr(s:exGS_select_title)
    if gs_winnr == -1
        " open window
        call s:exGS_ToggleWindow('Select')
    else
        exe gs_winnr . 'wincmd w'
    endif

    "
    let s:exGS_need_push_search_result = 0
    let s:exGS_select_idx = 1

    " create search cmd
    if a:search_method ==# '-w'
        echomsg 'search files by word ' . a:search_pattern . '...(no ignore case)'
        let search_cmd = 'fnid -f' . g:exES_ID . ' ' . a:search_pattern
    else
        echomsg 'search files by reg-exp ' . a:search_pattern . '...(no ignore case)'
        let search_cmd = 'fnid -f' . g:exES_ID . ' *' . a:search_pattern . '* '
    endif
    let search_result = system(search_cmd)
    let search_result = '----------' . a:search_pattern . '----------' . "\n" . search_result

    " clear screen and put new result
    silent exec '1,$d _'
    call exUtility#HighlightConfirmLine()
    let line_num = line('.')
    silent put = search_result

    " Init search state
    let s:exGS_select_idx = line_num+1
    silent call cursor( line_num+1, 1 )
endfunction " >>>

" ======================================================== 
" stack window functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Init exGlobalSearch select window
" ------------------------------------------------------------------ 

function g:exGS_InitStackWindow() " <<<
    " syntax highlight
    syntax match ex_SynJumpMethodS '\[GS]'
    syntax match ex_SynJumpMethodG '\[GG]'
    syntax match ex_SynJumpSymbol '======>'
    syntax match ex_SynTitle '#.\+PATTERN.\+ENTRY POINT PREVIEW'

    " key map
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exGS_ToggleWindow('Stack')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exGS_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exGS_Stack_GoDirect()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exGS_Stack_GoDirect()<CR>

    nnoremap <buffer> <silent> <C-Up>   :call <SID>exGS_SwitchWindow('Stack')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exGS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exGS_SwitchWindow('QuickView')<CR>

    " autocmd
    au CursorMoved <buffer> :call exUtility#HighlightSelectLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update exGlobalSearch stack window 
" ------------------------------------------------------------------ 

function g:exGS_UpdateStackWindow() " <<<
    " if need update stack window 
    if s:exGS_need_update_stack_window
        let s:exGS_need_update_stack_window = 0
        call s:exGS_ShowStackList()
    endif

    let pattern = s:exGS_stack_idx . ':'
    if search( pattern, 'w') == 0
        call exUtility#WarningMsg('Pattern not found')
        return
    endif
    call exUtility#HighlightConfirmLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Push the result into stack
" ------------------------------------------------------------------ 

function s:exGS_PushStack( search_state ) " <<<
    let list_len = len(s:exGS_search_stack_list)
    if list_len > s:exGS_stack_idx+1
        call remove(s:exGS_search_stack_list, s:exGS_stack_idx+1, list_len-1)
        let s:exGS_stack_idx += 1
    else
        let s:exGS_stack_idx += 1
    endif
    let search_state = copy(a:search_state)
    call add(s:exGS_search_stack_list,search_state)

    let s:exGS_need_update_stack_window = 1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Show the stack list in stack window
" ------------------------------------------------------------------ 

function s:exGS_ShowStackList() " <<<
    " open and goto search window first
    let gs_winnr = bufwinnr(s:exGS_stack_title)
    if gs_winnr == -1
        " open window
        call s:exGS_ToggleWindow('Stack')
    else
        exe gs_winnr . 'wincmd w'
    endif

    " clear screen
    silent exec '1,$d _'

    " put an empty line first
    silent put = ''

    " put the title
    let tag_name = 'PATTERN'
    let stack_preview = 'ENTRY POINT PREVIEW'
    let str_line = printf(" #  %-54s%s", tag_name, stack_preview)
    silent put = str_line

    " put the stack
    let idx = 0
    for state in s:exGS_search_stack_list
        let str_line = printf("%2d: %-40s ======> %s", idx, state.pattern, state.stack_preview)
        silent put = str_line
        let idx += 1
    endfor
    silent exec 'normal! gg"_dd'

endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Go to idx tags
" jump_method : 'to_tag', to_entry
" ------------------------------------------------------------------ 

function s:exGS_Stack_GotoTag( idx, jump_method ) " <<<
    let jump_method = a:jump_method
    let list_len = len(s:exGS_search_stack_list)
    " if idx < 0, return
    if a:idx < 0
        call exUtility#WarningMsg('at the top of exSearchStack')
        let s:exGS_stack_idx = 0
        return
    elseif a:idx > list_len-1
        call exUtility#WarningMsg('at the bottom of exSearchStack')
        let s:exGS_stack_idx = list_len-1
        return
    endif

    let s:exGS_stack_idx = a:idx
    let need_jump = 1
    " start point always use to_entry method
    if s:exGS_stack_idx == 0
        let jump_method = 'to_entry'
    endif

    " open and go to stack window first
    let background_op = 0
    if bufwinnr(s:exGS_stack_title) == -1
        call s:exGS_ToggleWindow('Stack')
        let background_op = 1
    else
        call g:exGS_UpdateStackWindow()
    endif

    " start parsing
    if need_jump == 1
        " go by tag_idx
        if jump_method == 'to_entry'
            call exUtility#GotoEditBuffer()
            silent exec 'e ' . s:exGS_search_stack_list[s:exGS_stack_idx].entry_file_name
            call setpos('.', s:exGS_search_stack_list[s:exGS_stack_idx].entry_cursor_pos)
        else
            call exUtility#GotoEditBuffer()
            silent exec 'e ' . s:exGS_search_stack_list[s:exGS_stack_idx].pattern_file_name
            call setpos('.', s:exGS_search_stack_list[s:exGS_stack_idx].pattern_cursor_pos)
        endif
        exe 'normal! zz'
    endif

    " go back if needed
    call exUtility#OperateWindow ( s:exGS_stack_title, g:exGS_stack_close_when_selected || background_op, g:exGS_backto_editbuf, 1 )

endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exGS_Stack_GoDirect() " <<<
    let cur_line = getline(".")
    let idx = match(cur_line, '\S')
    let cur_line = strpart(cur_line, idx)
    let idx = match(cur_line, ':')
    if idx == -1
        call exUtility#WarningMsg("Can't jump in this line")
        return
    endif

    let stack_idx = eval(strpart(cur_line, 0, idx))
    call exUtility#HighlightConfirmLine()

    " if select idx > old idx, jump to tag. else jump to entry
    if stack_idx > s:exGS_stack_idx
        call s:exGS_Stack_GotoTag(stack_idx, 'to_tag')
        let s:exGS_last_jump_method = "to_tag"
    elseif stack_idx < s:exGS_stack_idx
        call s:exGS_Stack_GotoTag(stack_idx, 'to_entry')
        let s:exGS_last_jump_method = "to_entry"
    else
        call s:exGS_Stack_GotoTag(stack_idx, s:exGS_last_jump_method)
    endif
endfunction " >>>

" ======================================================== 
" quick view window part
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Init exGlobalSearch select window
" ------------------------------------------------------------------ 

function g:exGS_InitQuickViewWindow() " <<<
    setlocal number
    setlocal foldmethod=marker foldmarker=<<<<<<,>>>>>> foldlevel=1

    " syntax highlight
    if g:exGS_highlight_result
        " this will load the syntax highlight as cpp for search result
        silent exec "so $VIM/vimfiles/after/syntax/exUtility.vim"
    endif
    "
    syntax region ex_SynFileName start="^[^:]*" end=":" oneline
    syntax region ex_SynSearchPattern start="^----------" end="----------"
    syntax match ex_SynLineNr '\d\+:'

    "
    syntax match ex_SynFold '<<<<<<'
    syntax match ex_SynFold '>>>>>>'

    " key map
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exGS_ToggleWindow('QuickView')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exGS_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exGS_GotoInQuickViewWindow()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exGS_GotoInQuickViewWindow()<CR>

    nnoremap <buffer> <silent> <C-Up>   :call <SID>exGS_SwitchWindow('Stack')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exGS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exGS_SwitchWindow('QuickView')<CR>

    call s:exGS_MapPickupResultKeys()

    " autocmd
    au CursorMoved <buffer> :call exUtility#HighlightSelectLine()

    " command
    command -buffer -nargs=1 SUB call s:exGS_ParseSubcmd('<args>')
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update exGlobalSearch stack window 
" ------------------------------------------------------------------ 

function g:exGS_UpdateQuickViewWindow() " <<<
    silent call cursor(s:exGS_quick_view_idx, 1)
    call exUtility#HighlightConfirmLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exGS_GotoInQuickViewWindow() " <<<
    let s:exGS_quick_view_idx = line(".")
    " TODO save history idx
    call exUtility#HighlightConfirmLine()
    call s:exGS_Goto()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: copy the quick view result with search pattern
" ------------------------------------------------------------------ 

function s:exGS_CopyPickedLine( search_pattern, line_start, line_end, search_method, inverse_search ) " <<<
    if a:search_pattern == ''
        let search_pattern = @/
    else
        let search_pattern = a:search_pattern
    endif
    if search_pattern == ''
        let s:exGS_quick_view_search_pattern = ''
        call exUtility#WarningMsg('search pattern not exists')
        return
    else
        let s:exGS_quick_view_search_pattern = '----------' . search_pattern . '----------'
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
        if !empty( s:exGS_picked_search_result )
            silent call remove( s:exGS_picked_search_result, 0, len(s:exGS_picked_search_result)-1 )
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
        let s:exGS_picked_search_result = getline(1,'$')

        " recover
        silent exec 'normal! u'

        " go back to the original position
        silent call setpos(".", save_cursor)
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: show the picked result in the quick view window
" ------------------------------------------------------------------ 

function s:exGS_ShowPickedResult( search_pattern, line_start, line_end, edit_mode, search_method, inverse_search ) " <<<
    call s:exGS_CopyPickedLine( a:search_pattern, a:line_start, a:line_end, a:search_method, a:inverse_search )
    call s:exGS_SwitchWindow('QuickView')
    if a:edit_mode == 'replace'
        silent exec '1,$d _'
        let s:exGS_quick_view_idx = 1
        call exUtility#HighlightConfirmLine()
        silent put = s:exGS_quick_view_search_pattern
        silent put = s:exGS_fold_start
        silent put = s:exGS_picked_search_result
        silent put = s:exGS_fold_end
        silent call search('<<<<<<', 'w')
    elseif a:edit_mode == 'append'
        silent exec 'normal! G'
        silent put = ''
        silent put = s:exGS_quick_view_search_pattern
        silent put = s:exGS_fold_start
        silent put = s:exGS_picked_search_result
        silent put = s:exGS_fold_end
    endif

endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: show the picked result in the quick view window
" ------------------------------------------------------------------ 

function s:exGS_ShowPickedResultNormalMode( search_pattern, edit_mode, search_method, inverse_search ) " <<<
    let line_start = 1
    let line_end = line('$')
    call s:exGS_ShowPickedResult( a:search_pattern, line_start, line_end, a:edit_mode, a:search_method, a:inverse_search )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: show the picked result in the quick view window
" ------------------------------------------------------------------ 

function s:exGS_ShowPickedResultVisualMode( search_pattern, edit_mode, search_method, inverse_search ) " <<<
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

    call s:exGS_ShowPickedResult( a:search_pattern, line_start, line_end, a:edit_mode, a:search_method, a:inverse_search )
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" Commands
"/////////////////////////////////////////////////////////////////////////////

command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile GS call s:exGS_GetGlobalSearchResult('<args>', '-s', 0)
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile GSW call s:exGS_GetGlobalSearchResult('<args>', '-w', 0)
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile GSR call s:exGS_GetGlobalSearchResult('<args>', '-r', 0)

command -nargs=1 -complete=customlist,exUtility#CompleteByProjectFile GSF call s:exGS_GetFilenameSearchResult('<args>', '-s')
command -nargs=1 -complete=customlist,exUtility#CompleteByProjectFile GSFW call s:exGS_GetFilenameSearchResult('<args>', '-w')

command ExgsToggle call s:exGS_ToggleWindow('')
command ExgsSelectToggle call s:exGS_ToggleWindow('Select')
command ExgsStackToggle call s:exGS_ToggleWindow('Stack')
command ExgsQuickViewToggle call s:exGS_ToggleWindow('QuickView')
command ExgsGoDirectly call s:exGS_GetGlobalSearchResult(expand("<cword>"), '-s', 1)
command BackwardSearchStack call s:exGS_Stack_GotoTag(s:exGS_stack_idx-1, 'to_entry')
command ForwardSearchStack call s:exGS_Stack_GotoTag(s:exGS_stack_idx+1, 'to_tag')

command ExgsGotoNextResult call s:exGS_GotoResult ( 'next' )
command ExgsGotoPrevResult call s:exGS_GotoResult ( 'prev' )

" quick view command
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile GSPR call s:exGS_ShowPickedResult('<args>', 'replace', '', 0 )
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile GSPRI call s:exGS_ShowPickedResult('<args>', 'replace', '', 1 )
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile GSPA call s:exGS_ShowPickedResult('<args>', 'append', '', 0 )
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile GSPAI call s:exGS_ShowPickedResult('<args>', 'append', '', 1 )

" Ignore case setting
command GSigc call s:exGS_SetIgnoreCase(1)
command GSnoigc call s:exGS_SetIgnoreCase(0)

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
