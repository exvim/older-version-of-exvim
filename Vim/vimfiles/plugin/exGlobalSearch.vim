"=============================================================================
" File:        exGlobalSearch.vim
" Author:      Johnny
" Last Change: Wed 29 Oct 2006 01:05:03 PM EDT
" Version:     1.0
"=============================================================================
" You may use this code in whatever way you see fit.

if exists('loaded_exglobalsearch') || &cp
    finish
endif
let loaded_exglobalsearch=1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------
" Initialization <<<
" -------------------------------
" gloable varialbe initialization
" -------------------------------

" window height for horizon window mode
if !exists('g:exGS_window_height')
    let g:exGS_window_height = 20
endif

" window width for vertical window mode
if !exists('g:exGS_window_width')
    let g:exGS_window_width = 30
endif

" window height increment value
if !exists('g:exGS_window_height_increment')
    let g:exGS_window_height_increment = 30
endif

" window width increment value
if !exists('g:exGS_window_width_increment')
    let g:exGS_window_width_increment = 100
endif

" go back to edit buffer
" 'topleft','botright'
if !exists('g:exGS_window_direction')
    let g:exGS_window_direction = 'botright'
endif

" use vertical or not
if !exists('g:exGS_use_vertical_window')
    let g:exGS_use_vertical_window = 0
endif

" go back to edit buffer
if !exists('g:exGS_backto_editbuf')
    let g:exGS_backto_editbuf = 1
endif

" go and close exTagSelect window
if !exists('g:exGS_close_when_selected')
    let g:exGS_close_when_selected = 0
endif

" go and close exTagSelect window
if !exists('g:exGS_stack_close_when_selected')
    let g:exGS_stack_close_when_selected = 0
endif

" use syntax highlight for search result
if !exists('g:exGS_highlight_result')
    let g:exGS_highlight_result = 0
endif

" set edit mode
" 'none', 'append', 'replace'
if !exists('g:exGS_edit_mode')
    let g:exGS_edit_mode = 'replace'
endif

" -------------------------------
" local variable initialization
" -------------------------------

" title
let s:exGS_select_title = '__exGS_SelectWindow__'
let s:exGS_stack_title = '__exGS_StackWindow__'
let s:exGS_quick_view_title = '__exGS_QuickViewWindow__'
let s:exGS_short_title = 'Select'

" general
let s:exGS_fold_start = '<<<<<<'
let s:exGS_fold_end = '>>>>>>'
let s:exGS_ignore_case = 1
let s:exGS_need_search_again = 0

" select variable
let s:exGS_select_idx = 1

" stack variable
let s:exGS_need_update_stack_window = 0
let s:exGS_stack_idx = 0
let s:exGS_search_state_tmp = {'pattern':'', 'pattern_cursor_pos':[-1,-1,-1,-1], 'pattern_file_name':'', 'entry_cursor_pos':[-1,-1,-1,-1], 'entry_file_name':'', 'stack_preview':''}
let s:exGS_search_stack_list = [{'pattern':'exGS_StartPoint', 'pattern_cursor_pos':[-1,-1,-1,-1], 'pattern_file_name':'', 'entry_cursor_pos':[-1,-1,-1,-1], 'entry_file_name':'', 'stack_preview':''}]
let s:exGS_need_push_search_result = 0
let s:exGS_last_jump_method = "to_tag"

" quick view variable
let s:exGS_quick_view_idx = 1
let s:exGS_picked_search_result = ''
let s:exGS_quick_view_search_pattern = ''

" >>>

" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------

