" ======================================================================================
" File         : exUtility.vim
" Author       : Wu Jie 
" Last Change  : 04/28/2009 | 21:18:50 PM | Tuesday,April
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
" Desc: register plugin buffer filetypes, so we can recognize the window as plugin window
" ------------------------------------------------------------------ 

if !exists('g:ex_plugin_registered_filetypes')
    let g:ex_plugin_registered_filetypes = ["ex_plugin","ex_project","taglist","nerdtree"] 
endif

" ------------------------------------------------------------------ 
" Desc: register plugin buffer names, so we can recognize the window as plugin window
" ------------------------------------------------------------------ 

if !exists('g:ex_plugin_registered_bufnames')
    let g:ex_plugin_registered_bufnames = ["-MiniBufExplorer-","__Tag_List__","\[Lookup File\]"] 
endif

" ------------------------------------------------------------------ 
" Desc: turn on/off help text
" ------------------------------------------------------------------ 

if !exists('g:ex_help_text_on')
    let g:ex_help_text_on = 0
endif

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

if !exists('g:ex_auto_hl_cursor_word')
    let g:ex_auto_hl_cursor_word = 0
endif

" ------------------------------------------------------------------ 
" Desc: add todo syntax keyword 
" ------------------------------------------------------------------ 

if !exists('g:ex_todo_keyword')
    let g:ex_todo_keyword = 'NOTE REF EXAMPLE SAMPLE CHECK'
endif

" ------------------------------------------------------------------ 
" Desc: add comment lable keyword
" ------------------------------------------------------------------ 

if !exists('g:ex_comment_lable_keyword')
    let g:ex_comment_lable_keyword = 'DELME TEMP MODIFY ADD KEEPME DISABLE ' " for editing
    let g:ex_comment_lable_keyword .= 'DEBUG CRASH DUMMY UNUSED TESTME ' " for testing 
    let g:ex_comment_lable_keyword .= 'HACK OPTME HARDCODE REFACTORING DUPLICATE REDUNDANCY ' " for refactoring
endif

" ------------------------------------------------------------------ 
" Desc: default supported languages 
" ------------------------------------------------------------------ 

if !exists ( "g:ex_default_langs" )
    let g:ex_default_langs = ['c', 'cpp', 'c#', 'java', 'shader', 'python', 'vim', 'uc', 'math', 'wiki', 'ini', 'make', 'sh', 'batch', 'debug' ] 
endif

" ------------------------------------------------------------------ 
" Desc: cscope supported languages 
" ------------------------------------------------------------------ 

if !exists ( "g:ex_cscope_langs" )
    let g:ex_cscope_langs = ['c', 'cpp', 'shader', 'asm' ] 
endif

" ------------------------------------------------------------------ 
" Desc: ex_dev environment variable 
" NOTE: we don't recommend to set the g:ex_dev_path directly in vim/.vimrc
" ------------------------------------------------------------------ 

if $EX_DEV ==# ""
    if has ("unix")
        call confirm ("exvim error: Please set the EX_DEV in .vimrc, default is let $EX_DEV='~/exdev'")
        let $EX_DEV='~/exdev'
    elseif has("win32")
        call confirm ("exvim error: Please set the EX_DEV in .vimrc, default is let $EX_DEV='d:\exdev'")
        let $EX_DEV='d:\exdev'
    endif
endif

" check if the EX_DEV path exists
if finddir($EX_DEV) == ''
    call exUtility#WarningMsg("the path define in environment variable $EX_DEV doesn't exist, please check your $EX_DEV definition.")
endif

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

if !exists ( "g:ex_toolkit_path" )
    let g:ex_toolkit_path = $EX_DEV.'/tools/exvim/toolkit'
endif

" check if the toolkit path exists
if finddir(g:ex_toolkit_path) == ''
    call exUtility#WarningMsg("the toolkit path doesn't exits, please set a right path to the global variable g:ex_toolkit_path in your .vimrc")
endif

