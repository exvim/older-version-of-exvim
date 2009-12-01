" ======================================================================================
" File         : exProject.vim
" Author       : Wu Jie 
" Last Change  : 10/18/2008 | 18:56:58 PM | Saturday,October
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_exproject') || &cp
    finish
endif
let loaded_exproject=1

"/////////////////////////////////////////////////////////////////////////////
" variables
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" gloable varialbe initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: window height for horizon window mode
" ------------------------------------------------------------------ 

if !exists('g:exPJ_window_height')
    let g:exPJ_window_height = 20
endif

" ------------------------------------------------------------------ 
" Desc: window width for vertical window mode
" ------------------------------------------------------------------ 

if !exists('g:exPJ_window_width')
    let g:exPJ_window_width = 30
endif

" ------------------------------------------------------------------ 
" Desc: window height increment value
" ------------------------------------------------------------------ 

if !exists('g:exPJ_window_height_increment')
    let g:exPJ_window_height_increment = 30
endif

" ------------------------------------------------------------------ 
" Desc: window width increment value
" ------------------------------------------------------------------ 

if !exists('g:exPJ_window_width_increment')
    let g:exPJ_window_width_increment = 50
endif

" ------------------------------------------------------------------ 
" Desc: placement of the window
" 'topleft','botright', 'belowright'
" ------------------------------------------------------------------ 

if !exists('g:exPJ_window_direction')
    let g:exPJ_window_direction = 'topleft'
endif

" ------------------------------------------------------------------ 
" Desc: use vertical or not
" ------------------------------------------------------------------ 

if !exists('g:exPJ_use_vertical_window')
    let g:exPJ_use_vertical_window = 1
endif

" ------------------------------------------------------------------ 
" Desc: go back to edit buffer
" ------------------------------------------------------------------ 

if !exists('g:exPJ_backto_editbuf')
    let g:exPJ_backto_editbuf = 1
endif

" ------------------------------------------------------------------ 
" Desc: close the project window after selected, by YJR
" ------------------------------------------------------------------ 

if !exists('g:exPJ_close_when_selected')
    let g:exPJ_close_when_selected = 0
endif

" ------------------------------------------------------------------ 
" Desc: set edit mode
" 'none', 'append', 'replace'
" ------------------------------------------------------------------ 

if !exists('g:exPJ_edit_mode')
    let g:exPJ_edit_mode = 'replace'
endif

" ======================================================== 
" local variable initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: title
" ------------------------------------------------------------------ 

let s:exPJ_select_title = "__exPJ_SelectWindow__"
let s:exPJ_short_title = 'Select'
let s:exPJ_cur_filename = '__exPJ_SelectWindow__'

" ------------------------------------------------------------------ 
" Desc: select variable
" ------------------------------------------------------------------ 

let s:exPJ_cursor_line = 0
let s:exPJ_cursor_col = 0
let s:exPJ_need_update_select_window = 0

"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" general functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Open exTagSelect window 
" ------------------------------------------------------------------ 

function s:exPJ_OpenWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exPJ_short_title != a:short_title
            let _title = '__exPJ_' . s:exPJ_short_title . 'Window__'
            if s:exPJ_short_title == 'Select'
                let _title = s:exPJ_cur_filename
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
        call exUtility#OpenWindow( title, g:exPJ_window_direction, g:exPJ_window_width, g:exPJ_use_vertical_window, 'none', 1, 'g:exPJ_Init'.s:exPJ_short_title.'Window', 'g:exPJ_Update'.s:exPJ_short_title.'Window' )
    else
        call exUtility#OpenWindow( title, g:exPJ_window_direction, g:exPJ_window_height, g:exPJ_use_vertical_window, 'none', 1, 'g:exPJ_Init'.s:exPJ_short_title.'Window', 'g:exPJ_Update'.s:exPJ_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize the window use the increase value
" ------------------------------------------------------------------ 

function s:exPJ_ResizeWindow() " <<<
    if g:exPJ_use_vertical_window
        call exUtility#ResizeWindow( g:exPJ_use_vertical_window, g:exPJ_window_width, g:exPJ_window_width_increment )
    else
        call exUtility#ResizeWindow( g:exPJ_use_vertical_window, g:exPJ_window_height, g:exPJ_window_height_increment )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Toggle the window
" ------------------------------------------------------------------ 

