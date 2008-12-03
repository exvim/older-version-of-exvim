@echo off

rem  ======================================================================================
rem  File         : quick_gen_project.bat
rem  Author       : Wu Jie 
rem  Last Change  : 10/19/2008 | 15:27:53 PM | Sunday,October
rem  Description  : 
rem  ======================================================================================

rem /////////////////////////////////////////////////////////////////////////////
rem preprocess arguments
rem /////////////////////////////////////////////////////////////////////////////

set LANGTYPE=ALL
set FILEFILTER="*.c *.cpp *.cxx *.h *.hpp *.inl *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.uc *.m"
if /I "%1"=="all" goto START
if /I "%1"=="general" goto GENERAL
if /I "%1"=="c" goto C_ONLY
if /I "%1"=="cpp" goto CPP_ONLY
if /I "%1"=="c#" goto CSHARP
if /I "%1"=="html" goto HTML
if /I "%1"=="js" goto JS
if /I "%1"=="lua" goto LUA
if /I "%1"=="math" goto MATH
if /I "%1"=="python" goto PYTHON
if /I "%1"=="uc" goto UC
if /I "%1"=="vim" goto VIM

rem /////////////////////////////////////////////////////////////////////////////
rem set variables
rem /////////////////////////////////////////////////////////////////////////////

rem  ------------------------------------------------------------------ 
rem  Desc: cstyle settings
rem  ------------------------------------------------------------------ 

:GENERAL
set LANGTYPE=GENERAL
set FILEFILTER=*.c *.cpp *.cxx *.h *.hpp *.inl *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.uc *.m
goto START

rem  ------------------------------------------------------------------ 
rem  Desc: c-only settings
rem  ------------------------------------------------------------------ 

:C_ONLY
set LANGTYPE=C_ONLY
set FILEFILTER=*.c *.h
goto START

rem  ------------------------------------------------------------------ 
rem  Desc: cpp-only settings
rem  ------------------------------------------------------------------ 

:CPP_ONLY
set LANGTYPE=CPP_ONLY
set FILEFILTER=*.cpp *.cxx *.h *.hpp *.inl
goto START

rem  ------------------------------------------------------------------ 
rem  Desc: c# settings
rem  ------------------------------------------------------------------ 

:CSHARP
set LANGTYPE=CSHARP
set FILEFILTER=*.cs
goto START

rem  ------------------------------------------------------------------ 
rem  Desc: html settings
rem  ------------------------------------------------------------------ 

:HTML
set LANGTYPE=HTML
set FILEFILTER=*.html *.htm *.shtml *.stm
goto START

rem  ------------------------------------------------------------------ 
rem  Desc: javascript settings
rem  ------------------------------------------------------------------ 

:JS
set LANGTYPE=JS
set FILEFILTER=*.js *.as
goto START

rem  ------------------------------------------------------------------ 
rem  Desc: lua settings
rem  ------------------------------------------------------------------ 

:LUA
set LANGTYPE=LUA
set FILEFILTER=*.lua
goto START

rem  ------------------------------------------------------------------ 
rem  Desc: 
rem  ------------------------------------------------------------------ 

:MATH
set LANGTYPE=MATH
set FILEFILTER=*.m
goto START

rem  ------------------------------------------------------------------ 
rem  Desc: python settings
rem  ------------------------------------------------------------------ 

:PYTHON
set LANGTYPE=PYTHON
set FILEFILTER=*.py
goto START

rem  ------------------------------------------------------------------ 
rem  Desc: 
rem  ------------------------------------------------------------------ 

:UC
set LANGTYPE=UC
set FILEFILTER=*.uc
goto START

rem  ------------------------------------------------------------------ 
rem  Desc: vim settings
rem  ------------------------------------------------------------------ 

:VIM
set LANGTYPE=VIM
set FILEFILTER=*.vim
goto START

rem /////////////////////////////////////////////////////////////////////////////
rem Start Process
rem /////////////////////////////////////////////////////////////////////////////

:START

rem  ------------------------------------------------------------------ 
rem  Desc: start generate
rem  ------------------------------------------------------------------ 

echo Generate %LANGTYPE% Project

:MKDIR

rem  ------------------------------------------------------------------ 
rem  Desc: create directory first
rem  ------------------------------------------------------------------ 

echo Create Diretory: _vimfiles
mkdir _vimfiles

rem  ------------------------------------------------------------------ 
rem  Desc: choose the generate mode
rem  ------------------------------------------------------------------ 

