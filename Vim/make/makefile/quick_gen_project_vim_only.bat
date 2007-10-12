@echo off
: MakeDir
echo Create Diretory: _vimfiles
mkdir _vimfiles

: tags
echo Creating Tags...
ctags -o./tags -R  --fields=+iaS --extra=+q --languages=vim -I

: symbol
echo Creating Symbols...
gawk -f "c:\Program Files\Vim\make\gawk\prg_NoStripSymbol.awk" ./tags>./_vimfiles/symbol

: ID
echo Creating IDs...
mkid --include="text"
rem mkid --include="C C++"
echo Move ID to ./_vimfiles/ID
move ID "./_vimfiles/ID"

:Finish
echo Finish

echo on


