echo off
for /R %1 %%i in (*.log *.cue *.txt) do ( 
        echo Converting %%i... 
        iconv -c -f cp932 -t EUC-JP "%%i" > "%%i.cov"
        move "%%i.cov" "%%i" )
goto Finish
:Finish
echo on
