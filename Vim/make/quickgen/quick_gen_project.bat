@echo off

rem preprocess arguments
set LANGTYPE=ALL
set FILEFILTER="*.c *.cpp *.cxx *.h *.hpp *.inl *.uc *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd"
if /I "%1"=="" goto START
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

:TAG
rem create tags
echo Creating Tags...
if /I "%LANGTYPE%"=="C_ONLY" ctags -o./tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c --langmap=c++:+.inl
if /I "%LANGTYPE%"=="CPP_ONLY" ctags -o./tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ --langmap=c++:+.inl
if /I "%LANGTYPE%"=="GENERAL" ctags -o./tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++ --langmap=c++:+.inl
if /I "%LANGTYPE%"=="VIM" ctags -o./tags -R  --fields=+iaS --extra=+q --languages=vim
if /I "%LANGTYPE%"=="ALL" ctags -o./tags -R --c++-kinds=+p --fields=+iaS --extra=+q

:SYMBOL
rem create symbols
echo Creating Symbols...
gawk -f "c:\Program Files\Vim\make\gawk\prg_NoStripSymbol.awk" ./tags>./_vimfiles/symbol

:ID
rem create IDs
echo Creating IDs...
mkid --include="text"
rem mkid --include="C C++"
echo Move ID to ./_vimfiles/ID
move ID "./_vimfiles/ID"

:CSCOPE
rem create cscope files
echo Creating cscope.files...
dir /s /b %FILEFILTER% > cscope.files
echo Creating cscope.out...
cscope -b
move cscope.files "./_vimfiles/cscope.files"
move cscope.out "./_vimfiles/cscope.out"

:FINISH
rem finish process
echo Finish
echo on


