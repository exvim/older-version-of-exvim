@echo off
echo Command: %1
echo Solution: %2
echo Configuration: %3
echo Project: %4

if "%1"=="Build" goto Build 
if "%1"=="Rebuild" goto Rebuild
if "%1"=="Clean" goto Clean
if "%1"=="" goto Finish

:Build
echo Creating Directory...
mkdir .\_makes\Logs\BuildLogs
echo %1: %2-%4 %3
if "%4" == "" ( devenv %2 /Build %3 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_makes\Logs\BuildLogs\make_vs.err
) else ( 
devenv %2 /Build %3 /Project %4 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_makes\Logs\BuildLogs\%4_vs.err
)
goto Finish

:Rebuild
echo Creating Directory...
mkdir .\_makes\Logs\BuildLogs
echo %1: %2-%4 %3
mkdir .\_makes\Logs\BuildLogs
if "%4" == "" ( devenv %2 /Rebuild %3 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_makes\Logs\BuildLogs\make_vs.err
) else ( 
devenv %2 /Rebuild %3 /Project %4 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_makes\Logs\BuildLogs\%4_vs.err
)
goto Finish

:Clean
echo Creating Directory...
mkdir .\_makes\Logs\BuildLogs
echo %1: %2-%4 %3
mkdir .\_makes\Logs\BuildLogs
if "%4" == "" ( devenv %2 /Clean %3 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_makes\Logs\BuildLogs\make_vs.err
) else ( 
devenv %2 /Clean %3 /Project %4 | gawk -f "c:\Program Files\Vim\make\gawk\prg_ConvertLog.awk" > .\_makes\Logs\BuildLogs\%4_vs.err
)
goto Finish

:Finish
echo on
