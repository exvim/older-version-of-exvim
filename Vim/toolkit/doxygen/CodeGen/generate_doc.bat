doxygen.exe config.cfg
copy logo.gif .\doc\html\logo.gif
cd .\doc\html
..\..\hhc.exe index.hhp
cd ..
copy html\index.chm Document.chm
