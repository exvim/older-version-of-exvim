@echo off
: MakeDir
echo Create Diretory: _vimfiles
mkdir _vimfiles

: tags
echo Creating Tags...
ctags -o./tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ --langmap=c++:+.inl -I

: symbol
echo Creating Symbols...
gawk -f "c:\Program Files\Vim\make\gawk\prg_NoStripSymbol.awk" ./tags>./_vimfiles/symbol

: ID
echo Creating IDs...
mkid --include="text"
rem mkid --include="C C++"
echo Copy ID to ./_vimfiles/ID
copy ID "./_vimfiles/ID"
echo Delete ./ID
del ID

:Finish
echo Finish

echo on


