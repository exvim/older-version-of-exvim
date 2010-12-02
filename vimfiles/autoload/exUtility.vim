" ======================================================================================
" File         : exUtility.vim
" Author       : Wu Jie 
" Last Change  : 11/30/2009 | 18:49:57 PM | Monday,November
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_exutility_auto') || &cp
    finish
endif
let loaded_exutility_auto=1

"/////////////////////////////////////////////////////////////////////////////
" variables
"/////////////////////////////////////////////////////////////////////////////

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
    for item in split(tolower(g:ex_todo_keyword), ' ')
        let s:ex_special_mark_pattern .= '\|\<' . item . '\>' 
    endfor
endif
if exists('g:ex_comment_lable_keyword')
    for item in split(tolower(g:ex_comment_lable_keyword), ' ')
        let s:ex_special_mark_pattern .= '\|\<' . item . '\>' 
    endfor
endif

" ------------------------------------------------------------------ 
" Desc: language file maps 
" ------------------------------------------------------------------ 

let s:ex_exvim_lang_map = {}
let s:ex_exvim_lang_map['asm'] = [ 'asm', 'ASM' ]
let s:ex_exvim_lang_map['awk'] = [ 'awk', 'gawk', 'mawk' ]
let s:ex_exvim_lang_map['batch'] = [ 'bat' ]
let s:ex_exvim_lang_map['c'] = [ 'c', 'C' ]
let s:ex_exvim_lang_map['cpp'] = ['c++', 'cc', 'cp', 'cpp', 'cxx', 'h', 'H', 'h++', 'hh', 'hp', 'hpp', 'hxx', 'inl', 'ipp' ]
let s:ex_exvim_lang_map['c#'] = [ 'cs' ]
let s:ex_exvim_lang_map['doxygen'] = [ 'dox', 'doxygen' ]
let s:ex_exvim_lang_map['debug'] = [ 'log', 'err', 'exe' ]
let s:ex_exvim_lang_map['html'] = [ 'htm', 'html' ]
let s:ex_exvim_lang_map['ini'] = [ 'ini', 'cfg' ]
let s:ex_exvim_lang_map['java'] = [ 'java' ]
let s:ex_exvim_lang_map['javascript'] = [ 'js' ]
let s:ex_exvim_lang_map['lua'] = [ 'lua' ]
let s:ex_exvim_lang_map['make'] = [ 'mak', 'mk', 'Makefile', 'makefile' ]
let s:ex_exvim_lang_map['matlab'] = [ 'm' ]
let s:ex_exvim_lang_map['python'] = [ 'py', 'pyw', 'pyx', 'pxd' ]
let s:ex_exvim_lang_map['ruby'] = [ 'rb', 'ruby' ]
let s:ex_exvim_lang_map['sh'] = [ 'sh', 'SH', 'bsh', 'bash', 'ksh', 'zsh' ]
let s:ex_exvim_lang_map['shader'] = [ 'hlsl', 'vsh', 'psh', 'fx', 'fxh', 'cg', 'shd', 'glsl' ]
let s:ex_exvim_lang_map['uc'] = [ 'uc' ]
let s:ex_exvim_lang_map['vim'] = [ 'vim' ]
let s:ex_exvim_lang_map['wiki'] = [ 'wiki' ]
let s:ex_exvim_lang_map['xml'] = [ 'xml' ]
let s:ex_exvim_lang_map['qt'] = [ 'qrc', 'pro', 'pri' ]
let s:ex_exvim_lang_map['swig'] = [ 'i', 'swg' ]

" ------------------------------------------------------------------ 
" Desc: ctags language file maps 
" ------------------------------------------------------------------ 

let s:ex_ctags_lang_map = {}
let s:ex_ctags_lang_map['asm'] = [ 'asm', 'ASM', 's', 'S', 'A51' ]
let s:ex_ctags_lang_map['asp'] = [ 'asp', 'asa' ]
let s:ex_ctags_lang_map['awk'] = [ 'awk', 'gawk', 'mawk' ]
let s:ex_ctags_lang_map['basic'] = [ 'bas', 'bi', 'bb', 'pb' ]
let s:ex_ctags_lang_map['beta'] = [ 'bet' ]
let s:ex_ctags_lang_map['c'] = [ 'c' ]
let s:ex_ctags_lang_map['cpp'] = [ 'c++', 'cc', 'cp', 'cpp', 'cxx', 'h', 'h++', 'hh', 'hp', 'hpp', 'hxx' ]
let s:ex_ctags_lang_map['c#'] = [ 'cs' ]
let s:ex_ctags_lang_map['cobol'] = [ 'cbl', 'cob', 'CBL', 'COB' ]
let s:ex_ctags_lang_map['eiffel'] = [ 'e' ]
let s:ex_ctags_lang_map['erlang'] = [ 'erl', 'ERL', 'hrl', 'HRL' ]
let s:ex_ctags_lang_map['fortran'] = [ 'fo', 'ft', 'f7', 'f9', 'f95' ]
let s:ex_ctags_lang_map['html'] = [ 'htm', 'html' ]
let s:ex_ctags_lang_map['java'] = [ 'java' ]
let s:ex_ctags_lang_map['javascript'] = [ 'js' ]
let s:ex_ctags_lang_map['lisp'] = [ 'cl', 'clisp', 'el', 'l', 'lisp', 'lsp', 'ml' ]
let s:ex_ctags_lang_map['lua'] = [ 'lua' ]
let s:ex_ctags_lang_map['make'] = [ 'mak', 'mk', 'Makefile', 'makefile' ]
let s:ex_ctags_lang_map['pascal'] = [ 'p', 'pas' ]
let s:ex_ctags_lang_map['perl'] = [ 'pl', 'pm', 'plx', 'perl' ]
let s:ex_ctags_lang_map['php'] = [ 'php', 'php3', 'phtml' ]
let s:ex_ctags_lang_map['python'] = [ 'py', 'pyx', 'pxd', 'scons' ]
let s:ex_ctags_lang_map['rexx'] = [ 'cmd', 'rexx', 'rx' ]
let s:ex_ctags_lang_map['ruby'] = [ 'rb', 'ruby' ]
let s:ex_ctags_lang_map['scheme'] = [ 'SCM', 'SM', 'sch', 'scheme', 'scm', 'sm' ]
let s:ex_ctags_lang_map['sh'] = [ 'sh', 'SH', 'bsh', 'bash', 'ksh', 'zsh' ]
let s:ex_ctags_lang_map['slang'] = [ 'sl' ]
let s:ex_ctags_lang_map['sml'] = ['sml', 'sig' ]
let s:ex_ctags_lang_map['sql'] = ['sql' ]
let s:ex_ctags_lang_map['tcl'] = ['tcl', 'tk', 'wish', 'itcl' ]
let s:ex_ctags_lang_map['vera'] = ['vr', 'vri', 'vrh' ]
let s:ex_ctags_lang_map['verilog'] = [ 'v' ]
let s:ex_ctags_lang_map['vim'] = [ 'vim' ]
let s:ex_ctags_lang_map['yacc'] = [ 'y' ]
let s:ex_ctags_lang_map['matlab'] = [ 'm' ]

" ------------------------------------------------------------------ 
" Desc: project file filter 
" ------------------------------------------------------------------ 

let s:ex_project_file_filter  = 'c,cpp,cxx,c++,C,cc,'
let s:ex_project_file_filter .= 'h,H,hh,hxx,hpp,inl,'
let s:ex_project_file_filter .= 'cs,'
let s:ex_project_file_filter .= 'uc,'
let s:ex_project_file_filter .= 'hlsl,vsh,psh,fx,fxh,cg,shd,glsl,'
let s:ex_project_file_filter .= 'py,pyw,'
let s:ex_project_file_filter .= 'vim,awk,m,'
let s:ex_project_file_filter .= 'dox,doxygen,'
let s:ex_project_file_filter .= 'ini,cfg,wiki,'
let s:ex_project_file_filter .= 'mk,err,exe,bat,sh,'

" ------------------------------------------------------------------ 
" Desc: project dir filter 
" ------------------------------------------------------------------ 

let s:ex_project_dir_filter = '' " null-string means include all directories

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

" TODO: change to proper variable { 
let s:ex_MapHelpText={}
let s:ex_MapHelpMode={}
let s:ex_MapHelpOldMode={}
let s:ex_MapLastCursorLine={}
" } TODO end 

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

function exUtility#CreateWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, init_func_name ) " <<<
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
            silent exec '1,$d _'
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
        call exUtility#InitWindow( a:init_func_name )
    endif

    " Set direction
    let w:use_vertical = a:use_vertical
    let w:window_direction = a:window_direction

    " adjust with edit_mode
    if a:edit_mode == 'append'
        exe 'normal! G'
    elseif a:edit_mode == 'replace'
        silent exec '1,$d _'
    endif

    " after create the window, record the bufname into the plugin buffer name list
    let short_bufname = fnamemodify(a:buffer_name,":p:t")
    if index( g:ex_plugin_registered_bufnames, short_bufname ) == -1
        silent call add( g:ex_plugin_registered_bufnames, short_bufname )
    endif

    " record the filetype into the plugin filetype list
    let buf_filetype = getbufvar(a:buffer_name,'&filetype')
    if index( g:ex_plugin_registered_filetypes, buf_filetype ) == -1
        silent call add( g:ex_plugin_registered_filetypes, buf_filetype )
    endif

endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Init window
" init_func_name: 'none', 'function_name'
" ------------------------------------------------------------------ 

function exUtility#InitWindow(init_func_name) " <<<
    silent! setlocal filetype=ex_plugin

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

    " the winfix height width will let plugin-window not join into the <c-w>= operations
    silent! setlocal winfixheight
    silent! setlocal winfixwidth

    " Define the ex autocommands
    augroup ex_auto_cmds
        autocmd WinLeave * call exUtility#RecordCurrentBufNum()
        autocmd BufLeave * call exUtility#RecordSwapBufInfo()
    augroup end

    " avoid cwd change problem
    if exists( 'g:exES_CWD' )
        au BufEnter * silent exec 'lcd ' . escape(g:exES_CWD, " ")
    endif

    " call the user define init_function
    if a:init_func_name != 'none'
        exe 'call ' . a:init_func_name . '()'
    endif

    " Define syntax highlight
    " NOTE: define the syntax highlight after user init. this can prevent user
    "       override the basic syntax.
    syntax match ex_SynError '^Error:.*'
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

function exUtility#OpenWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, backto_editbuf, init_func_name, call_func_name ) " <<<
    " close ex_plugin window in same position
    call exUtility#ClosePluginWindowInSamePosition ( a:use_vertical, a:window_direction )

    " go to edit buffer first, then open the window, this will avoid some bugs
    call exUtility#RecordCurrentBufNum()
    call exUtility#GotoEditBuffer()

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
            silent exec '1,$d _'
        endif

        return
    endif

    " Open window
    call exUtility#CreateWindow( a:buffer_name, a:window_direction, a:window_size, a:use_vertical, a:edit_mode, a:init_func_name )

    if a:call_func_name != 'none'
        exe 'call ' . a:call_func_name . '()'
    endif

    "
    if a:backto_editbuf
        " Need to jump back to the original window only if we are not
        " already in that window
        call exUtility#GotoEditBuffer()
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Close window
" ------------------------------------------------------------------ 