function s:exPJ_ToggleWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exPJ_short_title != a:short_title
            let _title = '__exPJ_' . s:exPJ_short_title . 'Window__'
            if s:exPJ_short_title == 'Select'
                let _title = s:exPJ_cur_filename
            endif
            if bufwinnr(_title) != -1
                call exUtility#CloseWindow(_title)
            endif
            let s:exPJ_short_title = a:short_title
        endif
    endif

    let title = '__exPJ_' . s:exPJ_short_title . 'Window__'
    " toggle exPJ window
    if a:short_title == 'Select'
        let title = s:exPJ_cur_filename
    endif

    " when toggle on, we expect the cursor can be focus on that window.
    if g:exPJ_use_vertical_window
        call exUtility#ToggleWindow( title, g:exPJ_window_direction, g:exPJ_window_width, g:exPJ_use_vertical_window, 'none', 0, 'g:exPJ_Init'.s:exPJ_short_title.'Window', 'g:exPJ_Update'.s:exPJ_short_title.'Window' )
    else
        call exUtility#ToggleWindow( title, g:exPJ_window_direction, g:exPJ_window_height, g:exPJ_use_vertical_window, 'none', 0, 'g:exPJ_Init'.s:exPJ_short_title.'Window', 'g:exPJ_Update'.s:exPJ_short_title.'Window' )
    endif
endfunction " >>>

" DISABLE { 
" " ------------------------------------------------------------------ 
" " Desc: 
" " ------------------------------------------------------------------ 

" function s:exPJ_SwitchWindow( short_title ) " <<<
"     let title = '__exPJ_' . a:short_title . 'Window__'
"     if a:short_title == 'Select'
"         let title = s:exPJ_cur_filename
"     endif
"     if bufwinnr(title) == -1
"         " save the old height & width
"         let old_height = g:exPJ_window_height
"         let old_width = g:exPJ_window_width

"         " use the width & height of current window if it is same plugin window.
"         if fnamemodify(bufname ('%'),':p:.') ==# fnamemodify(s:exPJ_cur_filename,':p:.') || bufname ('%') ==# s:exPJ_quick_view_title
"             let g:exPJ_window_height = winheight('.')
"             let g:exPJ_window_width = winwidth('.')
"         endif

"         " switch to the new plugin window
"         call s:exPJ_ToggleWindow(a:short_title)

"         " recover the width and height
"         let g:exPJ_window_height = old_height
"         let g:exPJ_window_width = old_width
"     endif
" endfunction " >>>
" } DISABLE end 

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exPJ_GetName( line_num ) " <<<
    let line = getline(a:line_num)
    let line = substitute(line,'.\{-}\[.\{-}\]\(.\{-}\)','\1','')
    let idx_end_1 = stridx(line,' {')
    let idx_end_2 = stridx(line,' }')
    if idx_end_1 != -1
        let line = strpart(line,0,idx_end_1)
    elseif idx_end_2 != -1
        let line = strpart(line,0,idx_end_2)
    endif
    return line
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: used by exPJ_GetPath, by YJR
" ------------------------------------------------------------------ 

function s:exPJ_SearchForPattern(line_num,pattern) " <<<
    for linenum in range(a:line_num , 1 , -1)
        if match( getline(linenum) , a:pattern ) != -1
            return linenum
        endif
    endfor
    return 0
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Get the full path of the line, by YJR
" ------------------------------------------------------------------ 

function s:exPJ_GetPath( line_num ) " <<<
    let fold_level = exUtility#GetFoldLevel(a:line_num)

    " recursively make full path
    if match(getline(a:line_num),'[^^]-\C\[F\]') != -1
        let full_path = s:exPJ_GetName( a:line_num )
    else
        let full_path = ""
    endif
    let level_pattern = repeat('.',fold_level-1)
    let searchpos = a:line_num
    while fold_level > 1 " don't parse level:0
        let fold_level -= 1
        let level_pattern = repeat('.',fold_level*2)
        let fold_pattern = '^'.level_pattern.'-\C\[F\]'
        let searchpos = s:exPJ_SearchForPattern(searchpos , fold_pattern)
        if searchpos
            let full_path = s:exPJ_GetName(searchpos).'/'.full_path
        else
            call exUtility#WarningMsg('Fold not found')
            break
        endif
    endwhile

    return full_path
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exPJ_RefreshWindow() " <<<
    " silent! wincmd H
    if g:exPJ_use_vertical_window
        silent exe 'vertical resize ' . g:exPJ_window_width
    else
        silent exe 'resize ' . g:exPJ_window_height
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exPJ_UpdateFilters() " <<<
    let file_filter_txt = getline( search('^file filter =', 'nw') )
    if file_filter_txt != ''
        silent call exUtility#SetProjectFilter ( "file_filter", strpart( file_filter_txt, stridx(file_filter_txt, "=")+2 ) )
    endif

    let dir_filter_txt = getline( search('^dir filter =', 'nw') )
    if dir_filter_txt != ''
        silent call exUtility#SetProjectFilter ( "dir_filter", strpart( dir_filter_txt, stridx(dir_filter_txt, "=")+2 ) )
    endif
