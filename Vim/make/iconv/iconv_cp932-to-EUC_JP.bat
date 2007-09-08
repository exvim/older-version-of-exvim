echo off
for /R %1 %%i in (*.log *.cue *.txt) do ( 
        echo Converting %%i... 
        iconv -c -f cp932 -t EUC-JP "%%i" > "%%i.cov"
        copy "%%i.cov" "%%i"
        del "%%i.cov" )
goto Finish
:Finish
echo on
