@echo off

rem  ======================================================================================
rem  File         : quick_gen_project_custom.bat
rem  Author       : Wu Jie 
rem  Last Change  : 05/17/2009 | 12:00:27 PM | Sunday,May
rem  Description  : 
rem  ======================================================================================

rem /////////////////////////////////////////////////////////////////////////////
rem general 
rem /////////////////////////////////////////////////////////////////////////////

set cwd=%~pd0
set lang_type=c cpp c# uc shader python vim math
set vimfiles_path=_vimfiles
set file_filter=*.c *.cpp *.cxx *.c++ *.C *.cc *.h *.H *.hh *.hxx *.hpp *.inl *.cs *.uc *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.glsl *.py *.pyw *.vim *.awk *.m *.dox *.doxygen *.ini *.cfg *.wiki *.mk *.err *.exe *.bat *.sh 
set dir_filter=

rem /////////////////////////////////////////////////////////////////////////////
rem support 
rem /////////////////////////////////////////////////////////////////////////////

set support_filenamelist=true
set support_ctags=true
set support_symbol=true
set support_inherit=true
set support_cscope=true
set support_idutils=true

rem /////////////////////////////////////////////////////////////////////////////
rem  options
rem /////////////////////////////////////////////////////////////////////////////

set ctags_options= --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,c,python,vim,math,uc, --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd,

rem /////////////////////////////////////////////////////////////////////////////
rem  main
rem /////////////////////////////////////////////////////////////////////////////

"%EX_DEV%\vim\toolkit\quickgen\batch\quick_gen_project.bat" %1

echo on
