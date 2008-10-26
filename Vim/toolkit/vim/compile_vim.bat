@echo off

rem  ======================================================================================
rem  File         : compile_vim.bat
rem  Author       : Wu Jie 
rem  Last Change  : 10/25/2008 | 10:47:34 AM | Saturday,October
rem  Description  : copy this file in vim/vimXX/src/ then run it. 
rem  ======================================================================================

rem /////////////////////////////////////////////////////////////////////////////
rem  prepare 
rem /////////////////////////////////////////////////////////////////////////////

@echo copy vcvars32.bat
vcvars32.bat

rem /////////////////////////////////////////////////////////////////////////////
rem  clean first 
rem /////////////////////////////////////////////////////////////////////////////

@echo clean compiled-vim ... 
nmake -f Make_mvc.mak clean

rem /////////////////////////////////////////////////////////////////////////////
rem  compile 
rem /////////////////////////////////////////////////////////////////////////////

echo on

@echo compile vim ... 
rem nmake -f Make_mvc.mak GUI=yes PYTHON=d:exDev\Python25 DYNAMIC_PYTHON=YES PYTHON_VER=25
nmake -f Make_mvc.mak GUI=yes PYTHON=d:exDev\Python26 DYNAMIC_PYTHON=YES PYTHON_VER=26


