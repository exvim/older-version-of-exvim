" ======================================================================================
" File         : exUtility.vim
" Author       : Wu Jie 
" Last Change  : 10/18/2008 | 18:57:33 PM | Saturday,October
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_exutility') || &cp
    finish
endif
let loaded_exutility=1

"/////////////////////////////////////////////////////////////////////////////
" variables
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" gloable varialbe initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: store the plugins buffer name, so we can ensure not recore name as edit-buffer
" ------------------------------------------------------------------ 

if !exists('g:exUT_plugin_list')
    let g:exUT_plugin_list = []
endif

" ------------------------------------------------------------------ 
" Desc: turn on/off help text
" ------------------------------------------------------------------ 

if !exists('g:ex_help_text_on')
    let g:ex_help_text_on = 0
endif

" ======================================================== 
" local variable initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: store the highlight strings
" ------------------------------------------------------------------ 

let s:ex_hlRegMap = ["","q","w","e","r"]

" ------------------------------------------------------------------ 
" Desc: local script vairable initialization
" ------------------------------------------------------------------ 

let s:ex_editbuf_num = -1
let s:ex_pluginbuf_num = -1

" ------------------------------------------------------------------ 
" Desc: swap buf infos
" ------------------------------------------------------------------ 

let s:ex_swap_buf_num = -1
let s:ex_swap_buf_pos = []

" ------------------------------------------------------------------ 
" Desc: file browse
" ------------------------------------------------------------------ 

let s:ex_level_list = []

" ------------------------------------------------------------------ 
" Desc: special mark text 
" ------------------------------------------------------------------ 

let s:ex_special_mark_pattern = 'todo\|xxx\|fixme'
if exists('g:ex_todo_keyword')
    let s:ex_special_mark_pattern .= '\|' . substitute(tolower(g:ex_todo_keyword), ' ', '\\|', 'g' ) 
endif
if exists('g:ex_comment_lable_keyword')
    let s:ex_special_mark_pattern .= '\|' . substitute(tolower(g:ex_comment_lable_keyword), ' ', '\\|', 'g' ) 
endif

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

let s:ex_MapHelpText={}
let s:ex_MapHelpMode={}
let s:ex_MapHelpOldMode={}
let s:ex_MapLastCursorLine={}

" ======================================================== 
" syntax highlight
" ======================================================== 

hi def ex_SynHL1 gui=none guibg=LightCyan term=none cterm=none ctermbg=LightCyan
hi def ex_SynHL2 gui=none guibg=LightMagenta term=none cterm=none ctermbg=LightMagenta
hi def ex_SynHL3 gui=none guibg=LightRed term=none cterm=none ctermbg=LightRed
hi def ex_SynHL4 gui=none guibg=LightGreen term=none cterm=none ctermbg=LightGreen

hi def ex_SynSelectLine gui=none guibg=#bfffff term=none cterm=none ctermbg=LightCyan
hi def ex_SynConfirmLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=DarkYellow
hi def ex_SynObjectLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=DarkYellow

hi def link ex_SynError Error
hi def link ex_SynFold Comment
hi def link ex_SynFileName Statement
hi def link ex_SynLineNr LineNr
hi def link ex_SynNormal Normal

hi def ex_SynTransparent gui=none guifg=background term=none cterm=none ctermfg=DarkGray
hi def ex_SynSearchPattern gui=bold guifg=DarkRed guibg=LightGray term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray
hi def ex_SynTitle term=bold cterm=bold ctermfg=DarkYellow gui=bold guifg=Brown

hi def ex_SynJumpMethodS term=none cterm=none ctermfg=Red gui=none guifg=Red 
hi def ex_SynJumpMethodG term=none cterm=none ctermfg=Blue gui=none guifg=Blue 
hi def link ex_SynJumpSymbol Comment

" help syntax color
highlight def ex_SynHelpText gui=none guifg=DarkGreen


"/////////////////////////////////////////////////////////////////////////////
"  window functions
"/////////////////////////////////////////////////////////////////////////////


" ------------------------------------------------------------------ 
" Desc: Create window
" buffer_name : a string of the buffer_name
" window_direction : 'topleft', 'botright'
" use_vertical : 0, 1
" edit_mode : 'none', 'append', 'replace'
" init_func_name: 'none', 'function_name'
" ------------------------------------------------------------------ 

function g:ex_CreateWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, init_func_name ) " <<<
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
            exe 'normal! gg"_dG'
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

    " Set direction
    let w:use_vertical = a:use_vertical
    let w:window_direction = a:window_direction

    " adjust with edit_mode
    if a:edit_mode == 'append'
        exe 'normal! G'
    elseif a:edit_mode == 'replace'
        exe 'normal! gg"_dG'
    endif

    " after create the window, record the bufname into the plugin list
    if index( g:exUT_plugin_list, fnamemodify(a:buffer_name,":p:t") ) == -1
        silent call add(g:exUT_plugin_list, fnamemodify(a:buffer_name,":p:t"))
    endif

endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Init window
" init_func_name: 'none', 'function_name'
" ------------------------------------------------------------------ 

function g:ex_InitWindow(init_func_name) " <<<
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

    " Define the ex autocommands
    augroup ex_auto_cmds
        autocmd WinLeave * call g:ex_RecordCurrentBufNum()
        autocmd BufLeave * call g:ex_RecordSwapBufInfo()
    augroup end

    " avoid cwd change problem
    if exists( 'g:exES_CWD' )
        au BufEnter * silent exec 'lcd ' . g:exES_CWD
    endif

    if a:init_func_name != 'none'
        exe 'call ' . a:init_func_name . '()'
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Open window
" buffer_name : a string of the buffer_name
" window_direction : 'topleft', 'botright'
" use_vertical : 0, 1
" edit_mode : 'none', 'append', 'replace'
" backto_editbuf : 0, 1
" init_func_name: 'none', 'function_name'
" call_func_name: 'none', 'function_name'
" ------------------------------------------------------------------ 

function g:ex_OpenWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, backto_editbuf, init_func_name, call_func_name ) " <<<
    " check if a ex window exists on the target position 
    for nr_win in range(1,winnr("$"))
        if getwinvar(nr_win, "use_vertical") == a:use_vertical && getwinvar(nr_win, "window_direction") == a:window_direction 
            " get the ex window, change window to the target window
            silent exe nr_win . 'wincmd w'
        endif
    endfor

    " if current editor buf is a plugin file type
    if &filetype == "ex_filetype"
        silent exec "normal \<Esc>"
    endif

    " go to edit buffer first, then open the window, this will avoid some bugs
    call g:ex_RecordCurrentBufNum()
    call g:ex_GotoEditBuffer()

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
            exe 'normal! gg"_dG'
        endif

        return
    endif

    " Open window
    call g:ex_CreateWindow( a:buffer_name, a:window_direction, a:window_size, a:use_vertical, a:edit_mode, a:init_func_name )

    if a:call_func_name != 'none'
        exe 'call ' . a:call_func_name . '()'
    endif

    "
    if a:backto_editbuf
        " Need to jump back to the original window only if we are not
        " already in that window
        call g:ex_GotoEditBuffer()
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Close window
" ------------------------------------------------------------------ 

function g:ex_CloseWindow( buffer_name ) " <<<
    "Make sure the window exists
    let winnum = bufwinnr(a:buffer_name)
    if winnum == -1
        call g:ex_WarningMsg('Error: ' . a:buffer_name . ' window is not open')
        return
    endif

    " close window
    exe winnum . 'wincmd w'
    " if this is not the only window
    if winbufnr(2) != -1
        " If a window other than the a:buffer_name window is open,
        " then only close the a:buffer_name window.
        close
    endif

    " go back to edit buffer
    call g:ex_GotoEditBuffer()
    call g:ex_ClearObjectHighlight()
    
    "if winnr() == winnum
    "    let last_buf_num = bufnr('#') 
    "    " Already in the window. Close it and return
    "    if winbufnr(2) != -1
    "        " If a window other than the a:buffer_name window is open,
    "        " then only close the a:buffer_name window.
    "        close
    "    endif

    "    " Need to jump back to the original window only if we are not
    "    " already in that window
    "    let winnum = bufwinnr(last_buf_num)
    "    if winnr() != winnum
    "        exe winnum . 'wincmd w'
    "    endif
    "else
    "    " Goto the a:buffer_name window, close it and then come back to the 
    "    " original window
    "    let cur_buf_num = bufnr('%')
    "    exe winnum . 'wincmd w'
    "    close
    "    " Need to jump back to the original window only if we are not
    "    " already in that window
    "    let winnum = bufwinnr(cur_buf_num)
    "    if winnr() != winnum
    "        exe winnum . 'wincmd w'
    "    endif
    "endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Toggle window
