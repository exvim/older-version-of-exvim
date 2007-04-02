"=============================================================================
" File:        exScript.vim
" Author:      Johnny
" Last Change: Wed 29 Oct 2006 01:05:03 PM EDT
" Version:     1.0
"=============================================================================
" You may use this code in whatever way you see fit.

if exists('loaded_exscript') || &cp
    finish
endif
let loaded_exscript=1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------
" Initialization <<<
" gloable variable initialization
highlight def ex_SynHL1 gui=none guibg=LightCyan
highlight def ex_SynHL2 gui=none guibg=LightMagenta
highlight def ex_SynHL3 gui=none guibg=LightRed

" local script vairable initialization
let s:ex_editbuf_name = ""
let s:ex_editbuf_ftype = ""
let s:ex_editbuf_lnum = ""
let s:ex_editbuf_num = ""

" file browse
let s:ex_level_list = []
" >>>

" ------------------------
"  window functions
" ------------------------

" --ex_CreateWindow--
" Create window
" buffer_name : a string of the buffer_name
" window_direction : 'topleft', 'botright'
" use_vertical : 0, 1
" edit_mode : 'none', 'append', 'replace'
" init_func_name: 'none', 'function_name'
function! g:ex_CreateWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, init_func_name ) " <<<
    " If the window is open, jump to it
    let winnum = bufwinnr(a:buffer_name)
    if winnum != -1
        "Jump to the existing window
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif

        if a:edit_mode == 'append'
            exe 'normal! G'
        elseif a:edit_mode == 'replace'
            exe 'normal! ggdG'
        endif

        return
    endif

    " Create a new window. If user prefers a horizontal window, then open
    " a horizontally split window. Otherwise open a vertically split
    " window
    if a:use_vertical
        " Open a vertically split window
        let win_dir = 'vertical '
    else
        " Open a horizontally split window
        let win_dir = ''
    endif
    
    " If the tag listing temporary buffer already exists, then reuse it.
    " Otherwise create a new buffer
    let bufnum = bufnr(a:buffer_name)
    if bufnum == -1
        " Create a new buffer
        let wcmd = a:buffer_name
    else
        " Edit the existing buffer
        let wcmd = '+buffer' . bufnum
    endif

    " Create the ex_window
    exe 'silent! ' . win_dir . a:window_direction . ' 10' . ' split ' . wcmd
    exe win_dir . 'resize ' . a:window_size

    " Initialize the window
    if bufnum == -1
        call g:ex_InitWindow( a:init_func_name )
    endif

    " adjust with edit_mode
    if a:edit_mode == 'append'
        exe 'normal! G'
    elseif a:edit_mode == 'replace'
        exe 'normal! ggdG'
    endif

endfunction " >>>

" --ex_InitWindow--
" Init window
" init_func_name: 'none', 'function_name'
function! g:ex_InitWindow(init_func_name) " <<<
    silent! setlocal filetype=ex_filetype

    " Folding related settings
    silent! setlocal foldenable
    silent! setlocal foldminlines=0
    silent! setlocal foldmethod=manual
    silent! setlocal foldlevel=9999

    " Mark buffer as scratch
    silent! setlocal buftype=nofile
    silent! setlocal bufhidden=hide
    silent! setlocal noswapfile
    silent! setlocal nobuflisted

    silent! setlocal nowrap

    " If the 'number' option is set in the source window, it will affect the
    " exTagSelect window. So forcefully disable 'number' option for the exTagSelect
    " window
    silent! setlocal nonumber
    set winfixheight
    set winfixwidth

    " Define hightlighting
    syntax match ex_SynError '^Error:.*'

    highlight def ex_SynSelectLine gui=none guibg=LightCyan
    highlight def ex_SynConfirmLine gui=none guibg=Orange
    highlight def ex_SynObjectLine gui=none guibg=Orange
    highlight def ex_SynError gui=none guifg=White guibg=Red 

    " Define the ex autocommands
    augroup ex_auto_cmds
        autocmd WinLeave * call g:ex_RecordCurrentBufNum()
    augroup end

    if a:init_func_name != 'none'
        exe 'call ' . a:init_func_name . '()'
    endif
endfunction " >>>

