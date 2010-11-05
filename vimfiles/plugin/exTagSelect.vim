" ======================================================================================
" File         : exTagSelect.vim
" Author       : Wu Jie 
" Last Change  : 10/18/2008 | 18:57:27 PM | Saturday,October
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_extagselect') || &cp
    finish
endif
let loaded_extagselect=1

"/////////////////////////////////////////////////////////////////////////////
" variables
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" gloable varialbe initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: window height for horizon window mode
" ------------------------------------------------------------------ 

if !exists('g:exTS_window_height')
    let g:exTS_window_height = 20
endif

" ------------------------------------------------------------------ 
" Desc: window width for vertical window mode
" ------------------------------------------------------------------ 

if !exists('g:exTS_window_width')
    let g:exTS_window_width = 30
endif

" ------------------------------------------------------------------ 
" Desc: window height increment value
" ------------------------------------------------------------------ 

if !exists('g:exTS_window_height_increment')
    let g:exTS_window_height_increment = 30
endif

" ------------------------------------------------------------------ 
" Desc: window width increment value
" ------------------------------------------------------------------ 

if !exists('g:exTS_window_width_increment')
    let g:exTS_window_width_increment = 50
endif

" ------------------------------------------------------------------ 
" Desc: placement of the window
" 'topleft','botright','belowright'
" ------------------------------------------------------------------ 

if !exists('g:exTS_window_direction')
    let g:exTS_window_direction = 'belowright'
endif

" ------------------------------------------------------------------ 
" Desc: use vertical or not
" ------------------------------------------------------------------ 

if !exists('g:exTS_use_vertical_window')
    let g:exTS_use_vertical_window = 0
endif

" ------------------------------------------------------------------ 
" Desc: go back to edit buffer
" ------------------------------------------------------------------ 

if !exists('g:exTS_backto_editbuf')
    let g:exTS_backto_editbuf = 0
endif

" ------------------------------------------------------------------ 
" Desc: go and close exTagSelect window
" ------------------------------------------------------------------ 

if !exists('g:exTS_close_when_selected')
    let g:exTS_close_when_selected = 1
endif

" ------------------------------------------------------------------ 
" Desc: use syntax highlight for search result
" ------------------------------------------------------------------ 

if !exists('g:exTS_highlight_result')
    let g:exTS_highlight_result = 0
endif

" ------------------------------------------------------------------ 
" Desc: set edit mode
" 'none', 'append', 'replace'
" ------------------------------------------------------------------ 

if !exists('g:exTS_edit_mode')
    let g:exTS_edit_mode = 'replace'
endif

" ======================================================== 
" local variable initialization
" ======================================================== 


" ------------------------------------------------------------------ 
" Desc: title
" ------------------------------------------------------------------ 

let s:exTS_select_title = "__exTS_SelectWindow__"
let s:exTS_short_title = 'Select'

" ------------------------------------------------------------------ 
" Desc: general
" ------------------------------------------------------------------ 

let s:exTS_ignore_case = 0
let s:exTS_need_parse_again = 0
let s:exTS_need_push_tag = 0

" ------------------------------------------------------------------ 
" Desc: select variable
" ------------------------------------------------------------------ 

let s:exTS_cursor_idx = 0
let s:exTS_need_update_select_window = 0

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

let s:exTS_cur_taglist = []
let s:exTS_cur_tagname = ''
let s:exTS_cur_tagidx = 0

"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" global functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:exTS_ResetTaglist( new_taglist, tag_name, tag_idx ) " <<<
    let s:exTS_need_update_select_window = 1
    let s:exTS_cur_taglist = a:new_taglist
    let s:exTS_cur_tagname = a:tag_name
    let s:exTS_cur_tagidx = a:tag_idx
endfunction " >>>

" ======================================================== 
" general function defines
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exTS_ClearEntryToggleWindow( title ) " <<<
    call g:exJS_ClearEntryStateList ()
    call s:exTS_ToggleWindow ( a:title )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Open exTagSelect window 
" ------------------------------------------------------------------ 

