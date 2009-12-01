
rem  ======================================================================================
rem  File         : exCompileVim.bat
rem  Author       : Wu Jie 
rem  Last Change  : 10/25/2008 | 10:46:30 AM | Saturday,October
rem  Description  : 
rem  ======================================================================================

rem /////////////////////////////////////////////////////////////////////////////
rem  prepare 
rem /////////////////////////////////////////////////////////////////////////////

@echo copy vcvars32.bat
vcvars32.bat

rem /////////////////////////////////////////////////////////////////////////////
rem  compile 
rem /////////////////////////////////////////////////////////////////////////////


@echo compile vim ... 
nmake -f Make_mvc.mak clean
nmake -f Make_mvc.mak GUI=yes PYTHON=d:\exDev\Python25 DYNAMIC_PYTHON=YES PYTHON_VER=25
rem  nmake -f Make_mvc.mak GUI=yes PYTHON=d:\exDev\Python26 DYNAMIC_PYTHON=YES PYTHON_VER=26