" --ex_OpenWindow--
"  Open window
" buffer_name : a string of the buffer_name
" window_direction : 'topleft', 'botright'
" use_vertical : 0, 1
" edit_mode : 'none', 'append', 'replace'
" backto_editbuf : 0, 1
" init_func_name: 'none', 'function_name'
" call_func_name: 'none', 'function_name'
function! g:ex_OpenWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, backto_editbuf, init_func_name, call_func_name ) " <<<
    " If the window is open, jump to it
    let winnum = bufwinnr(a:buffer_name)
    if winnum != -1
        " Jump to the existing window
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif

        if a:edit_mode == 'append'
            exe 'normal! G'
        elseif a:edit_mode == 'replace'
            exe 'normal! ggdG'
        endif

        return
    endif

    " Get the filename and filetype for the specified buffer
    let s:ex_editbuf_name = fnamemodify(bufname('%'), ':p')
    let s:ex_editbuf_ftype = getbufvar('%', '&filetype')
    let s:ex_editbuf_lnum = line('.')
    let s:ex_editbuf_num = bufnr('%')

    " Open window
    call g:ex_CreateWindow( a:buffer_name, a:window_direction, a:window_size, a:use_vertical, a:edit_mode, a:init_func_name )

    if a:call_func_name != 'none'
        exe 'call ' . a:call_func_name . '()'
    endif

    if a:backto_editbuf
        " Need to jump back to the original window only if we are not
        " already in that window
        let winnum = bufwinnr(s:ex_editbuf_num)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
    endif
endfunction " >>>

" --ex_CloseWindow--
"  Close window
function! g:ex_CloseWindow( buffer_name ) " <<<
    "Make sure the window exists
    let winnum = bufwinnr(a:buffer_name)
    if winnum == -1
        call g:ex_WarningMsg('Error: ' . a:buffer_name . ' window is not open')
        return
    endif
    
    if winnr() == winnum
        let last_buf_num = bufnr('#') 
        " Already in the window. Close it and return
        if winbufnr(2) != -1
            " If a window other than the a:buffer_name window is open,
            " then only close the a:buffer_name window.
            close
        endif

        " Need to jump back to the original window only if we are not
        " already in that window
        let winnum = bufwinnr(last_buf_num)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
    else
        " Goto the a:buffer_name window, close it and then come back to the 
        " original window
        let cur_buf_num = bufnr('%')
        exe winnum . 'wincmd w'
        close
        " Need to jump back to the original window only if we are not
        " already in that window
        let winnum = bufwinnr(cur_buf_num)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
    endif
    call g:ex_ClearObjectHighlight()
endfunction " >>>

" --ex_ToggleWindow--
" Toggle window
function! g:ex_ToggleWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, backto_editbuf, init_func_name, call_func_name ) " <<<
    " If exTagSelect window is open then close it.
    let winnum = bufwinnr(a:buffer_name)
    if winnum != -1
        call g:ex_CloseWindow(a:buffer_name)
        return
    endif

    call g:ex_OpenWindow( a:buffer_name, a:window_direction, a:window_size, a:use_vertical, a:edit_mode, a:backto_editbuf, a:init_func_name, a:call_func_name )
endfunction " >>>

" --ex_ResizeWindow
"  Resize window use increase value
function! g:ex_ResizeWindow( use_vertical, original_size, increase_size ) " <<<
    if a:use_vertical
        let new_size = a:original_size
        if winwidth('.') <= a:original_size
            let new_size = a:original_size + a:increase_size
        endif
        silent exe 'vertical resize ' . new_size
    else
        let new_size = a:original_size
        if winheight('.') <= a:original_size
            let new_size = a:original_size + a:increase_size
        endif
        silent exe 'resize ' . new_size
    endif


endfunction " >>>

" ------------------------
"  string functions
" ------------------------
" --ex_AlignDigit--
function! g:ex_AlignDigit( align_nr, digit ) " <<<
    let print_fmt = '%'.a:align_nr.'d'
    let str_digit = printf(print_fmt,a:digit)
    retur substitute(str_digit,' ', '0','g')
endfunction " >>>

" --ex_InsertIFZero--
function! g:ex_InsertIFZero() range " <<<
    let lstline = a:lastline + 1 
    call append( a:lastline , "#endif")
    call append( a:firstline -1 , "#if 0")
    exec ":" . lstline
endfunction " >>>