" --exGS_OpenWindow--
" Open exGlobalSearch window 
function! s:exGS_OpenWindow( short_title ) " <<<
    if a:short_title != ''
        let s:exGS_short_title = a:short_title
    endif
    let title = '__exGS_' . s:exGS_short_title . 'Window__'
    " open window
    if g:exGS_use_vertical_window
        call g:ex_OpenWindow( title, g:exGS_window_direction, g:exGS_window_width, g:exGS_use_vertical_window, g:exGS_edit_mode, g:exGS_backto_editbuf, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    else
        call g:ex_OpenWindow( title, g:exGS_window_direction, g:exGS_window_height, g:exGS_use_vertical_window, g:exGS_edit_mode, g:exGS_backto_editbuf, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    endif
endfunction " >>>

" --exGS_ResizeWindow--
" Resize the window use the increase value
function! s:exGS_ResizeWindow() " <<<
    if g:exGS_use_vertical_window
        call g:ex_ResizeWindow( g:exGS_use_vertical_window, g:exGS_window_width, g:exGS_window_width_increment )
    else
        call g:ex_ResizeWindow( g:exGS_use_vertical_window, g:exGS_window_height, g:exGS_window_height_increment )
    endif
endfunction " >>>

" --exGS_ToggleWindow--
" Toggle the window
function! s:exGS_ToggleWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exGS_short_title != a:short_title
            if bufwinnr('__exGS_' . s:exGS_short_title . 'Window__') != -1
                call g:ex_CloseWindow('__exGS_' . s:exGS_short_title . 'Window__')
            endif
            let s:exGS_short_title = a:short_title
        endif
    endif

    " toggle exGS window
    let title = '__exGS_' . s:exGS_short_title . 'Window__'
    if g:exGS_use_vertical_window
        call g:ex_ToggleWindow( title, g:exGS_window_direction, g:exGS_window_width, g:exGS_use_vertical_window, 'none', g:exGS_backto_editbuf, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    else
        call g:ex_ToggleWindow( title, g:exGS_window_direction, g:exGS_window_height, g:exGS_use_vertical_window, 'none', g:exGS_backto_editbuf, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    endif
endfunction " >>>

" --exGS_SwitchWindow
function! s:exGS_SwitchWindow( short_title ) " <<<
    let title = '__exGS_' . a:short_title . 'Window__'
    if bufwinnr(title) == -1
        let tmp_backup = g:exGS_backto_editbuf
        let g:exGS_backto_editbuf = 0
        call s:exGS_ToggleWindow(a:short_title)
        let g:exGS_backto_editbuf = tmp_backup
    endif
endfunction " >>>

" --exGS_Goto--
"  goto select line
function! s:exGS_Goto() " <<<
    let line = getline('.')
    " get file name
    let idx = stridx(line, ":")
    let file_name = strpart(line, 0, idx) " escape(strpart(line, 0, idx), ' ')
    if findfile(file_name) == ''
        call g:ex_WarningMsg( file_name . ' not found' )
        return 0
    endif
    let line = strpart(line, idx+1)

    " get line number
    let idx = stridx(line, ":")
    let line_num  = eval(strpart(line, 0, idx))

    " start jump
    call g:ex_GotoEditBuffer()
    if bufnr('%') != bufnr(file_name)
        exe 'silent e ' . file_name
    endif
    call cursor(line_num, 1)
    let cursor_pos = getpos(".")

    " jump to the pattern if the code have been modified
    let pattern = strpart(line, idx+2)
    let pattern = '\V' . substitute( pattern, '\', '\\\', "g" )
    if search(pattern, 'w') == 0
        call g:ex_WarningMsg('search pattern not found: ' . pattern)
    endif

    call g:ex_HighlightObjectLine()
    exe 'normal! zz'

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
    if !g:exGS_close_when_selected
        if !g:exGS_backto_editbuf
            let winnum = bufwinnr(title)
            if winnr() != winnum
                exe winnum . 'wincmd w'
            endif
            return 1
        endif
    else
        let winnum = bufwinnr(title)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
        close
        call g:ex_GotoEditBuffer()
    endif
    return 1
endfunction " >>>


" --exGS_SetCase--
"  set if ignore case
function! s:exGS_SetIgnoreCase(ignore_case) " <<<
    let s:exGS_ignore_case = a:ignore_case
    let s:exGS_need_search_again = 1
    if a:ignore_case
        echomsg 'exGS ignore case'
    else
        echomsg 'exGS no ignore case'
    endif
endfunction " >>>

" --exGS_GoDirect--
function! s:exGS_GoDirect() " <<<
    let reg_s = @s
    let save_pos = getpos(".")
    exe 'normal! "syiw'
    silent call setpos(".", save_pos )
    let search_text = @s
    let @s = reg_s
    call s:exGS_GetGlobalSearchResult(search_text, '-s', 1)
endfunction " >>>

" --exGS_GlobalSubstitute--
function! s:exGS_GlobalSubstitute( pat, sub, flag ) " <<<
    silent normal! gg
    let last_line = line("$")
    let cur_line_idx = 0
    let cur_line = ''
    while cur_line_idx <= last_line
        let s:exGS_select_idx = line(".")
        if s:exGS_Goto()
            silent call g:ex_GotoEditBuffer()
            let cur_line = substitute( getline("."), a:pat, a:sub, a:flag )
            if cur_line !=# getline(".")
                silent call setline( ".", cur_line )
            endif
            echon cur_line . "\r"
            silent call g:ex_GotoPluginBuffer()
        endif
        let cur_line_idx += 1
        silent normal! j
    endwhile
endfunction " >>>

" -- exGS_ParseSubcmd--
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

    echo pat . ' ' . sub . ' ' . flag
    call s:exGS_GlobalSubstitute( pat, sub, flag )
endfunction " >>>

" ------------------------------
"  select window part
" ------------------------------

" --exGS_InitSelectWindow--
" Init exGlobalSearch window
function! g:exGS_InitSelectWindow() " <<<
    setlocal number

    " syntax highlight
    if g:exGS_highlight_result
        " this will load the syntax highlight as cpp for search result
        silent exec "so $VIM/vimfiles/after/syntax/exUtility.vim"

        "
        syntax region exGS_SynFileName start="^[^:]*" end=":" oneline
        syntax region exGS_SynSearchPattern start="^----------" end="----------"
        syntax match exGS_SynLineNumber '\d\+:'

        "
        highlight def exGS_SynFileName gui=none guifg=DarkBlue term=none cterm=none ctermfg=DarkBlue
        highlight def exGS_SynSearchPattern gui=bold guifg=DarkRed guibg=LightGray term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray
        highlight def exGS_SynLineNumber gui=none guifg=Red term=none cterm=none ctermfg=Red
    else
        "
        syntax region exGS_SynFileName start="^[^:]*" end=":" oneline
        syntax region exGS_SynSearchPattern start="^----------" end="----------"
        syntax match exGS_SynLineNumber '\d\+:'

        "
        highlight def exGS_SynFileName gui=none guifg=Blue term=none cterm=none ctermfg=Blue
        highlight def exGS_SynSearchPattern gui=bold guifg=DarkRed guibg=LightGray term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray
        highlight def exGS_SynLineNumber gui=none guifg=Brown term=none cterm=none ctermfg=Brown
    endif

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exGS_GotoInSelectWindow()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exGS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exGS_ToggleWindow('Select')<CR>

    nnoremap <buffer> <silent> <C-Up>   :call <SID>exGS_SwitchWindow('Stack')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exGS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exGS_SwitchWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <LocalLeader>r :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>d :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'pattern', 1)<CR>
    nnoremap <buffer> <silent> <LocalLeader>ar :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>ad :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'pattern', 1)<CR>
    nnoremap <buffer> <silent> <LocalLeader>nr :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>nd :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>r <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>d <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>ar <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>ad <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>nr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>nd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'pattern', 1)<CR>

    nnoremap <buffer> <silent> <LocalLeader>fr :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'file', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>fd :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'file', 1)<CR>
    nnoremap <buffer> <silent> <LocalLeader>far :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'file', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>fad :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'file', 1)<CR>
    nnoremap <buffer> <silent> <LocalLeader>fnr :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'file', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>fnd :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'file', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>fr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'file', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>fd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'file', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>far <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'file', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>fad <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'file', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>fnr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'file', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>fnd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'file')<CR>

    nnoremap <buffer> <silent> <LocalLeader>gr :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', '', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>gd :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', '', 1)<CR>
    nnoremap <buffer> <silent> <LocalLeader>gar :call <SID>exGS_ShowPickedResultNormalMode('', 'append', '', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>gad :call <SID>exGS_ShowPickedResultNormalMode('', 'append', '', 1)<CR>
    nnoremap <buffer> <silent> <LocalLeader>gnr :call <SID>exGS_ShowPickedResultNormalMode('', 'new', '', 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>gnd :call <SID>exGS_ShowPickedResultNormalMode('', 'new', '', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>gr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', '', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>gd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', '', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>gar <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', '', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>gad <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', '', 1)<CR>
    vnoremap <buffer> <silent> <LocalLeader>gnr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', '', 0)<CR>
    vnoremap <buffer> <silent> <LocalLeader>gnd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', '', 1)<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()

    " command
    command -buffer -nargs=1 SUB call s:exGS_ParseSubcmd('<args>')
endfunction " >>>

" --exGS_GotoSelectLine--
"  goto select line
function! s:exGS_GotoInSelectWindow() " <<<
    let s:exGS_select_idx = line(".")
    call g:ex_HighlightConfirmLine()
    call s:exGS_Goto()
endfunction " >>>

" --exGS_UpdateSelectWindow--
" Update exGlobalSearch window 
function! g:exGS_UpdateSelectWindow() " <<<
    silent call cursor(s:exGS_select_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exGS_GetGlobalSearchResult--
" Get Global Search Result
" search_pattern = ''
" search_method = -s / -r / -w
function! s:exGS_GetGlobalSearchResult(search_pattern, search_method, direct_jump) " <<<
    " this will fix the jump error when tagselect in the same window
    if &filetype == "ex_filetype"
        silent exec "normal \<Esc>"
    endif

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
        let old_opt = g:exGS_backto_editbuf
        let g:exGS_backto_editbuf = 0
        call s:exGS_ToggleWindow('Select')
        let g:exGS_backto_editbuf = old_opt
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

    " TODO file path
    " let search_cmd = 'lid --file=' . g:exES_ID . ' --result=grep ' . a:search_pattern
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
    silent exec 'normal! Gdgg'
    call g:ex_HighlightConfirmLine()
    let line_num = line('.')
    silent put = search_result

    " Init search state
    let s:exGS_search_state_tmp.pattern = a:search_pattern
    let s:exGS_select_idx = line_num+1
    silent call cursor( line_num+1, 1 )
endfunction " >>>

" ------------------------------
"  stack window part
" ------------------------------
" --exGS_InitStackWindow--
" Init exGlobalSearch select window
function! g:exGS_InitStackWindow() " <<<
    " syntax highlight
    syntax match exGS_SynJumpMethodGS '\[GS]'
    syntax match exGS_SynJumpMethodGG '\[GG]'
    syntax match exGS_SynJumpSymbol '======>'
    syntax match exGS_SynStackTitle '#.\+PATTERN.\+ENTRY POINT PREVIEW'

    highlight def exGS_SynJumpMethodGS gui=none guifg=Red 
    highlight def exGS_SynJumpMethodGG gui=none guifg=Blue 
    highlight def exGS_SynJumpSymbol gui=none guifg=DarkGreen
    highlight def exGS_SynStackTitle gui=bold guifg=Brown

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exGS_Stack_GoDirect()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exGS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exGS_ToggleWindow('Stack')<CR>

    nnoremap <buffer> <silent> <C-Up>   :call <SID>exGS_SwitchWindow('Stack')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exGS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exGS_SwitchWindow('QuickView')<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" --exGS_UpdateStackWindow--
" Update exGlobalSearch stack window 
function! g:exGS_UpdateStackWindow() " <<<
    " if need update stack window 
    if s:exGS_need_update_stack_window
        let s:exGS_need_update_stack_window = 0
        call s:exGS_ShowStackList()
    endif

    let pattern = s:exGS_stack_idx . ':'
    if search( pattern, 'w') == 0
        call g:ex_WarningMsg('Pattern not found')
        return
    endif
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exGS_PushStack--
" Push the result into stack
function! s:exGS_PushStack( search_state ) " <<<
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

" --exGS_SetStack--
" Set current stack value
function! s:exGS_SetStack( search_state ) " <<<
    let s:exGS_search_stack_list[s:exGS_stack_idx] = copy( a:search_state )
endfunction " >>>

" --exGS_ShowStackList--
" Show the stack list in stack window
function! s:exGS_ShowStackList() " <<<
    " open and goto search window first
    let gs_winnr = bufwinnr(s:exGS_stack_title)
    if gs_winnr == -1
        " open window
        let old_opt = g:exGS_backto_editbuf
        let g:exGS_backto_editbuf = 0
        call s:exGS_ToggleWindow('Stack')
        let g:exGS_backto_editbuf = old_opt
    else
        exe gs_winnr . 'wincmd w'
    endif

    " clear screen
    silent exec 'normal! Gdgg'

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
    let reg_tmp = @t
    silent exec 'normal! gg"tdd'
    let @t = reg_tmp
endfunction " >>>

" --exGS_Stack_GotoTag--
" Go to idx tags
" jump_method : 'to_tag', to_entry
function! s:exGS_Stack_GotoTag( idx, jump_method ) " <<<
    let jump_method = a:jump_method
    let list_len = len(s:exGS_search_stack_list)
    " if idx < 0, return
    if a:idx < 0
        call g:ex_WarningMsg('at the top of exSearchStack')
        let s:exGS_stack_idx = 0
        return
    elseif a:idx > list_len-1
        call g:ex_WarningMsg('at the bottom of exSearchStack')
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
        let old_setting = g:exTS_backto_editbuf
        let g:exGS_backto_editbuf = 0
        call s:exGS_ToggleWindow('Stack')
        let g:exGS_backto_editbuf = old_setting
        let background_op = 1
    else
        call g:exGS_UpdateStackWindow()
    endif

    " start parsing
    if need_jump == 1
        " go by tag_idx
        if jump_method == 'to_entry'
            call g:ex_GotoEditBuffer()
            silent exec 'e ' . s:exGS_search_stack_list[s:exGS_stack_idx].entry_file_name
            call setpos('.', s:exGS_search_stack_list[s:exGS_stack_idx].entry_cursor_pos)
        else
            call g:ex_GotoEditBuffer()
            silent exec 'e ' . s:exGS_search_stack_list[s:exGS_stack_idx].pattern_file_name
            call setpos('.', s:exGS_search_stack_list[s:exGS_stack_idx].pattern_cursor_pos)
        endif
        exe 'normal! zz'
    endif

    " go back if needed
    if !g:exGS_stack_close_when_selected && !background_op
        " highlight the select object in edit buffer
        call g:ex_HighlightObjectLine()
        exe 'normal! zz'

        "
        if !g:exGS_backto_editbuf
            let winnum = bufwinnr(s:exGS_stack_title)
            if winnr() != winnum
                exe winnum . 'wincmd w'
            endif
            return
        endif
    else
        let winnum = bufwinnr(s:exGS_stack_title)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
        close
        call g:ex_GotoEditBuffer()
    endif
endfunction " >>>

" --exGS_Stack_GoDirect--
function! s:exGS_Stack_GoDirect() " <<<
    let cur_line = getline(".")
    let idx = match(cur_line, '\S')
    let cur_line = strpart(cur_line, idx)
    let idx = match(cur_line, ':')
    let stack_idx = eval(strpart(cur_line, 0, idx))
    call g:ex_HighlightConfirmLine()

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

" ------------------------------
"  quick view window part
" ------------------------------
" --exGS_InitQuickViewWindow--
" Init exGlobalSearch select window
function! g:exGS_InitQuickViewWindow() " <<<
    setlocal number
    setlocal foldmethod=marker foldmarker=<<<<<<,>>>>>> foldlevel=1

    " syntax highlight
    if g:exGS_highlight_result
        " this will load the syntax highlight as cpp for search result
        silent exec "so $VIM/vimfiles/after/syntax/exUtility.vim"

        "
        syntax region exGS_SynFileName start="^[^:]*" end=":" oneline
        syntax region exGS_SynSearchPattern start="^----------" end="----------"
        syntax match exGS_SynLineNumber '\d\+:'

        "
        highlight def exGS_SynFileName gui=none guifg=DarkBlue term=none cterm=none ctermfg=DarkBlue
        highlight def exGS_SynSearchPattern gui=bold guifg=DarkRed guibg=LightGray term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray
        highlight def exGS_SynLineNumber gui=none guifg=Red term=none cterm=none ctermfg=Red

        "
        syntax match exGS_SynFoldStart '<<<<<<'
        syntax match exGS_SynFoldEnd '>>>>>>'
        highlight def exGS_SynFoldStart gui=none guifg=DarkGreen term=none cterm=none ctermfg=DarkGreen
        highlight def exGS_SynFoldEnd gui=none guifg=DarkGreen term=none cterm=none ctermfg=DarkGreen
    else
        "
        syntax region exGS_SynFileName start="^[^:]*" end=":" oneline
        syntax region exGS_SynSearchPattern start="^----------" end="----------"
        syntax match exGS_SynLineNumber '\d\+:'

        "
        highlight def exGS_SynFileName gui=none guifg=Blue term=none cterm=none ctermfg=Blue
        highlight def exGS_SynSearchPattern gui=bold guifg=DarkRed guibg=LightGray term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray
        highlight def exGS_SynLineNumber gui=none guifg=Brown term=none cterm=none ctermfg=Brown

        "
        syntax match exGS_SynFoldStart '<<<<<<'
        syntax match exGS_SynFoldEnd '>>>>>>'
        highlight def exGS_SynFoldStart gui=none guifg=DarkGreen term=none cterm=none ctermfg=DarkGreen
        highlight def exGS_SynFoldEnd gui=none guifg=DarkGreen term=none cterm=none ctermfg=DarkGreen
    endif

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exGS_GotoInQuickViewWindow()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exGS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exGS_ToggleWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <C-Up>   :call <SID>exGS_SwitchWindow('Stack')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exGS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exGS_SwitchWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <Leader>r :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <Leader>d :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'pattern', 1)<CR>
    nnoremap <buffer> <silent> <Leader>ar :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <Leader>ad :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'pattern', 1)<CR>
    nnoremap <buffer> <silent> <Leader>nr :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'pattern', 0)<CR>
    nnoremap <buffer> <silent> <Leader>nd :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <Leader>r <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <Leader>d <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <Leader>ar <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <Leader>ad <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'pattern', 1)<CR>
    vnoremap <buffer> <silent> <Leader>nr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'pattern', 0)<CR>
    vnoremap <buffer> <silent> <Leader>nd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'pattern', 1)<CR>

    nnoremap <buffer> <silent> <Leader>fr :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'file', 0)<CR>
    nnoremap <buffer> <silent> <Leader>fd :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'file', 1)<CR>
    nnoremap <buffer> <silent> <Leader>far :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'file', 0)<CR>
    nnoremap <buffer> <silent> <Leader>fad :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'file', 1)<CR>
    nnoremap <buffer> <silent> <Leader>fnr :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'file', 0)<CR>
    nnoremap <buffer> <silent> <Leader>fnd :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'file', 1)<CR>
    vnoremap <buffer> <silent> <Leader>fr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'file', 0)<CR>
    vnoremap <buffer> <silent> <Leader>fd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'file', 1)<CR>
    vnoremap <buffer> <silent> <Leader>far <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'file', 0)<CR>
    vnoremap <buffer> <silent> <Leader>fad <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'file', 1)<CR>
    vnoremap <buffer> <silent> <Leader>fnr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'file', 0)<CR>
    vnoremap <buffer> <silent> <Leader>fnd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'file')<CR>

    nnoremap <buffer> <silent> <Leader>gr :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', '', 0)<CR>
    nnoremap <buffer> <silent> <Leader>gd :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', '', 1)<CR>
    nnoremap <buffer> <silent> <Leader>gar :call <SID>exGS_ShowPickedResultNormalMode('', 'append', '', 0)<CR>
    nnoremap <buffer> <silent> <Leader>gad :call <SID>exGS_ShowPickedResultNormalMode('', 'append', '', 1)<CR>
    nnoremap <buffer> <silent> <Leader>gnr :call <SID>exGS_ShowPickedResultNormalMode('', 'new', '', 0)<CR>
    nnoremap <buffer> <silent> <Leader>gnd :call <SID>exGS_ShowPickedResultNormalMode('', 'new', '', 1)<CR>
    vnoremap <buffer> <silent> <Leader>gr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', '', 0)<CR>
    vnoremap <buffer> <silent> <Leader>gd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', '', 1)<CR>
    vnoremap <buffer> <silent> <Leader>gar <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', '', 0)<CR>
    vnoremap <buffer> <silent> <Leader>gad <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', '', 1)<CR>
    vnoremap <buffer> <silent> <Leader>gnr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', '', 0)<CR>
    vnoremap <buffer> <silent> <Leader>gnd <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', '', 1)<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()

    " command
    command -buffer -nargs=1 SUB call s:exGS_ParseSubcmd('<args>')
