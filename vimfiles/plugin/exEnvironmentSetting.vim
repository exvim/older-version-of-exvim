" ======================================================================================
" File         : exEnvironmentSetting.vim
" Author       : Wu Jie 
" Last Change  : 10/18/2008 | 18:56:38 PM | Saturday,October
" Description  : 
" ======================================================================================

" check if plugin loaded
if exists('loaded_ex_environment_setting') || &cp
    finish
endif
let loaded_ex_environment_setting=1

"/////////////////////////////////////////////////////////////////////////////
" variables
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" gloable variable initialization
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: 
" NOTE: this value will be set automatically
" ------------------------------------------------------------------ 

let g:exES_vimfiles_dirname = ".vimfiles"

" ------------------------------------------------------------------ 
" Desc: set project command
" ------------------------------------------------------------------ 

if !exists('g:exES_project_cmd')
    let g:exES_project_cmd = 'EXProject'
endif

" ------------------------------------------------------------------ 
" Desc: set web browser
" ------------------------------------------------------------------ 

if !exists('g:exES_WebBrowser')
    if has("gui_running")
        if has("win32")
            let g:exES_WebBrowser = 'c:\Users\Johnny\AppData\Local\Google\Chrome\Application\chrome.exe'
        elseif has("unix")
            let g:exES_WebBrowser = 'firefox'
        endif
    endif
endif

" ------------------------------------------------------------------ 
" Desc: set image viewer
" ------------------------------------------------------------------ 

if !exists('g:exES_ImageViewer')
    if has("gui_running")
        if has("win32")
            let g:exES_ImageViewer = $EX_DEV.'\tools\IrfanView\i_view32.exe'
        elseif has("unix")
            " TODO
        endif
    endif
endif

" ======================================================== 
" local variable initialization 
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: used to detect if environment have been set
" ------------------------------------------------------------------ 

let s:exES_setted = 0

" ------------------------------------------------------------------ 
" Desc: current version. increase this will cause template re-write 
" ------------------------------------------------------------------ 

let s:exES_CurrentVersion = 25

