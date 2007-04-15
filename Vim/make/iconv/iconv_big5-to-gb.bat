echo off
for /R %1 %%i in (*.srt) do ( 
        echo Converting %%i... 
        iconv -c -f BIG5 -t GB18030 "%%i" > "%%i.cov" )
goto Finish
:Finish
echo on
