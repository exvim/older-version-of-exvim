@echo off

rem =======================================
rem preprocess arguments
rem =======================================
set LANGTYPE=ALL
set FILEFILTER="*.c *.cpp *.cxx *.h *.hpp *.inl *.uc *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd"
if /I "%1"=="all" goto START
if /I "%1"=="c" goto C_ONLY
if /I "%1"=="cpp" goto CPP_ONLY
if /I "%1"=="python" goto PYTHON
if /I "%1"=="c#" goto CSHARP
if /I "%1"=="general" goto GENERAL
if /I "%1"=="vim" goto VIM
if /I "%1"=="lua" goto LUA
if /I "%1"=="js" goto JS
if /I "%1"=="html" goto HTML

rem =======================================
rem set variables
rem =======================================

rem c-only settings
:C_ONLY
set LANGTYPE=C_ONLY
set FILEFILTER=*.c *.h
goto START

rem cpp-only settings
:CPP_ONLY
set LANGTYPE=CPP_ONLY
set FILEFILTER=*.cpp *.cxx *.h *.hpp *.inl
goto START

rem python settings
:PYTHON
set LANGTYPE=PYTHON
set FILEFILTER=*.py
goto START

rem c# settings
:CSHARP
set LANGTYPE=CSHARP
set FILEFILTER=*.cs
goto START

rem vim settings
:VIM
set LANGTYPE=VIM
set FILEFILTER=*.vim
goto START

rem html settings
:HTML
set LANGTYPE=HTML
set FILEFILTER=*.html *.htm *.shtml *.stm
goto START

rem lua settings
:LUA
set LANGTYPE=LUA
set FILEFILTER=*.lua
goto START

rem javascript settings
:JS
set LANGTYPE=JS
set FILEFILTER=*.js *.as
goto START

rem cstyle settings
:GENERAL
set LANGTYPE=GENERAL
set FILEFILTER=*.c *.cpp *.cxx *.h *.hpp *.inl *.uc *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd
goto START

rem =======================================
rem Start Process
rem =======================================

:START
rem =======================================
rem start generate
rem =======================================
echo Generate %LANGTYPE% Project

:MKDIR
rem =======================================
rem create directory first
rem =======================================
echo Create Diretory: _vimfiles
mkdir _vimfiles

rem =======================================
rem choose the generate mode
rem =======================================
if /I "%2"=="" goto TAG
if /I "%2"=="tag" goto TAG
if /I "%2"=="symbol" goto SYMBOL
if /I "%2"=="inherits" goto INHERITS
if /I "%2"=="cscope" goto CSCOPE
if /I "%2"=="id" goto ID

:TAG
rem =======================================
rem create tags
rem =======================================
echo Creating Tags...
if /I "%LANGTYPE%"=="C_ONLY" ctags -o./_tags -R --c-kinds=+p --fields=+iaS --extra=+q --languages=c --langmap=c++:+.inl
if /I "%LANGTYPE%"=="CPP_ONLY" ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ --langmap=c++:+.inl
if /I "%LANGTYPE%"=="PYTHON" ctags -o./_tags -R --fields=+iaS --extra=+q --languages=python
if /I "%LANGTYPE%"=="CSHARP" ctags -o./_tags -R --fields=+iaS --extra=+q --languages=c#
if /I "%LANGTYPE%"=="VIM" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=vim
if /I "%LANGTYPE%"=="HTML" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=html
if /I "%LANGTYPE%"=="LUA" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=lua
if /I "%LANGTYPE%"=="JS" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=javascript --langmap=javascript:+.as
if /I "%LANGTYPE%"=="GENERAL" ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd
if /I "%LANGTYPE%"=="ALL" ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd,javascript:+.as
move /Y ".\_tags" ".\tags"

:SYMBOL
rem =======================================
rem create symbols
rem =======================================
if /I "%2"=="tag" goto FINISH
echo Creating Symbols...
gawk -f "%EX_DEV%\Vim\toolkit\gawk\prg_NoStripSymbol.awk" ./tags>./_vimfiles/_symbol
move /Y ".\_vimfiles\_symbol" ".\_vimfiles\symbol"

:INHERITS
rem =======================================
rem create inherits
rem     note: only for OO language
rem =======================================
if /I "%2"=="symbol" goto FINISH
if /I "%LANGTYPE%"=="C_ONLY" goto CSCOPE
if /I "%LANGTYPE%"=="VIM" goto CSCOPE
if /I "%LANGTYPE%"=="HTML" goto CSCOPE
if /I "%LANGTYPE%"=="LUA" goto CSCOPE
echo Creating Inherits...
gawk -f "%EX_DEV%\Vim\toolkit\gawk\prg_Inherits.awk" ./tags>./_vimfiles/_inherits
move /Y ".\_vimfiles\_inherits" ".\_vimfiles\inherits"

:CSCOPE
rem =======================================
rem create cscope files
rem     note: only for c/cpp
rem =======================================
if /I "%2"=="inherits" goto FINISH
if /I "%LANGTYPE%"=="PYTHON" goto ID
if /I "%LANGTYPE%"=="CSHARP" goto ID
if /I "%LANGTYPE%"=="VIM" goto ID
if /I "%LANGTYPE%"=="HTML" goto ID
if /I "%LANGTYPE%"=="LUA" goto ID
if /I "%LANGTYPE%"=="JS" goto ID
echo Creating cscope.files...
dir /s /b %FILEFILTER%|sed "s,\(.*\),\"\1\",g" > cscope.files
echo Creating cscope.out...
cscope -b
move /Y cscope.files ".\_vimfiles\cscope.files"
move /Y cscope.out ".\_vimfiles\cscope.out"

:ID
rem =======================================
rem create IDs
rem =======================================
if /I "%2"=="cscope" goto FINISH
echo Creating IDs...
mkid --include="text"
rem mkid --include="C C++"
echo Move ID to ./_vimfiles/ID
move /Y ID ".\_vimfiles\ID"
if /I "%2"=="id" goto FINISH

:FINISH
rem =======================================
rem finish process
rem =======================================
echo Finish
echo on