function s:exTS_OpenWindow( short_title ) " <<<
    if a:short_title != ''
        let s:exTS_short_title = a:short_title
    endif
    let title = '__exTS_' . s:exTS_short_title . 'Window__'
    " open window
    if g:exTS_use_vertical_window
        call exUtility#OpenWindow( title, g:exTS_window_direction, g:exTS_window_width, g:exTS_use_vertical_window, g:exTS_edit_mode, 1, 'g:exTS_Init'.s:exTS_short_title.'Window', 'g:exTS_Update'.s:exTS_short_title.'Window' )
    else
        call exUtility#OpenWindow( title, g:exTS_window_direction, g:exTS_window_height, g:exTS_use_vertical_window, g:exTS_edit_mode, 1, 'g:exTS_Init'.s:exTS_short_title.'Window', 'g:exTS_Update'.s:exTS_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize the window use the increase value
" ------------------------------------------------------------------ 

function s:exTS_ResizeWindow() " <<<
    if g:exTS_use_vertical_window
        call exUtility#ResizeWindow( g:exTS_use_vertical_window, g:exTS_window_width, g:exTS_window_width_increment )
    else
        call exUtility#ResizeWindow( g:exTS_use_vertical_window, g:exTS_window_height, g:exTS_window_height_increment )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Toggle the window
" ------------------------------------------------------------------ 

function s:exTS_ToggleWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exTS_short_title != a:short_title
            if bufwinnr('__exTS_' . s:exTS_short_title . 'Window__') != -1
                call exUtility#CloseWindow('__exTS_' . s:exTS_short_title . 'Window__')
            endif
            let s:exTS_short_title = a:short_title
        endif
    endif

    " toggle exTS window
    let title = '__exTS_' . s:exTS_short_title . 'Window__'
    if g:exTS_use_vertical_window
        call exUtility#ToggleWindow( title, g:exTS_window_direction, g:exTS_window_width, g:exTS_use_vertical_window, 'none', 0, 'g:exTS_Init'.s:exTS_short_title.'Window', 'g:exTS_Update'.s:exTS_short_title.'Window' )
    else
        call exUtility#ToggleWindow( title, g:exTS_window_direction, g:exTS_window_height, g:exTS_use_vertical_window, 'none', 0, 'g:exTS_Init'.s:exTS_short_title.'Window', 'g:exTS_Update'.s:exTS_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exTS_SwitchWindow( short_title ) " <<<
    let title = '__exTS_' . a:short_title . 'Window__'
    if bufwinnr(title) == -1
        " save the old height & width
        let old_height = g:exTS_window_height
        let old_width = g:exTS_window_width

        " use the width & height of current window if it is same plugin window.
        if bufname ('%') ==# s:exTS_select_title 
            let g:exTS_window_height = winheight('.')
            let g:exTS_window_width = winwidth('.')
        endif

        " switch to the new plugin window
        call s:exTS_ToggleWindow(a:short_title)

        " recover the width and height
        let g:exTS_window_height = old_height
        let g:exTS_window_width = old_width
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: set if ignore case
" ------------------------------------------------------------------ 

function s:exTS_SetIgnoreCase(ignore_case) " <<<
    let s:exTS_ignore_case = a:ignore_case
    let s:exTS_need_parse_again = 1
    if a:ignore_case
        echomsg 'exTS ignore case'
    else
        echomsg 'exTS no ignore case'
    endif
endfunction " >>>

" ======================================================== 
"  select window functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Init exTagSelect window
" ------------------------------------------------------------------ 

function g:exTS_InitSelectWindow() " <<<
    " KEEPME: we don't need this, but keep it { 
    " load the tagfiles
    " let s:exTS_tag_file_list = tagfiles()
    " } KEEPME end 

    " syntax highlight
    if g:exTS_highlight_result
        " this will load the syntax highlight as cpp for search result
        silent exec "so $VIM/vimfiles/after/syntax/exUtility.vim"
    endif

    "
    syntax match ex_SynSearchPattern '^\S\+'
    syntax match ex_SynFileName '^\S\+\s(.\+)$'
    syntax match ex_SynNormal '^        \S.*$'
    syntax match ex_SynLineNr '^        \d\+:'

    " key map
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exTS_ToggleWindow('Select')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exTS_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exTS_GotoTagSelectResult()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse> \|:call <SID>exTS_GotoTagSelectResult()<CR>

    " DUMMY { 
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exTS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exTS_SwitchWindow('Select')<CR>
    " } DUMMY end 

    " autocmd
    au CursorMoved <buffer> :call s:exTS_SelectCursorMoved()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update window
" ------------------------------------------------------------------ 