endfunction

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exPJ_EchoPath () " <<<
    " get line text and line number
    let line_text = getline('.')
    let line_nr = line('.')

    " get full path name.
    let full_path_name = ''
    if match(line_text, '\C\[[^F]*\]') == -1
        let full_path_name = s:exPJ_GetPath(line_nr)
    else
        let full_path_name = s:exPJ_GetPath(line_nr) . s:exPJ_GetName(line_nr)
    endif

    " echo the path name
    echohl Statement
    echo full_path_name
    echohl None
endfunction " >>>


" ======================================================== 
"  select window functons
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Init exTagSelect window
" ------------------------------------------------------------------ 

function g:exPJ_InitSelectWindow() " <<<
    " NOTE: overwrite the filetype from ex_plugin to ex_project, so that the project window will not be close when doing a ex-operation
    silent! setlocal filetype=ex_project 
    silent! setlocal buftype=
    silent! setlocal cursorline

    " +++++++++++++++++++++++++++++++
    " silent! setlocal foldmethod=expr
    " silent! setlocal foldexpr=exUtility#GetFoldLevel(v:lnum)
    " silent! setlocal foldtext=exUtility#FoldText()
    " +++++++++++++++++++++++++++++++
    silent! setlocal foldmethod=marker foldmarker={,} foldlevel=1
    silent! setlocal foldtext=exUtility#FoldText()
    silent! setlocal foldminlines=0
    silent! setlocal foldlevel=9999
    syntax match ex_SynTransparent '{'
    syntax match ex_SynTransparent '}'
    " +++++++++++++++++++++++++++++++

    " syntax highlight
    syntax match exPJ_SynDir '\C\[F\]'
    syntax match exPJ_TreeLine '\( |\)\+-*\ze'
    syntax match exPJ_SynFile '\C\[[^F]*\]'
    syntax match exPJ_SynFilter '^.* filter = .*$'
    syntax match exPJ_SynSrcFile '\[c\]'
    syntax match exPJ_SynHeaderFile '\[\(h\|i\)\]'
    syntax match exPJ_SynErrorFile '\[e\]'

    " key map
    " silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exPJ_ToggleWindow('Select')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exPJ_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exPJ_GotoSelectResult('e')<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exPJ_GotoSelectResult('e')<CR>

    nnoremap <silent> <buffer> <S-Return> :call <SID>exPJ_GotoSelectResult('bel sp')<CR>
    nnoremap <silent> <buffer> <S-2-LeftMouse> :call <SID>exPJ_GotoSelectResult('bel sp')<CR>

    nnoremap <silent> <buffer> <localleader>C    :call <SID>exPJ_CreateProject(1)<CR>
    nnoremap <silent> <buffer> <localleader>cf   :call <SID>exPJ_RefreshProject(1)<CR>
    nnoremap <silent> <buffer> <localleader>R    :call <SID>exPJ_CreateProject(0)<CR>
    nnoremap <silent> <buffer> <localleader>r    :call <SID>exPJ_RefreshProject(0)<CR>
    nnoremap <silent> <buffer> <localleader>e    :call <SID>exPJ_EchoPath()<CR>

    " map to NERDTree if exists
    if exists (':NERDTree')
        nnoremap <buffer> <silent> <c-right>   :NERDTree<CR>
    else " dummy mapping
        nnoremap <buffer> <silent> <c-right>   :call exUtility#WarningMsg('invalid')<CR>
    endif
    nnoremap <buffer> <silent> <c-left>   :echon "dummy operation\r"<CR>

    "
    nnoremap <silent> <buffer> <c-up> :call exUtility#CursorJump( 'ErrorLog.err', 'up' )<CR>
    nnoremap <silent> <buffer> <c-down> :call exUtility#CursorJump( 'ErrorLog.err', 'down' )<CR>

    nnoremap <silent> <buffer> <c-k> :call exUtility#CursorJump( '\C\[F\]', 'up' )<CR>
    nnoremap <silent> <buffer> <c-j> :call exUtility#CursorJump( '\C\[F\]', 'down' )<CR>

    "
    nnoremap <silent> <buffer> o  :call <SID>exPJ_CreateNewFile()<CR>
    nnoremap <silent> <buffer> O  :call <SID>exPJ_CreateNewFold()<CR>

    " Autocommands to keep the window the specified size
    au WinLeave <buffer> :call s:exPJ_RefreshWindow()
    au BufWritePost <buffer> :call s:exPJ_UpdateFilters()
    " au CursorMoved <buffer> :call exUtility#HighlightSelectLine()
    au CursorHold <buffer> :call s:exPJ_EchoPath()

    " init filter variables
    call s:exPJ_UpdateFilters ()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update window