"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exES_WriteDefaultTemplate() " <<<
    " NOTE: we use the dir path of .vimentry instead of getcwd().  
    let _cwd = exUtility#Pathfmt( fnamemodify( expand('%'), ':p:h' ), 'unix' )
    let _vimentry_name = fnamemodify( expand('%'), ":t:r" )  
    let _dir_name = '.vimfiles.'._vimentry_name
    let _list = []

    silent call add(_list, '-- auto-gen settings (DO NOT MODIFY) --')
    silent call add(_list, '')
    silent call add(_list, 'CWD='._cwd)
    silent call add(_list, 'Version='.s:exES_CurrentVersion)
    silent call add(_list, 'VimEntryName='._vimentry_name)
    silent call add(_list, 'VimfilesDirName='._dir_name)

	" Init the exUtility plugin file path
    silent call add(_list, '')
    silent call add(_list, '-- ex-plugins File Settings --')
    silent call add(_list, '')
    silent call add(_list, 'LangType=auto') " NOTE: null means depends on file_filter
    silent call add(_list, 'Project=./'._dir_name.'/'.'project_tree.exproject')
    silent call add(_list, 'FilenameList=./'._dir_name.'/filenamelist')
    silent call add(_list, 'Tag=./'._dir_name.'/tags') " NOTE: if cpoptions+=d not set for each buffer, then the tags need full path or will not be able to find. so pls write 'au BufNewFile,BufEnter * set cpoptions+=d' in your rc
    silent call add(_list, 'ID=./'._dir_name.'/ID')
    silent call add(_list, 'Symbol=./'._dir_name.'/symbol')
    silent call add(_list, 'Macro=./'._dir_name.'/macro')
    silent call add(_list, 'Cscope=./'._dir_name.'/cscope.out')
    silent call add(_list, 'Inherits=./'._dir_name.'/inherits')
    silent call add(_list, 'Bookmarks=./'._dir_name.'/bookmarks')
    silent call add(_list, '')
    silent call add(_list, 'vimentryRefs+=')
    silent call add(_list, '')
    silent call add(_list, '-- ex-plugins Behavior Settings --')
    silent call add(_list, '')
    silent call add(_list, 'RestoreBuffers=false')
    silent call add(_list, 'AskForRestoration=true')
    silent call add(_list, 'RestoreInfo=./'._dir_name.'/restore_info')

	" Init the LookupFile plugin file path
    silent call add(_list, '')
    silent call add(_list, '-- LookupFile Settings --')
    silent call add(_list, '')

    silent call add(_list, 'LookupFileTag=./'._dir_name.'/filenametags')

	" Init the visual_studio plugin file path
    silent call add(_list, '')
    silent call add(_list, '-- Visual Studio Settings --')
    silent call add(_list, '')

    silent call add(_list, 'vsTaskList=./'._dir_name.'/vs_task_list')
    silent call add(_list, 'vsOutput=./'._dir_name.'/vs_output')
    silent call add(_list, 'vsFindResult1=./'._dir_name.'/vs_find_results_1')
    silent call add(_list, 'vsFindResult2=./'._dir_name.'/vs_find_results_2')

	" TODO: use list for souliton results, and apply this list in
	" visual_studio plugin search
	" Init visual studio solution file path
    let sln_list = split(glob("*.sln"))
    if empty(sln_list) != 1
        for sln in sln_list
            silent call add(_list, 'Solution='.sln)
        endfor
    endif

    " DISABLE: now I use sphinxdoc, so vimwiki will go as option { 
    " Init the vimwiki plugin file path
    " silent call add(_list, '')
    " silent call add(_list, '-- vimwiki Settings --')
    " silent call add(_list, '')

    " silent call add(_list, 'wikiHome=./wiki')
    " silent call add(_list, 'wikiHomeHtml=./wiki/html')
    " silent call add(_list, 'wikiHtmlHeader=./wiki/template/header.tpl')
    " } DISABLE end 

    " put the settings into vimentry file
    silent put! = _list
    silent exec "w!"
    silent exec "normal gg"
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: default environment update function 
" ------------------------------------------------------------------ 