" ------------------------------------------------------------------ 
" Desc: general key mappings 
" ------------------------------------------------------------------ 

" general key mapping: close window
if !exists ( "g:ex_keymap_close" )
    let g:ex_keymap_close = "<esc>"
    if has("gui_running")
        let g:ex_keymap_close = "<esc>"
    else " xterm should not map <esc> key
        if has("unix")
            let g:ex_keymap_close = "<leader><esc>"
        endif
    endif
endif

" general key mapping: resize window
if !exists ( "g:ex_keymap_resize" )
    let g:ex_keymap_resize = "<space>"
endif

" general key mapping: select confirm
if !exists ( "g:ex_keymap_confirm" )
    let g:ex_keymap_confirm = "<enter>"
endif

" ------------------------------------------------------------------ 
" Desc: smart detect ctags
" ------------------------------------------------------------------ 

if !exists('g:ex_ctags_cmd')
    if executable('exuberant-ctags')
        " On Debian Linux, exuberant ctags is installed
        " as exuberant-ctags
        let g:ex_ctags_cmd = 'exuberant-ctags'
    elseif executable('exctags')
        " On Free-BSD, exuberant ctags is installed as exctags
        let g:ex_ctags_cmd = 'exctags'
    elseif executable('ctags')
        let g:ex_ctags_cmd = 'ctags'
    elseif executable('ctags.exe')
        let g:ex_ctags_cmd = 'ctags.exe'
    elseif executable('tags')
        let g:ex_ctags_cmd = 'tags'
    else
        let g:ex_ctags_cmd = ''
    endif
endif

" ======================================================== 
" local variable initialization
" ======================================================== 

" ======================================================== 
" function settings
" ======================================================== 

silent call exUtility#SetProjectFilter ( "file_filter", exUtility#GetFileFilterByLanguage (g:ex_default_langs) )
silent call exUtility#SetProjectFilter ( "dir_filter", "" ) " null-string means include all directories

"/////////////////////////////////////////////////////////////////////////////
" functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: update the syntax highlight in exvim  
" ------------------------------------------------------------------ 