" ------------------------------------------------------------------ 

function g:exPJ_UpdateSelectWindow() " <<<
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exPJ_OpenProject(project_name) " <<<
    " set and find project file
    if a:project_name != ''
        " if we open a different project, close the old one first.
        if a:project_name !=# s:exPJ_cur_filename
            if bufwinnr(s:exPJ_cur_filename) != -1
                call exUtility#CloseWindow(s:exPJ_cur_filename)
            endif
        endif

        " reset project filename and title.
        let s:exPJ_cur_filename = a:project_name
        let s:exPJ_select_title = s:exPJ_cur_filename
    endif

    " open and goto the window
    let pj_winnr = bufwinnr(s:exPJ_select_title)
    if pj_winnr == -1
        " open window
        call s:exPJ_ToggleWindow('Select')
    else
        exe pj_winnr . 'wincmd w'
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exPJ_CreateProject(with_dialog) " <<<
    call s:exPJ_UpdateFilters()
    call exUtility#SetLevelList(-1, 1)

    " get entry dir
    let entry_dir = getcwd()
    if exists('g:exES_CWD')
        let entry_dir = g:exES_CWD
    endif

    " if use dialog
    if a:with_dialog == 1
        " if the exProject is standalone version, show entry dir dialog
        if !exists('g:exES_CWD')
            let entry_dir = inputdialog( 'Enter the entry directory: ', getcwd(), 'cancle' )
            if entry_dir == ''
                call exUtility#WarningMsg('Entry dir is empty')
                return
            elseif entry_dir == 'cancle'
                return
            endif
        endif

        " get file filter
        let project_file_filter = exUtility#GetProjectFilter ( "file_filter" )
        let file_filter = inputdialog( 'Enter the file filters: sample(cpp,c,inl): ', project_file_filter, 'cancle')
        if file_filter == 'cancle'
            return
        else
            silent call exUtility#SetProjectFilter ( "file_filter", file_filter )
        endif

        " add dir filter
        let project_dir_filter = exUtility#GetProjectFilter ( "dir_filter" )
        let dir_filter = inputdialog( 'Enter the dir filters: sample(folder1,folder2): ', project_dir_filter, 'cancle')
        if dir_filter == 'cancle'
            return
        else
            silent call exUtility#SetProjectFilter ( "dir_filter", dir_filter )
        endif
    endif

    echon "Creating exProject: " . entry_dir . "\r"
    call s:exPJ_OpenProject('')
    silent exec '1,$d _'

    " create filname list and filanmetag list
    " KEEPME: let filename_list = [[],[],[]] " NOTE: 0 is the filenametag, 1 is the filenamelist_cwd, 2 is the filenamelist_vimfiles
    let filename_list = []
    silent call add ( filename_list, "!_TAG_FILE_SORTED\t2\t/0=unsorted, 1=sorted, 2=foldcase/")
    let project_file_filter = exUtility#GetProjectFilter ( "file_filter" )
    let project_dir_filter = exUtility#GetProjectFilter ( "dir_filter" )
    call exUtility#Browse( entry_dir, exUtility#GetFileFilterPattern(project_file_filter), exUtility#GetDirFilterPattern(project_dir_filter), filename_list )

    " save filenametag list
    if exists( 'g:exES_LookupFileTag' )
        echon "sorting filenametags... \r"
        silent call writefile( sort(filename_list), simplify(g:exES_CWD.'/'.g:exES_LookupFileTag))
        echon "save as " . g:exES_LookupFileTag . " \r"
    endif

    " KEEPME: we don't use this method now { 
    " save filenamelist_cwd & filenamelist_vimfiles
    " if exists( 'g:exES_FilenameList' )
    "     silent call writefile( filename_list[1], simplify(g:exES_CWD.'/'.g:exES_FilenameList.'_cwd'))
    "     echon "save as " . g:exES_FilenameList . "_cwd \r"
    "     silent call writefile( filename_list[2], simplify(g:exES_CWD.'/'.g:exES_FilenameList.'_vimfiles'))
    "     echon "save as " . g:exES_FilenameList . "_vimfiles \r"
    " endif
    " } KEEPME end 

    " DELME: since exUtility#CreateIDLangMap will be call in SetProjectFilter ('file_filter'), I don't think here we need it { 
    " Create id-lang-autogen map
    " echon "generate id-lang-autogen.map file... \r"
    " call exUtility#CreateIDLangMap( project_file_filter )
    " } DELME end 

    silent keepjumps normal! gg
    silent put! = ''
    silent put! = 'dir filter = ' . project_dir_filter
    silent put! = 'file filter = ' . project_file_filter
    silent normal! 3j

    echon "Creating exProject: " . entry_dir . " done!\r"
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" TODO: doesn't work
" TODO: should be refresh file in current directory no recursively
" ------------------------------------------------------------------ 