function s:exES_LoadSettings( start, end ) " <<<
    for Line in getline( a:start, a:end )
        if match(Line,'+=\|=') == -1 " if the line is comment line, skip it.
            continue 
        endif

        if stridx ( Line, '+=') == -1
            let SettingList = split(Line, "=")
            if len(SettingList)>=2 " set value as string to the non-list variable.
                " let g:exES_{SettingList[0]} = escape(SettingList[1], ' ')
                " since '\ ' will get error in win32, just disable it here
                let g:exES_{SettingList[0]} = SettingList[1]
            elseif len(SettingList)>=1 " if don't have value, set '' value
                let g:exES_{SettingList[0]} = ''
            endif
        else " create list variables
            let SettingList = split(Line, "+=")
            if len(SettingList)>=1 " we can define a variable if the number of split list itmes more than one
                if !exists( 'g:exES_'.SettingList[0] ) " if we don't define this list variable, define it first
                    let g:exES_{SettingList[0]} = []
                endif

                " now add items to the list
                if len(SettingList)>=2 " we can assigne a value if the number of split list items more then two
                    if findfile( SettingList[1] ) != ''
                        silent call add ( g:exES_{SettingList[0]}, SettingList[1] )
                    else
                        call exUtility#WarningMsg( 'Warning: vimentry ' . SettingList[1] . ' not found! Skip reference it' )
                    endif
                endif
            endif
        endif
    endfor
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exES_ClearListVariables() " <<<
    " HACK: a little bit hack, if you add new list value, you need to maintain remove code manually { 
    if !empty(g:exES_vimentryRefs)
        silent call remove ( g:exES_vimentryRefs, 0, len(g:exES_vimentryRefs)-1 )
    endif
    " } HACK end 
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function g:exES_SetEnvironment( force_reset ) " <<<
    " do not show it in buffer list
    silent! setlocal bufhidden=hide
    silent! setlocal noswapfile
    silent! setlocal nobuflisted

	" syntax highlight
	syn match exES_SynSetting transparent  "^.\{-}=.*$" contains=exES_SynVar,exES_SynOperator
	syn match exES_SynVar	"^.\{-}=" contained contains=exES_SynOperator
	syn match exES_SynOperator	"+*=.*$" contained contains=exES_SynVal
	syn match exES_SynVal	"[^+=].*$" contained " contains=exES_SynDeref
	syn match exES_SynComment	"^-- .\+ --$" 
    " KEEPME: syn region exES_SynDeref start="\${" end="}" contained

    " record edit buffer
    silent! call exUtility#RecordCurrentBufNum()

    " if the file is empty, we creat a template for it
    let _file_name = bufname("%")
    if match(_file_name,"vimentry") != -1
        if findfile( fnamemodify(_file_name,':p'), '.;' ) == "" || empty( readfile(_file_name) )
            call s:exES_WriteDefaultTemplate()
        endif
    endif

    " init force reset
    let force_reset = a:force_reset

    " if we already in a vimentry file, and open another vimentry file.
    if s:exES_setted == 1
        let cur_vimentry_name = fnamemodify( expand('%'), ":t:r" )  
        if cur_vimentry_name !=# g:exES_VimEntryName
            " close all ex-plugin windows
            call exUtility#CloseAllExpluginWindow ()

            " NOTE: no use at all, since some time we may use :e xxx.vimentry in a plugin window, and :e command have lower level than GotoEditBuffer to control window.
            " " first make sure we are back to edit buffer
            " call exUtility#GotoEditBuffer()

            let force_reset = 1
        endif
    endif

    " if we reset the variables, clear list first
    if force_reset && s:exES_setted
        call s:exES_ClearListVariables ()
    endif

    " get environment value
    if s:exES_setted != 1 || force_reset == 1
        let s:exES_setted = 1

        " get CWD and Version
        call s:exES_LoadSettings ( 1, 6 )

        " check if need to update setting file
        let need_update = 0

        " process check
        let _cwd = exUtility#Pathfmt( fnamemodify( expand('%'), ':p:h' ), 'unix' )
        let _vimentry_name = fnamemodify( expand('%'), ":t:r" )  
        if !exists( 'g:exES_CWD' ) || !exists( 'g:exES_Version' )
            echomsg "g:exES_CWD/g:exES_Version not exists"
            let need_update = 1
        elseif g:exES_CWD != _cwd " check if CWD is correct, rewrite default template if not
            echomsg "g:exES_CWD != _cwd ==> " . g:exES_CWD . " != " . _cwd
            let need_update = 1
        elseif g:exES_Version != s:exES_CurrentVersion " check if Ver is correct, rewrite default template if not
            echomsg "g:exES_Version != s:exES_CurrentVersion ==> " . g:exES_Version . " != " . s:exES_CurrentVersion
            let need_update = 1
        elseif g:exES_VimEntryName != _vimentry_name
            echomsg "g:exES_VimEntryName != _vimentry_name ==> " . g:exES_VimEntryName . " != " . _vimentry_name
            let need_update = 1
        endif

        " update if needed
        if need_update == 1
            silent exec '1,$d _'
            call s:exES_WriteDefaultTemplate()
        endif

        " read lines to get settings
        " NOTE: since we may rewrite the 'auto-gen settings' section, we need to load from first line.
        call s:exES_LoadSettings ( 1, '$' )

        " update environment
        call g:exES_UpdateEnvironment()

        "
        call exUtility#CreateIDLangMap ( exUtility#GetProjectFilter("file_filter") )
        call exUtility#CreateQuickGenProject ()
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: default environment update function 
" ------------------------------------------------------------------ 