function exUtility#CloseWindow( buffer_name ) " <<<
    "Make sure the window exists
    let winnum = bufwinnr(a:buffer_name)
    if winnum == -1
        call exUtility#WarningMsg('Error: ' . a:buffer_name . ' window is not open')
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
    call exUtility#GotoEditBuffer()
    call exUtility#ClearObjectHighlight()
    
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

function exUtility#ToggleWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, backto_editbuf, init_func_name, call_func_name ) " <<<
    " If exTagSelect window is open then close it.
    let winnum = bufwinnr(a:buffer_name)
    if winnum != -1
        call exUtility#CloseWindow(a:buffer_name)
        return
    endif

    call exUtility#OpenWindow( a:buffer_name, a:window_direction, a:window_size, a:use_vertical, a:edit_mode, a:backto_editbuf, a:init_func_name, a:call_func_name )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Resize window use increase value
" ------------------------------------------------------------------ 

function exUtility#ResizeWindow( use_vertical, original_size, increase_size ) " <<<
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

function exUtility#OperateWindow( title, close_when_selected, backto_edibut, hl_obj_line ) " <<<
    if a:close_when_selected
        call exUtility#CloseWindow(a:title)
        call exUtility#GotoEditBuffer()
    else
        " go back to edit buffer first
        call exUtility#GotoEditBuffer()

        " highlight object line when 
        " 1: we not close selected window 
        " 2: if we needed
        if a:hl_obj_line
            call exUtility#HighlightObjectLine()
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

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#ClosePluginWindowInSamePosition ( use_vertical, window_direction ) " <<<
    " NOTE: the CloseWindow should be called in each situation. 
    " Since you can: in a exProject/Minibuffer window try to open another plugin window. 
    "                or just open a plugin window that already have another plugin window take the position.

    " check if a ex window exists on the target position, if yes, close it. 
    for nr_win in range(1,winnr("$"))
        if getwinvar(nr_win, "use_vertical") == a:use_vertical && getwinvar(nr_win, "window_direction") == a:window_direction 
            " get the ex window, change window to the target window
            silent exe nr_win . 'wincmd w'
            call exUtility#CloseWindow( bufname('%') )
            return
        endif
    endfor

    " check if current window is a plugin window ( except minibuf, exProject), if yes close it
    if exUtility#IsRegisteredPluginBuffer ( bufname('%') ) && 
                \ fnamemodify(bufname('%'),":p:t") !=# "-MiniBufExplorer-" &&
                \ &filetype != 'ex_project' &&
                \ &filetype != 'nerdtree'
        call exUtility#CloseWindow( bufname('%') )
        return
    endif
endfunction " >>>


" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CloseAllExpluginWindow() " <<<
    " walk through all window in exvim
    let i = 1
    let bufnum_list = []
    while i <= winnr("$")
        let bnum = winbufnr(i)
        let buf_filetype = getbufvar(bnum, '&filetype') 
        if bnum != -1 && exUtility#IsRegisteredPluginBuffer ( bufname('%') )
            silent call add ( bufnum_list, bnum )
        endif
        let i += 1
    endwhile

    "
    for bnum in bufnum_list
        call exUtility#CloseWindow ( bufname(bnum) )
    endfor
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  string functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#PutLine( len, line_type ) " <<<
    let plen = a:len - strlen(getline('.'))
    if (plen > 0)
        execute 'normal! ' plen . 'A' . a:line_type
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#PutSegment() " <<<
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

function exUtility#PutNote() " <<<
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

function exUtility#PutNamespaceStart( space_name ) " <<<
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

function exUtility#PutNamespaceEnd( space_name ) " <<<
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

function exUtility#PutNamespace( space_name, line1, line2 ) " <<<
    " 
    let first_line = a:line1
    let last_line = a:line2

    " put namespace end first
    silent call cursor( last_line, 1 )
    silent put = ''
    call exUtility#PutNamespaceEnd(a:space_name)

    " then go back to first line and put namespace start
    silent call cursor( first_line - 1, 1 )
    call exUtility#PutNamespaceStart(a:space_name)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#PutExternC( line1, line2 ) " <<<
    " 
    let first_line = a:line1
    let last_line = a:line2

    " put namespace end first
    silent call cursor( last_line, 1 )
    silent put = ''
    silent call append  ( '.', b:ECcommentOpen . " ######################### " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "#ifdef __cplusplus" )
    silent normal! j
    silent call append  ( '.', "} // end extern C " )
    silent normal! j
    silent call append  ( '.', "#endif" )
    silent normal! j
    silent call append  ( '.', b:ECcommentOpen . " ######################### " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "" )
    silent normal! j

    " then go back to first line and put namespace start
    silent call cursor( first_line - 1, 1 )
    silent call append  ( '.', b:ECcommentOpen . " ######################### " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "#ifdef __cplusplus" )
    silent normal! j
    silent call append  ( '.', 'extern "C" { ' )
    silent normal! j
    silent call append  ( '.', "#endif" )
    silent normal! j
    silent call append  ( '.', b:ECcommentOpen . " ######################### " . b:ECcommentClose )
    silent normal! j
    silent call append  ( '.', "" )
    silent normal! j
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#PutSeparate() " <<<
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

function exUtility#PutDescription() " <<<
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

function exUtility#PutDefine() " <<<
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

function exUtility#PutDeclaration() " <<<
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

function exUtility#PutHeader() " <<<
    let old_lan = v:lang
    silent exec 'language C'

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

    " FIXME: cannot reset { 
    " silent exec 'language ' . old_lan
    " } FIXME end 
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#PutMain() " <<<
    execute 'normal! ' . 'o' .   "int main( int argc, char* argv[] )"
    execute 'normal! ' . "o" . "{"
    execute 'normal! ' . "o" . "}\<CR>"
    execute 'normal! ' . "2k"
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#PutClass( class_type, class_name ) " <<<
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

function exUtility#MarkText( text, line1, line2 ) " <<<

    " 
    let first_line = a:line1
    let last_line = a:line2

    " check if it is special mark, special mark will use uppercase
    let text = ''
    for item in split(a:text, ' ')
        if item =~? s:ex_special_mark_pattern
            let text .= toupper(item) . ' ' 
        else
            let text .= item . ' ' 
        endif
    endfor

    " remove last space
    let text = strpart ( text, 0, len(text) - 1 )

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

