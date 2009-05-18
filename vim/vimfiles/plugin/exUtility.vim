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
" Desc: store the plugins buffer name, so we can ensure not recore name as edit-buffer
" ------------------------------------------------------------------ 

if !exists('g:exUT_plugin_list')
    let g:exUT_plugin_list = ["-MiniBufExplorer-","__Tag_List__","\[Lookup File\]"] 
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

" ======================================================== 
" local variable initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc:  
" ------------------------------------------------------------------ 

let s:ex_HighlightsInited = 0 

"/////////////////////////////////////////////////////////////////////////////
" functions
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: update the syntax highlight in exVim  
" ------------------------------------------------------------------ 

function s:UpdateSyntaxHighlights() " <<<

    let s:ex_HighlightsInited = 1 

    " ======================================================== 
    " exUtility
    " ======================================================== 

    hi default ex_SynHL1 gui=none guibg=LightCyan term=none cterm=none ctermbg=LightCyan
    hi default ex_SynHL2 gui=none guibg=LightMagenta term=none cterm=none ctermbg=LightMagenta
    hi default ex_SynHL3 gui=none guibg=LightRed term=none cterm=none ctermbg=LightRed
    hi default ex_SynHL4 gui=none guibg=LightGreen term=none cterm=none ctermbg=LightGreen

    hi default ex_SynSelectLine gui=none guibg=#bfffff term=none cterm=none ctermbg=LightCyan
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

    hi default ex_SynJumpMethodS term=none cterm=none ctermfg=Red gui=none guifg=Red 
    hi default ex_SynJumpMethodG term=none cterm=none ctermfg=Blue gui=none guifg=Blue 
    hi default link ex_SynJumpSymbol Comment

    hi default exCommentLable term=standout ctermfg=DarkYellow ctermbg=Red gui=none guifg=LightYellow guibg=Red
    " hi exCommentLable term=standout ctermfg=DarkYellow ctermbg=Red gui=none guifg=DarkRed guibg=LightMagenta

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
    " exProject
    " ======================================================== 

    hi default exPJ_TreeLine gui=none guifg=DarkGray term=none cterm=none ctermfg=Gray
    hi default exPJ_SynDir gui=bold guifg=Brown term=bold cterm=bold ctermfg=DarkRed
    hi default exPJ_SynFile gui=none guifg=Magenta term=none cterm=none ctermfg=Magenta

    hi default exPJ_SynSrcFile gui=none guifg=Blue term=none cterm=none ctermfg=Blue
    hi default exPJ_SynHeaderFile gui=none guifg=DarkGreen term=none cterm=none ctermfg=DarkGreen
    hi default exPJ_SynErrorFile gui=none guifg=Red term=none cterm=none ctermfg=Red

    " ======================================================== 
    " exCScope
    " ======================================================== 

    hi default exCS_SynQfNumber gui=none guifg=Red term=none cterm=none ctermfg=Red

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

" if you don't use color scheme, you may properly not run the code above, so
" run it manually here
if s:ex_HighlightsInited == 0
    call s:UpdateSyntaxHighlights()
endif

"/////////////////////////////////////////////////////////////////////////////
" commands
"/////////////////////////////////////////////////////////////////////////////

" highlight commands
command -narg=? -complete=customlist,exUtility#CompleteBySymbolFile HL1 call exUtility#Highlight_Text(1, "<args>")
command -narg=? -complete=customlist,exUtility#CompleteBySymbolFile HL2 call exUtility#Highlight_Text(2, "<args>")
command -narg=? -complete=customlist,exUtility#CompleteBySymbolFile HL3 call exUtility#Highlight_Text(3, "<args>")
command -narg=? -complete=customlist,exUtility#CompleteBySymbolFile HL4 call exUtility#Highlight_Text(4, "<args>")

" project gen/copy/build
command -narg=? -complete=customlist,exUtility#CompleteGMakeArgs GMake call exUtility#GCCMake("<args>")
command -narg=? -complete=customlist,exUtility#CompleteGMakeArgs SMake call exUtility#ShaderMake("<args>")
command -narg=* -complete=customlist,exUtility#CompleteVMakeArgs VMake call exUtility#VCMake("<args>")
command -narg=* VBat call exUtility#VCMakeBAT(<f-args>)
command -narg=? -complete=customlist,exUtility#CompleteUpdateArgs Update call exUtility#UpdateVimFiles("<args>")
command -narg=? QCopy call exUtility#CopyQuickGenProject()

" inherits genreate
command -narg=1 -complete=customlist,exUtility#CompleteBySymbolFile GV call exUtility#GenInheritsDot('<args>',"all")
command -narg=1 -complete=customlist,exUtility#CompleteBySymbolFile GVP call exUtility#GenInheritsDot('<args>',"parent")
command -narg=1 -complete=customlist,exUtility#CompleteBySymbolFile GVC call exUtility#GenInheritsDot('<args>',"children")

" code writing
command LINE call exUtility#PutLine(86, '-')
command -narg=1 NSS call exUtility#PutNamespaceStart("<args>")
command -narg=1 NSE call exUtility#PutNamespaceEnd("<args>")
command -range -narg=1 NS call exUtility#PutNamespace("<args>", <line1>, <line2>)
command HEADER call exUtility#PutHeader()
command SEP call exUtility#PutSeparate()
command SEG call exUtility#PutSegment()
command NOTE call exUtility#PutNote()
command DEF call exUtility#PutDefine()
command DEC call exUtility#PutDeclaration()
command DES call exUtility#PutDescription()
command MAIN call exUtility#PutMain()
command -narg=1 CLASS call exUtility#PutClass( "class", "<args>" )
command -narg=1 STRUCT call exUtility#PutClass( "struct", "<args>" )

" src-highlight
command -range=% SHL call exUtility#SrcHighlight( <line1>, <line2> )

" text mark
command -range -narg=1 -complete=customlist,exUtility#CompleteMKArgs MK call exUtility#MarkText("<args>", <line1>, <line2> )

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
