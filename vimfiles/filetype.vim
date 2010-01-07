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

" treat gitignore file as config file
au BufNewFile,BufRead *.gitignore setf cfg 