function s:UpdateSyntaxHighlights() " <<<

    " ======================================================== 
    " exUtility
    " ======================================================== 

    hi default ex_SynHL1 gui=none guibg=LightCyan term=none cterm=none ctermbg=LightCyan
    hi default ex_SynHL2 gui=none guibg=LightMagenta term=none cterm=none ctermbg=LightMagenta
    hi default ex_SynHL3 gui=none guibg=LightRed term=none cterm=none ctermbg=LightRed
    hi default ex_SynHL4 gui=none guibg=LightGreen term=none cterm=none ctermbg=LightGreen
    hi default ex_SynHLTemp gui=none guibg=White term=none cterm=none ctermbg=White 

    " hi default ex_SynSelectLine gui=none guibg=#bfffff term=none cterm=none ctermbg=LightCyan
    hi default link ex_SynSelectLine CursorLine  
    hi default ex_SynConfirmLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=DarkYellow
    hi default ex_SynObjectLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=DarkYellow

    hi default link ex_SynError Error
    hi default link ex_SynFold Comment
    hi default link ex_SynFileName Statement
    hi default link ex_SynLineNr LineNr
    hi default link ex_SynNormal Normal

    hi default ex_SynTransparent gui=none guifg=background term=none cterm=none ctermfg=DarkGray
    hi default ex_SynSearchPattern gui=bold guifg=DarkRed guibg=LightGray term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray
    hi default ex_SynTitle term=bold cterm=bold ctermfg=DarkYellow gui=bold guifg=Brown

    hi default exCommentLable term=standout ctermfg=DarkYellow ctermbg=Red gui=none guifg=LightGray guibg=Red
    " hi exCommentLable term=standout ctermfg=DarkYellow ctermbg=Red gui=none guifg=DarkRed guibg=LightMagenta

    " DISABLE: status-line { 
    " hi default ex_SynSLBufNr     cterm=none    ctermfg=black  ctermbg=cyan    gui=none guibg=#840c0c guifg=#ffffff
    " hi default ex_SynSLFlag      cterm=none    ctermfg=black  ctermbg=cyan    gui=none guibg=#bc5b4c guifg=#ffffff
    " hi default ex_SynSLPath      cterm=none    ctermfg=white  ctermbg=green   gui=none guibg=#8d6c47 guifg=black
    " hi default ex_SynSLFileName  cterm=none    ctermfg=white  ctermbg=blue    gui=none guibg=#d59159 guifg=black
    " hi default ex_SynSLFileEnc   cterm=none    ctermfg=white  ctermbg=yellow  gui=none guibg=#ffff77 guifg=black
    " hi default ex_SynSLFileType  cterm=bold    ctermbg=white  ctermfg=black   gui=none guibg=#acff84 guifg=black
    " hi default ex_SynSLTermEnc   cterm=none    ctermbg=white  ctermfg=yellow  gui=none guibg=#77cf77 guifg=black
    " hi default ex_SynSLChar      cterm=none    ctermbg=white  ctermfg=yellow  gui=none guibg=#66b06f guifg=black
    " hi default ex_SynSLSyn       cterm=none    ctermbg=white  ctermfg=yellow  gui=none guibg=#60af9f guifg=black
    " hi default ex_SynSLRealSyn   cterm=none    ctermbg=white  ctermfg=yellow  gui=none guibg=#5881b7 guifg=black
    " hi default ex_SynSLTime      cterm=none    ctermfg=black  ctermbg=cyan    gui=none guibg=#3a406e guifg=#000000
    " hi default ex_SynSLSomething cterm=reverse ctermfg=white  ctermbg=darkred gui=none guibg=#c0c0f0 guifg=black

    " hi StatusLine          cterm=none    ctermbg=white  ctermfg=yellow  gui=none guibg=#3f4d77 guifg=#729eb0 
    " hi StatusLineNC                                                     gui=none guifg=#70a0a0 guibg=#304050  
    " } DISABLE: status-line end 

    " ======================================================== 
    " exEnvironment
    " ======================================================== 

	hi default exES_SynVar gui=none guifg=DarkCyan term=none cterm=none ctermfg=DarkCyan
	hi default exES_SynVal gui=none guifg=Brown term=none cterm=none ctermfg=Brown
	hi default link exES_SynOperator Normal
	hi default link exES_SynComment Comment
    " KEEPME highlight link exES_SynDeref Preproc

    " ======================================================== 
    " exProject
    " ======================================================== 

    hi default exPJ_TreeLine gui=none guifg=DarkGray term=none cterm=none ctermfg=Gray
    hi default exPJ_SynDir gui=bold guifg=Brown term=bold cterm=bold ctermfg=DarkRed
    hi default exPJ_SynFile gui=none guifg=Magenta term=none cterm=none ctermfg=Magenta
    hi default exPJ_SynFilter gui=none guifg=DarkCyan term=none cterm=none ctermfg=DarkCyan

    hi default exPJ_SynSrcFile gui=none guifg=Blue term=none cterm=none ctermfg=Blue
    hi default exPJ_SynHeaderFile gui=none guifg=DarkGreen term=none cterm=none ctermfg=DarkGreen
    hi default exPJ_SynErrorFile gui=none guifg=Red term=none cterm=none ctermfg=Red

    " ======================================================== 
    " exJumpStack
    " ======================================================== 

    hi default exJS_SynJumpMethodS term=none cterm=none ctermfg=Red gui=none guifg=Red 
    hi default exJS_SynJumpMethodG term=none cterm=none ctermfg=Blue gui=none guifg=Blue 
    hi default link exJS_SynKeyWord Preproc

    hi default exJS_SynJumpLine term=none cterm=none ctermfg=DarkGray gui=none guifg=DarkGray 
    hi default exJS_SynJumpDisable term=none cterm=none ctermfg=DarkGray gui=none guifg=DarkGray

    " ======================================================== 
    " exMacroHighlight
    " ======================================================== 

    hi default exMacroDisable term=none cterm=none ctermfg=DarkGray gui=none guifg=DarkGray
    hi default link cCppOut exMacroDisable                
    hi default exMH_GroupNameEnable term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray gui=bold guifg=DarkRed guibg=LightGray
    hi default exMH_GroupNameDisable term=bold cterm=bold ctermfg=Red ctermbg=DarkGray gui=bold guifg=DarkGray guibg=LightGray
    hi default link exMH_MacroEnable PreProc
    hi default link exMH_MacroDisable exMacroDisable

    " ======================================================== 
    " exCScope
    " ======================================================== 

    hi default exCS_SynQfNumber gui=none guifg=Red term=none cterm=none ctermfg=Red

    " ======================================================== 
    " Dark Scheme Special
    " ======================================================== 

    if &background == "dark"
        hi ex_SynHL1 gui=none guibg=DarkCyan term=none cterm=none ctermbg=DarkCyan
        hi ex_SynHL2 gui=none guibg=DarkMagenta term=none cterm=none ctermbg=DarkMagenta
        hi ex_SynHL3 gui=none guibg=DarkRed term=none cterm=none ctermbg=DarkRed
        hi ex_SynHL4 gui=none guibg=DarkGreen term=none cterm=none ctermbg=DarkGreen
        hi ex_SynHLTemp gui=none guibg=DarkGray term=none cterm=none ctermbg=DarkGray

        hi ex_SynConfirmLine gui=none guibg=DarkRed term=none cterm=none ctermbg=DarkRed
        hi ex_SynObjectLine gui=none guibg=DarkRed term=none cterm=none ctermbg=DarkRed
    endif

    " update custom environment
    if exists('*g:ex_CustomHighlight')
        call g:ex_CustomHighlight()
    endif