function s:exPJ_QuickRefreshProject() " <<<
    " check if the line is valid file line
    let file_line = getline('.') 
    if match(file_line, '.*|.*') == -1
        call exUtility#WarningMsg ("can't refresh project at this line")
        return
    endif

    " get filter
    let project_file_filter = exUtility#GetProjectFilter ( "file_filter" )
    let filter = inputdialog( 'Enter the filters: sample(cpp c inl): ', project_file_filter, 'cancle')
    if filter == 'cancle'
        return
    else
        silent call exUtility#SetProjectFilter ( "file_filter", filter )
    endif

    " if fold, open it else if not a file return
    if foldclosed('.') != -1
        normal! zr
    endif

    " initial variable
    let fold_level = exUtility#GetFoldLevel(line('.'))
    let fold_level -= 1
    let level_pattern = repeat('.',fold_level*2)
    let full_path_name = ''
    let fold_pattern = '^'.level_pattern.'-\C\[F\]'

    " get first fold name
    if match(file_line, '\C\[F\]') == -1
        if search(fold_pattern,'b')
            let full_path_name = s:exPJ_GetName(line('.'))
        else
            call exUtility#WarningMsg('Fold not found')
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
            let fold_pattern = '^'.level_pattern.'-\C\[F\]'
            if search(fold_pattern,'b')
                let full_path_name = s:exPJ_GetName(line('.')).'/'.full_path_name
            else
                call exUtility#WarningMsg('Fold not found')
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
    let space_cout = (exUtility#GetFoldLevel(line('.'))+1)*2+1
    let pattern_dot = repeat('.', space_cout)
    let file_pattern = pattern_dot . '-\[.\]'

    " start search
    let line_idx = search(file_pattern)

    while (line_idx>fold_start) && (line_idx<=fold_end) && (line_idx!=-1)
        let cur_line = getline(line_idx)

        let idx = stridx(cur_line, '}')
        if idx == -1
            silent exec 'normal! "_ddk'
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

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exPJ_RefreshProject( with_dialog ) " <<<
    " check if the line is valid file line
    let file_line = getline('.') 
    if match(file_line, '.*|.*') == -1
        call exUtility#WarningMsg ("can't refresh project at this line")
        return
    endif

    call s:exPJ_UpdateFilters()

    if a:with_dialog == 1
        " get filter
        let project_file_filter = exUtility#GetProjectFilter ( "file_filter" )
        let filter = inputdialog( 'Enter the filters: sample(cpp c inl): ', project_file_filter, 'cancle')

        "
        if filter == 'cancle'
            return
        else
            silent call exUtility#SetProjectFilter ( "file_filter", filter )
        endif
    endif

    " if fold, open it else if not a file return
    if foldclosed('.') != -1
        normal! zr
    endif

    " initial variable
    let fold_level = exUtility#GetFoldLevel(line('.'))
    let fold_level -= 1
    let level_pattern = repeat('.',fold_level*2)
    let full_path_name = ''
    let fold_pattern = '^'.level_pattern.'-\C\[F\]'

    " get first fold name
    if match(file_line, '\C\[F\]') == -1
        if search(fold_pattern,'b')
            let full_path_name = s:exPJ_GetName(line('.'))
        else
            call exUtility#WarningMsg('Fold not found')
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
    let is_root_dir = 0
    if fold_level == 0
        let is_root_dir = 1
    else
        while fold_level > 1
            let fold_level -= 1
            let level_pattern = repeat('.',fold_level*2)
            let fold_pattern = '^'.level_pattern.'-\C\[F\]'
            if search(fold_pattern,'b')
                let full_path_name = s:exPJ_GetName(line('.')).'/'.full_path_name
            else
                call exUtility#WarningMsg('Fold not found')
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
    if is_root_dir == 0
        call exUtility#SetLevelList(line('.'), 1)
    endif
    " delete the whole fold
    silent exec "normal! zc"
    silent exec 'normal! "_2dd'
    " broswing

    let tag_contents = [] 
    let project_file_filter = exUtility#GetProjectFilter ( "file_filter" )
    let project_dir_filter = exUtility#GetProjectFilter ( "dir_filter" )
    call exUtility#Browse( full_path_name, exUtility#GetFileFilterPattern(project_file_filter), is_root_dir ? exUtility#GetDirFilterPattern(project_dir_filter) : '', tag_contents )
    unlet tag_contents 

    " reset level list
    call exUtility#SetLevelList(-1, 1)

    echon "Update directory: " . full_path_name . " done!\r"

    " at the end, we need to rename the folder as simple one
    " rename the folder
    let cur_line = getline('.')

    " if this is a empty directory, return
    let pattern = '\C\[F\].*\<' . short_dir . '\> {'
    if match(cur_line, pattern) == -1
        call exUtility#WarningMsg("The directory is empty")
        return
    endif

    let idx_start = stridx(cur_line, ']')
    let start_part = strpart(cur_line,0,idx_start+1)

    let idx_end = stridx(cur_line, ' {')
    let end_part = strpart(cur_line,idx_end)

    silent call setline('.', start_part . short_dir . end_part)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exPJ_CreateNewFile() " <<<
    " check if the line is valid file line
    let cur_line = getline('.') 
    if match(cur_line, '\C\[.*\]') == -1
        call exUtility#WarningMsg ("can't create new file at this line")
        return
    endif

    let reg_t = @t
    if foldclosed('.') != -1
        silent exec 'normal! j"tyy"t2p$a-[]'
        return
    endif

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

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exPJ_CreateNewFold() " <<<
    " check if the line is valid folder line
    let cur_line = getline('.') 
    if match(cur_line, '\C\[F\]') == -1
        call exUtility#WarningMsg ("pls create new folder under a parent folder line")
        return
    endif

    let reg_t = @t
    if foldclosed('.') != -1
        silent exec 'normal! j"tyy"t2p$a-[]'
        return
    endif

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

" ------------------------------------------------------------------ 
" Desc: 
" NOTE: the e, sp edit_cmd only work with file 
"       for folder, when you use e edit_cmd, it will do folder open/close
"                   when you use sp edit_cmd, it will do prompt cmd/terminal
" ------------------------------------------------------------------ 

function s:exPJ_GotoSelectResult(edit_cmd) " <<<
    " check if the line is valid file line
    let cur_line = getline('.') 
    if match(cur_line, '\C\[.*\]') == -1
        call exUtility#WarningMsg('Please select a file')
        return
    endif

    " initial variable
    let s:exPJ_cursor_line = line('.')
    let s:exPJ_cursor_col = col('.')

    let file_line = getline('.')
    " if fold, open it else if not a file return
    if foldclosed('.') != -1 || match(getline('.'), '\C\[F\]') != -1
        if a:edit_cmd == 'e'
            normal! za
        else
            call exUtility#Terminal ( 'remain', 'nowait', 'cd '. s:exPJ_GetPath(s:exPJ_cursor_line) )
        endif
        return
    elseif match(file_line, '\C\[[^F]*\]') == -1
        if a:edit_cmd == 'e'
            call exUtility#WarningMsg('Please select a file')
        else
            call exUtility#Terminal ( 'remain', 'nowait', 'cd '. s:exPJ_GetPath(s:exPJ_cursor_line) )
        endif
        return
    endif

    let full_path_name = s:exPJ_GetPath(s:exPJ_cursor_line) . s:exPJ_GetName(s:exPJ_cursor_line)

    silent call cursor(s:exPJ_cursor_line,s:exPJ_cursor_col)

    " simplify the file name
    let full_path_name = fnamemodify( full_path_name, ":p" )
    let full_path_name = escape(simplify(full_path_name),' ')

    " switch file_type
    " let file_type = strpart( full_path_name, strridx(full_path_name,'.')+1 )
    let file_type = fnamemodify( full_path_name, ":e" )
    if file_type == 'err'
        echon 'load quick fix list: ' . full_path_name . "\r"
        call exUtility#GotoPluginBuffer()
        silent exec 'QF '.full_path_name
        " NOTE: when open error by QF, we don't want to exec exUtility#OperateWindow below ( we want keep stay in the exQF plugin ), so return directly 
        return 
    elseif file_type == 'mk'
        echon 'set make file: ' . full_path_name . "\r"
        call exUtility#GotoEditBuffer()
        silent exec a:edit_cmd.' '.full_path_name
        """"""""""""""""""""""""""""""""""""""
        " do not show it in buffer list // jwu: show them have more convienience
        " silent! setlocal bufhidden=hide
        " silent! setlocal noswapfile
        " silent! setlocal nobuflisted
        """"""""""""""""""""""""""""""""""""""
    elseif file_type == 'exe'
        echon 'debug: ' . full_path_name . "\r"
        call exUtility#GotoEditBuffer()
        call exUtility#Debug( full_path_name )
    else " default
        " put the edit file
        echon full_path_name . "\r"
        " silent wincmd p
        call exUtility#GotoEditBuffer()
        " do not open again if the current buf is the file to be opened
        if fnamemodify(expand("%"),":p") != fnamemodify(full_path_name,":p")
            silent exec a:edit_cmd.' '.full_path_name
        endif
    endif

    " go back if needed
    call exUtility#OperateWindow ( s:exPJ_select_title, g:exPJ_close_when_selected, g:exPJ_backto_editbuf, 0 )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
"  jump_to_project_window
"   0: do not jump the cursor to project window
"   1: jump the cursor to project window
" ------------------------------------------------------------------ 

function s:exPJ_GotoCurrentFile( jump_to_project_window ) " <<<
    " first make sure we are in edit buffer.
    call exUtility#GotoEditBuffer()

    " get current buffer name then jump
    let cur_filename = fnamemodify(bufname("%") , ":t")
    let cur_filefullpath = fnamemodify(bufname("%") , ":p")
    let is_found = 0

    " go to the project window
    silent call s:exPJ_OpenProject("")

    " store position if we don't find, restore to the position
    let cursor_line = line ('.')
    let cursor_col = col ('.')

    " now go to the top start search
    silent normal gg

    " process search
    while !is_found
        if search( cur_filename, "W" ) > 0
            let linenum = line ('.')
            let searchfilename = s:exPJ_GetPath(linenum) . s:exPJ_GetName(linenum)
            if fnamemodify(searchfilename , ":p") == cur_filefullpath
                silent call cursor(linenum, 0)
                " unfold the line if it's folded
                norm! zv
                " if find, set the text line in the middel of the window
                silent normal! zz

                "
                let is_found = 1
                echon "file found in: " . cur_filefullpath . "\r"
                break
            endif
        else " if file not found
            silent call cursor ( cursor_line, cursor_col )
            call exUtility#WarningMsg('Warnning file not found: ' . cur_filefullpath )
            return 
        endif
    endwhile

    " back to edit buffer if needed
    if !a:jump_to_project_window
        call exUtility#GotoEditBuffer()
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: return if the project is open or not, YJR
" ------------------------------------------------------------------ 

function! g:exPJ_IsWindowOpened() " <<<
    return bufwinnr(s:exPJ_cur_filename) != -1
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" Commands
"/////////////////////////////////////////////////////////////////////////////

command -narg=? -complete=file EXProject call s:exPJ_OpenProject('<args>')
command ExpjSelectToggle call s:exPJ_ToggleWindow('Select')
command ExpjGotoCurrentFile call s:exPJ_GotoCurrentFile(1)
command ExpjUpdateFilters call s:exPJ_UpdateFilters()

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
