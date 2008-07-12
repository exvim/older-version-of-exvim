" Vim compiler file
" Compiler:	Miscrosoft hlsl
" Maintainer:	Wu Jie
" Last Change:	2008 Jul 8

if exists("current_compiler")
  finish
endif
let current_compiler = "hlsl"

" 
CompilerSet errorformat=%f(%l\\,%c):\ %m " fxc shader error-format
CompilerSet makeprg=nmake