function exUtility#RemoveSpecialMarkText () " <<<
    let save_cursor = getpos(".")
    let save_line = getline(".")
    let cur_line = save_line

    let start_lnum = -1
    let end_lnum = -1
    let start_pattern = b:ECcommentOpen . '.*' . '\(' . s:ex_special_mark_pattern . '\)' . '.* { ' . b:ECcommentClose
    let end_pattern = b:ECcommentOpen . ' }.*' . '\(' . s:ex_special_mark_pattern . '\)' . '.* end ' . b:ECcommentClose

    " found '#if 0' first
    while match(cur_line, start_pattern ) == -1
        let cur_line_nr = line(".")
        silent normal! ^[{
        let cur_line = getline(".")
        let lnum = line(".")
        if lnum == cur_line_nr
            if match( cur_line, start_pattern ) == -1
                call exUtility#WarningMsg("special mark pattern not found")
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

function exUtility#AlignDigit( align_nr, digit ) " <<<
    let print_fmt = '%'.a:align_nr.'d'
    let str_digit = printf(print_fmt,a:digit)
    retur substitute(str_digit,' ', '0','g')
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#InsertIFZero() range " <<<
    let lstline = a:lastline + 1 
    call append( a:lastline , "#endif")
    call append( a:firstline -1 , "#if 0")
    silent exec ":" . lstline
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#RemoveIFZero() range " <<<
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
                call exUtility#WarningMsg(" not #if 0 matched")
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
"       TODO: used the longest column as the base column to insert \
" ------------------------------------------------------------------ 

function exUtility#InsertRemoveExtend() range " <<<
    let line = getline('.')
    if (strpart(line,strlen(line)-1,1) == "\\")
        exec ":" . a:firstline . "," . a:lastline . "s/\\\\$//"
    else
        exec ":" . a:firstline . "," . a:lastline . "s/$/ \\\\/"
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#Yank( string ) " <<<
    let @" = a:string
    let @* = a:string
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#SmartCaseCompare( text, pattern ) " <<<
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
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#IsRegisteredPluginBuffer ( buffer_name ) " <<<
    " check if the buffer filetype is register in the plugin filetype list 
    if index( g:ex_plugin_registered_filetypes, getbufvar( a:buffer_name, '&filetype' ), 0, 1 ) >= 0
        return 1
    endif

    " check if the buffer name is register in the plugin buffername list 
    if index( g:ex_plugin_registered_bufnames, fnamemodify( a:buffer_name, ":p:t" ), 0, 1 ) >= 0
        return 1
    endif

    return 0
endfunction " >>>


" ------------------------------------------------------------------ 
" Desc: Record current buf num when leave
" FIXME: when you split window/open the same file in two window, you can only get the original bufwinnr() by the bufnr().
" FIXME: :sp will trigger the WinEnter, find a way to use it.
" ------------------------------------------------------------------ 

function exUtility#RecordCurrentBufNum() " <<<
    let short_bufname = fnamemodify(bufname('%'),":p:t")
    if !exUtility#IsRegisteredPluginBuffer(bufname('%'))
        let s:ex_editbuf_num = bufnr('%')
    elseif short_bufname !=# "-MiniBufExplorer-"
        let s:ex_pluginbuf_num = bufnr('%')
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Record current buf pos
" ------------------------------------------------------------------ 

function exUtility#RecordSwapBufInfo() " <<<
    let bufnr = bufnr('%')
    let short_bufname = fnamemodify(bufname(bufnr),":p:t")
    if buflisted(bufnr) && bufloaded(bufnr) && bufexists(bufnr) && !exUtility#IsRegisteredPluginBuffer(bufname('%'))
        let s:ex_swap_buf_num = bufnr
        let s:ex_swap_buf_pos = getpos('.')
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#SwapToLastEditBuffer() " <<<
    " check if current buffer can use switch
    let cur_bufnr = bufnr('%')
    let cru_short_bufname = fnamemodify(bufname('%'),":p:t")

    if exUtility#IsRegisteredPluginBuffer ( bufname('%') ) " check it is plugin window or not
        call exUtility#WarningMsg("Buffer: " .bufname(cur_bufnr).  " can't be switch.")
        return
    endif

    " check if last buffer existed and listed, swap if accessable
    let last_bufnr = bufnr("#")
    let last_short_bufname = fnamemodify(bufname(last_bufnr),":p:t")
    if buflisted(last_bufnr) && bufloaded(last_bufnr) && bufexists(last_bufnr) && !exUtility#IsRegisteredPluginBuffer(bufname('%'))
        let tmp_swap_buf_pos = deepcopy(s:ex_swap_buf_pos)
        let tmp_swap_buf_nr = s:ex_swap_buf_num
        let s:ex_swap_buf_pos = getpos('.')
        silent exec last_bufnr."b!"

        " only recover the pos when we have the right last buffer recorded
        if last_bufnr == tmp_swap_buf_nr
            silent call setpos('.',tmp_swap_buf_pos)
        endif
    else
        call exUtility#WarningMsg("Buffer: " .bufname(last_bufnr).  " can't be accessed.")
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GotoBuffer(cmd) " <<<
    " NOTE: there has a bug, in window (not fullscree) mode, some times the buffer will jump to other display screen ( if you use double screen ).      

    " save current win pos x,y.
    if has("gui_running")
        let gui_win_pos_x = getwinposx()
        let gui_win_pos_y = getwinposy()
    endif

    " if this is a registered plugin buffer, then go to the edit buffer first 
    if exUtility#IsRegisteredPluginBuffer(bufname('%')) 
        call exUtility#GotoEditBuffer()
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

function exUtility#UpdateCurrentBuffer() " <<<
    if exists(':UMiniBufExplorer')
        silent exe "UMiniBufExplorer"
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GotoEditBuffer() " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum && winnum != -1 " this will fix the jump error in the vimentry buffer, cause the winnum for vimentry buffer will be -1
        exe winnum . 'wincmd w'
    endif
    call exUtility#RecordCurrentBufNum()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GotoPluginBuffer() " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_pluginbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif
    call exUtility#RecordCurrentBufNum()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetEditBufferNum() " <<<
    return s:ex_editbuf_num
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#YankBufferNameForCode() " <<<
    let buf_name = exUtility#Pathfmt( bufname('%'), 'unix' )
    silent call exUtility#Yank( fnamemodify(buf_name,"") )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#YankFilePathForCode() " <<<
    let buf_name = exUtility#Pathfmt( bufname('%'), 'unix' )
    silent call exUtility#Yank( fnamemodify(buf_name,":h") )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#SwitchBuffer() " <<<
    " this will fix no jump error < bufwinnr() == -1 >
    silent call exUtility#RecordCurrentBufNum()

    " if current window is same as edit buffer window, jump to last edit window
    if winnr() == bufwinnr(s:ex_editbuf_num)
        call exUtility#GotoPluginBuffer()
    else
        call exUtility#GotoEditBuffer()
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: VimTip #1119: How to use Vim like an IDE
" delete the buffer; keep windows; create a scratch buffer if no buffers left 
" Using this Kwbd function (:call Kwbd(1)) will make Vim behave like an IDE; or maybe even better. 
" ------------------------------------------------------------------ 

function exUtility#Kwbd(kwbdStage) " <<<
    if(a:kwbdStage == 1) 
        " check it is plugin window, if yes, close it directly to prevent use \bd
        " close, reopen will loose plugin ability problem
        let cru_short_bufname = fnamemodify(bufname('%'),":p:t")
        if exUtility#IsRegisteredPluginBuffer(bufname('%')) 
            silent exec 'close'
            call exUtility#GotoEditBuffer()
            return
        endif

        "
        if(!buflisted(winbufnr(0))) 
            bd! 
            return 
        endif 
        let g:kwbdBufNum = bufnr("%") 
        let g:kwbdWinNum = winnr() 
        windo call exUtility#Kwbd(2) 
        exe g:kwbdWinNum . 'wincmd w'
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
            exe g:kwbdWinNum . 'wincmd w'
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

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#SaveRestoreInfo() " <<<
    if exists ('g:exES_RestoreInfo')
        let nb_buffers = bufnr('$')     " Get the number of the last buffer.
        let idx = 1                     " Set the buffer index to one, NOTE: zero is represent to last edit buffer.
        let cmdlist = []

        " store listed buffers
        while idx <= nb_buffers
            if getbufvar( idx, '&buflisted') == 1
                silent call add ( cmdlist, "badd " . bufname(idx) )
            endif
            let idx += 1
        endwhile

        " save the last edit buffer detail info
        call exUtility#GotoEditBuffer()
        let last_buf_nr = bufnr('%')
        if getbufvar( last_buf_nr, '&buflisted') == 1
            " load last edit buffer
            silent call add ( cmdlist, "edit " . bufname(last_buf_nr) )
            let save_cursor = getpos(".")
            silent call add ( cmdlist, "call cursor(" . save_cursor[1] . "," . save_cursor[2] . ")" )
        endif

        "
        call writefile( cmdlist, g:exES_RestoreInfo )
    endif
endfunction  " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#RestoreLastEditBuffers() " <<<
    if exists ('g:exES_RestoreInfo') && findfile( fnamemodify(g:exES_RestoreInfo,':p'), '.;' ) != ""
        call exUtility#GotoEditBuffer()
        let cmdlist = readfile ( g:exES_RestoreInfo )

        " load all buffers
        for cmd in cmdlist 
            silent exec cmd 
        endfor

        " go to last edit buffer
        call exUtility#GotoEditBuffer()
        doautocmd BufNewFile,BufRead,BufEnter,BufWinEnter
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

function exUtility#GetVimFile( entry_path, vimfiles_dirname, file_type ) " <<<
    "
    let entry_path = fnamemodify( a:entry_path, ':p')
    let fullpath_file = ''
    if a:file_type ==# 'tag'
        let fullpath_file = entry_path . '/' . a:vimfiles_dirname . '/tags'
    elseif a:file_type ==# 'symbol' 
        let fullpath_file = entry_path . '/' . a:vimfiles_dirname . '/symbol'
    elseif a:file_type ==# 'id' 
        let fullpath_file = entry_path . '/' . a:vimfiles_dirname . '/ID'
    elseif a:file_type ==# 'inherits' 
        let fullpath_file = entry_path . '/' . a:vimfiles_dirname . '/inherits'
    else
        call exUtility#WarningMsg( 'unknown file_type: ' . a:file_type )
        return
    endif

    "
    return simplify(fullpath_file)
endfunction ">>>

" ------------------------------------------------------------------ 
" Desc: 
"  system: 'windows' 'unix'
" ------------------------------------------------------------------ 

function exUtility#Pathfmt( path, system ) " <<<
    if a:system == 'windows'
        return substitute( a:path, "\/", "\\", "g" )
    elseif a:system == 'unix'
        return substitute( a:path, "\\", "\/", "g" )
    else
        call exUtility#WarningMsg('unknown OS: ' . system)
    endif
endfunction ">>>


" ------------------------------------------------------------------ 
" Desc: Convert full file name into the format: file_name (directory)
" ------------------------------------------------------------------ 

function exUtility#ConvertFileName(full_file_name) " <<<
    return fnamemodify( a:full_file_name, ":t" ) . ' (' . fnamemodify( a:full_file_name, ":h" ) . ')'    
endfunction ">>>

" ------------------------------------------------------------------ 
" Desc: Get full file name from converted format
" ------------------------------------------------------------------ 

function exUtility#GetFullFileName(converted_line) " <<<
    if match(a:converted_line, '^\S\+\s(\S\+)$') == -1
        call exUtility#WarningMsg('format is wrong')
        return
    endif
    let idx_space = stridx(a:converted_line, ' ')
    let simple_file_name = strpart(a:converted_line, 0, idx_space)
    let idx_bracket_first = stridx(a:converted_line, '(')
    let file_path = strpart(a:converted_line, idx_bracket_first+1)
    let idx_bracket_last = stridx(file_path, ')')
    return strpart(file_path, 0, idx_bracket_last) . '\' . simple_file_name
endfunction " >>>

" KEEPME: we don't need this function, but keep it { 
" ------------------------------------------------------------------ 
" Desc: Match tag and find file if it has
" ------------------------------------------------------------------ 

" function exUtility#MatchTagFile( tag_file_list, file_name ) " <<<
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
"         call exUtility#WarningMsg( a:file_name . ' not found' )
"     endif
" 
"     return simplify(full_file_name)
" endfunction " >>>
" } KEEPME end 

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetFileFilterByLanguage( lang_type_list ) " <<<
    let file_filter = ''
    for lang_type in a:lang_type_list 
        if has_key (s:ex_exvim_lang_map, lang_type)
            for file_type in s:ex_exvim_lang_map[lang_type] 
                let file_filter .= file_type . ',' 
            endfor
        endif
    endfor
    return file_filter
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#SetProjectFilter( filter_type, filter ) " <<<
    " first strip filter
    let idx = match( a:filter, '\S' )
    let idx = idx >= 0 ? idx : 0 
    let idx_end = match( a:filter, '\s$' )
    let idx_end = idx_end >= 0 ? idx_end : len(a:filter) 
    let filter = strpart( a:filter, idx, idx_end-idx )

    " 
    if a:filter_type ==# 'file_filter'
        let s:ex_project_file_filter = filter
        call exUtility#CreateIDLangMap( s:ex_project_file_filter )
    elseif a:filter_type ==# 'dir_filter'
        let s:ex_project_dir_filter = filter
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetProjectFilter(filter_type) " <<<
    if a:filter_type ==# 'file_filter'
        return s:ex_project_file_filter
    elseif a:filter_type ==# 'dir_filter'
        return s:ex_project_dir_filter
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetCscopeFileFilter(filter_list) " <<<
    let cscope_file_filter_list = []
    for lang_type in g:ex_cscope_langs 
        if has_key (s:ex_exvim_lang_map, lang_type)
            for file_type in s:ex_exvim_lang_map[lang_type] 
                if index(a:filter_list,file_type) != -1
                    silent call add(cscope_file_filter_list,file_type)
                endif
            endfor
        endif
    endfor
    return cscope_file_filter_list
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetProjectFileFilterCommand() " <<<
    let filter_list = split(s:ex_project_file_filter,',')
    let filter_command = ''

    let cscope_filter_list = exUtility#GetCscopeFileFilter(filter_list)
    let cscope_filter_command = ''

    if has ('win32')
        " NOTE: in win32, since we use dir /s /b, the result *.h and *.H will 
        "       list .h files twice, also *.h will not list .H files. To prevent 
        "       this, we detect the filter_list if same file suffix found, we 
        "       choose upper case. 

        " general filter command
        let filter_list2 = []
        for item1 in filter_list
            let found = 0
            for item2 in filter_list2
                if item1 ==? item2
                    let found = 1
                endif
            endfor
            if found == 0
                silent call add ( filter_list2, toupper(item1) )
            endif
        endfor
        for item in filter_list2
            let filter_command .= '*.' . item . ' '
        endfor

        " cscope filter command
        let filter_list2 = []
        for item1 in cscope_filter_list
            let found = 0
            for item2 in filter_list2
                if item1 ==? item2
                    let found = 1
                endif
            endfor
            if found == 0
                silent call add ( filter_list2, toupper(item1) )
            endif
        endfor
        for item in filter_list2
            let cscope_filter_command .= '*.' . item . ' '
        endfor
    elseif has ('unix')
        for item in filter_list 
            let filter_command .= substitute(item, "\+", "\\\\+", "g") . '|'
        endfor
        for item in cscope_filter_list 
            let cscope_filter_command .= substitute(item, "\+", "\\\\+", "g") . '|'
        endfor
        let filter_command = strpart( filter_command, 0, len(filter_command) - 1)
        let cscope_filter_command = strpart( cscope_filter_command, 0, len(cscope_filter_command) - 1)
    endif

    return [filter_command,cscope_filter_command]
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetProjectFileFilterPattern() " <<<
    "
    let filter_list = split(s:ex_project_file_filter,',')
    let filter_pattern = ''
    let cscope_filter_pattern = ''

    let cscope_filter_list = exUtility#GetCscopeFileFilter(filter_list)
    let cscope_filter_pattern = ''

    "
    for item in filter_list
        let filter_pattern .= '\\.' . item . '$|'
    endfor

    for item in cscope_filter_list
        let cscope_filter_pattern .= '\\.' . item . '$|'
    endfor

    "
    let filter_pattern = strpart( filter_pattern, 0, len(filter_pattern) - 1)
    let cscope_filter_pattern = strpart( cscope_filter_pattern, 0, len(cscope_filter_pattern) - 1)
    return [filter_pattern,cscope_filter_pattern]
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetProjectDirFilterCommand() " <<<
    let filter_list = split(s:ex_project_dir_filter,',')
    let filter_command = ''

    if has ('win32')
        for item in filter_list 
            let filter_command .= '"' . item . '" '
        endfor
    elseif has ('unix')
        for item in filter_list 
            let filter_command .= '"./' . item . '" '
        endfor
    endif

    return filter_command
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetFileFilterPattern(filter) " <<<
    let filter_list = split(a:filter,',')
    let filter_pattern = '\V'
    for filter in filter_list
        if filter == ''
            continue
        endif
        let filter_pattern = filter_pattern . '\<' . filter . '\>\$\|'
    endfor
    return strpart(filter_pattern, 0, strlen(filter_pattern)-2)
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetDirFilterPattern(filter) " <<<
    if a:filter ==# ''
        return ''
    endif

    let filter_list = split(a:filter,',')
    let filter_pattern = '\V'
    for filter in filter_list
        if filter == ''
            continue
        endif
        let filter_pattern = filter_pattern . '\<' . filter . '\>\$\|'
    endfor
    return strpart(filter_pattern, 0, strlen(filter_pattern)-2)
endfunction " >>>


" KEEPME: we don't need this function, but keep it { 
" " ------------------------------------------------------------------ 
" " Desc: 
" " ------------------------------------------------------------------ 

" function exUtility#BrowseWithEmtpy(dir, filter) " <<<
"     " get short_dir
"     "let short_dir = strpart( a:dir, strridx(a:dir,'\')+1 )
"     let short_dir = fnamemodify( a:dir, ":t" )
"     if short_dir == ''
"         let short_dir = a:dir
"     endif

"     " write space
"     let space = ''
"     let list_idx = 0
"     let list_last = len(s:ex_level_list)-1
"     for level in s:ex_level_list
"         if level.is_last != 0 && list_idx != list_last
"             let space = space . '  '
"         else
"             let space = space . ' |'
"         endif
"         let list_idx += 1
"     endfor
"     let space = space.'-'

"     " get end_fold
"     let end_fold = ''
"     let rev_list = reverse(copy(s:ex_level_list))
"     for level in rev_list
"         if level.is_last != 0
"             let end_fold = end_fold . ' }'
"         else
"             break
"         endif
"     endfor

"     " judge if it is a dir
"     if isdirectory(a:dir) == 0
"         " put it
"         " let file_type = strpart( short_dir, strridx(short_dir,'.')+1, 1 )
"         let file_type = strpart( fnamemodify( short_dir, ":e" ), 0, 1 )
"         silent put = space.'['.file_type.']'.short_dir  . end_fold
"         " if file_end enter a new line for it
"         if end_fold != ''
"             let end_space = strpart(space,0,strridx(space,'-')-1)
"             let end_space = strpart(end_space,0,strridx(end_space,'|')+1)
"             silent put = end_space " . end_fold
"         endif
"         return
"     else
"         " split the first level to file_list
"         let file_list = split(globpath(a:dir,'*'),'\n')

"         " first sort the list as we want (file|dir )
"         let list_idx = 0
"         let list_last = len(file_list)-1
"         let list_count = 0
"         while list_count <= list_last
"             if isdirectory(file_list[list_idx]) == 0 " move the file to the end of the list
"                 if match(file_list[list_idx],a:filter) == -1
"                     silent call remove(file_list,list_idx)
"                     let list_idx -= 1
"                 else
"                     let file = remove(file_list,list_idx)
"                     silent call add(file_list, file)
"                     let list_idx -= 1
"                 endif
"             endif
"             " ++++++++++++++++++++++++++++++++++
"             " if isdirectory(file_list[list_idx]) != 0 " move the dir to the end of the list
"             "     let dir = remove(file_list,list_idx)
"             "     silent call add(file_list, dir)
"             "     let list_idx -= 1
"             " else " filter file
"             "     if match(file_list[list_idx],a:filter) == -1
"             "         silent call remove(file_list,list_idx)
"             "         let list_idx -= 1
"             "     endif
"             " endif
"             " ++++++++++++++++++++++++++++++++++

"             let list_idx += 1
"             let list_count += 1
"         endwhile

"         "silent put = strpart(space, 0, strridx(space,'\|-')+1)
"         if len(file_list) == 0 " if it is a empty directory
"             if end_fold == ''
"                 " if dir_end enter a new line for it
"                 let end_space = strpart(space,0,strridx(space,'-'))
"             else
"                 " if dir_end enter a new line for it
"                 let end_space = strpart(space,0,strridx(space,'-')-1)
"                 let end_space = strpart(end_space,0,strridx(end_space,'|')+1)
"             endif
"             let end_fold = end_fold . ' }'
"             silent put = space.'[F]'.short_dir . ' {' . end_fold
"             silent put = end_space
"         else
"             silent put = space.'[F]'.short_dir . ' {'
"         endif
"         silent call add(s:ex_level_list, {'is_last':0,'short_dir':short_dir})
"     endif

"     " ECHO full_path for this level
"     " ++++++++++++++++++++++++++++++++++
"     " let full_path = ''
"     " for level in s:ex_level_list
"     "     let full_path = level.short_dir.'/'.full_path
"     " endfor
"     " echon full_path."\r"
"     " ++++++++++++++++++++++++++++++++++

"     " recuseve browse list
"     let list_idx = 0
"     let list_last = len(file_list)-1
"     for dir in file_list
"         if list_idx == list_last
"             let s:ex_level_list[len(s:ex_level_list)-1].is_last = 1
"         endif
"         call exUtility#BrowseWithEmtpy(dir,a:filter)
"         let list_idx += 1
"     endfor
"     silent call remove( s:ex_level_list, len(s:ex_level_list)-1 )
" endfunction " >>>
" } KEEPME end 

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#SetLevelList( line_num, by_next_line ) " <<<
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

function exUtility#FileNameSort( i1, i2 ) " <<<
    return a:i1 ==? a:i2 ? 0 : a:i1 >? a:i2 ? 1 : -1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#Browse(dir, file_filter, dir_filter, filename_list ) " <<<
    " show progress
    echon "processing: " . a:dir . "\r"

    " get short_dir
    " let short_dir = strpart( a:dir, strridx(a:dir,'\')+1 )
    let short_dir = fnamemodify( a:dir, ":t" )

    " if directory
    if isdirectory(a:dir) == 1
        " split the first level to file_list
        let file_list = split(globpath(a:dir,'*'),'\n') " NOTE, globpath('.','.*') will show hidden folder
        silent call sort( file_list, "exUtility#FileNameSort" )

        " sort and filter the list as we want (file|dir )
        let list_idx = 0
        let list_last = len(file_list)-1
        let list_count = 0
        while list_count <= list_last
            if isdirectory(file_list[list_idx]) == 0 " remove not fit file types
                let suffix = fnamemodify ( file_list[list_idx], ":e" ) 
                " move the file to the end of the list
                if ( match ( suffix, a:file_filter ) != -1 ) ||
                 \ ( suffix == '' && match ( 'NULL', a:file_filter ) != -1 ) 
                    let file = remove(file_list,list_idx)
                    silent call add(file_list, file)
                else " if not found file type in file filter
                    silent call remove(file_list,list_idx)
                endif
                let list_idx -= 1
            elseif a:dir_filter != '' " remove not fit dirs
                if match( file_list[list_idx], a:dir_filter ) == -1 " if not found dir name in dir filter
                    silent call remove(file_list,list_idx)
                    let list_idx -= 1
                endif
            " DISABLE: in our case, globpath never search hidden folder. { 
            " elseif len (s:ex_level_list) == 0 " in first level directory, if we .vimfiles* folders, remove them
            "     if match( file_list[list_idx], '\<.vimfiles.*' ) != -1
            "         silent call remove(file_list,list_idx)
            "         let list_idx -= 1
            "     endif
            " } DISABLE end 
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
            if exUtility#Browse(file_list[list_idx],a:file_filter,'',a:filename_list) == 1 " if it is empty
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

        " add file with full path as tag contents
        let filename_path = exUtility#Pathfmt(fnamemodify(a:dir,':.'),'unix')
        silent call add ( a:filename_list, short_dir."\t".'../'.filename_path."\t1" )
        " KEEPME: we don't use this method now { 
        " silent call add ( a:filename_list[1], './'.filename_path )
        " silent call add ( a:filename_list[2], '../'.filename_path )
        " } KEEPME end 
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

function exUtility#QuickFileJump() " <<<
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
            call exUtility#WarningMsg("file not found")
        endif
    else
        normal! gf
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#Explore( path ) " <<<
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

function exUtility#GetFoldLevel(line_num) " <<<
    let cur_line = getline(a:line_num)
    let cur_line = strpart(cur_line,0,strridx(cur_line,'|')+1)
    let str_len = strlen(cur_line)
    return str_len/2
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#FoldText() " <<<
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

function exUtility#GotoSearchPattern(full_file_name, search_pattern) " <<<
    " check and jump to the buffer first
    call exUtility#GotoEditBuffer()

    " start jump
    let file_name = escape(a:full_file_name, ' ')
    exe 'silent e ' . file_name

    " if search_pattern is digital, just set pos of it
    let line_num = strpart(a:search_pattern, 2, strlen(a:search_pattern)-4)
    let line_num = matchstr(line_num, '^\d\+$')
    if line_num
        call cursor(eval(line_num), 1)
    elseif search(a:search_pattern, 'w') == 0
        call exUtility#WarningMsg('search pattern not found')
        return 0
    endif

    " set the text at the middle
    exe 'normal! zz'

    return 1
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Goto the position by file name and search pattern
" ------------------------------------------------------------------ 

function exUtility#GotoExCommand(full_file_name, ex_cmd, keepjump_cmd) " <<<
    " check and jump to the buffer first
    call exUtility#GotoEditBuffer()

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
                call exUtility#WarningMsg('search pattern not found: ' . pattern)
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

function exUtility#GotoTagNumber(tag_number) " <<<
    " check and jump to the buffer first
    call exUtility#GotoEditBuffer()

    silent exec a:tag_number . "tr!"

    " set the text at the middle
    exe 'normal! zz'
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Goto the pos by position list
" ------------------------------------------------------------------ 

function exUtility#GotoPos(poslist) " <<<
    " check and jump to the buffer first
    call exUtility#GotoEditBuffer()

    " TODO must have buffer number or buffer name
    call setpos('.', a:poslist)

    " set the text at the middle
    exe 'normal! zz'
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CursorJump( search_pattern, search_direction ) " <<<
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

function exUtility#Terminal( behavior, wait, cmd ) " <<<
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

function exUtility#GCCMake(args) " <<<
    " save all file for compile first
    silent exec "wa!"

    let entry_file = glob('gcc_entry*.mk') 
    if entry_file != ''
        if has ("win32")
            call exUtility#Terminal ( 'prompt', 'nowait', 'make -f' . entry_file . ' ' . a:args )
        elseif has("unix")
            exec "!make -f" . entry_file . ' ' . a:args
        endif
    else
        call exUtility#WarningMsg("entry file not found")
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#ShaderMake(args) " <<<
    " save all file for compile first
    silent exec "wa!"

    let entry_file = glob('shader_entry*.mk') 
    if entry_file != ''
        call exUtility#Terminal ( 'prompt', 'nowait', 'make -f' . entry_file . ' ' . a:args )
    else
        call exUtility#WarningMsg("entry file not found")
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#VCMake(args) " <<<
    " save all file for compile first
    silent exec "wa!"

    let entry_file = glob('msvc_entry*.mk') 
    if entry_file != ''
        call exUtility#Terminal ( 'prompt', 'nowait', 'make -f' . entry_file . ' ' . a:args )
    else
        call exUtility#WarningMsg("entry file not found")
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#VCMakeBAT(cmd, config) " <<<
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
                call exUtility#WarningMsg("command: ".cmd."not found")
                return
            endif

            " exec make_vs.bat
            call exUtility#Terminal ( 'prompt', 'nowait', 'make_vs ' . cmd . ' ' . g:exES_Solution . ' ' . a:config . ' ' . prj_name )
        else
            call exUtility#WarningMsg("solution not found")
        endif
    else
        call exUtility#WarningMsg("make_vs.bat not found")
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#SphinxMake(args) " <<<
    " save all file for compile first
    silent exec "wa!"
    let make_file = glob('make.bat')
    if has ("unix")
        let make_file = glob('Makefile')
    endif
    if make_file == ''
        call exUtility#WarningMsg("make.bat not found")
        return
    endif

    let error_file = '.build/error.err'
    if has ("win32")
        call exUtility#Terminal ( 'silent', 'wait', 'make ' . a:args . ' 2>' . error_file )
        silent exec 'QF '. error_file
    elseif has("unix")
        exec "!make -f" . make_file . ' ' . a:args . ' 2>' . error_file
        silent exec 'QF '. error_file
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#Debug( exe_name ) " <<<
    if glob(a:exe_name) == ''
        call exUtility#WarningMsg('file: ' . a:exe_name . ' not found')
    else
        " TODO: call exUtility#Terminal ( 'remain', 'wait', 'insight ' . a:exe_name ) " right now can't use this...
        silent exec '!start insight ' . a:exe_name
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: type: ID,symbol,tag,none=all
" ------------------------------------------------------------------ 

function exUtility#UpdateVimFiles( type ) " <<<
    " find quick gen script first
    let suffix = '\(bat\|sh\)'
    if has ("win32")
        let suffix = 'bat'
    elseif has ("unix")
        let suffix = 'sh'
    endif

    " ======================================================== 
    " create id-lang map and quick_gen_project script 
    " ======================================================== 

    call exUtility#CreateIDLangMap( s:ex_project_file_filter )

    " ======================================================== 
    " create quick_gen_project_NAME_autogen.sh/bat
    " ======================================================== 

    let quick_gen_script = exUtility#CreateQuickGenProject()

    " ======================================================== 
    " rule: if we have quick_gen_project_NAME_custom.sh/bat, use it first, else we use auto-gen one
    " ======================================================== 

    let vimentry_name = ''
    if exists('g:exES_VimEntryName')
        let vimentry_name = '_' . g:exES_VimEntryName
    endif
    let quick_gen_custom = 'quick_gen_project' . vimentry_name . '_custom.' . suffix
    if findfile( quick_gen_custom, escape(g:exES_CWD,' \') ) != ""
        let quick_gen_script = quick_gen_custom
    endif

    " ======================================================== 
    " check if we have quick_gen_script, if not, return
    " ======================================================== 

    if quick_gen_script != ''
        silent exec "cscope kill " . g:exES_Cscope
        " we use async update
        " silent exec "cscope add " . g:exES_Cscope
    else
        call exUtility#WarningMsg("quick_gen_project script not found")
        return
    endif

    " ======================================================== 
    " create update cmd
    " ======================================================== 

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
    elseif a:type == "filenamelist"
        let gen_type = ' filenamelist'
    else
        call exUtility#WarningMsg("do not found update-type: " . a:type )
        return
    endif

    " ======================================================== 
    " add quick_gen_project script command
    " ======================================================== 

    let update_cmd = quick_gen_script . gen_type . ' ' . g:exES_vimfiles_dirname

    " ======================================================== 
    " add vimentry references command
    " ======================================================== 

    let refs_update_cmd = exUtility#GetUpdateVimentryRefsCommand (a:type) 
    if refs_update_cmd != ''
        let update_cmd .= refs_update_cmd
    endif

    " ======================================================== 
    " prompt terminal, run the shell programme we gen.
    " ======================================================== 

    call exUtility#Terminal ( 'prompt', 'nowait', update_cmd )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: get reference vimentry update command
" ------------------------------------------------------------------ 

function exUtility#GetUpdateVimentryRefsCommand( type ) " <<<
    let cmd = ''

    if !empty(g:exES_vimentryRefs)
        if has ('win32')
            let cmd .= ' & echo.'
            let cmd .= ' & echo Update vimentry references...'

            let destSymbol = '"' . exUtility#Pathfmt(exUtility#GetVimFile ( g:exES_CWD, g:exES_vimfiles_dirname, 'symbol'),'windows') . '"'
            let destInherit = '"' . exUtility#Pathfmt(exUtility#GetVimFile ( g:exES_CWD, g:exES_vimfiles_dirname, 'inherits'),'windows') . '"'

            let symbolFiles = destSymbol
            let inheritFiles = destInherit

            " get process files
            for vimentry in g:exES_vimentryRefs
                let ref_entry_dir = fnamemodify( vimentry, ':p:h')
                let ref_vimfiles_dirname = '.vimfiles.' . fnamemodify( vimentry, ":t:r" )
                let symbolFiles .= '+' . '"' . exUtility#Pathfmt(exUtility#GetVimFile ( ref_entry_dir, ref_vimfiles_dirname, 'symbol'),'windows') . '"'
                let inheritFiles .= '+' . '"' . exUtility#Pathfmt(exUtility#GetVimFile ( ref_entry_dir, ref_vimfiles_dirname, 'inherits'),'windows') . '"'
            endfor

            " get symbol cmd
            if a:type == "" || a:type == "symbol"
                let tmpSymbol = '"' . exUtility#Pathfmt( './'.g:exES_vimfiles_dirname.'/_symbol', 'windows' ) . '"'
                let tmp_cmd = ' copy ' . symbolFiles . ' ' . tmpSymbol
                let tmp_cmd .= ' & sort ' . tmpSymbol . ' /O ' . tmpSymbol
                let tmp_cmd .= ' & move /Y ' . tmpSymbol . ' ' . destSymbol

                let cmd .= ' & echo merge Symbols...'
                let cmd .= ' & ' . tmp_cmd
            endif

            " get inherit cmd
            if a:type == "" || a:type == "inherit"
                let tmpInherit = '"' . exUtility#Pathfmt( './'.g:exES_vimfiles_dirname.'/_inherits', 'windows' ) . '"'
                let tmp_cmd = ' copy ' . inheritFiles . ' ' . tmpInherit
                let tmp_cmd .= ' & move /Y ' . tmpInherit . ' ' . destInherit

                let cmd .= ' & echo merge Inherits...'
                let cmd .= ' & ' . tmp_cmd
            endif
        elseif has ('unix')
            let cmd .= ' && echo'
            let cmd .= ' && echo Update vimentry references...'

            let destSymbol = '"' . exUtility#Pathfmt(exUtility#GetVimFile ( g:exES_CWD, g:exES_vimfiles_dirname, 'symbol'),'unix') . '"'
            let destInherit = '"' . exUtility#Pathfmt(exUtility#GetVimFile ( g:exES_CWD, g:exES_vimfiles_dirname, 'inherits'),'unix') . '"'

            let symbolFiles = destSymbol
            let inheritFiles = destInherit

            " get process files
            for vimentry in g:exES_vimentryRefs
                let ref_entry_dir = fnamemodify( vimentry, ':p:h')
                let ref_vimfiles_dirname = '.vimfiles.' . fnamemodify( vimentry, ":t:r" )
                let symbolFiles .= ' ' . '"' . exUtility#Pathfmt(exUtility#GetVimFile ( ref_entry_dir, ref_vimfiles_dirname, 'symbol'),'unix') . '"'
                let inheritFiles .= ' ' . '"' . exUtility#Pathfmt(exUtility#GetVimFile ( ref_entry_dir, ref_vimfiles_dirname, 'inherits'),'unix') . '"'
            endfor

            " get symbol cmd
            if a:type == "" || a:type == "symbol"
                let tmpSymbol = '"' . exUtility#Pathfmt( './'.g:exES_vimfiles_dirname.'/_symbol', 'unix' ) . '"'
                let tmp_cmd = ' cat ' . symbolFiles . ' > ' . tmpSymbol
                let tmp_cmd .= ' && sort ' . tmpSymbol . ' -o ' . tmpSymbol
                let tmp_cmd .= ' && mv -f ' . tmpSymbol . ' ' . destSymbol

                let cmd .= ' && echo merge Symbols...'
                let cmd .= ' && ' . tmp_cmd
            endif

            " get inherit cmd
            if a:type == "" || a:type == "inherit"
                let tmpInherit = '"' . exUtility#Pathfmt( './'.g:exES_vimfiles_dirname.'/_inherits', 'unix' ) . '"'
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

function exUtility#CopyQuickGenProject() " <<<
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
    let quick_gen_script = 'quick_gen_project_custom.' . script_suffix

    " get quick gen script from repository
    let full_quick_gen_script = fnamemodify( g:ex_toolkit_path . '/' . folder_name . '/' . quick_gen_script, ":p" )

    if findfile( full_quick_gen_script ) == ""
        call exUtility#WarningMsg('Error: file ' . full_quick_gen_script . ' not found')
    else
        let cmd = copy_cmd . ' ' . '"'.full_quick_gen_script.'"' . ' ' . quick_gen_script 
        exec 'silent !' . cmd
        echo 'file copied: ' . quick_gen_script
    endif

    "
    return quick_gen_script
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#ResetLangMap( langmap_type, lang_type, file_type_list ) " <<<
    let s:ex_{a:langmap_type}_lang_map[a:lang_type] = a:file_type_list
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#AddLangMap( langmap_type, lang_type, file_type_list ) " <<<
    " we there have the lang_type, just add those new file types 
    if has_key (s:ex_{a:langmap_type}_lang_map, a:lang_type)
        for new_file_type in a:file_type_list
            if index ( s:ex_{a:langmap_type}_lang_map[a:lang_type], new_file_type ) == -1
                silent call add ( s:ex_{a:langmap_type}_lang_map[a:lang_type], new_file_type )
            endif
        endfor
    else
        let s:ex_{a:langmap_type}_lang_map[a:lang_type] = a:file_type_list
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetLangType() " <<<
    if exists('g:exES_LangType')
        let lang_list = []
        if g:exES_LangType == 'auto' " if user don't specific language type, use filter as language type.
            " get filter_list and walk through it
            let filter_list = split( s:ex_project_file_filter, ',' )
            for filter in filter_list 
                " walk through the language map to get language type and its file type list
                for [lang_type,file_type_list] in items (s:ex_exvim_lang_map)
                    " check if the filter is in the file_type_list of the language
                    if index ( file_type_list, filter ) != -1
                        " add the language type to language list if not exists
                        if index ( lang_list, lang_type ) == -1
                            silent call add ( lang_list, lang_type )
                        endif
                    endif
                endfor
            endfor
        else
            let lang_list = split( g:exES_LangType, ',' )
        endif

        " return lang list
        if empty(lang_list)
            return "unknown"
        else
            let lang_text = ''
            for item in lang_list
                let lang_text = lang_text . ' ' . item
            endfor
            let idx = match( lang_text, '\S' )
            return strpart (lang_text, idx)
        endif
    else
        return "unknown"
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetQuickGenSupportMap( lang_type ) " <<<
    let support_map = {'ctags':'false', 'symbol':'false', 'inherit':'false', 'cscope':'false', 'idutils':'false', 'filenamelist':'false'}
    let lang_list = split( a:lang_type, ' ' )

    " check plugin level support
    if exists('g:loaded_extagselect') && g:loaded_extagselect && g:ex_ctags_cmd != ''
        let support_map['ctags'] = 'true'
    endif
    if exists('g:loaded_exsymboltable') && g:loaded_exsymboltable 
        let support_map['symbol'] = 'true'
    endif
    if exists('g:loaded_exutility_auto') && g:loaded_exutility_auto 
        let support_map['inherit'] = 'true'
    endif
    if exists('g:loaded_excscope') && g:loaded_excscope 
        let support_map['cscope'] = 'true'
    endif
    if exists('g:loaded_exglobalsearch') && g:loaded_exglobalsearch 
        let support_map['idutils'] = 'true'
    endif
    let support_map['filenamelist'] = 'true'

    " check language level support

    " check ctags support
    let found_lang = 0
    if support_map['ctags'] == 'true'
        " search a:lang_type in ctags_lang_map
        for item in lang_list
            if has_key( s:ex_ctags_lang_map, item )
                let found_lang = 1
                break
            endif
        endfor

        " if we don't found the language, set it to false
        if found_lang == 0
            let support_map['ctags'] = 'false'
        endif
    endif

    " check symbol support
    if support_map['ctags'] == 'false' || support_map['symbol'] == 'false'
        let support_map['symbol'] = 'false'
    endif

    " check inherit support
    if support_map['ctags'] == 'false' || support_map['inherit'] == 'false'
        let support_map['inherit'] = 'false'
    else
        if a:lang_type !~# '\<c\>\|\<cpp\>\|\<c\>#\|\<python\>\|\<javascript\>\|\<java\>\|\<uc\>'
            let support_map['inherit'] = 'false'
        endif
    endif

    " check cscope support
    let found_lang = 0
    if support_map['cscope'] == 'true'
        " search a:lang_type in ctags_lang_map
        for item in lang_list
            if index ( g:ex_cscope_langs, item ) >= 0
                let found_lang = 1
                break
            endif
        endfor

        " if we don't found the language, set it to false
        if found_lang == 0
            let support_map['cscope'] = 'false'
        endif
    endif

    " check filenamelist support
    if exists( 'g:exES_LookupFileTag' )
        let support_map['filenamelist'] = 'true'
    else
        if support_map['ctags'] == 'false' && support_map['cscope'] == 'false'
            let support_map['filenamelist'] = 'false'
        endif
    endif

    " check global support
    " nothing to check

    return support_map
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetCtagsOptions( lang_type ) " <<<
    let ctags_kinds=''
    let ctags_fields='--fields=+iaS'
    let ctags_extra='--extra=+q'
    let ctags_languages='--languages='
    let ctags_langmap='--langmap='

    " process language list
    let lang_list = split( a:lang_type, ' ' )

    " first check kinds for each language
    if a:lang_type =~# '\<c\>\|\<shader\>'
        let ctags_kinds.=' --c-kinds=+p'
    endif
    if a:lang_type =~# '\<cpp\>'
        let ctags_kinds.=' --c++-kinds=+p'
    endif

    " process general language options
    for lang_type in lang_list
        if has_key ( s:ex_ctags_lang_map, lang_type ) && has_key ( s:ex_exvim_lang_map, lang_type )
            " convert language type first
            let ctags_lang_type = lang_type
            if lang_type ==# 'cpp'
                let ctags_lang_type = 'c++'
            endif

            " add languages type.
            let ctags_languages.=ctags_lang_type.','

            " add langmap
            for file_type in s:ex_exvim_lang_map[lang_type]
                if index ( s:ex_ctags_lang_map[lang_type], file_type ) == -1
                    let ctags_langmap.=ctags_lang_type.':+.'.file_type.','
                endif
            endfor
        endif
    endfor

    " process special language options
    if index ( lang_list, 'shader' ) >= 0
        let ctags_languages.='c,'
        if has_key (s:ex_exvim_lang_map, 'shader')
            for file_type in s:ex_exvim_lang_map['shader'] 
                let ctags_langmap.='c:+.'.file_type.',' 
            endfor
        endif
    endif

    " return ctags_options
    let ctags_options = ctags_kinds.' '.ctags_fields.' '.ctags_extra.' '.ctags_languages.' '.ctags_langmap
    return ctags_options 
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CreateIDLangMap( file_filter ) " <<<
    if exists('g:exES_vimfiles_dirname')
        let idlang_map_file = './'.g:exES_vimfiles_dirname.'/id-lang-autogen.map'
        if finddir( './'.g:exES_vimfiles_dirname ) == ""
            call exUtility#WarningMsg('Error: ' . './'.g:exES_vimfiles_dirname . ' not found!')
            return 
        endif

        let text_list = []
        silent call add ( text_list, '# autogen id-lang.map')
        silent call add ( text_list, '# NOTE: this file is created automatically after you create/refresh exProject.')
        silent call add ( text_list, '# CAUTION: you may loose your modification in this file, if you want customize your language map,')
        silent call add ( text_list, '#          please create your own language map file under ./.vimfiles*, and change the file name as id-lang.map')
        silent call add ( text_list, '*~                    IGNORE')
        silent call add ( text_list, '*.bak                 IGNORE')
        silent call add ( text_list, '*.bk[0-9]             IGNORE')
        silent call add ( text_list, '[sp].*                IGNORE')
        silent call add ( text_list, '*/.deps/*             IGNORE')
        silent call add ( text_list, '*/.svn/*              IGNORE')
        silent call add ( text_list, '*.svn-base            IGNORE')
        silent call add ( text_list, '.vimfiles*/*          IGNORE')
        silent call add ( text_list, 'quick_gen_project_*.* IGNORE')
        silent call add ( text_list, '*.err                 IGNORE') " never bring error file into global search
        silent call add ( text_list, '*.exe                 IGNORE') " never bring exe file into global search
        silent call add ( text_list, '*.lnk                 IGNORE') " never bring lnk file into global search

        let filter_list = split(a:file_filter,',')
        for item in filter_list 
            if item == ''
                continue
            endif
            silent call add ( text_list, '*.'.item.'    text')
        endfor

        call writefile( text_list, idlang_map_file, "b" )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CreateQuickGenProject() " <<<
    " init variables
    let text_list = []
    let lang_type = exUtility#GetLangType()
    let support_map = exUtility#GetQuickGenSupportMap(lang_type) 
    let ctags_options = exUtility#GetCtagsOptions(lang_type) 
    let file_filter_list = exUtility#GetProjectFileFilterCommand() " NOTE: 0: file_filter, 1: cscope_file_filter
    let file_filter_pattern_list = exUtility#GetProjectFileFilterPattern() " NOTE: 0: file_filter_pattern, 1: cscope_file_filter_pattern
    let script_suffix = ''

    " init platform dependence value and write script
    if has ('win32')
        let script_suffix = 'bat'
        let fmt_toolkit_path = exUtility#Pathfmt( g:ex_toolkit_path, 'windows')

        silent call add( text_list, '@echo off' )
        silent call add( text_list, 'set script_type=autogen' )
        silent call add( text_list, 'set cwd=%~pd0' )
        silent call add( text_list, 'set toolkit_path='.fmt_toolkit_path )
        silent call add( text_list, 'set lang_type='.lang_type ) " 
        silent call add( text_list, 'set vimfiles_path='.g:exES_vimfiles_dirname )
        silent call add( text_list, 'set file_filter='.file_filter_list[0] )
        silent call add( text_list, 'set file_filter_pattern='.'"'.file_filter_pattern_list[0].'"' )
        silent call add( text_list, 'set cscope_file_filter='.file_filter_list[1] )
        silent call add( text_list, 'set cscope_file_filter_pattern='.'"'.file_filter_pattern_list[1].'"' )
        silent call add( text_list, 'set dir_filter='.exUtility#GetProjectDirFilterCommand() )
        silent call add( text_list, 'set support_filenamelist='.support_map['filenamelist'] )
        silent call add( text_list, 'set support_ctags='.support_map['ctags'] )
        silent call add( text_list, 'set support_symbol='.support_map['symbol'] )
        silent call add( text_list, 'set support_inherit='.support_map['inherit'] )
        silent call add( text_list, 'set support_cscope='.support_map['cscope'] )
        silent call add( text_list, 'set support_idutils='.support_map['idutils'] )
        silent call add( text_list, 'set ctags_cmd='.g:ex_ctags_cmd )
        silent call add( text_list, 'set ctags_options='.ctags_options )
        silent call add( text_list, 'if exist .\%vimfiles_path%\quick_gen_project_pre_custom.bat (' )
        silent call add( text_list, '    call .\%vimfiles_path%\quick_gen_project_pre_custom.bat' )
        silent call add( text_list, ')' )
        silent call add( text_list, 'call "%toolkit_path%\quickgen\batch\quick_gen_project.bat" %1' )
        silent call add( text_list, 'if exist .\%vimfiles_path%\quick_gen_project_post_custom.bat (' )
        silent call add( text_list, '    call .\%vimfiles_path%\quick_gen_project_post_custom.bat' )
        silent call add( text_list, ')' )
        silent call add( text_list, 'echo on' )
    elseif has ('unix')
        let script_suffix = 'sh'
        let fmt_toolkit_path = exUtility#Pathfmt( g:ex_toolkit_path, 'unix')

        silent call add( text_list, '#!/bin/sh' )
        silent call add( text_list, 'export script_type="autogen"' )
        silent call add( text_list, 'export EX_DEV='.'"'.$EX_DEV.'"' )
        silent call add( text_list, 'export cwd=${PWD}' ) " 
        silent call add( text_list, 'export toolkit_path='.fmt_toolkit_path )
        silent call add( text_list, 'export lang_type='.'"'.lang_type.'"' ) " 
        silent call add( text_list, 'export vimfiles_path='.'"'.g:exES_vimfiles_dirname.'"' )
        silent call add( text_list, 'export file_filter='.'"'.file_filter_list[0].'"' )
        silent call add( text_list, 'export file_filter_pattern='."'".file_filter_pattern_list[0]."'" )
        silent call add( text_list, 'export cscope_file_filter='.'"'.file_filter_list[1].'"' )
        silent call add( text_list, 'export cscope_file_filter_pattern='."'".file_filter_pattern_list[1]."'" )
        silent call add( text_list, 'export dir_filter='.'"'.exUtility#GetProjectDirFilterCommand().'"' )
        silent call add( text_list, 'export support_filenamelist='.'"'.support_map['filenamelist'].'"' )
        silent call add( text_list, 'export support_ctags='.'"'.support_map['ctags'].'"' )
        silent call add( text_list, 'export support_symbol='.'"'.support_map['symbol'].'"' )
        silent call add( text_list, 'export support_inherit='.'"'.support_map['inherit'].'"' )
        silent call add( text_list, 'export support_cscope='.'"'.support_map['cscope'].'"' )
        silent call add( text_list, 'export support_idutils='.'"'.support_map['idutils'].'"' )
        silent call add( text_list, 'export ctags_cmd='.'"'.g:ex_ctags_cmd.'"' )
        silent call add( text_list, 'export ctags_options='.'"'.ctags_options.'"' )
        silent call add( text_list, 'if [ -f "./${vimfiles_path}/quick_gen_project_pre_custom.sh" ]; then' )
        silent call add( text_list, '    sh ./${vimfiles_path}/quick_gen_project_pre_custom.sh' )
        silent call add( text_list, 'fi' )
        silent call add( text_list, 'sh ${toolkit_path}/quickgen/bash/quick_gen_project.sh $1' )
        silent call add( text_list, 'if [ -f "./${vimfiles_path}/quick_gen_project_post_custom.sh" ]; then' )
        silent call add( text_list, '    sh ./${vimfiles_path}/quick_gen_project_post_custom.sh' )
        silent call add( text_list, 'fi' )
    endif

    " save to quick_gen_project_NAME_autogen.bat/sh
    let vimentry_name = ''
    if exists('g:exES_VimEntryName')
        let vimentry_name = '_' . g:exES_VimEntryName
    endif
    let file_name = 'quick_gen_project' . vimentry_name . '_autogen.' . script_suffix
    call writefile ( text_list, file_name )

    " write pre and post file
    let quick_gen_custom_pre = g:exES_vimfiles_dirname . '/quick_gen_project_pre_custom.' . script_suffix
    let quick_gen_custom_post = g:exES_vimfiles_dirname . '/quick_gen_project_post_custom.' . script_suffix
    if findfile( quick_gen_custom_pre, escape(g:exES_CWD,' \') ) == ""
        call writefile ( [], quick_gen_custom_pre )
    endif
    if findfile( quick_gen_custom_post, escape(g:exES_CWD,' \') ) == ""
        call writefile ( [], quick_gen_custom_post )
    endif

    " 
    return file_name
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  Hightlight functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: hightlight confirm line
" ------------------------------------------------------------------ 

function exUtility#HighlightConfirmLine() " <<<
    " Clear previously selected name
    match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe 'match ex_SynConfirmLine ' . pat
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: hightlight select line
" ------------------------------------------------------------------ 

function exUtility#HighlightSelectLine() " <<<
    " Clear previously selected name
    2match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe '2match ex_SynSelectLine ' . pat
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: hightlight object line
" ------------------------------------------------------------------ 

function exUtility#HighlightObjectLine() " <<<
    " Clear previously selected name
    3match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe '3match ex_SynObjectLine ' . pat
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: clear the confirm line hight light
" ------------------------------------------------------------------ 

function exUtility#ClearConfirmHighlight() " <<<
    " Clear previously selected name
    match none
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: clear the object line hight light
" ------------------------------------------------------------------ 

function exUtility#ClearObjectHighlight() " <<<
    " Clear previously selected name
    3match none
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#Highlight_Temp() " <<<
    if strpart( getline('.'), col('.')-1, 1 ) !~ '[a-zA-Z]'
        return
    endif

    call exUtility#DefineMatchVariables() 

    let hl_word = expand('<cword>')
    let hl_pattern = '\<\C'.hl_word.'\>'
    if hl_pattern !=# w:ex_HighLightTextTemp
        let w:ex_hlMatchIDTemp = matchadd( 'ex_SynHLTemp', hl_pattern, 0 )
        let w:ex_HighLightTextTemp = hl_pattern
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#Highlight_TempCursorMoved () " <<<
    call exUtility#DefineMatchVariables() 
    let hl_word = expand('<cword>')
    let hl_pattern = '\<\C'.hl_word.'\>'
    if w:ex_HighLightTextTemp != '' && ( hl_pattern !=# w:ex_HighLightTextTemp || strpart( getline('.'), col('.')-1, 1 ) !~ '[a-zA-Z]' )
        silent call matchdelete(w:ex_hlMatchIDTemp)
        let w:ex_hlMatchIDTemp = 0
        let w:ex_HighLightTextTemp = ''
    endif
endfunction " >>>


" ------------------------------------------------------------------ 
" Desc: hightlight match_nr
" NOTE: the 1,2,3,4 correspond to reg q,w,e,r
" ------------------------------------------------------------------ 

function exUtility#Highlight_Normal(match_nr) " <<<
    " get word under cursor
    let hl_word = expand('<cword>')
    let hl_pattern = '\<\C'.hl_word.'\>'
    call exUtility#Highlight_Text( a:match_nr, hl_pattern )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: hightlight match_nr with text
" NOTE: the 1,3 will save word to register as \<word\>, the 2,4 will save word to register as word
" ------------------------------------------------------------------ 

function exUtility#Highlight_Text(match_nr, args) " <<<
    " if no argument comming, cancle hihglight return
    if a:args == ''
        call exUtility#HighlightCancle(a:match_nr)
        return
    endif

    " if we don't have upper case character, ignore case
    let pattern = a:args
    if match( a:args, '\u' ) == -1
        let pattern = '\c' . pattern
    endif

    " start match
    call exUtility#DefineMatchVariables() 
    if pattern ==# w:ex_HighLightText[a:match_nr]
        call exUtility#HighlightCancle(a:match_nr)
    else
        call exUtility#HighlightCancle(a:match_nr)
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

function exUtility#Highlight_Visual(match_nr) range " <<<
    call exUtility#DefineMatchVariables() 

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
    call exUtility#Highlight_Text( a:match_nr, pat )
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Cancle highlight
" ------------------------------------------------------------------ 

function exUtility#HighlightCancle(match_nr) " <<<
    call exUtility#DefineMatchVariables() 
    if a:match_nr == 0
        call exUtility#MatchDelete(1)
        call exUtility#MatchDelete(2)
        call exUtility#MatchDelete(3)
        call exUtility#MatchDelete(4)
    else
        call exUtility#MatchDelete(a:match_nr)
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#DefineMatchVariables() " <<<
    if !exists('w:ex_hlMatchID')
        let w:ex_hlMatchID = [0,0,0,0,0]
    endif
    if !exists('w:ex_HighLightText')
        let w:ex_HighLightText = ["","","","",""]
    endif
    if g:ex_auto_hl_cursor_word
        if !exists('w:ex_hlMatchIDTemp')
            let w:ex_hlMatchIDTemp = 0
        endif
        if !exists('w:ex_HighLightTextTemp')
            let w:ex_HighLightTextTemp = ""
        endif
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#MatchDelete(match_nr) " <<<
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

function exUtility#SrcHighlight( line1, line2 ) " <<<
    " 
    let first_line = a:line1
    let last_line = a:line2

    " process src-highlight
    if exists("g:exES_CWD")
        let temp_directory_path = g:exES_CWD.'/'.g:exES_vimfiles_dirname.'/.temp' 
        let temp_file = temp_directory_path.'/'.'_src_highlight.txt' 
        let temp_file_html = temp_file . '.html' 
    else
        let temp_directory_path = './.temp' 

        " create .temp directory if not found
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
    let share_path = g:ex_toolkit_path . '\src-highlight\data'
    let shl_cmd = 'source-highlight -f html -s ex_cpp -n --data-dir='.share_path . ' -i ' . temp_file . ' -o ' . temp_file_html

    let shl_result = system(shl_cmd)

    " TODO: use if win32, if linux
    let win_file = exUtility#Pathfmt( temp_file_html, 'windows')

    " try to open the file by web browser
    if findfile ( g:exES_WebBrowser ) != ''
        silent exec '!start ' . g:exES_WebBrowser . ' ' . win_file
    else
        call exUtility#WarningMsg ("Can't not find web-browser: ".g:exES_WebBrowser . " defined by g:exES_WebBrowser")
        return
    endif

    " go back to start line
    silent exec ":" . first_line
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  Inherits functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GenInheritsDot( pattern, gen_method ) " <<<
    " find inherits file
    if exists( g:exES_Inherits )
        let inherits_file = g:exES_Inherits
    else
        let inherits_file = './'.g:exES_vimfiles_dirname.'/inherits'
    endif

    if findfile ( inherits_file ) == ''
        call exUtility#WarningMsg ('the project not support inherits.')
        return ""
    endif

    echomsg "generating inherits: " . a:pattern

    " create inherit dot file path
    let inherit_directory_path = g:exES_CWD.'/'.g:exES_vimfiles_dirname.'/.hierarchies/' 
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
        let inherits_list += exUtility#RecursiveGetParent( parent_inherits_list, file_list )
        let inherits_list += exUtility#RecursiveGetChildren( children_inherits_list, file_list )
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
            let inherits_list += exUtility#RecursiveGetParent( inherits_list, file_list )
        elseif a:gen_method == "children"
            let inherits_list += exUtility#RecursiveGetChildren( inherits_list, file_list )
        endif
    endif

    " add dot gamma
    let inherits_list = ["digraph INHERITS {", "rankdir=LR;"] + inherits_list
    let inherits_list += ["}"]
    unlet s:pattern_list

    " write file
    call writefile(inherits_list, inherits_dot_file, "b")
    let image_file_name = inherit_directory_path . pattern_fname . ".png"
    let dot_cmd = "!dot " . '"'.inherits_dot_file.'"' . " -Tpng -o" . '"'.image_file_name.'"'
    silent exec dot_cmd
    if has("win32")
        return exUtility#Pathfmt( fnamemodify( image_file_name, ":p" ), 'windows' )
    else
        return fnamemodify( image_file_name, ":p" )
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#ViewInheritsImage() " <<<
    let inherit_class_name = expand("<cword>")
    let inherit_class_name = "\\<" . inherit_class_name . "\\>"

    " check if we create image
    let file_name = exUtility#GenInheritsDot(inherit_class_name,"all")
    if file_name == ""
        return
    endif

    " try to open the file by image viewer
    if findfile ( g:exES_ImageViewer ) != ''
        silent exec '!start ' . g:exES_ImageViewer ' ' . file_name
    else
        call exUtility#WarningMsg ("Can't not find image viewer: ".g:exES_ImageViewer . " defined by g:exES_ImageViewer")
        return
    endif

endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#RecursiveGetChildren(inherits_list, file_list) " <<<
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
        let result_list += exUtility#RecursiveGetChildren( children_list, a:file_list ) 
    endfor
    return result_list
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#RecursiveGetParent(inherits_list, file_list) " <<<
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
        let result_list += exUtility#RecursiveGetParent( parent_list, a:file_list ) 
    endfor
    return result_list
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" environment functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#EditVimEntry() " <<<
    if exists( 'g:exES_VimEntryName' ) && exists( 'g:exES_CWD' ) && findfile ( g:exES_VimEntryName.'.vimentry', escape(g:exES_CWD,' \') ) != ""
        let vimentry_file = g:exES_VimEntryName . '.vimentry'
        echon 'edit vimentry file: ' . vimentry_file . "\r"
        call exUtility#GotoEditBuffer ()
        silent exec 'e ' . g:exES_CWD . '/' . vimentry_file
    else
        call exUtility#WarningMsg ("can't find current vimentry file")
    endif
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" command custom complete functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CompleteBySymbolFile( arg_lead, cmd_line, cursor_pos ) " <<<
    let filter_tag = []
    if exists ('g:exES_Symbol')
        let tags = readfile( g:exES_Symbol )

        for tag in tags
            if exUtility#SmartCaseCompare ( tag, '^'.a:arg_lead.'.*' )
                silent call add ( filter_tag, tag )
            endif
        endfor
    endif
    return filter_tag
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#GetFileName( text ) " <<<
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
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CompleteByProjectFile( arg_lead, cmd_line, cursor_pos ) " <<<
    let filter_files = []
    if exists ('g:exES_Project')
        let project_files = readfile(g:exES_Project)
        for file_line in project_files
            let file_name = exUtility#GetFileName (file_line)
            if exUtility#SmartCaseCompare( file_name, '^'.a:arg_lead.'.*' )
                silent call add ( filter_files, file_name )
            endif
        endfor
    endif
    return filter_files
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" TODO: can combine args with file,directory search
" ------------------------------------------------------------------ 

function exUtility#CompleteGMakeArgs( arg_lead, cmd_line, cursor_pos ) " <<<
    let idx = strridx(a:arg_lead,'/')+1
    let arg_lead_prefix = strpart(a:arg_lead, 0, idx )
    let arg_lead_suffix = strpart(a:arg_lead, idx )

    let args = ["all","rebuild","rebuild-deps","rebuild-gchs","rebuild-objs","rebuild-target","clean-all","clean-deps","clean-errs","clean-gchs","clean-objs","clean-target"]
    let filter_result = []
    for arg in args
        if exUtility#SmartCaseCompare( arg, '^'.arg_lead_suffix.'.*' )
            silent call add ( filter_result, arg_lead_prefix . arg )
        endif
    endfor
    return filter_result
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CompleteVMakeArgs( arg_lead, cmd_line, cursor_pos ) " <<<
    let args = ["all","rebuild","clean-all"]
    let filter_result = []
    for arg in args
        if exUtility#SmartCaseCompare( arg, '^'.a:arg_lead.'.*' )
            silent call add ( filter_result, arg )
        endif
    endfor
    return filter_result
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CompleteUpdateArgs( arg_lead, cmd_line, cursor_pos ) " <<<
    let args = ["ID","symbol","inherit","tag","cscope","filenamelist"]
    let filter_result = []
    for arg in args
        if exUtility#SmartCaseCompare( arg, '^'.a:arg_lead.'.*' )
            silent call add ( filter_result, arg )
        endif
    endfor
    return filter_result
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CompleteMKArgs( arg_lead, cmd_line, cursor_pos ) " <<<
    let args = split( g:ex_todo_keyword, ' ' )
    silent call extend (args, split( g:ex_comment_lable_keyword, ' ' ) )

    let filter_result = []
    for arg in args
        if exUtility#SmartCaseCompare( arg, '^'.a:arg_lead.'.*' )
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

function exUtility#WarningMsg(msg) " <<<
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

function exUtility#VisualPasteFixed() " <<<
    silent call getreg('*')
    " silent normal! gvpgvy " <-- this let you be the win32 copy/paste style
    silent normal! gvp
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" plugin helper functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CreateVimwikiFiles() " <<<
    " create wiki html header
    if exists( 'g:exES_wikiHtmlHeader' )

        " if we don't exist g:exES_wikiHome directory, don't create default header template 
        if finddir( fnamemodify(g:exES_wikiHome,':p') ) != ''

            " write default header if not found one.
            let html_header_file = fnamemodify(g:exES_wikiHtmlHeader,':p') 
            if findfile( html_header_file, '.;' ) == "" || empty( readfile(html_header_file) )
                "
                let text_list = []
                " add title and charset
                silent call add ( text_list, "<html>" )
                silent call add ( text_list, "<head>" )
                silent call add ( text_list, "\t<link rel=\"Stylesheet\" type=\"text/css\" href=\"%root_path%style.css\" />" )
                silent call add ( text_list, "\t<title>%title%</title>" )
                silent call add ( text_list, "\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=".&encoding."\" />" )

                " add syntax highlighter js
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shCore.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushAS3.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushBash.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushColdFusion.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushCpp.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushCSharp.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushCss.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushDelphi.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushDiff.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushErlang.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushGroovy.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushJava.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushJavaFX.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushJScript.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushPhp.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushPlain.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushPowerShell.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushPython.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushRuby.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushScala.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushSql.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushVb.js\"></script>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\" src=\"%root_path%/syntax_highlighter/scripts/shBrushXml.js\"></script>" )
	            silent call add ( text_list, "\t<link type=\"text/css\" rel=\"stylesheet\" href=\"%root_path%/syntax_highlighter/styles/shCore.css\"/>" )
	            silent call add ( text_list, "\t<link type=\"text/css\" rel=\"stylesheet\" href=\"%root_path%/syntax_highlighter/styles/shThemeEX.css\"/>" )
	            silent call add ( text_list, "\t<script type=\"text/javascript\">" )
	            silent call add ( text_list, "\t\tSyntaxHighlighter.config.clipboardSwf = \"%root_path%/syntax_highlighter/scripts/clipboard.swf\";" )
	            silent call add ( text_list, "\t\tSyntaxHighlighter.all();" )
	            silent call add ( text_list, "\t</script>" )

                " end header
                silent call add ( text_list, "</head>" )
                silent call add ( text_list, "<body>" )
                silent call add ( text_list, "<div class=\"contents\">" )

                " create dir before write, if not exist
                if finddir( fnamemodify(g:exES_wikiHtmlHeader,':p:h') ) == ''
                    silent call mkdir( fnamemodify(g:exES_wikiHtmlHeader,':p:h') )
                endif

                " finally write file
                call writefile ( text_list, html_header_file )
            endif
        endif
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#SaveAndConvertVimwiki( save_all ) " <<<
    " first check and create vimwiki file if needed.
    call exUtility#CreateVimwikiFiles ()

    " parsing wiki to html
    if a:save_all == 1
        silent exec 'wa' 
        echo 'converting wikies to html...' 
        exec 'VimwikiAll2HTML'
    else
        silent exec 'w'
        echo "converting current buffer to html...\r"
        exec 'Vimwiki2HTML'
        echon "Done!\r"
    endif

    " copy syntax highlighter js files
    if exists ( 'g:exES_wikiHomeHtml' )
        let dest_path = fnamemodify( simplify(g:exES_wikiHomeHtml . '/syntax_highlighter'), ':p' ) 
        " if we don't have ./html/syntax_highlighter, create it, and copy files to it
        if finddir ( dest_path ) == ''
            silent call mkdir( dest_path )
            silent call exUtility#CopySyntaxHighlighterFiles ( dest_path )
        endif
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exUtility#CopySyntaxHighlighterFiles( dest_path ) " <<<
    let full_path = fnamemodify(a:dest_path,':p') 
    " if we don't exist g:exES_wikiHome directory, don't create default header template 
    if finddir( full_path ) != ''
        " init platform dependence value
        let copy_cmd = ''
        if has("win32")
            let copy_cmd = 'xcopy /E /Y'
        elseif has("unix")
            let copy_cmd = 'cp -r'
        endif

        let dest = full_path 
        let src = '' 
        let cmd = ''
        if has("win32")
            let src = fnamemodify( g:ex_toolkit_path . "\\SyntaxHighlighter", ":p")
            let src = exUtility#Pathfmt( src, 'windows')

            " remove last \ if found in src path
            if ( src[strlen(src)-1] == '\' )
                let src = strpart ( src, 0, strlen(src)-1 )
            endif

            " remove last \ if found in dest path
            if ( dest[strlen(dest)-1] == '\' )
                let dest = strpart ( dest, 0, strlen(dest)-1 )
            endif

            let cmd = copy_cmd . ' ' . src . ' ' . dest 
        elseif has("unix")
            let src = fnamemodify( g:ex_toolkit_path . '/SyntaxHighlighter/', ":p")
            let src = exUtility#Pathfmt( src, 'unix')

            " remove last \ if found in dest path
            if ( dest[strlen(dest)-1] == '/' )
                let dest = strpart ( dest, 0, strlen(dest)-1 )
            endif

            let cmd = copy_cmd . ' ' . src . '*' . ' ' . dest 
        endif

        if finddir( src ) == ""
            call exUtility#WarningMsg('Error: toolkit SyntaxHighligter not found, please install it.')
        else
            exec 'silent !' . cmd
            echo 'syntax highligter files copied!'
        endif
    else
        call exUtility#WarningMsg ("Can't find path: " . full_path )
    endif
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
"  Help text functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: Add help Item for current buffer, used in initilization only
" ------------------------------------------------------------------ 

function exUtility#AddHelpItem(HelpText, HelpMode) " <<<
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
" Desc: Add help Item for current buffer, used in initilization only
" ------------------------------------------------------------------ 

function exUtility#DisplayHelp() " <<<
    " If it's not funtional window, do not display help

    if exUtility#IsRegisteredPluginBuffer(bufname('%'))
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
" Desc: Switch between different help text , -1 for toggle between 1 and 0
" ------------------------------------------------------------------ 

function exUtility#SwitchHelpTextMode(HelpMode) " <<<
    " call exUtility#ClearHighlightSelectLine()
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
    call exUtility#DisplayHelp()
    if ResetCursor
        call cursor(s:ex_MapLastCursorLine[BufName],0)
    else
        call cursor(1,0)
    endif
    call exUtility#HelpUpdateCursor()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: if Cursor is on the Help, jump to the first line without help
" ------------------------------------------------------------------ 

function exUtility#HelpUpdateCursor() " <<<
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
" Desc: return the length of HelpText
" ------------------------------------------------------------------ 

function exUtility#GetHelpTextLength() " <<<
    let linenum = 1
    while getline(linenum)[0] == '"'
        let linenum+=1
    endwhile
    return linenum-1
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
