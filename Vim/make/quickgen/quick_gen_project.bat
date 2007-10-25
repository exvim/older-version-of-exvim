@echo off

rem preprocess arguments
set LANGTYPE=ALL
set FILEFILTER="*.c *.cpp *.cxx *.h *.hpp *.inl *.uc *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd"
if /I "%1"=="all" goto START
if /I "%1"=="c" goto C_ONLY
if /I "%1"=="cpp" goto CPP_ONLY
if /I "%1"=="general" goto GENERAL
if /I "%1"=="vim" goto VIM

rem c-only settings
:C_ONLY
set LANGTYPE=C_ONLY
set FILEFILTER="*.c *.h" 
goto START

rem cpp-only settings
:CPP_ONLY
set LANGTYPE=CPP_ONLY
set FILEFILTER="*.cpp *.cxx *.h *.hpp *.inl" 
goto START

rem cstyle settings
:GENERAL
set LANGTYPE=GENERAL
set FILEFILTER=*.c *.cpp *.cxx *.h *.hpp *.inl *.uc *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd
goto START

rem vim settings
:VIM
set LANGTYPE=VIM
set FILEFILTER="*.vim" 
goto START

:START
rem start generate
echo Generate %LANGTYPE% Project

:MKDIR
rem create directory first
echo Create Diretory: _vimfiles
mkdir _vimfiles

rem choose the generate mode
if /I "%2"=="" goto TAG
if /I "%2"=="tag" goto TAG
if /I "%2"=="symbol" goto SYMBOL
if /I "%2"=="cscope" goto CSCOPE
if /I "%2"=="id" goto ID

:TAG
rem create tags
echo Creating Tags...
if /I "%LANGTYPE%"=="C_ONLY" ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c --langmap=c++:+.inl
if /I "%LANGTYPE%"=="CPP_ONLY" ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ --langmap=c++:+.inl
if /I "%LANGTYPE%"=="GENERAL" ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++ --langmap=c++:+.inl
if /I "%LANGTYPE%"=="VIM" ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=vim
if /I "%LANGTYPE%"=="ALL" ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q
move /Y ".\_tags" ".\tags"
if /I "%2"=="tag" goto FINISH

:SYMBOL
rem create symbols
echo Creating Symbols...
gawk -f "c:\Program Files\Vim\make\gawk\prg_NoStripSymbol.awk" ./tags>./_vimfiles/_symbol
move /Y ".\_vimfiles\_symbol" ".\_vimfiles\symbol"
if /I "%2"=="symbol" goto FINISH

:CSCOPE
rem create cscope files
echo Creating cscope.files...
dir /s /b %FILEFILTER%|sed "s,\(.*\),\"\1\",g" > cscope.files
echo Creating cscope.out...
cscope -b
move /Y cscope.files ".\_vimfiles\cscope.files"
move /Y cscope.out ".\_vimfiles\cscope.out"
if /I "%2"=="cscope" goto FINISH

:ID
rem create IDs
echo Creating IDs...
mkid --include="text"
rem mkid --include="C C++"
echo Move ID to ./_vimfiles/ID
move /Y ID ".\_vimfiles\ID"
if /I "%2"=="id" goto FINISH

:FINISH
rem finish process
echo Finish
echo on


