echo off
for /D /R %1 %%i in (.svn) do ( 
        echo delete directory %%i... 
        rmdir /S /Q %%i
        )       
goto Finish
:Finish
echo on