function g:exES_UpdateEnvironment() " <<<
    " set parent working directory
    if exists( 'g:exES_CWD' )
        silent exec 'cd ' . escape(g:exES_CWD, " ")
    endif

    if exists('g:exES_VimEntryName')
        au VimEnter,BufNewFile,BufEnter * let &titlestring = g:exES_VimEntryName . ' : %t %M%r (' . expand("%:p:h") . ')' . ' %h%w%y'
    endif

    " create _vimfiles directories
    if exists ('g:exES_VimfilesDirName')
        let g:exES_vimfiles_dirname = g:exES_VimfilesDirName

        " create .vimfiles directory
        if finddir(g:exES_CWD.'/'.g:exES_vimfiles_dirname) == ''
            silent call mkdir(g:exES_CWD.'/'.g:exES_vimfiles_dirname)
        endif

        " create .hierarchies directory
        let inherit_directory_path = g:exES_CWD.'/'.g:exES_vimfiles_dirname.'/.hierarchies' 
        if finddir(inherit_directory_path) == ''
            silent call mkdir(inherit_directory_path)
        endif

        " create .temp directory
        let temp_directory_path = g:exES_CWD.'/'.g:exES_vimfiles_dirname.'/.temp' 
        if finddir(temp_directory_path) == ''
            silent call mkdir(temp_directory_path)
        endif
    endif

    " set default language type map
    if exists('g:exES_LangType')
        if g:exES_LangType != 'auto' " if auto, we use default language map.
            let lang_list = split( g:exES_LangType, ',' )
            silent call exUtility#SetProjectFilter ( "file_filter", exUtility#GetFileFilterByLanguage (lang_list) )
        endif
    endif

    " Open Minibuffer always, re-adjust project position
    let g:miniBufExplorerMoreThanOne = 0 
    if exists(':MiniBufExplorer')
        silent exe "MiniBufExplorer"
    endif

    " set tag file path
    if exists( 'g:exES_Tag' )
        "let &tags = &tags . ',' . g:exES_Tag
        let &tags = escape(g:exES_Tag, " ")
    endif

    " open exProject window
    if exists( 'g:exES_Project' )
        silent exec g:exES_project_cmd.' '.g:exES_Project
        silent exec 'ExpjUpdateFilters'
    endif

    " init macro list
    if exists( 'g:exES_Macro' )
        silent call g:exMH_InitMacroList(g:exES_Macro)
    endif

    " connect cscope file
    if exists( 'g:exES_Cscope' )
        silent call g:exCS_ConnectCscopeFile()
    endif

    " set vimentry references
    if exists ('g:exES_vimentryRefs')
        for vimentry in g:exES_vimentryRefs
            let ref_entry_dir = fnamemodify( vimentry, ':p:h')
            let ref_vimfiles_dirname = '.vimfiles.' . fnamemodify( vimentry, ":t:r" )
            let fullpath_tagfile = exUtility#GetVimFile ( ref_entry_dir, ref_vimfiles_dirname, 'tag')
            if has ('win32')
                let fullpath_tagfile = exUtility#Pathfmt( fullpath_tagfile, 'windows' )
            elseif has ('unix')
                let fullpath_tagfile = exUtility#Pathfmt( fullpath_tagfile, 'unix' )
            endif
            if findfile ( fullpath_tagfile ) != ''
                let &tags .= ',' . fullpath_tagfile
            endif
        endfor
    endif

    " check if load last opened buffer
    if exists ('g:exES_RestoreBuffers')
        if g:exES_RestoreBuffers ==? 'true'
            autocmd VimLeave * call exUtility#SaveRestoreInfo ()
            let choice = 1
            if exists ('g:exES_AskForRestoration') && g:exES_AskForRestoration ==? 'true'
                let choice = confirm("Restore last edit buffers?", "&Yes\n&No", 1)
            endif
            if choice == 1 " if ask for restoration
                " DISABLE: call exUtility#RestoreLastEditBuffers ()
                autocmd VimEnter * call exUtility#RestoreLastEditBuffers ()
            endif
        endif
    endif

    " update custom environment
    if exists('*g:exES_PostUpdate')
        call g:exES_PostUpdate()
    endif
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" commands
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: if it is vimentry files, set evironment first
" ------------------------------------------------------------------ 

au BufEnter *.vimentry call g:exES_SetEnvironment(0)
au BufWritePost *.vimentry :call g:exES_SetEnvironment(1)

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