function g:exTS_UpdateSelectWindow() " <<<
    if s:exTS_need_update_select_window
        let s:exTS_need_update_select_window = 0
        call s:exTS_ShowTagList ( s:exTS_cur_taglist )
    endif

    " NOTE: when no confirm operation, the cur_tagidx will be 0
    let tag_pattern = '^\s*' . s:exTS_cur_tagidx . ':'
    if search( tag_pattern, 'w') != 0
        call exUtility#HighlightConfirmLine()
        let s:exTS_cursor_idx = line('.')
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: call when cursor moved
" ------------------------------------------------------------------ 

function s:exTS_SelectCursorMoved() " <<<
    let line_num = line('.')

    if line_num == s:exTS_cursor_idx
        call exUtility#HighlightSelectLine()
        return
    endif

    while match(getline('.'), '^\s\+\d\+:') == -1
        if line_num > s:exTS_cursor_idx
            if line('.') == line('$')
                break
            endif
            silent exec 'normal! j'
        else
            if line('.') == 1
                silent exec 'normal! 2j'
                let s:exTS_cursor_idx = line_num - 1
            endif
            silent exec 'normal! k'
        endif
    endwhile

    let s:exTS_cursor_idx = line('.')
    call exUtility#HighlightSelectLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Get the result of a word and use :ts record the result
" ------------------------------------------------------------------ 

