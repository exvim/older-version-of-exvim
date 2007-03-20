@echo off
rem -- Run Vim --

set VIM_EXE_DIR=C:\Program Files\Vim\vim70
if exist "%VIM%\vim70\gvim.exe" set VIM_EXE_DIR=%VIM%\vim70
if exist "%VIMRUNTIME%\gvim.exe" set VIM_EXE_DIR=%VIMRUNTIME%

if exist "%VIM_EXE_DIR%\gvim.exe" goto havevim
echo "%VIM_EXE_DIR%\gvim.exe" not found
goto eof

:havevim
rem collect the arguments in VIMARGS for Win95
set VIMARGS=
set VIMNOFORK=
:loopstart
if .%1==. goto loopend
if NOT .%1==.-f goto noforkarg
set VIMNOFORK=1
:noforkarg
set VIMARGS=%VIMARGS% %1
shift
goto loopstart
:loopend

if .%OS%==.Windows_NT goto ntaction

if .%VIMNOFORK%==.1 goto nofork
start "%VIM_EXE_DIR%\gvim.exe" -y %VIMARGS%
goto eof

:nofork
start /w "%VIM_EXE_DIR%\gvim.exe" -y %VIMARGS%
goto eof

:ntaction
rem for WinNT we can use %*
if .%VIMNOFORK%==.1 goto noforknt
start "dummy" /b "%VIM_EXE_DIR%\gvim.exe" -y %*
goto eof

:noforknt
start "dummy" /b /wait "%VIM_EXE_DIR%\gvim.exe" -y %*

:eof
set VIMARGS=
set VIMNOFORK=
