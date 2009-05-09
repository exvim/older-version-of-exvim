" ======================================================================================
" File         : exgcc.vim
" Author       : Wu Jie 
" Last Change  : 05/10/2009 | 00:44:56 AM | Sunday,May
" Description  : 
" ======================================================================================

if exists("current_compiler")
  finish
endif
let current_compiler = "exgcc"

" if exists('g:compiler_gcc_ignore_unmatched_lines')
"   let &errorformat .= ',%-G%.%#'
" endif

CompilerSet errorformat=\%*[^\"]\"%f\"%*\\D%l:\ %m,
      \\"%f\"%*\\D%l:\ %m,
      \%-G%f:%l:\ %trror:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once,
      \%-G%f:%l:\ %trror:\ for\ each\ function\ it\ appears\ in.),
      \%f:%l:\ %m,
      \\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m,
      \%D%\\S%\\+:\ Entering\ directory\ '%f'%.%#,
      \%X%\\S%\\+:\ Leaving\ directory\ '%f'%.%#,
      \%DEntering\ directory\ '%f'%.%#,
      \%XLeaving\ directory\ '%f'%.%#,
      \%D\<\<\<\<\<\<\ %\\S%\\+:\ '%f'%.%#,
      \%X\>\>\>\>\>\>\ %\\S%\\+:\ '%f'%.%#,
CompilerSet makeprg=nmake
