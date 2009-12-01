@echo off

rem  ======================================================================================
rem  File         : iconv_big5-to-gb.bat
rem  Author       : Wu Jie 
rem  Last Change  : 10/19/2008 | 15:26:58 PM | Sunday,October
rem  Description  : 
rem  ======================================================================================

rem  ------------------------------------------------------------------ 
rem  Desc: 
rem  ------------------------------------------------------------------ 

for /R %1 %%i in (*.srt) do ( 
        echo Converting %%i... 
        iconv -c -f BIG5 -t GB18030 "%%i" > "%%i.cov" )
goto Finish

:Finish
echo on