" ------------------------------------------------------------------ 

function g:ex_ToggleWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, backto_editbuf, init_func_name, call_func_name ) " <<<
    " If exTagSelect window is open then close it.
    let winnum = bufwinnr(a:buffer_name)
    if winnum != -1
        call g:ex_CloseWindow(a:buffer_name)
        return
    endif

    call g:ex_OpenWindow( a:buffer_name, a:window_direction, a:window_size, a:use_vertical, a:edit_mode, a:backto_editbuf, a:init_func_name, a:call_func_name )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize window use increase value
" ------------------------------------------------------------------ 

function g:ex_ResizeWindow( use_vertical, original_size, increase_size ) " <<<
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

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_OperateWindow( title, close_when_selected, backto_edibut, hl_obj_line ) " <<<
    if a:close_when_selected
        call g:ex_CloseWindow(a:title)
        call g:ex_GotoEditBuffer()
    else
        " go back to edit buffer first
        call g:ex_GotoEditBuffer()

        " highlight object line when 
        " 1: we not close selected window 
        " 2: if we needed
        if a:hl_obj_line
            call g:ex_HighlightObjectLine()
            exe 'normal! zz'
        endif

        " if not back to edit buffer, we jump back to specificed window
        if !a:backto_edibut
            let winnum = bufwinnr(a:title)
            if winnr() != winnum
                exe winnum . 'wincmd w'
            endif
        endif
    endif
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  string functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutLine( len, line_type ) " <<<
    let plen = a:len - strlen(getline('.'))
    if (plen > 0)
        execute 'normal! ' plen . 'A' . a:line_type
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutSegment() " <<<
    silent normal! o''
    let space = printf('%*s',indent('.'),'')
    silent call setline ( '.', space . b:ECcommentOpen . "/////////////////////////////////////////////////////////////////////////////" . b:ECcommentClose )
    silent call append  ( '.', space . b:ECcommentOpen . "" . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', space . b:ECcommentOpen . "/////////////////////////////////////////////////////////////////////////////" . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "" )
    silent normal! j
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutNote() " <<<
    silent normal! o''
    let space = printf('%*s',indent('.'),'')
    silent call setline ( '.', space . b:ECcommentOpen . " ############################################################################ " . b:ECcommentClose )
    silent call append  ( '.', space . b:ECcommentOpen . " Note: " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', space . b:ECcommentOpen . " ############################################################################ " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "" )
    silent normal! j
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutNamespaceStart( space_name ) " <<<
    silent call append  ( '.', b:ECcommentOpen . " ######################### " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "namespace " . a:space_name . " { " )
    silent normal! j
    silent call append  ( '.', b:ECcommentOpen . " ######################### " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "" )
    silent normal! j
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutNamespaceEnd( space_name ) " <<<
    silent call append  ( '.', b:ECcommentOpen . " ######################### " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "} // end namespace " . a:space_name . " " )
    silent normal! j
    silent call append  ( '.', b:ECcommentOpen . " ######################### " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "" )
    silent normal! j
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutNamespace( space_name ) " <<<
    call g:ex_PutNamespaceStart(a:space_name)
    call g:ex_PutNamespaceEnd(a:space_name)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutSeparate() " <<<
    silent normal! o''
    let space = printf('%*s',indent('.'),'')
    silent call setline ( '.', space . b:ECcommentOpen . " ======================================================== " . b:ECcommentClose )
    silent call append  ( '.', space . b:ECcommentOpen . " " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', space . b:ECcommentOpen . " ======================================================== " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "" )
    silent normal! j
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutDescription() " <<<
    silent normal! o''
    let space = printf('%*s',indent('.'),'')
    silent call setline ( '.', space . b:ECcommentOpen . " ------------------------------------------------------------------ " . b:ECcommentClose )
    silent call append  ( '.', space . b:ECcommentOpen . " Desc: " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', space . b:ECcommentOpen . " ------------------------------------------------------------------ " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "" )
    silent normal! j
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutDefine() " <<<
    silent normal! o''
    let space = printf('%*s',indent('.'),'')
    silent call setline ( '.', space . b:ECcommentOpen . " ------------------------------------------------------------------ " . b:ECcommentClose )
    silent call append  ( '.', space . b:ECcommentOpen . " Desc: " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', space . b:ECcommentOpen . " ------------------------------------------------------------------ " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "" )
    silent normal! j
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutDeclaration() " <<<
    silent normal! o''
    let space = printf('%*s',indent('.'),'')
    silent call setline ( '.', space . b:ECcommentOpen . "/////////////////////////////////////////////////////////////////////////////" . b:ECcommentClose )
    silent call append  ( '.', space . b:ECcommentOpen . " class " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', space . b:ECcommentOpen . " " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', space . b:ECcommentOpen . " Purpose: " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', space . b:ECcommentOpen . " " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', space . b:ECcommentOpen . "/////////////////////////////////////////////////////////////////////////////" . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "" )
    silent normal! j
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutHeader() " <<<
    if getline(1) =~# b:ECcommentOpen . " ======================================================================================" . b:ECcommentClose
        if getline(2) =~# b:ECcommentOpen . " File         : .*" . b:ECcommentClose
            if getline(3) =~# b:ECcommentOpen . " Author       : .*" . b:ECcommentClose
                if getline(4) =~# b:ECcommentOpen . " Last Change  : .*" . b:ECcommentClose
                    if getline(5) =~# b:ECcommentOpen . " Description  : .*" . b:ECcommentClose
                        silent call setline ( 2, b:ECcommentOpen . " File         : " . fnamemodify(expand('%'), ":t") . b:ECcommentClose )
                        silent call setline ( 3, b:ECcommentOpen . " Author       : " . g:ex_usr_name . " " . b:ECcommentClose )
                        silent call setline ( 4, b:ECcommentOpen . " Last Change  : " . strftime("%m/%d/%Y | %H:%M:%S %p | %A,%B") . b:ECcommentClose )
                        silent call cursor ( 7, 0 )
                        return
                    endif
                endif
            endif
        endif
    endif

    silent call append ( 0, b:ECcommentOpen . " ======================================================================================" . b:ECcommentClose )
    silent call append ( 1, b:ECcommentOpen . " File         : " . fnamemodify(expand('%'), ":t") . b:ECcommentClose )
    silent call append ( 2, b:ECcommentOpen . " Author       : " . g:ex_usr_name . " " . b:ECcommentClose )
    silent call append ( 3, b:ECcommentOpen . " Last Change  : " . strftime("%m/%d/%Y | %H:%M:%S %p | %A,%B") . b:ECcommentClose )
    silent call append ( 4, b:ECcommentOpen . " Description  : " . b:ECcommentClose )
    silent call append ( 5, b:ECcommentOpen . " ======================================================================================" . b:ECcommentClose )
    silent call append ( 6, "" )
    silent call cursor ( 7, 0 )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutMain() " <<<
    execute 'normal! ' . 'o' .   "int main( int argc, char* argv[] )"
    execute 'normal! ' . "o" . "{"
    execute 'normal! ' . "o" . "}\<CR>"
    execute 'normal! ' . "2k"
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_PutClass( class_type, class_name ) " <<<
    execute 'normal! ' . 'o' . "///////////////////////////////////////////////////////////////////////////////"
    execute 'normal! ' . 'o' . "// class " . a:class_name
    execute 'normal! ' . 'o' . "// "
    execute 'normal! ' . 'o' . "// Purpose: "
    execute 'normal! ' . 'o' . "// "
    execute 'normal! ' . 'o' . "///////////////////////////////////////////////////////////////////////////////"
    execute 'normal! ' . 'o'
    execute 'normal! ' . 'o' . a:class_type . " " . a:class_name
    execute 'normal! ' . 'o' . "{"
    execute 'normal! ' . 'o' . "public:"
    execute 'normal! ' . 'o' . "// internal typedef"
    execute 'normal! ' . 'o' . "typedef " . a:class_name . " self_t;"
    execute 'normal! ' . 'o'
    execute 'normal! ' . 'o' . "public:"
    execute 'normal! ' . 'o' . "// con/de-structor"
    execute 'normal! ' . 'o' . a:class_name . " ();"
    execute 'normal! ' . 'o' . "virtual ~" . a:class_name . " ();"
    execute 'normal! ' . 'o'
    execute 'normal! ' . 'o' . "public:"
    execute 'normal! ' . 'o' . "// copy constructor"
    execute 'normal! ' . 'o' . a:class_name . " ( const self_t& _copy );"
    execute 'normal! ' . 'o' . "self_t& operator = ( const self_t& _copy );"
    execute 'normal! ' . 'o'
    execute 'normal! ' . 'o' . "}; // end " . a:class_type . " " . a:class_name
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_MarkText( text, line1, line2 ) " <<<

    " 
    let first_line = a:line1
    let last_line = a:line2

    " check if it is special mark, special mark will use uppercase
    let text = a:text
    if a:text =~? s:ex_special_mark_pattern
        let text = toupper(text)
    endif

    "
    let lstline = last_line + 1 
    let space = printf('%*s',indent(first_line),'')
    call append( last_line , space . b:ECcommentOpen . ' } ' . text . ' end ' . b:ECcommentClose )
    call append( first_line -1 , space . b:ECcommentOpen . ' ' . text . ' { ' . b:ECcommentClose )
    silent exec ":" . lstline
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_RemoveSpecialMarkText () " <<<
    let save_cursor = getpos(".")
    let save_line = getline(".")
    let cur_line = save_line

    let start_lnum = -1
    let end_lnum = -1
    let start_pattern = b:ECcommentOpen . ' ' . '\(' . s:ex_special_mark_pattern . '\)' . '.* { ' . b:ECcommentClose
    let end_pattern = b:ECcommentOpen . ' } ' . '\(' . s:ex_special_mark_pattern . '\)' . '.* end ' . b:ECcommentClose

    " found '#if 0' first
    while match(cur_line, start_pattern ) == -1
        let cur_line_nr = line(".")
        silent normal! ^[{
        let cur_line = getline(".")
        let lnum = line(".")
        if lnum == cur_line_nr
            if match( cur_line, start_pattern ) == -1
                call g:ex_WarningMsg("special mark pattern not found")
                silent call cursor(save_cursor[1], save_cursor[2])
                return
            endif
        endif
    endwhile

    " record the line
    let start_lnum = line(".")
    silent normal! $]}
    let end_lnum = line(".")

    " delete the if/else/endif
    if end_lnum != -1
        silent exe end_lnum
        silent normal! dd
    endif
    if start_lnum != -1
        silent exe start_lnum
        silent normal! dd
    endif

    silent call setpos('.', save_cursor)
    if match(save_line, start_pattern) == -1 && match(save_line, end_pattern) == -1
        silent call search('\V'.save_line, 'b')
    endif
    silent call cursor(line('.'), save_cursor[2])
    if match(save_line, end_pattern) != -1
        silent normal! kk
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_AlignDigit( align_nr, digit ) " <<<
    let print_fmt = '%'.a:align_nr.'d'
    let str_digit = printf(print_fmt,a:digit)
    retur substitute(str_digit,' ', '0','g')
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_InsertIFZero() range " <<<
    let lstline = a:lastline + 1 
    call append( a:lastline , "#endif")
    call append( a:firstline -1 , "#if 0")
    silent exec ":" . lstline
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_RemoveIFZero() range " <<<
    " FIXME: when line have **, it will failed
    let save_cursor = getpos(".")
    let save_line = getline(".")
    let cur_line = save_line

    let if_lnum = -1
    let else_lnum = -1
    let endif_lnum = -1

    " found '#if 0' first
    while match(cur_line, "#if.*0") == -1
        let cur_line_nr = line(".")
        silent normal! [#
        let cur_line = getline(".")
        let lnum = line(".")
        if lnum == cur_line_nr
            if match(cur_line, "#if.*0") == -1
                call g:ex_WarningMsg(" not #if 0 matched")
                silent call cursor(save_cursor[1], save_cursor[2])
                return
            endif
        endif
    endwhile

    " record the line
    let if_lnum = line(".")
    silent normal! ]#
    let cur_line = getline(".")
    if match(cur_line, "#else") != -1
        let else_lnum = line(".")
        silent normal! ]#
        let endif_lnum = line(".")
    else
        let endif_lnum = line(".")
    endif

    " delete the if/else/endif
    if endif_lnum != -1
        silent exe endif_lnum
        silent normal! dd
    endif
    if else_lnum != -1
        silent exe else_lnum
        silent call setline('.',"// XXX #else XXX")
    endif
    if if_lnum != -1
        silent exe if_lnum
        silent normal! dd
    endif

    silent call setpos('.', save_cursor)
    if match(save_line, "#if.*0") == -1 && match(save_line, "#endif.*") == -1
        silent call search('\V'.save_line, 'b')
    endif
    silent call cursor(line('.'), save_cursor[2])
    if match(save_line, "#endif.*") != -1
        silent normal! kk
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: TODO: check if the last character is space, if not, add space
" ------------------------------------------------------------------ 

function g:ex_InsertRemoveExtend() range " <<<
    let line = getline('.')
    if (strpart(line,strlen(line)-1,1) == "\\")
        exec ":" . a:firstline . "," . a:lastline . "s/\\\\$//"
    else
        exec ":" . a:firstline . "," . a:lastline . "s/$/\\\\/"
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_Yank( string ) " <<<
    let @" = a:string
    let @* = a:string
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_SmartCaseCompare( text, pattern ) " <<<
    if match(a:pattern, '\u') != -1 " if we have upper case, use case compare
        return match ( a:text, '\C'.a:pattern ) != -1
    else " ignore case compare
        return match ( a:text, a:pattern ) != -1
    endif 
endfunction " >>>


"/////////////////////////////////////////////////////////////////////////////
"  buffer functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: Record current buf num when leave
" FIXME: when you split window/open the same file in two window, you can only get the original bufwinnr() by the bufnr().
" FIXME: :sp will trigger the WinEnter, find a way to use it.
" ------------------------------------------------------------------ 

function g:ex_RecordCurrentBufNum() " <<<
    let short_bufname = fnamemodify(bufname('%'),":p:t")
    if index( g:exUT_plugin_list, short_bufname, 0, 1 ) == -1 " compare ignore case
        let s:ex_editbuf_num = bufnr('%')
    elseif short_bufname !=# "-MiniBufExplorer-"
        let s:ex_pluginbuf_num = bufnr('%')
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Record current buf pos
" ------------------------------------------------------------------ 

function g:ex_RecordSwapBufInfo() " <<<
    let bufnr = bufnr('%')
    let short_bufname = fnamemodify(bufname(bufnr),":p:t")
    if buflisted(bufnr) && bufloaded(bufnr) && bufexists(bufnr) && index( g:exUT_plugin_list, short_bufname, 0, 1 ) == -1
        let s:ex_swap_buf_num = bufnr
        let s:ex_swap_buf_pos = getpos('.')
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_SwapToLastEditBuffer() " <<<
    " check if current buffer can use switch
    let cur_bufnr = bufnr('%')
    let cru_short_bufname = fnamemodify(bufname('%'),":p:t")

    if index( g:exUT_plugin_list, cru_short_bufname, 0, 1 ) != -1 " check it is plugin window or not
        call g:ex_WarningMsg("Buffer: " .bufname(cur_bufnr).  " can't be switch.")
        return
    endif

    " check if last buffer existed and listed, swap if accessable
    let last_bufnr = bufnr("#")
    let last_short_bufname = fnamemodify(bufname(last_bufnr),":p:t")
    if buflisted(last_bufnr) && bufloaded(last_bufnr) && bufexists(last_bufnr) && index( g:exUT_plugin_list, last_short_bufname, 0, 1 ) == -1
        let tmp_swap_buf_pos = deepcopy(s:ex_swap_buf_pos)
        let tmp_swap_buf_nr = s:ex_swap_buf_num
        let s:ex_swap_buf_pos = getpos('.')
        silent exec last_bufnr."b!"

        " only recover the pos when we have the right last buffer recorded
        if last_bufnr == tmp_swap_buf_nr
            silent call setpos('.',tmp_swap_buf_pos)
        endif
    else
        call g:ex_WarningMsg("Buffer: " .bufname(last_bufnr).  " can't be accessed.")
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_GotoBuffer(cmd) " <<<
    " save current win pos x,y.
    if has("gui_running")
        let gui_win_pos_x = getwinposx()
        let gui_win_pos_y = getwinposy()
    endif

    " jump buffer
    if a:cmd ==# 'next'
        silent exec "bn!"
    elseif a:cmd ==# 'prev'
        silent exec "bp!"
    endif

    " restore windows pos if needed ( if windows pos changed ) 
    if has("gui_running")
        if gui_win_pos_x != getwinposx() || gui_win_pos_y != getwinposy()
            silent exec "winpos " . gui_win_pos_x " " . gui_win_pos_y
        endif
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update current buffer
" ------------------------------------------------------------------ 

function g:ex_UpdateCurrentBuffer() " <<<
    if exists(':UMiniBufExplorer')
        silent exe "UMiniBufExplorer"
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_GotoEditBuffer() " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum && winnum != -1 " this will fix the jump error in the vimentry buffer, cause the winnum for vimentry buffer will be -1
        exe winnum . 'wincmd w'
    endif
    call g:ex_RecordCurrentBufNum()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_GotoPluginBuffer() " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_pluginbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif
    call g:ex_RecordCurrentBufNum()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_GetEditBufferNum() " <<<
    return s:ex_editbuf_num
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_YankBufferNameForCode() " <<<
    let buf_name = g:ex_Pathfmt( bufname('%'), 'unix' )
    silent call g:ex_Yank( fnamemodify(buf_name,"") )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_YankFilePathForCode() " <<<
    let buf_name = g:ex_Pathfmt( bufname('%'), 'unix' )
    silent call g:ex_Yank( fnamemodify(buf_name,":h") )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_SwitchBuffer() " <<<
    " this will fix no jump error < bufwinnr() == -1 >
    silent call g:ex_RecordCurrentBufNum()

    " if current window is same as edit buffer window, jump to last edit window
    if winnr() == bufwinnr(s:ex_editbuf_num)
        call g:ex_GotoPluginBuffer()
    else
        call g:ex_GotoEditBuffer()
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: VimTip #1119: How to use Vim like an IDE
" delete the buffer; keep windows; create a scratch buffer if no buffers left 
" Using this Kwbd function (:call Kwbd(1)) will make Vim behave like an IDE; or maybe even better. 
" ------------------------------------------------------------------ 

function g:ex_Kwbd(kwbdStage) " <<<
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
endfunction  " >>>

"/////////////////////////////////////////////////////////////////////////////
"  file functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
"  file_type can be: tag
"                    symbol
"                    id
"                    inherits
" ------------------------------------------------------------------ 

function g:ex_GetVimFile( entry_path, file_type ) " <<<
    "
    let entry_path = fnamemodify( a:entry_path, ':p')
    let fullpath_file = ''
    if a:file_type ==# 'tag'
        let fullpath_file = entry_path . '/' . g:exES_vimfile_dir . '/tags'
    elseif a:file_type ==# 'symbol' 
        let fullpath_file = entry_path . '/' . g:exES_vimfile_dir . '/symbol'
    elseif a:file_type ==# 'id' 
        let fullpath_file = entry_path . '/' . g:exES_vimfile_dir . '/ID'
    elseif a:file_type ==# 'inherits' 
        let fullpath_file = entry_path . '/' . g:exES_vimfile_dir . '/inherits'
    else
        call g:ex_WarningMsg( 'unknown file_type: ' . a:file_type )
        return
    endif

    "
    return simplify(fullpath_file)
endfunction ">>>

" ------------------------------------------------------------------ 
" Desc: 
"  system: 'windows' 'unix'
" ------------------------------------------------------------------ 

function g:ex_Pathfmt( path, system ) " <<<
    if a:system == 'windows'
        return substitute( a:path, "\/", "\\", "g" )
    elseif a:system == 'unix'
        return substitute( a:path, "\\", "\/", "g" )
    else
        call g:ex_WarningMsg('unknown OS: ' . system)
    endif
endfunction ">>>


" ------------------------------------------------------------------ 
" Desc: Convert full file name into the format: file_name (directory)
" ------------------------------------------------------------------ 

function g:ex_ConvertFileName(full_file_name) " <<<
    return fnamemodify( a:full_file_name, ":t" ) . ' (' . fnamemodify( a:full_file_name, ":h" ) . ')'    
endfunction ">>>

" ------------------------------------------------------------------ 
" Desc: Get full file name from converted format
" ------------------------------------------------------------------ 

function g:ex_GetFullFileName(converted_line) " <<<
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

" ------------------------------------------------------------------ 
" Desc: Match tag and find file if it has
" ------------------------------------------------------------------ 

" KEEPME: we don't need this function, but keep it { 
" function g:ex_MatchTagFile( tag_file_list, file_name ) " <<<
"     return fnamemodify(a:file_name,":p")
"     " if we can use CWD find file, use it first
"     if exists('g:exES_CWD')
"         let full_file_name = substitute(g:exES_CWD,'\','',"g") . '//' . substitute(a:file_name,'\.\\','\\',"g")
"         if findfile(full_file_name) != ''
"             return simplify(full_file_name)
"         endif
"     endif
" 
"     "let full_file_name = ''
"     "for tag_file in a:tag_file_list
"     "    let tag_path = strpart( tag_file, 0, strridx(tag_file, '\') )
"     "    let full_file_name = tag_path . a:file_name
"     "    if findfile(full_file_name) != ''
"     "        break
"     "    endif
"     "    let full_file_name = ''
"     "endfor
" 
"     if full_file_name == ''
"         call g:ex_WarningMsg( a:file_name . ' not found' )
"     endif
" 
"     return simplify(full_file_name)
" endfunction " >>>
" } KEEPME end 

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_GetFileFilterPattern(filter) " <<<
    let filter_list = split(a:filter,' ')
    let filter_pattern = '\V'
    for filter in filter_list
        let filter_pattern = filter_pattern . '.' . '\<' . filter . '\>\$\|'
    endfor
    return strpart(filter_pattern, 0, strlen(filter_pattern)-2)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_GetDirFilterPattern(filter) " <<<
    if a:filter ==# ''
        return ''
    endif

    let filter_list = split(a:filter,' ')
    let filter_pattern = '\V'
    for filter in filter_list
        let filter_pattern = filter_pattern . '\<' . filter . '\>\$\|'
    endfor
    return strpart(filter_pattern, 0, strlen(filter_pattern)-2)
endfunction " >>>


" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_BrowseWithEmtpy(dir, filter) " <<<
    " get short_dir
    "let short_dir = strpart( a:dir, strridx(a:dir,'\')+1 )
    let short_dir = fnamemodify( a:dir, ":t" )
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
        " let file_type = strpart( short_dir, strridx(short_dir,'.')+1, 1 )
        let file_type = strpart( fnamemodify( short_dir, ":e" ), 0, 1 )
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

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_SetLevelList( line_num, by_next_line ) " <<<
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
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_FileNameSort( i1, i2 ) " <<<
    return a:i1 ==? a:i2 ? 0 : a:i1 >? a:i2 ? 1 : -1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_Browse(dir, file_filter, dir_filter) " <<<
    " show progress
    echon "processing: " . a:dir . "\r"

    " get short_dir
    " let short_dir = strpart( a:dir, strridx(a:dir,'\')+1 )
    let short_dir = fnamemodify( a:dir, ":t" )

    " if directory
    if isdirectory(a:dir) == 1
        " split the first level to file_list
        let file_list = split(globpath(a:dir,'*'),'\n')
        silent call sort( file_list, "g:ex_FileNameSort" )

        " sort and filter the list as we want (file|dir )
        let list_idx = 0
        let list_last = len(file_list)-1
        let list_count = 0
        while list_count <= list_last
            if isdirectory(file_list[list_idx]) == 0 " remove not fit file types
                if match(file_list[list_idx],a:file_filter) == -1 " if not found file type in file filter
                    silent call remove(file_list,list_idx)
                    let list_idx -= 1
                else " move the file to the end of the list
                    let file = remove(file_list,list_idx)
                    silent call add(file_list, file)
                    let list_idx -= 1
                endif
            elseif a:dir_filter != '' " remove not fit dirs
                if match(file_list[list_idx],a:dir_filter) == -1 " if not found dir name in dir filter
                    silent call remove(file_list,list_idx)
                    let list_idx -= 1
                endif
            endif

            "
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
            if g:ex_Browse(file_list[list_idx],a:file_filter,'') == 1 " if it is empty
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
        " let file_type = strpart( short_dir, strridx(short_dir,'.')+1, 1 )
        let file_type = strpart( fnamemodify( short_dir, ":e" ), 0, 1 )
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
    endif

    return 0
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_QuickFileJump() " <<<
    " make the gf go everywhere in the project
    if exists( 'g:exES_CWD' )
        let file_name = expand("<cfile>")
        echomsg "searching file: " . file_name
        let path = escape(g:exES_CWD, " ") . "/**;"
        let full_path_file = findfile( simplify(file_name), path ) 

        " if we found the file
        if full_path_file != ""
            silent exec "e " . full_path_file 
            echon full_path_file . "\r"
        else
            call g:ex_WarningMsg("file not found")
        endif
    else
        normal! gf
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_Explore( path ) " <<<
    if expand( a:path ) != ""
        if isdirectory( a:path )
            let cur_dir =  fnamemodify( a:path, ":p" )
        else
            let cur_dir =  fnamemodify( a:path, ":p:h" )
        endif
        silent exec '!start explorer.exe ' . cur_dir
    endif
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  fold functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_GetFoldLevel(line_num) " <<<
    let cur_line = getline(a:line_num)
    let cur_line = strpart(cur_line,0,strridx(cur_line,'|')+1)
    let str_len = strlen(cur_line)
    return str_len/2
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_FoldText() " <<<
    let line = getline(v:foldstart)
    let line = substitute(line,'\[F\]\(.\{-}\) {.*','\[+\]\1 ','')
    return line
    " let line = getline(v:foldstart)
    " let line = strpart(line, 0, strridx(line,'|')+1)
    " let line = line . '+'
    " return line
endfunction ">>>

"/////////////////////////////////////////////////////////////////////////////
"  jump functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: Goto the position by file name and search pattern
" ------------------------------------------------------------------ 

function g:ex_GotoSearchPattern(full_file_name, search_pattern) " <<<
    " check and jump to the buffer first
    call g:ex_GotoEditBuffer()

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
    exe 'normal! zz'

    return 1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Goto the position by file name and search pattern
" ------------------------------------------------------------------ 

function g:ex_GotoExCommand(full_file_name, ex_cmd, keepjump_cmd) " <<<
    " check and jump to the buffer first
    call g:ex_GotoEditBuffer()

    " start jump
    let file_name = escape(a:full_file_name, ' ')
    if bufnr('%') != bufnr(file_name)
        exe a:keepjump_cmd . ' silent e ' . file_name
    endif

    " cursor jump
    try
        silent exe a:keepjump_cmd . ' ' . a:ex_cmd
    catch /^Vim\%((\a\+)\)\=:E/
        " if ex_cmd is not digital, try jump again manual
        if match( a:ex_cmd, '^\/\^' ) != -1
            let pattern = strpart(a:ex_cmd, 2, strlen(a:ex_cmd)-4)
            let pattern = '\V\^' . pattern . (pattern[len(pattern)-1] == '$' ? '\$' : '')
            if search(pattern, 'w') == 0
                call g:ex_WarningMsg('search pattern not found: ' . pattern)
                return 0
            endif
        endif
    endtry

    " set the text at the middle
    exe 'normal! zz'

    return 1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_GotoTagNumber(tag_number) " <<<
    " check and jump to the buffer first
    call g:ex_GotoEditBuffer()

    silent exec a:tag_number . "tr!"

    " set the text at the middle
    exe 'normal! zz'
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Goto the pos by position list
" ------------------------------------------------------------------ 

function g:ex_GotoPos(poslist) " <<<
    " check and jump to the buffer first
    call g:ex_GotoEditBuffer()

    " TODO must have buffer number or buffer name
    call setpos('.', a:poslist)

    " set the text at the middle
    exe 'normal! zz'
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_CursorJump( search_pattern, search_direction ) " <<<
    let save_cursor = getpos(".")

    " get search flags, also move cursors
    let search_flags = ''
    if a:search_direction == 'up'
        let search_flags  = 'bW'
        silent exec 'normal ^'
    else
        let search_flags  = 'W'
        silent exec 'normal $'
    endif

    " jump to error,warning pattern
    let jump_line = search(a:search_pattern, search_flags )
    if jump_line == 0
        silent call setpos(".", save_cursor)
    else
        silent exec jump_line
    endif
    call g:ex_HighlightSelectLine()
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  terminal functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
"  1. behavior
"   silent: win32 - when finish the task, cmd-window will close automatically
"           unix  - no message for processing task.
"   prompt: win32 - when finish the task, you need to press key to close the cmd-window so that you can read the information   
"   remain: win32 - when finish the task, the cmd-window will remain there
"  2. wait
"   wait:   wait until it is been processed
"   nowait:  open the cmd-window as a new process
" ------------------------------------------------------------------ 

function g:ex_Terminal( behavior, wait, cmd ) " <<<
    if has("win32")
        " NOTE: !start is different with silent !start, silent !start will close the 'cmd /c start' window

        " init shell & shell_end by behavior
        let shell = 'cmd'
        let shell_end = ''
        if a:behavior ==# 'silent'
            let shell = 'cmd /c'
        elseif a:behavior ==# 'prompt'
            let shell = 'cmd /c'
            let shell_end = ' & pause'
        elseif a:behavior ==# 'remain'
            let shell = 'cmd /k'
        endif

        " init wait
        let wait_cmd = ''
        if a:wait ==# 'nowait'
            let wait_cmd = 'start '
        endif

        " process
        exec 'silent !' . wait_cmd . shell . ' ' . a:cmd . shell_end 

    elseif has("unix")
        let silent_cmd = ''
        if a:behavior ==# 'silent'
            let silent_cmd = 'silent'
        endif
        exec silent_cmd . ' !sh ' . a:cmd
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_GCCMake(args) " <<<
    " save all file for compile first
    silent exec "wa!"

    let entry_file = glob('gcc_entry*.mk') 
    if entry_file != ''
        if has ("win32")
            call g:ex_Terminal ( 'prompt', 'nowait', 'make -f' . entry_file . ' ' . a:args )
        elseif has("unix")
            exec "!make -f" . entry_file . ' ' . a:args
        endif
    else
        call g:ex_WarningMsg("entry file not found")
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_ShaderMake(args) " <<<
    " save all file for compile first
    silent exec "wa!"

    let entry_file = glob('shader_entry*.mk') 
    if entry_file != ''
        call g:ex_Terminal ( 'prompt', 'nowait', 'make -f' . entry_file . ' ' . a:args )
    else
        call g:ex_WarningMsg("entry file not found")
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_VCMake(args) " <<<
    " save all file for compile first
    silent exec "wa!"

    let entry_file = glob('msvc_entry*.mk') 
    if entry_file != ''
        call g:ex_Terminal ( 'prompt', 'nowait', 'make -f' . entry_file . ' ' . a:args )
    else
        call g:ex_WarningMsg("entry file not found")
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_VCMakeBAT(cmd, config) " <<<
    " save all file for compile first
    silent exec "wa!"

    " process by bat
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
            call g:ex_Terminal ( 'prompt', 'nowait', 'make_vs ' . cmd . ' ' . g:exES_Solution . ' ' . a:config . ' ' . prj_name )
        else
            call g:ex_WarningMsg("solution not found")
        endif
    else
        call g:ex_WarningMsg("make_vs.bat not found")
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: type: ID,symbol,tag,none=all
" ------------------------------------------------------------------ 

function g:ex_UpdateVimFiles( type ) " <<<
    let script_not_found = 0

    " find quick gen script first
    let suffix = '\(bat\|sh\)'
    if has ("win32")
        let suffix = 'bat'
    elseif has ("unix")
        let suffix = 'sh'
    endif

    let quick_gen_script = glob('quick_gen_project*.'.suffix) 
    if quick_gen_script != ''
        silent exec "cscope kill " . g:exES_Cscope
        " we use async update
        " silent exec "cscope add " . g:exES_Cscope
    else
        call g:ex_WarningMsg("quick_gen_project script not found")
        let script_not_found = 1
    endif

    " if not found, we show a list let usr select project type, then copy the script and running it
    if script_not_found == 1
        let type_list = ['unknown', 'all', 'general', 'c', 'cpp', 'csharp', 'html', 'javascript', 'lua', 'math', 'python', 'uc', 'vim']
        let idx = inputlist ( ['Select Project Type:', '1. all', '2. general', '3. c', '4. cpp', '5. csharp', '6. html', '7. javascript', '8. lua', '9. math', '10. python', '11. uc', '12. vim'])
        let quick_gen_script = g:ex_CopyQuickGenProject ( type_list[idx] )
    endif

    " create update cmd
    let gen_type = ''
    if a:type == ""
        silent exec "cscope kill " . g:exES_Cscope
        let gen_type = ' all'
        " we use async update
        " silent exec "cscope add " . g:exES_Cscope
    elseif a:type == "ID"
        let gen_type = ' id'
    elseif a:type == "symbol"
        let gen_type = ' symbol'
    elseif a:type == "inherit"
        let gen_type = ' inherit'
    elseif a:type == "tag"
        let gen_type = ' tag'
    elseif a:type == "cscope"
        silent exec "cscope kill " . g:exES_Cscope
        let gen_type = ' cscope'
        " we use async update
        " silent exec "cscope add " . g:exES_Cscope
    else
        call g:ex_WarningMsg("do not found update-type: " . a:type )
        return
    endif

    " now process the quick_gen_project script
    let update_cmd = quick_gen_script . gen_type . ' ' . g:exES_vimfile_dir

    " now process vimentry references
    let refs_update_cmd = g:ex_GetUpdateVimentryRefsCommand (a:type) 
    if refs_update_cmd != ''
        let update_cmd .= refs_update_cmd
    endif

    "
    call g:ex_Terminal ( 'prompt', 'nowait', update_cmd )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: get reference vimentry update command
" ------------------------------------------------------------------ 

function g:ex_GetUpdateVimentryRefsCommand( type ) " <<<
    let cmd = ''

    if !empty(g:exES_vimentryRefs)
        if has ('win32')
            let cmd .= ' & echo.'
            let cmd .= ' & echo Update vimentry references...'

            let destSymbol = '"' . g:ex_Pathfmt(g:ex_GetVimFile ( g:exES_CWD, 'symbol'),'windows') . '"'
            let destInherit = '"' . g:ex_Pathfmt(g:ex_GetVimFile ( g:exES_CWD, 'inherits'),'windows') . '"'

            let symbolFiles = destSymbol
            let inheritFiles = destInherit

            " get process files
            for vimentry in g:exES_vimentryRefs
                let entry_dir = fnamemodify( vimentry, ':p:h')
                let symbolFiles .= '+' . '"' . g:ex_Pathfmt(g:ex_GetVimFile ( entry_dir, 'symbol'),'windows') . '"'
                let inheritFiles .= '+' . '"' . g:ex_Pathfmt(g:ex_GetVimFile ( entry_dir, 'inherits'),'windows') . '"'
            endfor

            " get symbol cmd
            if a:type == "" || a:type == "symbol"
                let tmpSymbol = '"' . g:ex_Pathfmt( './'.g:exES_vimfile_dir.'/_symbol', 'windows' ) . '"'
                let tmp_cmd = ' copy ' . symbolFiles . ' ' . tmpSymbol
                let tmp_cmd .= ' & sort ' . tmpSymbol . ' /O ' . tmpSymbol
                let tmp_cmd .= ' & move /Y ' . tmpSymbol . ' ' . destSymbol

                let cmd .= ' & echo merge Symbols...'
                let cmd .= ' & ' . tmp_cmd
            endif

            " get inherit cmd
            if a:type == "" || a:type == "inherit"
                let tmpInherit = '"' . g:ex_Pathfmt( './'.g:exES_vimfile_dir.'/_inherits', 'windows' ) . '"'
                let tmp_cmd = ' copy ' . inheritFiles . ' ' . tmpInherit
                let tmp_cmd .= ' & move /Y ' . tmpInherit . ' ' . destInherit

                let cmd .= ' & echo merge Inherits...'
                let cmd .= ' & ' . tmp_cmd
            endif
        elseif has ('unix')
            let cmd .= ' && echo'
            let cmd .= ' && echo Update vimentry references...'

            let destSymbol = '"' . g:ex_Pathfmt(g:ex_GetVimFile ( g:exES_CWD, 'symbol'),'unix') . '"'
            let destInherit = '"' . g:ex_Pathfmt(g:ex_GetVimFile ( g:exES_CWD, 'inherits'),'unix') . '"'

            let symbolFiles = destSymbol
            let inheritFiles = destInherit

            " get process files
            for vimentry in g:exES_vimentryRefs
                let entry_dir = fnamemodify( vimentry, ':p:h')
                let symbolFiles .= ' ' . '"' . g:ex_Pathfmt(g:ex_GetVimFile ( entry_dir, 'symbol'),'unix') . '"'
                let inheritFiles .= ' ' . '"' . g:ex_Pathfmt(g:ex_GetVimFile ( entry_dir, 'inherits'),'unix') . '"'
            endfor

            " get symbol cmd
            if a:type == "" || a:type == "symbol"
                let tmpSymbol = '"' . g:ex_Pathfmt( './'.g:exES_vimfile_dir.'/_symbol', 'unix' ) . '"'
                let tmp_cmd = ' cat ' . symbolFiles . ' > ' . tmpSymbol
                let tmp_cmd .= ' && sort ' . tmpSymbol . ' -o ' . tmpSymbol
                let tmp_cmd .= ' && mv -f ' . tmpSymbol . ' ' . destSymbol

                let cmd .= ' && echo merge Symbols...'
                let cmd .= ' && ' . tmp_cmd
            endif

            " get inherit cmd
            if a:type == "" || a:type == "inherit"
                let tmpInherit = '"' . g:ex_Pathfmt( './'.g:exES_vimfile_dir.'/_inherits', 'unix' ) . '"'
                let tmp_cmd = ' cat ' . inheritFiles . ' > ' . tmpInherit
                let tmp_cmd .= ' && mv -f ' . tmpInherit . ' ' . destInherit

                let cmd .= ' && echo merge Inherits...'
                let cmd .= ' && ' . tmp_cmd
            endif
        endif
    endif

    return cmd
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_CopyQuickGenProject( type ) " <<<
    " init platform dependence value
    let script_suffix = ''
    let folder_name = ''
    let copy_cmd = ''
    if has("win32")
        let script_suffix = 'bat'
        let folder_name = 'batch'
        let copy_cmd = 'copy'
    elseif has("unix")
        let script_suffix = 'sh'
        let folder_name = 'bash'
        let copy_cmd = 'cp'
    endif

    " copy quick gen script
    let quick_gen_script = ''
    if a:type == "all"
        let quick_gen_script = "quick_gen_project_all." . script_suffix
    elseif a:type == "general"
        let quick_gen_script = "quick_gen_project_general." . script_suffix  
    else
        let quick_gen_script = "quick_gen_project_" . a:type . "_only." . script_suffix
    endif

    " get quick gen script from repository
    let full_quick_gen_script = ''
    if has("win32")
        let full_quick_gen_script = fnamemodify( $EX_DEV . "\\vim\\toolkit\\quickgen\\" . folder_name . "\\" . quick_gen_script, ":p")
    elseif has("unix")
        let full_quick_gen_script = fnamemodify( '/usr/local/share/vim/toolkit/quickgen/' . folder_name . '/' . quick_gen_script, ":p" )
    endif
    if findfile( full_quick_gen_script ) == ""
        call g:ex_WarningMsg('Error: file ' . full_quick_gen_script . ' not found')
    else
        let cmd = copy_cmd . ' ' . full_quick_gen_script . ' ' . quick_gen_script 
        exec 'silent !' . cmd
        echo 'file copied: ' . quick_gen_script
    endif

    "
    return quick_gen_script
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_Debug( exe_name ) " <<<
    if glob(a:exe_name) == ''
        call g:ex_WarningMsg('file: ' . a:exe_name . ' not found')
    else
        " TODO: call g:ex_Terminal ( 'remain', 'wait', 'insight ' . a:exe_name ) " right now can't use this...
        silent exec '!start insight ' . a:exe_name
    endif
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  Hightlight functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: hightlight confirm line
" ------------------------------------------------------------------ 

function g:ex_HighlightConfirmLine() " <<<
    " Clear previously selected name
    match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe 'match ex_SynConfirmLine ' . pat
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: hightlight select line
" ------------------------------------------------------------------ 

function g:ex_HighlightSelectLine() " <<<
    " Clear previously selected name
    2match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe '2match ex_SynSelectLine ' . pat
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: hightlight object line
" ------------------------------------------------------------------ 

function g:ex_HighlightObjectLine() " <<<
    " Clear previously selected name
    3match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe '3match ex_SynObjectLine ' . pat
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: clear the object line hight light
" ------------------------------------------------------------------ 

function g:ex_ClearObjectHighlight() " <<<
    " Clear previously selected name
    3match none
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: hightlight match_nr
" NOTE: the 1,2,3,4 correspond to reg q,w,e,r
" ------------------------------------------------------------------ 

function g:ex_Highlight_Normal(match_nr) " <<<
    " get word under cursor
    let hl_word = expand('<cword>')
    let hl_pattern = '\<\C'.hl_word.'\>'
    call g:ex_Highlight_Text( a:match_nr, hl_pattern )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: hightlight match_nr with text
" NOTE: the 1,3 will save word to register as \<word\>, the 2,4 will save word to register as word
" ------------------------------------------------------------------ 

function g:ex_Highlight_Text(match_nr, args) " <<<
    " if no argument comming, cancle hihglight return
    if a:args == ''
        call g:ex_HighlightCancle(a:match_nr)
        return
    endif

    " if we don't have upper case character, ignore case
    let pattern = a:args
    if match( a:args, '\u' ) == -1
        let pattern = '\c' . pattern
    endif

    " start match
    call s:ex_DefineMatchVariables() 
    if pattern ==# w:ex_HighLightText[a:match_nr]
        call g:ex_HighlightCancle(a:match_nr)
    else
        call g:ex_HighlightCancle(a:match_nr)
        let w:ex_hlMatchID[a:match_nr] = matchadd( 'ex_SynHL'.a:match_nr, pattern, a:match_nr )
        let w:ex_HighLightText[a:match_nr] = pattern

        let hl_pattern = a:args
        if a:match_nr == 2 || a:match_nr == 4 " if 2,4, remove \<\C...\>
            let hl_pattern = strpart( hl_pattern, 4, strlen(hl_pattern) - 6)
        endif
        silent call setreg(s:ex_hlRegMap[a:match_nr],hl_pattern) 
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: hightlight match_nr
" ------------------------------------------------------------------ 

function g:ex_Highlight_Visual(match_nr) range " <<<
    call s:ex_DefineMatchVariables() 

    " if in the same line
    let pat = '//'
    if a:firstline == a:lastline
        let sl = a:firstline-1
        let sc = col("'<")-1
        let el = a:lastline+1
        let ec = col("'>")+1
        let pat = '\%>'.sl.'l'.'\%>'.sc.'v'.'\%<'.el.'l'.'\%<'.ec.'v'
    else
        let sl = a:firstline-1
        let el = a:lastline+1
        let pat = '\%>'.sl.'l'.'\%<'.el.'l'
    endif
    call g:ex_Highlight_Text( a:match_nr, pat )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Cancle highlight
" ------------------------------------------------------------------ 

function g:ex_HighlightCancle(match_nr) " <<<
    call s:ex_DefineMatchVariables() 
    if a:match_nr == 0
        call s:ex_MatchDelete(1)
        call s:ex_MatchDelete(2)
        call s:ex_MatchDelete(3)
        call s:ex_MatchDelete(4)
    else
        call s:ex_MatchDelete(a:match_nr)
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:ex_DefineMatchVariables() " <<<
    if !exists('w:ex_hlMatchID')
        let w:ex_hlMatchID = [0,0,0,0,0]
    endif
    if !exists('w:ex_HighLightText')
        let w:ex_HighLightText = ["","","","",""]
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:ex_MatchDelete(match_nr) " <<<
    if w:ex_hlMatchID[a:match_nr] != 0
        silent call matchdelete(w:ex_hlMatchID[a:match_nr])
        let w:ex_hlMatchID[a:match_nr] = 0
    endif
    let w:ex_HighLightText[a:match_nr] = ''
    silent call setreg(s:ex_hlRegMap[a:match_nr],'') 
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_SrcHighlight( line1, line2 ) " <<<
    " 
    let first_line = a:line1
    let last_line = a:line2

    " process src-highlight
    if exists("g:exES_CWD")
        let temp_directory_path = g:exES_CWD.'/'.g:exES_vimfile_dir.'/_temp' 
        let temp_file = temp_directory_path.'/'.'_src_highlight.txt' 
        let temp_file_html = temp_file . '.html' 
    else
        let temp_directory_path = './_temp' 

        " create _temp directory if not found
        if finddir(temp_directory_path) == ''
            silent call mkdir(temp_directory_path)
        endif

        let temp_file = temp_directory_path.'/'.'_src_highlight.txt' 
        let temp_file_html = temp_file . '.html' 
    endif

    " get text by lines
    let text = getline( first_line, last_line )
    call writefile( text, temp_file, "b" )

    " browse use browser browse file
    "KEEPME once we have css version (src 2.6): let shl_cmd = 'source-highlight -f html -s ex_cpp -n --data-dir=%EX_DEV%\GnuWin32\share\source-highlight -css="ex.css"' . ' -i ' . temp_file . ' -o ' . temp_file_html
    let shl_cmd = 'source-highlight -f html -s ex_cpp -n --data-dir=%EX_DEV%\GnuWin32\share\source-highlight' . ' -i ' . temp_file . ' -o ' . temp_file_html
    let shl_result = system(shl_cmd)

    " TODO: use if win32, if linux
    let win_file = g:ex_Pathfmt( temp_file_html, 'windows')
    silent exec '!start ' . g:exES_WebBrowser . ' ' . win_file

    " go back to start line
    silent exec ":" . first_line
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  Inherits functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_GenInheritsDot( pattern, gen_method ) " <<<
    " find inherits file
    if exists( g:exES_Inherits )
        let inherits_file = g:exES_Inherits
    else
        let inherits_file = './'.g:exES_vimfile_dir.'/inherits'
    endif

    " create inherit dot file path
    let inherit_directory_path = g:exES_CWD.'/'.g:exES_vimfile_dir.'/_hierarchies/' 
    if finddir(inherit_directory_path) == ''
        silent call mkdir(inherit_directory_path)
    endif
    let pattern_fname = substitute( a:pattern, "[^0-9A-Za-z_:]", "", "g" ) . "_" . a:gen_method
    let inherits_dot_file = inherit_directory_path . pattern_fname . ".dot"

    " read the inherits file
    let file_list = readfile( inherits_file )

    " init value
    let s:pattern_list = []
    let inherits_list = []

    " judge method
    if a:gen_method == "all"
        let parent_pattern = "->.*" . a:pattern
        let children_pattern = a:pattern . ".*->"

        " first filter
        let parent_inherits_list = filter( copy(file_list), 'v:val =~ parent_pattern' )
        let inherits_list += parent_inherits_list
        let children_inherits_list = filter( copy(file_list), 'v:val =~ children_pattern' )
        let inherits_list += children_inherits_list

        " processing inherits
        let inherits_list += s:ex_RecursiveGetParent( parent_inherits_list, file_list )
        let inherits_list += s:ex_RecursiveGetChildren( children_inherits_list, file_list )
    else
        if a:gen_method == "parent"
            let pattern = "->.*" . a:pattern
        elseif a:gen_method == "children"
            let pattern = a:pattern . ".*->"
        endif

        " first filter
        let inherits_list += filter( copy(file_list), 'v:val =~ pattern' )

        " processing inherits
        if a:gen_method == "parent"
            let inherits_list += s:ex_RecursiveGetParent( inherits_list, file_list )
        elseif a:gen_method == "children"
            let inherits_list += s:ex_RecursiveGetChildren( inherits_list, file_list )
        endif
    endif

    " add dot gamma
    let inherits_list = ["digraph INHERITS {", "rankdir=LR;"] + inherits_list
    let inherits_list += ["}"]
    unlet s:pattern_list

    " write file
    call writefile(inherits_list, inherits_dot_file, "b")
    let image_file_name = inherit_directory_path . pattern_fname . ".png"
    let dot_cmd = "!dot " . inherits_dot_file . " -Tpng -o" . image_file_name
    silent exec dot_cmd
    if has("win32")
        return g:ex_Pathfmt( fnamemodify( image_file_name, ":p" ), 'windows' )
    else
        return fnamemodify( image_file_name, ":p" )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_ViewInheritsImage() " <<<
    let inherit_class_name = expand("<cword>")
    let inherit_class_name = "\\<" . inherit_class_name . "\\>"
    echomsg inherit_class_name
    silent exec '!start ' . g:exES_ImageViewer ' ' . g:ex_GenInheritsDot(inherit_class_name,"all")
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:ex_RecursiveGetChildren(inherits_list, file_list) " <<<
    let result_list = []
    for inherit in a:inherits_list
        " change to parent pattern
        let pattern = strpart( inherit, stridx(inherit,"->")+3 ) . ' ->'

        " skip parsed pattern
        if index( s:pattern_list, pattern ) >= 0
            continue
        endif
        call add( s:pattern_list, pattern )

        " add children list
        let children_list = filter( copy(a:file_list), 'v:val =~# pattern' )
        let result_list += children_list 

        " recursive the children
        let result_list += s:ex_RecursiveGetChildren( children_list, a:file_list ) 
    endfor
    return result_list
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:ex_RecursiveGetParent(inherits_list, file_list) " <<<
    let result_list = []
    for inherit in a:inherits_list
        " change to child pattern
        let pattern =  '-> ' . strpart( inherit, 0, stridx(inherit,"->")-1 )

        " skip parsed pattern
        if index( s:pattern_list, pattern ) >= 0
            continue
        endif
        call add( s:pattern_list, pattern )

        " add pattern list
        let parent_list = filter( copy(a:file_list), 'v:val =~# pattern' )
        let result_list += parent_list 

        " recursive the parent
        let result_list += s:ex_RecursiveGetParent( parent_list, a:file_list ) 
    endfor
    return result_list
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" command custom complete functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_CompleteBySymbolFile( arg_lead, cmd_line, cursor_pos ) " <<<
    let filter_tag = []
    if exists ('g:exES_Symbol')
        let tags = readfile( g:exES_Symbol )

        for tag in tags
            if g:ex_SmartCaseCompare ( tag, '^'.a:arg_lead.'.*' )
                silent call add ( filter_tag, tag )
            endif
        endfor
    endif
    return filter_tag
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:ex_GetFileName( text )
    let line = ''
    " if it is a file
    if match(a:text,'[^^]-\C\[[^F]\]') != -1
        let line = a:text
        let line = substitute(line,'.\{-}\[.\{-}\]\(.\{-}\)','\1','')
        let idx_end_1 = stridx(line,' {')
        let idx_end_2 = stridx(line,' }')
        if idx_end_1 != -1
            let line = strpart(line,0,idx_end_1)
        elseif idx_end_2 != -1
            let line = strpart(line,0,idx_end_2)
        endif
    endif
    return line
endfunction

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_CompleteByProjectFile( arg_lead, cmd_line, cursor_pos ) " <<<
    let filter_files = []
    if exists ('g:exES_Project')
        let project_files = readfile(g:exES_Project)
        for file_line in project_files
            let file_name = s:ex_GetFileName (file_line)
            if g:ex_SmartCaseCompare( file_name, '^'.a:arg_lead.'.*' )
                silent call add ( filter_files, file_name )
            endif
        endfor
    endif
    return filter_files
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

" TODO: can combine args with file,directory search
function g:ex_CompleteGMakeArgs( arg_lead, cmd_line, cursor_pos ) " <<<
    let idx = strridx(a:arg_lead,'/')+1
    let arg_lead_prefix = strpart(a:arg_lead, 0, idx )
    let arg_lead_suffix = strpart(a:arg_lead, idx )

    let args = ["all","rebuild","rebuild-deps","rebuild-gchs","rebuild-objs","rebuild-target","clean-all","clean-deps","clean-errs","clean-gchs","clean-objs","clean-target"]
    let filter_result = []
    for arg in args
        if g:ex_SmartCaseCompare( arg, '^'.arg_lead_suffix.'.*' )
            silent call add ( filter_result, arg_lead_prefix . arg )
        endif
    endfor
    return filter_result
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_CompleteVMakeArgs( arg_lead, cmd_line, cursor_pos ) " <<<
    let args = ["all","rebuild","clean-all"]
    let filter_result = []
    for arg in args
        if g:ex_SmartCaseCompare( arg, '^'.a:arg_lead.'.*' )
            silent call add ( filter_result, arg )
        endif
    endfor
    return filter_result
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_CompleteUpdateArgs( arg_lead, cmd_line, cursor_pos ) " <<<
    let args = ["ID","symbol","inherit","tag","cscope"]
    let filter_result = []
    for arg in args
        if g:ex_SmartCaseCompare( arg, '^'.a:arg_lead.'.*' )
            silent call add ( filter_result, arg )
        endif
    endfor
    return filter_result
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_CompleteQCopyArgs( arg_lead, cmd_line, cursor_pos ) " <<<
    let args = ["all", "general", "c", "cpp", "csharp", "html", "javascript", "lua", "math", "python", "uc", "vim"]
    let filter_result = []
    for arg in args
        if g:ex_SmartCaseCompare( arg, '^'.a:arg_lead.'.*' )
            silent call add ( filter_result, arg )
        endif
    endfor
    return filter_result
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:ex_CompleteMKArgs( arg_lead, cmd_line, cursor_pos ) " <<<
    let args = split( g:ex_todo_keyword, ' ' )
    silent call extend (args, split( g:ex_comment_lable_keyword, ' ' ) )

    let filter_result = []
    for arg in args
        if g:ex_SmartCaseCompare( arg, '^'.a:arg_lead.'.*' )
            silent call add ( filter_result, arg )
        endif
    endfor
    return filter_result
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  Debug functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: Display a message using WarningMsg highlight group
" ------------------------------------------------------------------ 

function g:ex_WarningMsg(msg) " <<<
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: fix vim bug.
" when you use clipboard=unnamed, and you have two vim-windows, visual-copy 
" in window-1, then visual-copy in window-2, then visual-paste again. it is wrong
" FIXME: this will let the "ap useless
" ------------------------------------------------------------------ 

function g:ex_VisualPasteFixed() " <<<
    silent call getreg('*')
    " silent normal! gvpgvy " <-- this let you be the win32 copy/paste style
    silent normal! gvp
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  Help text functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

" --ex_AddHelpItem--
" Add help Item for current buffer, used in initilization only
function g:ex_AddHelpItem(HelpText, HelpMode) " <<<
    let BufName = fnamemodify(bufname(""), ':t')
    if !has_key(s:ex_MapHelpText, BufName)
        let s:ex_MapHelpText[BufName]={}
        let s:ex_MapHelpMode[BufName]=0
        let s:ex_MapHelpOldMode[BufName]=-1
        let s:ex_MapLastCursorLine[BufName]=1
    endif
    if !has_key(s:ex_MapHelpText[BufName], a:HelpMode)
        let s:ex_MapHelpText[BufName][a:HelpMode]=[]
    endif
    call add(s:ex_MapHelpText[BufName][a:HelpMode] , a:HelpText)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

" --ex_AddHelpItem--
" Add help Item for current buffer, used in initilization only
function g:ex_DisplayHelp() " <<<
    " If it's not funtional window, do not display help

    if g:ex_IsFunctionalbuf("")
        return
    endif

    if !g:ex_help_text_on
        return
    endif

    syntax match ex_SynHelpText '^" .*'

    " save the position
    let cur_line = line(".")
    let cur_col = col(".")

    let BufName = fnamemodify(bufname(""), ':t')
    " if we don't have this BufName map key, we will failed process function
    " below, so return instead.
    if !has_key(s:ex_MapHelpText, BufName)
        return
    endif

    let HelpMode = s:ex_MapHelpMode[BufName]

    " Set report option to a huge value to prevent informational messages
    " while deleting the lines
    let old_report = &report
    set report=99999

    " remove old help text
    let oldModifiableValue = &l:modifiable
    setlocal modifiable
    silent exec 'g/^" /d _'

    let index = len(s:ex_MapHelpText[BufName][HelpMode]) - 1
    while index >=0
        call append(0,'" ' . s:ex_MapHelpText[BufName][HelpMode][index])
        let index -= 1
    endwhile

    if  HelpMode != s:ex_MapHelpOldMode[BufName]
        normal! gg
        let s:ex_MapHelpOldMode[BufName] = HelpMode
    endif

    " Restore the report option
    let &report = old_report

    " write the file to prevent save file popup menu
    if &buftype==''
        exec 'w'
    endif

    let &l:modifiable=oldModifiableValue

    " restore the position
    silent call cursor(cur_line, cur_col)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

" --ex_SwitchHelpTextMode--
" Switch between different help text , -1 for toggle between 1 and 0
function g:ex_SwitchHelpTextMode(HelpMode) " <<<
    " call g:ex_ClearHighlightSelectLine()
    2match none " the function is gone, use the match directly
    let BufName = fnamemodify(bufname(""), ':t')
    let ResetCursor=0
    if a:HelpMode == -1
        if s:ex_MapHelpMode[BufName] == 0
            let s:ex_MapLastCursorLine[BufName]=line('.')
            let s:ex_MapHelpMode[BufName] = 1
        else
            let ResetCursor=getline(line('.')-1)[0]=='"'
            let s:ex_MapHelpMode[BufName] = 0
        endif
    else
        let s:ex_MapHelpMode[BufName] = a:HelpMode
    endif
    call g:ex_DisplayHelp()
    if ResetCursor
        call cursor(s:ex_MapLastCursorLine[BufName],0)
    else
        call cursor(1,0)
    endif
    call g:ex_HelpUpdateCursor()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

" --ex_HelpUpdateCursor--
" if Cursor is on the Help, jump to the first line without help
function g:ex_HelpUpdateCursor() " <<<
    " return immidiaetly if help off
    if !g:ex_help_text_on
        return 0
    endif
    if getline('.')[0] == '"'
        call search('^[^"]\|^$')
        return 1
    endif
    return 0
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

" --ex_GetHelpTextLength--
" return the length of HelpText
function g:ex_GetHelpTextLength() " <<<
    let linenum = 1
    while getline(linenum)[0] == '"'
        let linenum+=1
    endwhile
    return linenum-1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

" --ex_IsFunctionalbuf--
" return true if the buf is a functional buf
function g:ex_IsFunctionalbuf(Buf_Name) " <<<
    return index( g:exUT_plugin_list, fnamemodify(a:Buf_Name,":p:t") ) >=0
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
