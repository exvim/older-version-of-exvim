rem  ======================================================================================
rem  File         : make_vs.bat
rem  Author       : Wu Jie 
rem  Last Change  : 10/19/2008 | 11:40:07 AM | Sunday,October
rem  Description  : 
rem  ======================================================================================

rem /////////////////////////////////////////////////////////////////////////////
rem  echos 
rem /////////////////////////////////////////////////////////////////////////////

@echo off
echo Command: %1
echo Solution: %2
echo Configuration: %3
echo Project: %4

rem /////////////////////////////////////////////////////////////////////////////
rem  chooses commands 
rem /////////////////////////////////////////////////////////////////////////////

if "%1"=="Build" goto Build 
if "%1"=="Rebuild" goto Rebuild
if "%1"=="Clean" goto Clean
if "%1"=="" goto Finish

rem /////////////////////////////////////////////////////////////////////////////
rem  Build 
rem /////////////////////////////////////////////////////////////////////////////

:Build
echo Creating Directory...
mkdir .\_vmakes\Logs\BuildLogs
echo %1: %2-%4 %3
if "%4" == "" ( devenv %2 /Build %3 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_vmakes\Logs\BuildLogs\make_vs.err
) else ( 
devenv %2 /Build %3 /Project %4 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_vmakes\Logs\BuildLogs\%4_vs.err
)
goto Finish

rem /////////////////////////////////////////////////////////////////////////////
rem  Rebuild 
rem /////////////////////////////////////////////////////////////////////////////

:Rebuild
echo Creating Directory...
mkdir .\_vmakes\Logs\BuildLogs
echo %1: %2-%4 %3
mkdir .\_vmakes\Logs\BuildLogs
if "%4" == "" ( devenv %2 /Rebuild %3 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_vmakes\Logs\BuildLogs\make_vs.err
) else ( 
devenv %2 /Rebuild %3 /Project %4 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_vmakes\Logs\BuildLogs\%4_vs.err
)
goto Finish

rem /////////////////////////////////////////////////////////////////////////////
rem  Clean 
rem /////////////////////////////////////////////////////////////////////////////

:Clean
echo Creating Directory...
mkdir .\_vmakes\Logs\BuildLogs
echo %1: %2-%4 %3
mkdir .\_vmakes\Logs\BuildLogs
if "%4" == "" ( devenv %2 /Clean %3 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_vmakes\Logs\BuildLogs\make_vs.err
) else ( 
devenv %2 /Clean %3 /Project %4 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_vmakes\Logs\BuildLogs\%4_vs.err
)
goto Finish

rem /////////////////////////////////////////////////////////////////////////////
rem  Finish 
rem /////////////////////////////////////////////////////////////////////////////

:Finish
echo on