endfunction " >>>

" DISABLE: status-line { 
" " ------------------------------------------------------------------ 
" " Desc: 
" " ------------------------------------------------------------------ 

" function s:SetSimpleStatusline() " <<<
"   setlocal statusline=
"   setlocal statusline+=%t
" endfunction " >>>

" " ------------------------------------------------------------------ 
" " Desc: 
" " ------------------------------------------------------------------ 

" function s:SetFullStatusline() " <<<
"     if exUtility#IsRegisteredPluginBuffer(bufname('%')) 
"         call s:SetSimpleStatusline() 
"     else
"         setlocal statusline=
"         setlocal statusline+=%#ex_SynSLBufNr#%-1.2n\                           " buffer number
"         setlocal statusline+=%#ex_SynSLFlag#%h%m%r%w                           " flags
"         " setlocal statusline+=%#ex_SynSLPath#\ %-0.20{StatusLineGetPath()}%0*   " path
"         setlocal statusline+=%#ex_SynSLPath#\ %f*                              " path
"         setlocal statusline+=%#ex_SynSLFileName#\/%t\                          " file name

"         setlocal statusline+=%#ex_SynSLFileEnc#\ %{&fileencoding}\             " file encoding
"         setlocal statusline+=%#ex_SynSLFileType#\ %{strlen(&ft)?&ft:'**'}\ .   " filetype
"         setlocal statusline+=%#ex_SynSLFileType#%{&fileformat}\                " file format
"         setlocal statusline+=%#ex_SynSLTermEnc#\ %{&termencoding}\             " encoding
"         setlocal statusline+=%#ex_SynSLChar#\ %-2B\ %0*                        " current char
"         " setlocal statusline+=%#ex_SynSLSyn#\ %{synIDattr(synID(line('.'),col('.'),1),'name')}\ %0* "syntax name
"         " setlocal statusline+=%#ex_SynSLRealSyn#\ %{StatusLineRealSyn()}\ %0*                       "real syntax name
"         setlocal statusline+=%=

"         setlocal statusline+=\ %-10.(%l,%c-%v%)             "position
"         setlocal statusline+=%P                             "position percentage
"         setlocal statusline+=\ %#ex_SynSLTime#%{strftime(\"%m-%d\ %H:%M\")} " current time
"     endif
" endfunction " >>>
" } DISABLE: status-line end 