endfunction " >>>

" --exGS_UpdateQuickViewWindow--
" Update exGlobalSearch stack window 
function! g:exGS_UpdateQuickViewWindow() " <<<
    silent call cursor(s:exGS_quick_view_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exGS_GotoInQuickViewWindow--
"  goto select line
function! s:exGS_GotoInQuickViewWindow() " <<<
    let s:exGS_quick_view_idx = line(".")
    " TODO save history idx
    call g:ex_HighlightConfirmLine()
    call s:exGS_Goto()
endfunction " >>>

" --exGS_CopyPickedLine--
" copy the quick view result with search pattern
function! s:exGS_CopyPickedLine( search_pattern, line_start, line_end, search_method, inverse_search ) " <<<
    if a:search_pattern == ''
        let search_pattern = @/
    else
        let search_pattern = a:search_pattern
    endif
    if search_pattern == ''
        let s:exGS_quick_view_search_pattern = ''
        call g:ex_WarningMsg('search pattern not exists')
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
            silent exec 'normal! jdG'
        endif
        " clear up lines
        if a:line_start > 1
            silent call cursor( a:line_start, 1 )
            silent exec 'normal! kdgg'
        endif
        silent call cursor( 1, 1 )

        " clear the last search result
        let s:exGS_picked_search_result = ''
        if a:inverse_search
            " if inverse search, we first filter out not pattern line, then
            " then filter pattern
            let search_results = '\(.\+:\d\+:\).*'
            silent exec 'v/' . search_results . '/d'
            silent exec 'g/' . full_search_pattern . '/d'
        else
            silent exec 'v/' . full_search_pattern . '/d'
        endif

        " clear pattern result
        while search('----------.\+----------', 'w') != 0
            silent exec 'normal! dd'
        endwhile

        " copy picked result
        let reg_t = @t
        silent exec 'normal! gg"tyG'
        let s:exGS_picked_search_result = @t
        let @t = reg_t
        " recover
        silent exec 'normal! u'

        " this two algorithm was slow
        " -------------------------
        " let cmd = 'let s:exGS_picked_search_result = s:exGS_picked_search_result . "\n" . getline(".")'
        " silent exec '1,$' . 'g/' . search_pattern . '/' . cmd
        " -------------------------
        " let cur_line = a:line_start - 1 
        " while search( search_pattern, 'W', a:line_end ) != 0
        "     if cur_line != line(".")
        "         let cur_line = line(".")
        "         let s:exGS_picked_search_result = s:exGS_picked_search_result . "\n" . getline(".")
        "     else
        "         continue
        "     endif
        " endwhile

        " go back to the original position
        silent call setpos(".", save_cursor)
    endif
endfunction " >>>

" --exGS_ShowPickedResult--
"  show the picked result in the quick view window
function! s:exGS_ShowPickedResult( search_pattern, line_start, line_end, edit_mode, search_method, inverse_search ) " <<<
    call s:exGS_CopyPickedLine( a:search_pattern, a:line_start, a:line_end, a:search_method, a:inverse_search )
    call s:exGS_SwitchWindow('QuickView')
    if a:edit_mode == 'replace'
        silent exec 'normal! Gdgg'
        let s:exGS_quick_view_idx = 1
        call g:ex_HighlightConfirmLine()
        silent put = s:exGS_quick_view_search_pattern
        silent put = s:exGS_fold_start
        silent put = s:exGS_picked_search_result
        silent put = s:exGS_fold_end
    elseif a:edit_mode == 'append'
        silent exec 'normal! G'
        silent put = ''
        silent put = s:exGS_quick_view_search_pattern
        silent put = s:exGS_fold_start
        silent put = s:exGS_picked_search_result
        silent put = s:exGS_fold_end
    elseif a:edit_mode == 'new'
        return
    endif
endfunction " >>>

" --exGS_ShowPickedResultNormalMode--
"  show the picked result in the quick view window
function! s:exGS_ShowPickedResultNormalMode( search_pattern, edit_mode, search_method, inverse_search ) " <<<
    let line_start = 1
    let line_end = line('$')
    call s:exGS_ShowPickedResult( a:search_pattern, line_start, line_end, a:edit_mode, a:search_method, a:inverse_search )
endfunction " >>>

" --exGS_ShowPickedResultVisualMode--
"  show the picked result in the quick view window
function! s:exGS_ShowPickedResultVisualMode( search_pattern, edit_mode, search_method, inverse_search ) " <<<
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

" -------------------------------------------------------------------------
" Command part
" -------------------------------------------------------------------------
command -nargs=1 GS call s:exGS_GetGlobalSearchResult('<args>', '-s', 0)
command -nargs=1 GSW call s:exGS_GetGlobalSearchResult('<args>', '-w', 0)
command -nargs=1 GSR call s:exGS_GetGlobalSearchResult('<args>', '-r', 0)
command ExgsToggle call s:exGS_ToggleWindow('')
command ExgsSelectToggle call s:exGS_ToggleWindow('Select')
command ExgsStackToggle call s:exGS_ToggleWindow('Stack')
command ExgsQuickViewToggle call s:exGS_ToggleWindow('QuickView')
command ExgsGoDirectly call s:exGS_GoDirect()
command BackwardSearchStack call s:exGS_Stack_GotoTag(s:exGS_stack_idx-1, 'to_entry')
command ForwardSearchStack call s:exGS_Stack_GotoTag(s:exGS_stack_idx+1, 'to_tag')

" quick view command
command -nargs=1 GSPR call s:exGS_ShowPickedResult('<args>', 'replace', '', 0 )
command -nargs=1 GSPRI call s:exGS_ShowPickedResult('<args>', 'replace', '', 1 )
command -nargs=1 GSPA call s:exGS_ShowPickedResult('<args>', 'append', '', 0 )
command -nargs=1 GSPAI call s:exGS_ShowPickedResult('<args>', 'append', '', 1 )
command -nargs=1 GSPN call s:exGS_ShowPickedResult('<args>', 'new', '', 0 )
command -nargs=1 GSPNI call s:exGS_ShowPickedResult('<args>', 'new', '', 1 )

" Ignore case setting
command GSigc call s:exGS_SetIgnoreCase(1)
command GSnoigc call s:exGS_SetIgnoreCase(0)


finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
