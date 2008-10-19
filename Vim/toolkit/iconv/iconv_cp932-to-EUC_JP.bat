@echo off

rem  ======================================================================================
rem  File         : iconv_cp932-to-EUC_JP.bat
rem  Author       : Wu Jie 
rem  Last Change  : 10/19/2008 | 15:27:03 PM | Sunday,October
rem  Description  : 
rem  ======================================================================================

rem  ------------------------------------------------------------------ 
rem  Desc: 
rem  ------------------------------------------------------------------ 

for /R %1 %%i in (*.log *.cue *.txt) do ( 
        echo Converting %%i... 
        iconv -c -f cp932 -t EUC-JP "%%i" > "%%i.cov"
        move "%%i.cov" "%%i" )
goto Finish

:Finish
echo on
