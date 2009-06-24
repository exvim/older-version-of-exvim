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
" NOTE: we don't recommend to set the g:ex_dev_path directly in vim/_vimrc
" ------------------------------------------------------------------ 

if $EX_DEV ==# ""
    if has ("unix")
        call confirm ("exVim error: Please set the EX_DEV in _vimrc, default is let $EX_DEV='/usr/local/share'")
        let $EX_DEV='/usr/local/share'
    elseif has("win32")
        call confirm ("exVim error: Please set the EX_DEV in _vimrc, default is let $EX_DEV='d:\exDev'")
        let $EX_DEV='d:\exDev'
    endif
endif

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

if !exists ( "g:ex_toolkit_path" )
    let g:ex_toolkit_path = $EX_DEV.'/vim/toolkit'
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
" Desc: update the syntax highlight in exVim  
" ------------------------------------------------------------------ 

function s:UpdateSyntaxHighlights() " <<<

    " ======================================================== 
    " exUtility
    " ======================================================== 

    hi default ex_SynHL1 gui=none guibg=LightCyan term=none cterm=none ctermbg=LightCyan
    hi default ex_SynHL2 gui=none guibg=LightMagenta term=none cterm=none ctermbg=LightMagenta
    hi default ex_SynHL3 gui=none guibg=LightRed term=none cterm=none ctermbg=LightRed
    hi default ex_SynHL4 gui=none guibg=LightGreen term=none cterm=none ctermbg=LightGreen

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

        hi ex_SynConfirmLine gui=none guibg=DarkRed term=none cterm=none ctermbg=DarkRed
        hi ex_SynObjectLine gui=none guibg=DarkRed term=none cterm=none ctermbg=DarkRed
    endif

    " update custom environment
    if exists('*g:ex_CustomHighlight')
        call g:ex_CustomHighlight()
    endif

endfunction " >>>


"/////////////////////////////////////////////////////////////////////////////
" auto-commands
"/////////////////////////////////////////////////////////////////////////////

" update buffer ( right now only minibuffer highlight )
au BufWritePost * call exUtility#UpdateCurrentBuffer() 
au ColorScheme * call s:UpdateSyntaxHighlights()
au VimEnter * call s:UpdateSyntaxHighlights()

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
