" ======================================================================================
" File         : exBufExplorer.vim
" Author       : Wu Jie 
" Last Change  : 06/21/2009 | 14:52:59 PM | Sunday,June
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_exbufexplorer') || &cp
    finish
endif
let loaded_exbufexplorer=1

"/////////////////////////////////////////////////////////////////////////////
" variables
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" gloable varialbe initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: window height for horizon window mode
" ------------------------------------------------------------------ 

if !exists('g:exBE_window_height')
    let g:exBE_window_height = 20
endif

" ------------------------------------------------------------------ 
" Desc: window width for vertical window mode
" ------------------------------------------------------------------ 

if !exists('g:exBE_window_width')
    let g:exBE_window_width = 30
endif

" ------------------------------------------------------------------ 
" Desc: window height increment value
" ------------------------------------------------------------------ 

if !exists('g:exBE_window_height_increment')
    let g:exBE_window_height_increment = 30
endif

" ------------------------------------------------------------------ 
" Desc: window width increment value
" ------------------------------------------------------------------ 

if !exists('g:exBE_window_width_increment')
    let g:exBE_window_width_increment = 50
endif

" ------------------------------------------------------------------ 
" Desc: placement of the window
" 'topleft','botright', 'belowright'
" ------------------------------------------------------------------ 

if !exists('g:exBE_window_direction')
    let g:exBE_window_direction = 'botright'
endif

" ------------------------------------------------------------------ 
" Desc: use vertical or not
" ------------------------------------------------------------------ 

if !exists('g:exBE_use_vertical_window')
    let g:exBE_use_vertical_window = 1
endif

" ------------------------------------------------------------------ 
" Desc: go back to edit buffer
" ------------------------------------------------------------------ 

if !exists('g:exBE_backto_editbuf')
    let g:exBE_backto_editbuf = 0
endif

" ------------------------------------------------------------------ 
" Desc: go and close exTagSelect window
" ------------------------------------------------------------------ 

if !exists('g:exBE_close_when_selected')
    let g:exBE_close_when_selected = 0
endif

" ------------------------------------------------------------------ 
" Desc: set edit mode
" 'none', 'append', 'replace'
" ------------------------------------------------------------------ 

if !exists('g:exBE_edit_mode')
    let g:exBE_edit_mode = 'replace'
endif

" ======================================================== 
" local variable initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: title
" ------------------------------------------------------------------ 

let s:exBE_select_title = '__exBE_SelectWindow__'
let s:exBE_short_title = 'Select'

" ------------------------------------------------------------------ 
" Desc: select variable
" ------------------------------------------------------------------ 

let s:exBE_select_line = ''

"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" general functions
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: Open exTagSelect window 
" ------------------------------------------------------------------ 

function s:exBE_OpenWindow( short_title ) " <<<
    let title = '__exBE_' . s:exBE_short_title . 'Window__'

    " open window
    if g:exBE_use_vertical_window
        call exUtility#OpenWindow( title, g:exBE_window_direction, g:exBE_window_width, g:exBE_use_vertical_window, 'none', 1, 'g:exBE_Init'.s:exBE_short_title.'Window', 'g:exBE_Update'.s:exBE_short_title.'Window' )
    else
        call exUtility#OpenWindow( title, g:exBE_window_direction, g:exBE_window_height, g:exBE_use_vertical_window, 'none', 1, 'g:exBE_Init'.s:exBE_short_title.'Window', 'g:exBE_Update'.s:exBE_short_title.'Window' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize the window use the increase value
" ------------------------------------------------------------------ 

function s:exBE_ResizeWindow() " <<<
    if g:exBE_use_vertical_window
        call exUtility#ResizeWindow( g:exBE_use_vertical_window, g:exBE_window_width, g:exBE_window_width_increment )
    else
        call exUtility#ResizeWindow( g:exBE_use_vertical_window, g:exBE_window_height, g:exBE_window_height_increment )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Toggle the window
" ------------------------------------------------------------------ 

