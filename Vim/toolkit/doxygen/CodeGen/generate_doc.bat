rem  ======================================================================================
rem  File         : generate_doc.bat
rem  Author       : Wu Jie 
rem  Last Change  : 10/19/2008 | 15:24:49 PM | Sunday,October
rem  Description  : 
rem  ======================================================================================

rem  ------------------------------------------------------------------ 
rem  Desc: 
rem  ------------------------------------------------------------------ 

doxygen.exe config.cfg
copy logo.gif .\doc\html\logo.gif
cd .\doc\html
..\..\hhc.exe index.hhp
cd ..
copy html\index.chm Document.chm