" --ex_RemoveIFZero--
function! g:ex_RemoveIFZero() range " <<<
    let save_cursor = getpos(".")
    let save_line = getline(".")
    let cur_line = save_line
    while match(cur_line, "#if.*0") == -1
        silent normal [#
        let cur_line = getline(".")
    endwhile
    silent normal dd]#
    let cur_line = getline(".")
    if match(cur_line, "#else") != -1
        silent normal dd]#dd
    else
        silent normal dd
    endif

    silent call setpos('.', save_cursor)
    silent call search(save_line, 'b')
    silent call cursor(line('.'), save_cursor[2])
endfunction " >>>

" --ex_InsertRemoveCmt--
function! g:ex_InsertRemoveCmt() range " <<<
    if (strpart(getline('.'),0,2) == "//")
        exec ":" . a:firstline . "," . a:lastline . "s\/^\\\/\\\/\/\/"
    else
        exec ":" . a:firstline . "," . a:lastline . "s\/^\/\\\/\\\/\/"
    endif
endfunction " >>>

" ------------------------
"  buffer functions
" ------------------------

" --ex_RecordCurrentBufNum--
" Record current buf num when leave
function! g:ex_RecordCurrentBufNum() " <<<
    let s:ex_editbuf_num = bufnr('%')
endfunction " >>>

" --ex_UpdateCurrentBuffer--
"  Update current buffer
function! g:ex_UpdateCurrentBuffer() " <<<
    if exists(':UMiniBufExplorer')
        silent exe "UMiniBufExplorer"
    endif
endfunction " >>>

" --ex_GotoEditBuffer--
function! g:ex_GotoEditBuffer() " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif
endfunction " >>>

" --ex_GotoLastEditBuffer--
function! g:ex_GotoLastEditBuffer() " <<<
    " check if buffer existed and listed
    let bufnr = bufnr("#")
    if buflisted(bufnr) && bufloaded(bufnr) && bufexists(bufnr)
        "silent exec "normal M"
        silent exec bufnr."b!"
    else
        call g:ex_WarningMsg("Buffer: " .bufname(bufnr).  " can't be accessed.")
    endif
endfunction " >>>

" --ex_Kwbd--
" VimTip #1119: How to use Vim like an IDE
" delete the buffer; keep windows; create a scratch buffer if no buffers left 
" Using this Kwbd function (:call Kwbd(1)) will make Vim behave like an IDE; or maybe even better. 
function g:ex_Kwbd(kwbdStage) 
    if(a:kwbdStage == 1) 
        if(!buflisted(winbufnr(0))) 
            bd! 
            return 
        endif 
        let g:kwbdBufNum = bufnr("%") 
        let g:kwbdWinNum = winnr() 
        windo call g:ex_Kwbd(2) 
        execute "normal " . g:kwbdWinNum . "" 
        let g:buflistedLeft = 0 
        let g:bufFinalJump = 0 
        let l:nBufs = bufnr("$") 
        let l:i = 1 
        while(l:i <= l:nBufs) 
            if(l:i != g:kwbdBufNum) 
                if(buflisted(l:i)) 
                    let g:buflistedLeft = g:buflistedLeft + 1 
                else 
                    if(bufexists(l:i) && !strlen(bufname(l:i)) && !g:bufFinalJump) 
                        let g:bufFinalJump = l:i 
                    endif 
                endif 
            endif 
            let l:i = l:i + 1 
        endwhile 
        if(!g:buflistedLeft) 
            if(g:bufFinalJump) 
                windo if(buflisted(winbufnr(0))) | execute "b! " . g:bufFinalJump | endif 
            else 
                enew 
                let l:newBuf = bufnr("%") 
                windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif 
            endif 
            execute "normal " . g:kwbdWinNum . "" 
        endif 
        if(buflisted(g:kwbdBufNum) || g:kwbdBufNum == bufnr("%")) 
            execute "bd! " . g:kwbdBufNum 
        endif 
        if(!g:buflistedLeft) 
            set buflisted 
            set bufhidden=delete 
            set buftype=nofile 
            setlocal noswapfile 
            normal athis is the scratch buffer 
        endif 
    else 
        if(bufnr("%") == g:kwbdBufNum) 
            let prevbufvar = bufnr("#") 
            if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != g:kwbdBufNum) 
                b # 
            else 
                bn 
            endif 
        endif 
    endif 
