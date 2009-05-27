" ======================================================================================
" File         : filetype.vim
" Author       : Wu Jie 
" Description  : Vim support file to overrule default file types
" ======================================================================================


" /////////////////////////////////////////////////////////////////////////////
"   au defines
" /////////////////////////////////////////////////////////////////////////////

" additional cpp file type
au BufNewFile,BufRead *.ipp       setf cpp

" High Level Shader Language
au BufNewFile,BufRead *.hlsl,*.fx,*.fxh,*.cg,*.vsh,*.psh,*.shd,*.glsl       setf hlsl

" Max Script
au BufNewFile,BufRead *.ms,*.mse,*.mcr,*.mzp,*.ds  setf maxscript

" Doxygen Comment
au BufNewFile,BufRead *.dox,*.doxygen       setf cpp.doxygen

" gmsh
au BufNewFile,BufRead *.geo                 setf gmsh

" as (actionscript/flash) I use java analyasis it
au BufNewFile,BufRead *.as                  setf javascript

" nsis
au BufNewFile,BufRead *.nsh                 setf nsis