function s:exBE_ToggleWindow( short_title ) " <<<
    let title = '__exBE_' . s:exBE_short_title . 'Window__'

    " when toggle on, we expect the cursor can be focus on that window.
    if g:exBE_use_vertical_window
        call exUtility#ToggleWindow( title, g:exBE_window_direction, g:exBE_window_width, g:exBE_use_vertical_window, 'none', 0, 'g:exBE_Init'.s:exBE_short_title.'Window', 'g:exBE_Update'.s:exBE_short_title.'Window' )
    else
        call exUtility#ToggleWindow( title, g:exBE_window_direction, g:exBE_window_height, g:exBE_use_vertical_window, 'none', 0, 'g:exBE_Init'.s:exBE_short_title.'Window', 'g:exBE_Update'.s:exBE_short_title.'Window' )
    endif
endfunction " >>>

" ======================================================== 
" Select window
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: init select window
" ------------------------------------------------------------------ 

function g:exBE_InitSelectWindow () " <<<
    silent! setlocal cursorline
    silent! setlocal nomodifiable

    syntax match ex_SynSearchPattern '^-- \S\+ --'
    syntax match ex_SynLineNr '^ \d\+:'
    syntax region ex_SynFileName start="(" end=")" oneline

    " key map
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_close . " :call <SID>exBE_ToggleWindow('Select')<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_resize . " :call <SID>exBE_ResizeWindow()<CR>"
    silent exec "nnoremap <buffer> <silent> " . g:ex_keymap_confirm . " \\|:call <SID>exBE_GotoInSelectWindow()<CR>"
    nnoremap <buffer> <silent> <2-LeftMouse>   \|:call <SID>exBE_GotoInSelectWindow()<CR>

    nnoremap <buffer> <silent> dd   :call <SID>exBE_DeleteSelectLine()<CR>

    " Autocommands to keep the window the specified size
    au WinEnter <buffer> :call g:exBE_UpdateSelectWindow()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update exProject select window 
" ------------------------------------------------------------------ 

function g:exBE_UpdateSelectWindow() " <<<
    call s:exBE_ShowEditBuffers ()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: goto select line
" ------------------------------------------------------------------ 