"/////////////////////////////////////////////////////////////////////////////
" auto-commands
"/////////////////////////////////////////////////////////////////////////////

" update buffer ( right now only minibuffer highlight )
au BufWritePost * call exUtility#UpdateCurrentBuffer() 
au ColorScheme * call s:UpdateSyntaxHighlights()
au VimEnter * call s:UpdateSyntaxHighlights()

" DISABLE: status-line { 
" update status line when cursor move in/out
" au BufEnter * call s:SetFullStatusline()
" au BufLeave,BufNew,BufRead,BufNewFile * call s:SetSimpleStatusline()
" } DISABLE: status-line end 

" 
if g:ex_auto_hl_cursor_word
    au CursorHold * :call exUtility#Highlight_Temp()
    au CursorMoved * :call exUtility#Highlight_TempCursorMoved()
endif

"/////////////////////////////////////////////////////////////////////////////
" commands
"/////////////////////////////////////////////////////////////////////////////

" highlight commands
command -narg=? -complete=customlist,exUtility#CompleteBySymbolFile HL1 call exUtility#Highlight_Text(1, '<args>')
command -narg=? -complete=customlist,exUtility#CompleteBySymbolFile HL2 call exUtility#Highlight_Text(2, '<args>')
command -narg=? -complete=customlist,exUtility#CompleteBySymbolFile HL3 call exUtility#Highlight_Text(3, '<args>')
command -narg=? -complete=customlist,exUtility#CompleteBySymbolFile HL4 call exUtility#Highlight_Text(4, '<args>')

" project gen/copy/build
command -narg=? -complete=customlist,exUtility#CompleteGMakeArgs GMake call exUtility#GCCMake('<args>')
command -narg=? -complete=customlist,exUtility#CompleteGMakeArgs SMake call exUtility#ShaderMake('<args>')
command -narg=* -complete=customlist,exUtility#CompleteVMakeArgs VMake call exUtility#VCMake('<args>')
command -narg=* VBat call exUtility#VCMakeBAT(<f-args>)
command -narg=? -complete=customlist,exUtility#CompleteUpdateArgs Update call exUtility#UpdateVimFiles('<args>')
command -narg=? QCopy call exUtility#CopyQuickGenProject()

" inherits genreate
command -narg=1 -complete=customlist,exUtility#CompleteBySymbolFile GV call exUtility#GenInheritsDot('<args>',"all")
command -narg=1 -complete=customlist,exUtility#CompleteBySymbolFile GVP call exUtility#GenInheritsDot('<args>',"parent")
command -narg=1 -complete=customlist,exUtility#CompleteBySymbolFile GVC call exUtility#GenInheritsDot('<args>',"children")

" code writing
command LINE call exUtility#PutLine(86, '-')
command -narg=1 NSS call exUtility#PutNamespaceStart('<args>')
command -narg=1 NSE call exUtility#PutNamespaceEnd('<args>')
command -range -narg=1 NS call exUtility#PutNamespace('<args>', <line1>, <line2>)
command -range EXTC call exUtility#PutExternC(<line1>, <line2>)
command HEADER call exUtility#PutHeader()
command SEP call exUtility#PutSeparate()
command SEG call exUtility#PutSegment()
command NOTE call exUtility#PutNote()
command DEF call exUtility#PutDefine()
command DEC call exUtility#PutDeclaration()
command DES call exUtility#PutDescription()
command MAIN call exUtility#PutMain()
command -narg=1 CLASS call exUtility#PutClass( "class", '<args>' )
command -narg=1 STRUCT call exUtility#PutClass( "struct", '<args>' )

" src-highlight
command -range=% SHL call exUtility#SrcHighlight( <line1>, <line2> )

" text mark
command -range -narg=1 -complete=customlist,exUtility#CompleteMKArgs MK call exUtility#MarkText('<args>', <line1>, <line2> )

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
