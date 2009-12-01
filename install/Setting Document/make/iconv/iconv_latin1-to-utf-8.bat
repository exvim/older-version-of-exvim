echo off
for /R %1 %%i in (*.c *.cpp *.h *.txt) do ( 
        echo Converting %%i... 
        iconv -c -f latin1 -t utf-8 "%%i" > "%%i.cov"
        copy "%%i.cov" "%%i"
        del "%%i.cov" )
goto Finish
:Finish
echo on
