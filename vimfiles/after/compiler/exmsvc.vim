" ======================================================================================
" File         : exmsvc.vim
" Author       : Wu Jie 
" Last Change  : 12/18/2009 | 11:19:59 AM | Friday,December
" Description  : 
" ======================================================================================

if exists("current_compiler")
  finish
endif
let current_compiler = "exmsvc"

" An example vc error format log
" 1>------ Build started: Project: exCore, Configuration: Debug Win32 ------
" 1>Compiling...
" 1>Color.cpp
" 1>.\Math\Color.cpp(24) : error C2065: 'xxx' : undeclared identifier
" 1>Build log was saved at "file://D:\Projects\Dev\exUtility\src\exLibs\_build\msvc\Win32\Debug\int\exCore\BuildLog.htm"
" 1>exCore - 1 error(s), 0 warning(s)
" 2>------ Build started: Project: testLibs, Configuration: Debug Win32 ------
" 2>Compiling...
" 2>ArrayTest.cpp
" 2>.\tests\ArrayTest.cpp(25) : error C2065: 'TArray' : undeclared identifier
" 2>.\tests\ArrayTest.cpp(25) : error C2062: type 'int' unexpected
" 2>.\tests\ArrayTest.cpp(26) : error C2065: 'array' : undeclared identifier
" 2>.\tests\ArrayTest.cpp(26) : error C2228: left of '.PushBack' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>.\tests\ArrayTest.cpp(27) : error C2228: left of '.PushBack' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>.\tests\ArrayTest.cpp(28) : error C2228: left of '.PushBack' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>.\tests\ArrayTest.cpp(29) : error C2228: left of '.PushBack' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>.\tests\ArrayTest.cpp(30) : error C2228: left of '.PushBack' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>.\tests\ArrayTest.cpp(31) : error C2228: left of '.PushBack' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>.\tests\ArrayTest.cpp(32) : error C2228: left of '.PushBack' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>.\tests\ArrayTest.cpp(33) : error C2228: left of '.PushBack' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>.\tests\ArrayTest.cpp(34) : error C2228: left of '.PushBack' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>.\tests\ArrayTest.cpp(35) : error C2228: left of '.PushBack' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>.\tests\ArrayTest.cpp(36) : error C2228: left of '.Size' must have class/struct/union
" 2>        type is ''unknown-type''
" 2>Build log was saved at "file://D:\Projects\Dev\exUtility\src\exLibs\_build\msvc\Win32\Debug\int\testLibs\BuildLog.htm"
" 2>testLibs - 14 error(s), 0 warning(s)
" ========== Build: 0 succeeded, 2 failed, 0 up-to-date, 0 skipped ==========

CompilerSet errorformat=%D%\\d%\\+\>------\ %.%#Project:\ %f%\\,%.%#,
		    \%X%\\d%\\+\>%.%#%\\d%\\+\ error(s)%.%#%\\d%\\+\ warning(s),
		    \%\\d%\\+\>%f(%l)\ :\ %t%*\\D%n:\ %m
CompilerSet makeprg=nmake
