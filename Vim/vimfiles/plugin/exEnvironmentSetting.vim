"=============================================================================
" File:        exEnvironmentSetting.vim
" Author:      Johnny
" Last Change: Wed 29 Oct 2006 01:05:03 PM EDT
" Version:     1.0
"=============================================================================
" You may use this code in whatever way you see fit.

if exists('loaded_ex_environment_setting') || &cp
    finish
endif
let loaded_ex_environment_setting=1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------
" Initialization <<<
" gloable variable initialization
let g:exES_setted = 0

" set the vim file dir
if !exists('g:exES_vimfile_dir')
    let g:exES_vimfile_dir = "_vimfiles"
endif

" Project or EXProject
if !exists('g:exES_project_cmd')
    let g:exES_project_cmd = 'EXProject'
endif

" >>>

" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------

" --exES_WriteDefaultTemplate--
function! s:exES_WriteDefaultTemplate() " <<<
    let _cwd = substitute( getcwd(), "\\", "\/", "g" )
    let _dir_name = g:exES_vimfile_dir
    let _project_name = fnamemodify( expand('%'), ":t:r" )  
    let _list = []

    silent call add(_list, 'PWD='._cwd)
    if g:exES_project_cmd == 'EXProject'
        silent call add(_list, 'Project='._cwd.'/'._dir_name.'/'._project_name.'.exproject')
    else
        silent call add(_list, 'Project='._cwd.'/'._dir_name.'/'._project_name.'.vimprojects')
    endif
    silent call add(_list, 'Tag='._cwd.'/tags')
    silent call add(_list, 'ID=./'._dir_name.'/ID')
    silent call add(_list, 'Symbol='._cwd.'/'._dir_name.'/symbol')

    let sln_list = split(glob("*.sln"))
    if empty(sln_list) != 1
        for sln in sln_list
            silent call add(_list, 'Solution='.sln)
        endfor
    endif

    silent put! = _list
    silent exec "w!"
endfunction " >>>


" --exES_SetEnvironment--
function! g:exES_SetEnvironment() " <<<
    " do not show it in buffer list
    silent! setlocal bufhidden=hide
    silent! setlocal noswapfile
    silent! setlocal nobuflisted

    let _file_name = bufname("%")
    if match(_file_name,"vimentry") != -1
        if empty( readfile(_file_name) )
            " if the file is empty, we creat a template for it
            call s:exES_WriteDefaultTemplate()
        endif
    endif

    " get environment value
    if g:exES_setted != 1
        let g:exES_setted = 1

        for Line in getline(1, '$')
            let SettingList = split(Line, "=")
            if len(SettingList)>=2
                exec "let g:exES_".SettingList[0]."='".escape(SettingList[1], ' ')."'"
            endif
        endfor

        if finddir(g:exES_PWD.'/'.g:exES_vimfile_dir) == ''
            silent call mkdir(g:exES_PWD.'/'.g:exES_vimfile_dir)
        endif

        if exists('*g:exES_UpdateEnvironment')
            call g:exES_UpdateEnvironment()
        endif
    endif
endfunction " >>>


" if it is vimentry files, set evironment first
au BufEnter *.vimentry call g:exES_SetEnvironment()


finish
" vim600: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