function s:exBE_GotoInSelectWindow() " <<<
    let line = getline('.')
    if line =~ '^-- \S\+ --' || line == ''
        call exUtility#WarningMsg("can't jump in this line")
        return
    endif

    let bufnum = str2nr( getline('.') )
    if bufnum == 0
        let start_idx = stridx(line,'(') + 1
        let end_idx = stridx(line,')')
        let bufname = strpart( line, start_idx, end_idx - start_idx ) 
    else
        let bufname = expand("#".bufnum.":p")
    endif
    let s:exBE_select_line = line

    " silent wincmd p
    call exUtility#GotoEditBuffer()

    " do not open again if the current buf is the file to be opened
    if fnamemodify(expand("%"),":p") != bufname
        silent exec 'e ' . bufname
    endif

    " go back if needed
    let title = '__exBE_' . s:exBE_short_title . 'Window__'
    call exUtility#OperateWindow ( title, g:exBE_close_when_selected, g:exBE_backto_editbuf, 0 )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exBE_DeleteSelectLine () " <<<
    let line_nr = line('.')
    let bookmark_nr = search ('-- Bookmarks --', 'n')
    if line_nr > bookmark_nr
        call s:exBE_DeleteSelectBookmark ()
    else
        call s:exBE_DeleteSelectBuffer ()
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exBE_DeleteSelectBuffer () " <<<
    let bufnum = str2nr( getline('.') )
    if bufnum == 0
        call exUtility#WarningMsg("This is not a buffer line, can't delete it!")
    else
        " we can't delete no-save buffer
        if getbufvar(bufnum, '&modified') == 1
            call exUtility#WarningMsg( "Sorry, no write since last change for buffer: ".bufname(bufnum).", unable to delete" )
            return
        endif

        " goto edit buffer run \bd to delete the specific buffer
        call exUtility#GotoEditBuffer()
        silent exec 'b' . bufnum
        call exUtility#Kwbd(1)
        call s:exBE_GotoSelectWindow()
        let edit_bufnum = exUtility#GetEditBufferNum ()

        " then we locate the edit_buf if we found it. 
        silent call search( '^ '.edit_bufnum.':', 'w' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exBE_DeleteSelectBookmark () " <<<
    if exists ( 'g:exES_Bookmarks' )
        silent! setlocal modifiable
        silent normal! "_dd
        silent! setlocal nomodifiable

        let bookmark_nr = search ('-- Bookmarks --', 'n')
        let lines = getline( bookmark_nr+1, '$' )
        silent call writefile( lines, g:exES_Bookmarks )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exBE_GotoSelectWindow() " <<<
    " open and goto the window
    let pj_winnr = bufwinnr(s:exBE_select_title)
    if pj_winnr == -1
        " open window
        call s:exBE_ToggleWindow('Select')
    else
        exe pj_winnr . 'wincmd w'
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exBE_ShowEditBuffers () " <<<
    let buf_explorer_title = '-- Buffers --' 
    let book_mark_title = '-- Bookmarks --' 

    " walk through all window in exvim
    let bnum = 1
    let line_list = []
    while bnum <= bufnr("$")
        let bufname = bufname(bnum)
        if !exUtility#IsRegisteredPluginBuffer ( bufname ) && getbufvar( bnum, '&buflisted') == 1
            let text = ' ' . bnum . ': ' . fnamemodify( bufname, ':t' ) . ' (' .fnamemodify( bufname, ':h' ) . ')'
            silent call add ( line_list, text )
        endif
        let bnum += 1
    endwhile

    " clear screen and put the new context
    silent! setlocal modifiable
    silent exec '1,$d _'
    silent call append( line('$'), buf_explorer_title )
    silent call append( line('$'), line_list )

    " save book marks
    if exists ( 'g:exES_Bookmarks' )
        silent call append( line('$'), [''] )
        silent call append( line('$'), book_mark_title )
        if filereadable(g:exES_Bookmarks) == 1
            silent call append( line('$'), readfile( g:exES_Bookmarks ) )
        endif
    endif
    silent! setlocal nomodifiable

    " first we use the line we locate before last jump, then we use the line of current edit buffer
    if s:exBE_select_line == '' || search( escape(s:exBE_select_line,'\'), 'w' ) == 0
        let edit_bufnum = exUtility#GetEditBufferNum ()
        silent call search( '^ '.edit_bufnum.':', 'w' )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exBE_AddBookmark ( filename ) " <<<
    if exists ( 'g:exES_Bookmarks' )
        " show input dialog
        let bookmark_name = inputdialog( 'Bookmark Alias: ', fnamemodify(a:filename,':t'), 'cancle' )
        if bookmark_name == ''
            call exUtility#WarningMsg('Error: bookmark name is empty.')
            return
        elseif bookmark_name == 'cancle'
            return
        endif

        " read book mark file
        let lines = []
        if filereadable(g:exES_Bookmarks) == 1
            let lines = readfile( g:exES_Bookmarks )
        endif

        let relative_filename = fnamemodify(a:filename,':p:.')
        let bookmark_info = ' ' . bookmark_name . ' (' . relative_filename . ')'

        " check if we already have the file
        let found = 0
        let idx = 0
        for line in lines
            if match( line, escape(relative_filename,'\') ) != -1
                call confirm('NOTE: The bookmark you add already exists, use the new alias.')
                let lines[idx] = bookmark_info
                let found = 1
                break
            endif
            let idx += 1
        endfor

        " if not, append it
        if found != 1
            silent call add( lines, bookmark_info )
        endif
        let lines = sort( lines, 's:exBE_BookmarkCompare' )
        silent call writefile( lines, g:exES_Bookmarks )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exBE_BookmarkCompare ( i1, i2 ) " <<<
    return a:i1 ==? a:i2 ? 0 : a:i1 > a:i2 ? 1 : -1
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" Commands
"/////////////////////////////////////////////////////////////////////////////

command EXBufExplorer call s:exBE_GotoSelectWindow()
command EXAddBookmarkDirectly call s:exBE_AddBookmark( fnamemodify( bufname('%'), ':p' ) )

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
