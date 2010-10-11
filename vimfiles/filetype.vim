" ======================================================================================
" File         : filetype.vim
" Author       : Wu Jie 
" Last Change  : 12/09/2009 | 18:14:34 PM | Wednesday,December
" Description  : Vim support file to overrule default file types
" ======================================================================================

" /////////////////////////////////////////////////////////////////////////////
"   au defines
" /////////////////////////////////////////////////////////////////////////////

" additional cpp file type
au BufNewFile,BufRead *.ipp setf cpp

" High Level Shader Language
au BufNewFile,BufRead *.hlsl,*.fx,*.fxh,*.cg,*.vsh,*.psh,*.shd,*.glsl,*.shader setf hlsl

" Max Script
au BufNewFile,BufRead *.ms,*.mse,*.mcr,*.mzp,*.ds setf maxscript

" Doxygen Comment
au BufNewFile,BufRead *.dox,*.doxygen setf cpp.doxygen

" gmsh
au BufNewFile,BufRead *.geo setf gmsh

" as (actionscript/flash) I use java analyasis it
au BufNewFile,BufRead *.as setf javascript

" nsis
au BufNewFile,BufRead *.nsh setf nsis

" swig
au BufNewFile,BufRead *.i,*.swg setf swig 

" cs
au BufNewFile,BufRead *.tt setf cs 

" treat gitignore file as config file
au BufNewFile,BufRead *.gitignore setf cfg 

" Matlab or Objective C
au BufNewFile,BufRead *.m call s:ex_FTm()

" lua 
au BufNewFile,BufRead *.wlua setf lua 

"/////////////////////////////////////////////////////////////////////////////
" ex_FTm
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

func! s:ex_FTm()
    let n = 1
    while n < 10
        let line = getline(n)
        if line =~ '^\s*\(#\s*\(include\|import\)\>\|\/\*\|^\/\/\)'
            setf objc
            return
        endif
        if line =~ '^\s*%'
            setf matlab
            return
        endif
        if line =~ '^\s*(\*'
            setf mma
            return
        endif
        let n = n + 1
    endwhile
    if exists("g:filetype_m")
        exe "setf " . g:filetype_m
    else
        setf matlab
    endif
endfunc
