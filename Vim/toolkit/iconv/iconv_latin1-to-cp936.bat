rem  ======================================================================================
rem  File         : iconv_latin1-to-cp936.bat
rem  Author       : Wu Jie 
rem  Last Change  : 10/19/2008 | 15:27:09 PM | Sunday,October
rem  Description  : 
rem  ======================================================================================

rem  ------------------------------------------------------------------ 
rem  Desc: 
rem  ------------------------------------------------------------------ 

echo off
for /R %1 %%i in (*.c *.cpp *.cxx *.c++ *.C *.h *.H *.hh *.hxx *.hpp *.inl *.uc *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.txt) do ( 
        echo Converting %%i... 
        iconv -c -f latin1 -t cp936 "%%i" > "%%i.cov"
        move "%%i.cov" "%%i" )
goto Finish
:Finish
echo on