endfunction 


" ------------------------
"  file functions
" ------------------------

" --ex_ConvertFileName--
" Convert full file name into the format: file_name (directory)
function! g:ex_ConvertFileName(full_file_name) " <<<
    let idx = strridx(a:full_file_name, '\')
    if idx != -1
        return strpart(a:full_file_name, idx+1) . ' (' . strpart(a:full_file_name, 0, idx) . ')'
    else
        return a:full_file_name . ' (' . '.)'
    endif
endfunction ">>>

" --ex_GetFullFileName--
" Get full file name from converted format
function! g:ex_GetFullFileName(converted_line) " <<<
    if match(a:converted_line, '^\S\+\s(\S\+)$') == -1
        call g:ex_WarningMsg('format is wrong')
        return
    endif
    let idx_space = stridx(a:converted_line, ' ')
    let simple_file_name = strpart(a:converted_line, 0, idx_space)
    let idx_bracket_first = stridx(a:converted_line, '(')
    let file_path = strpart(a:converted_line, idx_bracket_first+1)
    let idx_bracket_last = stridx(file_path, ')')
    return strpart(file_path, 0, idx_bracket_last) . '\' . simple_file_name
endfunction " >>>

" --ex_MatchTagFile()--
" Match tag and find file if it has
function! g:ex_MatchTagFile( tag_file_list, file_name ) " <<<
    " if we can use PWD find file, use it first
    if exists('g:exES_PWD')
        let full_file_name = substitute(g:exES_PWD,'\','',"g") . substitute(a:file_name,'\.\\','\\',"g")
        if findfile(full_file_name) != ''
            return simplify(full_file_name)
        endif
    endif

    let full_file_name = ''
    for tag_file in a:tag_file_list
        let tag_path = strpart( tag_file, 0, strridx(tag_file, '\') )
        let full_file_name = tag_path . a:file_name
        if findfile(full_file_name) != ''
            break
        endif
        let full_file_name = ''
    endfor

    if full_file_name == ''
        call g:ex_WarningMsg( a:file_name . ' not found' )
    endif

    return simplify(full_file_name)
endfunction " >>>

" --ex_GetFileFilterPattern--
function! g:ex_GetFileFilterPattern(filter) " <<<
    let filter_list = split(a:filter,' ')
    let filter_pattern = '\V'
    for filter in filter_list
        let filter_pattern = filter_pattern . '.' . '\<' . filter . '\>\$\|'
    endfor
    return strpart(filter_pattern, 0, strlen(filter_pattern)-2)
endfunction " >>>

" --ex_BrowseWithEmtpy--
function! g:ex_BrowseWithEmtpy(dir, filter) " <<<
    " get short_dir
    let short_dir = strpart( a:dir, strridx(a:dir,'\')+1 )
    if short_dir == ''
        let short_dir = a:dir
    endif

    " write space
    let space = ''
    let list_idx = 0
    let list_last = len(s:ex_level_list)-1
    for level in s:ex_level_list
        if level.is_last != 0 && list_idx != list_last
            let space = space . '  '
        else
            let space = space . ' |'
        endif
        let list_idx += 1
    endfor
    let space = space.'-'

    " get end_fold
    let end_fold = ''
    let rev_list = reverse(copy(s:ex_level_list))
    for level in rev_list
        if level.is_last != 0
            let end_fold = end_fold . ' }'
        else
            break
        endif
    endfor

    " judge if it is a dir
    if isdirectory(a:dir) == 0
        " put it
        let file_type = strpart( short_dir, strridx(short_dir,'.')+1, 1 )
        silent put = space.'['.file_type.']'.short_dir  . end_fold
        " if file_end enter a new line for it
        if end_fold != ''
            let end_space = strpart(space,0,strridx(space,'-')-1)
            let end_space = strpart(end_space,0,strridx(end_space,'|')+1)
            silent put = end_space " . end_fold
        endif
        return
    else
        " split the first level to file_list
        let file_list = split(globpath(a:dir,'*'),'\n')

        " first sort the list as we want (file|dir )
        let list_idx = 0
        let list_last = len(file_list)-1
        let list_count = 0
        while list_count <= list_last
            if isdirectory(file_list[list_idx]) == 0 " move the file to the end of the list
                if match(file_list[list_idx],a:filter) == -1
                    silent call remove(file_list,list_idx)
                    let list_idx -= 1
                else
                    let file = remove(file_list,list_idx)
                    silent call add(file_list, file)
                    let list_idx -= 1
                endif
            endif
            " ++++++++++++++++++++++++++++++++++
            " if isdirectory(file_list[list_idx]) != 0 " move the dir to the end of the list
            "     let dir = remove(file_list,list_idx)
            "     silent call add(file_list, dir)
            "     let list_idx -= 1
            " else " filter file
            "     if match(file_list[list_idx],a:filter) == -1
            "         silent call remove(file_list,list_idx)
            "         let list_idx -= 1
            "     endif
            " endif
            " ++++++++++++++++++++++++++++++++++

            let list_idx += 1
            let list_count += 1
        endwhile

        "silent put = strpart(space, 0, strridx(space,'\|-')+1)
        if len(file_list) == 0 " if it is a empty directory
            if end_fold == ''
                " if dir_end enter a new line for it
                let end_space = strpart(space,0,strridx(space,'-'))
            else
                " if dir_end enter a new line for it
                let end_space = strpart(space,0,strridx(space,'-')-1)
                let end_space = strpart(end_space,0,strridx(end_space,'|')+1)
            endif
            let end_fold = end_fold . ' }'
            silent put = space.'[F]'.short_dir . ' {' . end_fold
            silent put = end_space
        else
            silent put = space.'[F]'.short_dir . ' {'
        endif
        silent call add(s:ex_level_list, {'is_last':0,'short_dir':short_dir})
    endif

    " ECHO full_path for this level
    " ++++++++++++++++++++++++++++++++++
    " let full_path = ''
    " for level in s:ex_level_list
    "     let full_path = level.short_dir.'/'.full_path
    " endfor
    " echon full_path."\r"
    " ++++++++++++++++++++++++++++++++++

    " recuseve browse list
    let list_idx = 0
    let list_last = len(file_list)-1
    for dir in file_list
        if list_idx == list_last
            let s:ex_level_list[len(s:ex_level_list)-1].is_last = 1
        endif
        call g:ex_BrowseWithEmtpy(dir,a:filter)
        let list_idx += 1
    endfor
    silent call remove( s:ex_level_list, len(s:ex_level_list)-1 )
endfunction " >>>

" --ex_SetLevelList()
function! g:ex_SetLevelList( line_num, by_next_line ) " <<<
    if len(s:ex_level_list)
        silent call remove(s:ex_level_list, 0, len(s:ex_level_list)-1)
    endif

    " for the clear method
    if a:line_num == -1
        return
    endif

    let idx = -1
    let cur_line = ''
    if a:by_next_line == 1
        let cur_line = getline(a:line_num+1)
        let idx = strridx(cur_line, '|') -2
    else
        let cur_line = getline(a:line_num)
        let idx = strridx(cur_line, '|')
    endif
    let cur_line = strpart(cur_line, 1, idx)

    let len = strlen(cur_line)
    let idx = 0
    while idx <= len
        if cur_line[idx] == '|'
            silent call add(s:ex_level_list, {'is_last':0,'short_dir':''})
        else
            silent call add(s:ex_level_list, {'is_last':1,'short_dir':''})
        endif
        let idx += 2
    endwhile

    echo s:ex_level_list
endfunction " >>>

" --ex_Browse--
function! g:ex_Browse(dir, filter) " <<<
    " get short_dir
    let short_dir = strpart( a:dir, strridx(a:dir,'\')+1 )

    " if directory
    if isdirectory(a:dir) == 1
        " split the first level to file_list
        let file_list = split(globpath(a:dir,'*'),'\n')

        " sort and filter the list as we want (file|dir )
        let list_idx = 0
        let list_last = len(file_list)-1
        let list_count = 0
        while list_count <= list_last
            if isdirectory(file_list[list_idx]) == 0 " move the file to the end of the list
                if match(file_list[list_idx],a:filter) == -1
                    silent call remove(file_list,list_idx)
                    let list_idx -= 1
                else
                    let file = remove(file_list,list_idx)
                    silent call add(file_list, file)
                    let list_idx -= 1
                endif
            endif
            " ++++++++++++++++++++++++++++++++++
            "if isdirectory(file_list[list_idx]) != 0 " move the dir to the end of the list
            "    let dir = remove(file_list,list_idx)
            "    silent call add(file_list, dir)
            "    let list_idx -= 1
            "else " filter file
            "    if match(file_list[list_idx],a:filter) == -1
            "        silent call remove(file_list,list_idx)
            "        let list_idx -= 1
            "    endif
            "endif
            " ++++++++++++++++++++++++++++++++++

            let list_idx += 1
            let list_count += 1
        endwhile

        silent call add(s:ex_level_list, {'is_last':0,'short_dir':short_dir})
        " recuseve browse list
        let list_last = len(file_list)-1
        let list_idx = list_last
        let s:ex_level_list[len(s:ex_level_list)-1].is_last = 1
        while list_idx >= 0
            if list_idx != list_last
                let s:ex_level_list[len(s:ex_level_list)-1].is_last = 0
            endif
            if g:ex_Browse(file_list[list_idx],a:filter) == 1 " if it is empty
                silent call remove(file_list,list_idx)
                let list_last = len(file_list)-1
            endif
            let list_idx -= 1
        endwhile

        silent call remove( s:ex_level_list, len(s:ex_level_list)-1 )

        if len(file_list) == 0
            return 1
        endif
    endif

    " write space
    let space = ''
    let list_idx = 0
    let list_last = len(s:ex_level_list)-1
    for level in s:ex_level_list
        if level.is_last != 0 && list_idx != list_last
            let space = space . '  '
        else
            let space = space . ' |'
        endif
        let list_idx += 1
    endfor
    let space = space.'-'

    " get end_fold
    let end_fold = ''
    let rev_list = reverse(copy(s:ex_level_list))
    for level in rev_list
        if level.is_last != 0
            let end_fold = end_fold . ' }'
        else
            break
        endif
    endfor

    " judge if it is a dir
    if isdirectory(a:dir) == 0
        " if file_end enter a new line for it
        if end_fold != ''
            let end_space = strpart(space,0,strridx(space,'-')-1)
            let end_space = strpart(end_space,0,strridx(end_space,'|')+1)
            silent put! = end_space " . end_fold
        endif
        " put it
        let file_type = strpart( short_dir, strridx(short_dir,'.')+1, 1 )
        silent put! = space.'['.file_type.']'.short_dir . end_fold
        return 0
    else

        "silent put = strpart(space, 0, strridx(space,'\|-')+1)
        if len(file_list) == 0 " if it is a empty directory
            if end_fold == ''
                " if dir_end enter a new line for it
                let end_space = strpart(space,0,strridx(space,'-'))
            else
                " if dir_end enter a new line for it
                let end_space = strpart(space,0,strridx(space,'-')-1)
                let end_space = strpart(end_space,0,strridx(end_space,'|')+1)
            endif
            let end_fold = end_fold . ' }'
            silent put! = end_space
            silent put! = space.'[F]'.short_dir . ' {' . end_fold
        else
            silent put! = space.'[F]'.short_dir . ' {'
        endif
        if list_last == -1 " if len of ex_level_list is 0
            silent put! = ''
        endif
    endif
    return 0

    " ECHO full_path for this level
    " ++++++++++++++++++++++++++++++++++
    " let full_path = ''
    " for level in s:ex_level_list
    "     let full_path = level.short_dir.'/'.full_path
    " endfor
    " echon full_path."\r"
    " ++++++++++++++++++++++++++++++++++
endfunction " >>>

" ------------------------
"  fold functions
" ------------------------

" --ex_GetFoldLevel--
function! g:ex_GetFoldLevel(line_num) " <<<
    let cur_line = getline(a:line_num)
    let cur_line = strpart(cur_line,0,strridx(cur_line,'|')+1)
    let str_len = strlen(cur_line)
    return str_len/2
endfunction " >>>

" --ex_FoldText() --
function! g:ex_FoldText() " <<<
    let line = getline(v:foldstart)
    let line = substitute(line,'\[F\]\(.\{-}\) {.*','\[+\]\1 ','')
    return line
    " let line = getline(v:foldstart)
    " let line = strpart(line, 0, strridx(line,'|')+1)
    " let line = line . '+'
    " return line
endfunction ">>>

" ------------------------
"  jump functions
" ------------------------

" --ex_Goto--
" Goto the position by file name and search pattern
function! g:ex_GotoSearchPattern(full_file_name, search_pattern) " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif

    " start jump
    let file_name = escape(a:full_file_name, ' ')
    exe 'silent e ' . file_name

    " if search_pattern is digital, just set pos of it
    let line_num = strpart(a:search_pattern, 2, strlen(a:search_pattern)-4)
    let line_num = matchstr(line_num, '^\d\+$')
    if line_num
        call cursor(eval(line_num), 1)
    elseif search(a:search_pattern, 'w') == 0
        call g:ex_WarningMsg('search pattern not found')
        return 0
    endif

    " set the text at the middle
    exe 'normal zz'

    return 1
endfunction " >>>

" --ex_GotoExCommand--
" Goto the position by file name and search pattern
function! g:ex_GotoExCommand(full_file_name, ex_cmd) " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif

    " start jump
    let file_name = escape(a:full_file_name, ' ')
    if bufnr('%') != bufnr(file_name)
        exe 'silent e ' . file_name
    endif

    " cursor jump
    " if ex_cmd is digital, just set pos of it
    if match( a:ex_cmd, '^\/\^' ) != -1
        let pattern = strpart(a:ex_cmd, 2, strlen(a:ex_cmd)-4)
        let pattern = '\V\^' . pattern . (pattern[len(pattern)-1] == '$' ? '\$' : '')
        if search(pattern, 'w') == 0
            call g:ex_WarningMsg('search pattern not found: ' . pattern)
            return 0
        endif
    elseif match( a:ex_cmd, '^\d\+' ) != -1
        silent exe a:ex_cmd
    endif

    " set the text at the middle
    exe 'normal zz'

    return 1
endfunction " >>>

" --ex_GotoTagNumber--
function! g:ex_GotoTagNumber(tag_number) " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif

    silent exec a:tag_number . "tr!"

    " set the text at the middle
    exe 'normal zz'
endfunction " >>>

" --ex_GotoPos--
" Goto the pos by position list
function! g:ex_GotoPos(poslist) " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif

    " TODO must have buffer number or buffer name
    call setpos('.', a:poslist)

    " set the text at the middle
    exe 'normal zz'
endfunction " >>>

" ------------------------
"  make functions
" ------------------------

" --ex_GCCMake()--
function! g:ex_GCCMake(args) " <<<
    " save all file for compile first
    silent exec "wa!"

    let entry_file = glob('entry_gcc*.mk') 
    if entry_file != ''
        exec "!make -f" . entry_file . " " . a:args
    else
        call g:ex_WarningMsg("entry file not found")
    endif
endfunction " >>>

" --ex_VCMake()-- 
function! g:ex_VCMake(cmd, config) " <<<
    " save all file for compile first
    silent exec "wa!"

    let make_vs = glob('make_vs.bat') 
    if make_vs != ''
        if exists('g:exES_Solution')
            let escape_idx = stridx(a:cmd, '/')
            let prj_name = ''
            let cmd = a:cmd

            " parse project
            if escape_idx != -1
                let prj_name = strpart(a:cmd, 0, escape_idx)
                let cmd = strpart(a:cmd, escape_idx+1)
            endif

            " redefine cmd
            if cmd == "all"
                let cmd = "Build"
            elseif cmd == "rebuild"
                let cmd = "Rebuild"
            elseif cmd == "clean-all"
                let cmd = "Clean"
            else
                call g:ex_WarningMsg("command: ".cmd."not found")
                return
            endif

            " exec make_vs.bat
            exec "!make_vs ".cmd.' '.g:exES_Solution.' '.a:config.' '.prj_name
        else
            call g:ex_WarningMsg("solution not found")
        endif
    else
        call g:ex_WarningMsg("make_vs.bat not found")
    endif
endfunction " >>>

" --ex_UpdateVimFiles()--
"  type: ID,symbol,tag,none=all
function! g:ex_UpdateVimFiles( type ) " <<<
    " create folder if not exists
    if g:exES_vimfile_dir != ''
        if finddir(g:exES_vimfile_dir) == ''
            silent call mkdir(g:exES_vimfile_dir)
        endif
    else
        call g:ex_WarningMsg("pls specified g:exES_vimfile_dir")
    endif

    " exec bat
    if a:type == ""
        let quick_gen_bat = glob('quick_gen_project*.bat') 
        if quick_gen_bat != ''
            silent exec "!" . quick_gen_bat
        else
            call g:ex_WarningMsg("quick_gen_project*.bat not found")
        endif
    elseif a:type == "ID"
        echo "Creating IDs..."
        silent exec '!mkid --include="text"'
        echo "Copy ID to ./_vimfiles/ID"
        silent exec '!copy ID "./_vimfiles/ID"'
        echo "Delete ./ID"
        silent exec '!del ID'
        echo "Finish"
    elseif a:type == "symbol"
        echo "Creating Symbols..."
        silent exec '!gawk -f "c:\Program Files\Vim\make\gawk\prg_NoStripSymbol.awk" ./_vimfiles/tags>./_vimfiles/symbol'
    elseif a:type == "tag"
        echo "Creating Tags..."
        silent exec '!ctags -o./_vimfiles/tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ --langmap=c:+.inl -I'
    else
        call g:ex_WarningMsg("do not found update-type: " . a:type )
    endif
endfunction " >>>

" --ex_Debug()--
function! g:ex_Debug( exe_name )
    if glob(a:exe_name) == ''
        call g:ex_WarningMsg('file: ' . a:exe_name . ' not found')
    else
        silent exec '!insight ' . a:exe_name
    endif
endfunction

" ------------------------
"  Hightlight functions
" ------------------------

" --ex_HighlightConfirmLine--
" hightlight confirm line
function! g:ex_HighlightConfirmLine() " <<<
    " Clear previously selected name
    match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe 'match ex_SynConfirmLine ' . pat
endfunction " >>>

" --ex_HighlightSelectLine--
" hightlight select line
function! g:ex_HighlightSelectLine() " <<<
    " Clear previously selected name
    2match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe '2match ex_SynSelectLine ' . pat
endfunction " >>>

" --ex_HighlightObjectLine--
" hightlight object line
function! g:ex_HighlightObjectLine() " <<<
    " Clear previously selected name
    3match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe '3match ex_SynObjectLine ' . pat
endfunction " >>>

" --ex_ClearObjectHighlight--
"  clear the object line hight light
function! g:ex_ClearObjectHighlight() " <<<
    " Clear previously selected name
    3match none
endfunction " >>>

" --ex_Highlight_Normal--
" hightlight match_nr
function! g:ex_Highlight_Normal(match_nr) " <<<
    let cur_line = line(".")
    let cur_col = col(".")
    " Clear previously selected name
    silent exe a:match_nr . 'match none'

    let reg_h = @h
    exe 'normal "hyiw'
    exe a:match_nr . 'match ex_SynHL' . a:match_nr . ' ' . '/\<'.@h.'\>/'
    let @h = reg_h
    silent call cursor(cur_line, cur_col)
endfunction " >>>

" --ex_Highlight_Visual--
" hightlight match_nr
function! g:ex_Highlight_Visual(match_nr) " <<<
    let cur_line = line(".")
    let cur_col = col(".")
    " Clear previously selected name
    silent exe a:match_nr . 'match none'
    let line_start = line("'<")
    let line_end = line("'>")

    " if in the same line
    let pat = '//'
    if line_start == line_end
        let sl = line_start-1
        let sc = col("'<")-1
        let el = line_end+1
        let ec = col("'>")+1
        let pat = '/\%>'.sl.'l'.'\%>'.sc.'v'.'\%<'.el.'l'.'\%<'.ec.'v/'
    else
        let sl = line_start-1
        let el = line_end+1
        let pat = '/\%>'.sl.'l'.'\%<'.el.'l/'
    endif
    exe a:match_nr . 'match ex_SynHL' . a:match_nr . ' ' . pat
    silent call cursor(cur_line, cur_col)
endfunction " >>>

" --ex_HighlightCancle--
" Cancle highlight
function! g:ex_HighlightCancle(match_nr) " <<<
    let cur_line = line(".")
    let cur_col = col(".")
    if a:match_nr == 0
        1match none
        2match none
        3match none
    else
        silent exe a:match_nr . 'match none'
    endif
    silent call cursor(cur_line, cur_col)
endfunction " >>>

" ------------------------
"  Debug functions
" ------------------------

" --ex_WarningMsg--
" Display a message using WarningMsg highlight group
function! g:ex_WarningMsg(msg) " <<<
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunction " >>>

finish
" vim600: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
