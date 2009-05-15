@echo off

rem  ======================================================================================
rem  File         : quick_gen_project_all.bat
rem  Author       : Wu Jie 
rem  Last Change  : 10/19/2008 | 15:31:29 PM | Sunday,October
rem  Description  : 
rem  ======================================================================================

rem  ------------------------------------------------------------------ 
rem  Desc: 
rem  ------------------------------------------------------------------ 

set lang_type=all
set vimfiles_path=_vimfiles

set file_filter=*.c *.cpp *.cxx *.c++ *.cc *.h *.hh *.hxx *.hpp *.inl *.cs *.uc *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.glsl *.py *.pyw *.vim *.awk *.m *.dox *.doxygen *.ini *.cfg *.wiki *.mk *.err *.exe *.bat *.sh *.txt
set dir_filter=
set cwd=%~pd0

set support_inherit=true
set support_cscope=true

"%EX_DEV%\Vim\toolkit\quickgen\batch\quick_gen_project.bat" %1

echo on
