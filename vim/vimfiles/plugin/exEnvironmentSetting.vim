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
" Desc: create to specified where to put vim files 
" ------------------------------------------------------------------ 

" set the vim file dir
if !exists('g:exES_vimfile_dir')
    let g:exES_vimfile_dir = "_vimfiles"
endif

" ------------------------------------------------------------------ 
" Desc: current version. increase this will cause template re-write 
" ------------------------------------------------------------------ 

let s:exES_CurrentVersion = 12

" ======================================================== 
" local variable initialization 
" ======================================================== 

" ------------------------------------------------------------------ 
" Desc: used to detect if environment have been set
" ------------------------------------------------------------------ 

let s:exES_setted = 0

"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:exES_WriteDefaultTemplate() " <<<
    let _cwd = g:ex_Pathfmt( getcwd(), 'unix' )
    let _dir_name = g:exES_vimfile_dir
    let _vimfile_fullpath = simplify(_cwd.'/'._dir_name)
    let _project_name = fnamemodify( expand('%'), ":t:r" )  
    let _list = []

    silent call add(_list, 'CWD='._cwd)
    silent call add(_list, 'Version='.s:exES_CurrentVersion)

	" Init the exUtility plugin file path
    silent call add(_list, '')
    silent call add(_list, '-- exUtility Settings --')
    silent call add(_list, '')
    silent call add(_list, 'Project=./'._dir_name.'/'._project_name.'.exproject')
    silent call add(_list, 'Tag=./'._dir_name.'/tags') " NOTE: if cpoptions+=d not set for each buffer, then the tags need full path or will not be able to find. so pls write 'au BufNewFile,BufEnter * set cpoptions+=d' in your rc
    silent call add(_list, 'ID=./'._dir_name.'/ID')
    silent call add(_list, 'Symbol=./'._dir_name.'/symbol')
    silent call add(_list, 'Macro=./'._dir_name.'/macro')
    silent call add(_list, 'Cscope=./'._dir_name.'/cscope.out')
    silent call add(_list, 'Inherits=./'._dir_name.'/inherits')
    silent call add(_list, '')
    silent call add(_list, 'vimentryRefs+=')

	" Init the LookupFile plugin file path
    silent call add(_list, '')
    silent call add(_list, '-- LookupFile Settings --')
    silent call add(_list, '')

    silent call add(_list, 'LookupFileTag=./'._dir_name.'/filenametags')

	" Init the visual_studio plugin file path
    silent call add(_list, '')
    silent call add(_list, '-- Visual Studio Settings --')
    silent call add(_list, '')

    silent call add(_list, 'vsTaskList=./'._dir_name.'/vs_task_list.txt')
    silent call add(_list, 'vsOutput=./'._dir_name.'/vs_output.txt')
    silent call add(_list, 'vsFindResult1=./'._dir_name.'/vs_find_results_1.txt')
    silent call add(_list, 'vsFindResult2=./'._dir_name.'/vs_find_results_2.txt')

	" TODO: use list for souliton results, and apply this list in
	" visual_studio plugin search
	" Init visual studio solution file path
    let sln_list = split(glob("*.sln"))
    if empty(sln_list) != 1
        for sln in sln_list
            silent call add(_list, 'Solution='.sln)
        endfor
    endif

    " Init the vimwiki plugin file path
    silent call add(_list, '')
    silent call add(_list, '-- vimwiki Settings --')
    silent call add(_list, '')

    silent call add(_list, 'wikiHome=./_doc/')
    silent call add(_list, 'wikiHomeHtml=./_doc/html/')

    " put the settings into vimentry file
    silent put! = _list
    silent exec "w!"
    silent exec "normal gg"
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
	syn match exES_SynVal	"[^+=].*$" contained
	syn match exES_SynComment	"^-- .\+ --$" 

	highlight def exES_SynVar gui=none guifg=DarkCyan term=none cterm=none ctermfg=DarkCyan
	highlight link exES_SynOperator Normal
	highlight def exES_SynVal gui=none guifg=Brown term=none cterm=none ctermfg=Brown
	highlight link exES_SynComment Comment

    " record edit buffer
    silent! call g:ex_RecordCurrentBufNum()

    let _file_name = bufname("%")
    if match(_file_name,"vimentry") != -1
        if findfile( _file_name, ".;" ) == "" || empty( readfile(_file_name) )
            " if the file is empty, we creat a template for it
            call s:exES_WriteDefaultTemplate()
        endif
    endif

    " HACK: a little bit hack, if you add new list value, you need to maintain remove code manually { 
    " if we reset the variables, clear list first
    if a:force_reset && s:exES_setted
        if !empty(g:exES_vimentryRefs)
            silent call remove ( g:exES_vimentryRefs, 0, len(g:exES_vimentryRefs)-1 )
        endif
    endif
    " } HACK end 

    " get environment value
    if s:exES_setted != 1 || a:force_reset == 1
        let s:exES_setted = 1

        " get CWD
        let Line = getline(1)
        let SettingList = split(Line, "=")
        if len(SettingList)>=2
            " let g:exES_{SettingList[0]} = escape(SettingList[1], ' ')
            " since '\ ' will get error in win32, just disable it here
            let g:exES_{SettingList[0]} = SettingList[1]
        endif
		" get Ver.
        let Line = getline(2)
        let SettingList = split(Line, "=")
        if len(SettingList)>=2
            let g:exES_{SettingList[0]} = SettingList[1]
        endif

        " check if need to update setting file
        let need_update = 0

        " process check
        let _cwd = g:ex_Pathfmt( getcwd(), 'unix' )
        if !exists( 'g:exES_CWD' ) || !exists( 'g:exES_Version' )
            echomsg "g:exES_CWD/g:exES_Version not exists"
            let need_update = 1
        elseif g:exES_CWD != _cwd " check if CWD is correct, rewrite default template if not
            echomsg "g:exES_CWD != _cwd ==> " . g:exES_CWD . " != " . _cwd
            let g:exES_CWD = _cwd 
            let need_update = 1
        elseif g:exES_Version != s:exES_CurrentVersion " check if Ver is correct, rewrite default template if not
            echomsg "g:exES_Version != s:exES_CurrentVersion ==> " . g:exES_Version . " != " . s:exES_CurrentVersion
            let need_update = 1
        endif

        " update if needed
        if need_update == 1
            silent normal! G"_dgg
            call s:exES_WriteDefaultTemplate()
        endif

        " read lines to get settings
        for Line in getline(1, '$')
            if stridx ( Line, '+=') == -1
                let SettingList = split(Line, "=")
                if len(SettingList)>=2 " the non-list variable must have value.
                    " let g:exES_{SettingList[0]} = escape(SettingList[1], ' ')
                    " since '\ ' will get error in win32, just disable it here
                    let g:exES_{SettingList[0]} = SettingList[1]
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
                            call g:ex_WarningMsg( 'Warning: vimentry ' . SettingList[1] . ' not found! Skip reference it' )
                        endif
                    endif
                endif
            endif
        endfor

        " create _vimfiles directory
        if finddir(g:exES_CWD.'/'.g:exES_vimfile_dir) == ''
            silent call mkdir(g:exES_CWD.'/'.g:exES_vimfile_dir)
        endif

        " create _inherits directory
        let inherit_directory_path = g:exES_CWD.'/'.g:exES_vimfile_dir.'/_hierarchies' 
        if finddir(inherit_directory_path) == ''
            silent call mkdir(inherit_directory_path)
        endif

        " create _temp directory
        let temp_directory_path = g:exES_CWD.'/'.g:exES_vimfile_dir.'/_temp' 
        if finddir(temp_directory_path) == ''
            silent call mkdir(temp_directory_path)
        endif

        " update environment
        if exists('*g:exES_UpdateEnvironment')
            call g:exES_UpdateEnvironment()
        endif
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
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