function s:exTS_GetTagSelectResult(tag, direct_jump) " <<<
    " strip white space.
    " DELME: let in_tag = strpart( a:tag, match(a:tag, '\S') )
    let in_tag = substitute (a:tag, '\s\+', '', 'g')
    if match(in_tag, '^\(\t\|\s\)') != -1
        return
    endif
    " if it is a new tag, push it into the tag stack and parse it.
    " NOTE: for exJumpStack, it may first parse tag, then global search, when
    " you parse tag again, you may parse the same tag, and if you skip push it
    " into stack, it will become a wrong jump
    " DISABLE: if in_tag !=# s:exTS_cur_tagname && s:exTS_need_parse_again != 1
    if s:exTS_need_parse_again != 1
        let s:exTS_need_push_tag = 1
    else
        let s:exTS_need_push_tag = 0
        let s:exTS_need_parse_again = 0
    endif

    " get taglist
    " NOTE: we use \s\* which allowed the tag have white space at the end.
    "       this is useful for lua. In current version of cTags(5.8), it
    "       will parse the lua function with space if you define the function
    "       as: functon foobar () instead of functoin foobar(). 
    if s:exTS_ignore_case && (match(in_tag, '\u') == -1)
        let in_tag = substitute( in_tag, '\', '\\\', "g" )
        echomsg 'parsing ' . in_tag . '...(ignore case)'
        let tag_list = taglist('\V\^'.in_tag.'\s\*\$')
    else
        let in_tag = substitute( in_tag, '\', '\\\', "g" )
        echomsg 'parsing ' . in_tag . '...(no ignore case)'
        let tag_list = taglist('\V\^\C'.in_tag.'\s\*\$')
    endif

    " push entry state if the taglist is not empty
    if !empty(tag_list)
        let stack_info = {}
        let stack_info.pattern = getline(".")
        if exUtility#IsRegisteredPluginBuffer ('')
            let stack_info.file_name = ''
        else
            let stack_info.file_name = bufname('%')
        endif
        let cur_pos = getpos(".")
        let stack_info.cursor_pos = [cur_pos[1],cur_pos[2]] " lnum, col
        if a:direct_jump == 0
            let stack_info.jump_method = 'TS'
        else
            let stack_info.jump_method = 'TG'
        endif
        let stack_info.keyword = in_tag
        let stack_info.taglist = []
        let stack_info.tagidx = -1
        call g:exJS_PushEntryState ( stack_info )
    endif

    " reset tag list
    call g:exTS_ResetTaglist ( tag_list, in_tag, 0 )

    " open window
    let ts_winnr = bufwinnr(s:exTS_select_title)
    if ts_winnr == -1
        call s:exTS_ToggleWindow('Select')
    else
        exe ts_winnr . 'wincmd w'
        call g:exTS_UpdateSelectWindow()
    endif

    " go to first then highlight
    silent exe 'normal! gg'
    let tag_pattern = '^\s*1:'
    call search( tag_pattern, 'w')
    call exUtility#HighlightSelectLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: ShowTagList 
" ------------------------------------------------------------------ 

function s:exTS_ShowTagList ( tag_list ) " <<<
    " clear window
    silent exec '1,$d _'
    call exUtility#HighlightConfirmLine()

    " if empty tag_list, put the error result
    if empty(a:tag_list)
        silent put = 'Error: tag not found ==> ' . s:exTS_cur_tagname
        silent put = ''
        return
    endif

    " Init variable
    let idx = 1
    let pre_tag_name = a:tag_list[0].name
    let pre_file_name = a:tag_list[0].filename
    " put different file name at first
    silent put = pre_tag_name
    silent put = exUtility#ConvertFileName(pre_file_name)
    " put search result
    for tag_info in a:tag_list
        if tag_info.name !=# pre_tag_name
            silent put = ''
            silent put = tag_info.name
            silent put = exUtility#ConvertFileName(tag_info.filename)
        elseif tag_info.filename !=# pre_file_name
            silent put = exUtility#ConvertFileName(tag_info.filename)
        endif
        " put search patterns
        let quick_view = ''
        if tag_info.cmd =~# '^\/\^' 
            let quick_view = strpart( tag_info.cmd, 2, strlen(tag_info.cmd)-4 )
            let quick_view = strpart( quick_view, match(quick_view, '\S') )
        elseif tag_info.cmd =~# '^\d\+'
            try
                let file_list = readfile( fnamemodify(tag_info.filename,":p") )
                let line_num = eval(tag_info.cmd) - 1 
                let quick_view = file_list[line_num]
                let quick_view = strpart( quick_view, match(quick_view, '\S') )
            catch /^Vim\%((\a\+)\)\=:E/
                let quick_view = "ERROR: can't get the preview from file!"
            endtry
        endif
        " this will change the \/\/ to //
        let quick_view = substitute( quick_view, '\\/', '/', "g" )
        silent put = '        ' . idx . ': ' . quick_view
        let idx += 1
        let pre_tag_name = tag_info.name
        let pre_file_name = tag_info.filename
    endfor

    "
    let s:exTS_need_update_select_window = 0
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Goto result position
" ------------------------------------------------------------------ 

function s:exTS_GotoTagSelectResult() " <<<
    " read current line as search pattern
    let cur_line = getline(".")
    if match(cur_line, '^        \S.*$') == -1
        call exUtility#WarningMsg('Pattern not found')
        return
    endif
    let idx = match(cur_line, '\S')
    let cur_line = strpart(cur_line, idx)
    let idx = match(cur_line, ':')
    let s:exTS_cur_tagidx = eval(strpart(cur_line, 0, idx))

    " jump by command
    call exUtility#GotoEditBuffer()

    " if we don't start a new stack, we pop the old jump, so that the new one
    " will only take the old stack position while we are selecting our result. 
    let keepjumps_cmd = ''
    if !s:exTS_need_push_tag
        let keepjumps_cmd = 'keepjumps'
    endif

    " process extractly jump
    call exUtility#GotoExCommand ( 
                \ fnamemodify(s:exTS_cur_taglist[s:exTS_cur_tagidx-1].filename,":p"),
                \ s:exTS_cur_taglist[s:exTS_cur_tagidx-1].cmd, 
                \ keepjumps_cmd ) 

    " push tag to jump stack if needed, otherwise set last jump stack
    let stack_info = {}
    let stack_info.pattern = getline(".")
    let stack_info.file_name = bufname('%')
    let cur_pos = getpos(".")
    let stack_info.cursor_pos = [cur_pos[1],cur_pos[2]] " lnum, col
    let stack_info.jump_method = ''
    let stack_info.keyword = s:exTS_cur_tagname
    let stack_info.taglist = s:exTS_cur_taglist
    let stack_info.tagidx = s:exTS_cur_tagidx
    if s:exTS_need_push_tag
        let s:exTS_need_push_tag = 0
        call g:exJS_PushJumpStack (stack_info)
    else
        call g:exJS_SetLastJumpStack (stack_info)
    endif

    " go back if needed
    call exUtility#OperateWindow ( s:exTS_select_title, g:exTS_close_when_selected, g:exTS_backto_editbuf, 1 )
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" Commands
"/////////////////////////////////////////////////////////////////////////////

"
command -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile TS call s:exTS_GetTagSelectResult('<args>', 0)
command ExtsSelectToggle call s:exTS_ClearEntryToggleWindow('Select')
command ExtsToggle call s:exTS_ClearEntryToggleWindow('')
command ExtsGoDirectly call s:exTS_GetTagSelectResult(expand("<cword>"), 1)

" Ignore case setting
command TSigc call s:exTS_SetIgnoreCase(1)
command TSnoigc call s:exTS_SetIgnoreCase(0)

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