if /I "%2"=="" goto TAG
if /I "%2"=="tag" goto TAG
if /I "%2"=="symbol" goto SYMBOL
if /I "%2"=="inherits" goto INHERITS
if /I "%2"=="cscope" goto CSCOPE
if /I "%2"=="id" goto ID

:TAG

rem  ------------------------------------------------------------------ 
rem  Desc: create tags
rem  ------------------------------------------------------------------ 

echo Creating Tags...
if /I "%LANGTYPE%"=="ALL" ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python,vim,html,lua,javascript,uc,math --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd,javascript:+.as
if /I "%LANGTYPE%"=="GENERAL" ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd
if /I "%LANGTYPE%"=="C_ONLY" ctags -o./_tags -R --c-kinds=+p --fields=+iaS --extra=+q --languages=c --langmap=c++:+.inl
if /I "%LANGTYPE%"=="CPP_ONLY" ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ --langmap=c++:+.inl
if /I "%LANGTYPE%"=="CSHARP" ctags -o./_tags -R --fields=+iaS --extra=+q --languages=c#
if /I "%LANGTYPE%"=="HTML" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=html
if /I "%LANGTYPE%"=="JS" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=javascript --langmap=javascript:+.as
if /I "%LANGTYPE%"=="LUA" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=lua
if /I "%LANGTYPE%"=="MATH" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=math
if /I "%LANGTYPE%"=="PYTHON" ctags -o./_tags -R --fields=+iaS --extra=+q --languages=python
if /I "%LANGTYPE%"=="UC" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=uc
if /I "%LANGTYPE%"=="VIM" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=vim
move /Y ".\_tags" ".\tags"

:SYMBOL

rem  ------------------------------------------------------------------ 
rem  Desc: create symbols
rem  ------------------------------------------------------------------ 

if /I "%2"=="tag" goto FINISH
echo Creating Symbols...
gawk -f "%EX_DEV%\Vim\toolkit\gawk\prg_NoStripSymbol.awk" ./tags>./_vimfiles/_symbol
move /Y ".\_vimfiles\_symbol" ".\_vimfiles\symbol"

:INHERITS

rem  ------------------------------------------------------------------ 
rem  Desc: create inherits
rem  NOTE: only for OO language
rem  ------------------------------------------------------------------ 

if /I "%2"=="symbol" goto FINISH
if /I "%LANGTYPE%"=="C_ONLY" goto CSCOPE
if /I "%LANGTYPE%"=="HTML" goto CSCOPE
if /I "%LANGTYPE%"=="LUA" goto CSCOPE
if /I "%LANGTYPE%"=="MATH" goto CSCOPE
if /I "%LANGTYPE%"=="VIM" goto CSCOPE
echo Creating Inherits...
gawk -f "%EX_DEV%\Vim\toolkit\gawk\prg_Inherits.awk" ./tags>./_vimfiles/_inherits
move /Y ".\_vimfiles\_inherits" ".\_vimfiles\inherits"

:CSCOPE

rem  ------------------------------------------------------------------ 
rem  Desc: create cscope files
rem  NOTE: only for c/cpp
rem  ------------------------------------------------------------------ 

if /I "%2"=="inherits" goto FINISH
if /I "%LANGTYPE%"=="CSHARP" goto ID
if /I "%LANGTYPE%"=="PYTHON" goto ID
if /I "%LANGTYPE%"=="HTML" goto ID
if /I "%LANGTYPE%"=="JS" goto ID
if /I "%LANGTYPE%"=="LUA" goto ID
if /I "%LANGTYPE%"=="MATH" goto ID
if /I "%LANGTYPE%"=="UC" goto ID
if /I "%LANGTYPE%"=="VIM" goto ID
echo Creating cscope.files...
dir /s /b %FILEFILTER%|sed "s,\(.*\),\"\1\",g" > cscope.files
echo Creating cscope.out...
cscope -b
move /Y cscope.files ".\_vimfiles\cscope.files"
move /Y cscope.out ".\_vimfiles\cscope.out"

:ID

rem  ------------------------------------------------------------------ 
rem  Desc: create IDs
rem  ------------------------------------------------------------------ 

if /I "%2"=="cscope" goto FINISH
echo Creating IDs...
mkid --include="text"
rem mkid --include="C C++"
echo Move ID to ./_vimfiles/ID
move /Y ID ".\_vimfiles\ID"
if /I "%2"=="id" goto FINISH

:FINISH

rem  ------------------------------------------------------------------ 
rem  Desc: finish process
rem  ------------------------------------------------------------------ 

echo Finish
echo on


