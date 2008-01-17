doxygen.exe config.cfg
cd ..\dox\html
..\..\doxy_tmpl\hhc.exe index.hhp
cd ..
copy html\index.chm Document.chm
