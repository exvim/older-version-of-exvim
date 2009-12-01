" ======================================================================================
" File         : hlsl.vim
" Author       : Wu Jie 
" Last Change  : 05/10/2009 | 00:45:12 AM | Sunday,May
" Description  : 
" ======================================================================================

if exists("current_compiler")
  finish
endif
let current_compiler = "hlsl"

" 
CompilerSet errorformat=%f(%l\\,%c):\ %m " fxc shader error-format
CompilerSet makeprg=nmake
