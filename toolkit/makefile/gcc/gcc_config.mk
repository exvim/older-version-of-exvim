#  ======================================================================================
#  File         : gcc_config.mk
#  Author       : Wu Jie 
#  Last Change  : 10/19/2008 | 11:06:21 AM | Sunday,October
#  Description  : 
#  ======================================================================================

# /////////////////////////////////////////////////////////////////////////////
#  System Auto Dectect
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: current OS
#  parameter: Win32
#  			  Linux
#  ------------------------------------------------------------------ 

CURRENT_OS := Win32

# /////////////////////////////////////////////////////////////////////////////
#  User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Configuration Name
#  parameter: Debug
# 			  Release
# 			  Final
# 			  All
#  ------------------------------------------------------------------ 

Configuration = Debug

#  ------------------------------------------------------------------ 
#  Desc: Platform Name
#  parameter: Linux
#  			  Win32
#  			  PS3
#  			  All
#  ------------------------------------------------------------------ 

Platform = Win32

#  ------------------------------------------------------------------ 
#  Desc: Compile Mode
#  parameter: Safe
# 		      Fast
#  ------------------------------------------------------------------ 

CompileMode = Fast

# /////////////////////////////////////////////////////////////////////////////
#  C/Cpp Compiler & Linker Choose 
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Compiler
#  parameter: g++ 			( gcc_version_3 )
#  			  g++-sjlj 		( gcc_version_4 compiled by sjlj )
# 			  ppu-lv2-g++ 	( gcc_ps3 )
# 			  cl 			( msvc )
#  ------------------------------------------------------------------ 

CPP_COMPILER_WIN32=g++
CPP_COMPILER_LINUX=g++
CPP_COMPILER_PS3=ppu-lv2-g++

#  ------------------------------------------------------------------ 
#  Desc: Linker
#  parameter: ar 			( archive )
#  			  ld 			( gcc linker )
# 			  ppu-lv2-ar 	( ps3 linker )
# 			  link 			( msvc linker )
#  ------------------------------------------------------------------ 

CPP_LINKER_WIN32=ar
CPP_LINKER_LINUX=ar
CPP_LINKER_PS3=ppu-lv2-ar

# /////////////////////////////////////////////////////////////////////////////
#  Machine built-in functions
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: 
#  ------------------------------------------------------------------ 

ifeq ($(Platform),Win32) # x86
USE_MMX := 1
USE_SSE := 1
USE_SSE3 := 1
else
ifeq ($(Platform),Linux) # x86
USE_MMX := 1
USE_SSE := 1
USE_SSE3 := 1
else
ifeq ($(Platform),PS3) # power pc
USE_MMX := 0
USE_SSE := 0
USE_SSE3 := 0
else #default
USE_MMX := 1
USE_SSE := 1
USE_SSE3 := 1
endif
endif
endif

# /////////////////////////////////////////////////////////////////////////////
#  Advance User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Choose the shell
#  ------------------------------------------------------------------ 

SHELL := /bin/sh

#  ------------------------------------------------------------------ 
#  Desc: Make Debug
#  ------------------------------------------------------------------ 

SILENT_CMD := @

#  ------------------------------------------------------------------ 
#  Desc: Make Silent
#  ------------------------------------------------------------------ 

ifeq ($(SILENT_CMD),@)
SILENT_MK := --silent
else
SILENT_MK :=
endif

#  ------------------------------------------------------------------ 
#  Desc: platform dependence variables
#  EXE_NAME: Choose the execute name
#  CC: Choose the compiler
#  AR: Choose the linker
#  ------------------------------------------------------------------ 

ifeq ($(Platform),Win32)
EXE_NAME := exe
LIB_NAME := a
DLL_NAME := dll
CC := $(SILENT_CMD)$(CPP_COMPILER_WIN32)
AR := $(SILENT_CMD)$(CPP_LINKER_WIN32)
else
ifeq ($(Platform),Linux)
EXE_NAME := run
LIB_NAME := a
DLL_NAME := so
CC := $(SILENT_CMD)$(CPP_COMPILER_LINUX)
AR := $(SILENT_CMD)$(CPP_LINKER_LINUX)
else
ifeq ($(Platform),PS3)
EXE_NAME := elf
LIB_NAME := a
DLL_NAME := so
CC := $(SILENT_CMD)$(CPP_COMPILER_PS3)
AR := $(SILENT_CMD)$(CPP_LINKER_PS3)
else #default
EXE_NAME := exe
LIB_NAME := lib
DLL_NAME := dll
CC := $(SILENT_CMD)g++
AR := $(SILENT_CMD)ar
endif
endif
endif

#  ------------------------------------------------------------------ 
#  Desc: General Commands
#  ------------------------------------------------------------------ 

ECHO := $(SILENT_CMD)echo
SMAKE := $(SILENT_CMD)$(MAKE) $(SILENT_MK)

#  ------------------------------------------------------------------ 
#  Desc: OS dependence command
#  ------------------------------------------------------------------ 

ifeq ($(CURRENT_OS),Linux)
CMD_PATH_LINUX :=
ECHO_EMPTY_LINE := $(ECHO)
VERTICAL_BAR := "|"
else
CMD_PATH_LINUX := $(EX_DEV)/tools/msys/1.0/bin/
ECHO_EMPTY_LINE := $(ECHO).
VERTICAL_BAR := ^|
endif

#  ------------------------------------------------------------------ 
#  Desc: Linux Commands
#  ------------------------------------------------------------------ 

RM := $(SILENT_CMD)$(CMD_PATH_LINUX)rm -f
RMDIR := $(SILENT_CMD)$(CMD_PATH_LINUX)rmdir
MKDIR := $(SILENT_CMD)$(CMD_PATH_LINUX)mkdir -p
CAT := $(SILENT_CMD)$(CMD_PATH_LINUX)cat

#  ------------------------------------------------------------------ 
#  Desc: Windows Commands
#  ------------------------------------------------------------------ 

DEVENV := $(SILENT_CMD)devenv
CLS := $(SILENT_CMD)cls # this is the dos command, temp exist here
COPY := $(SILENT_CMD)copy

# /////////////////////////////////////////////////////////////////////////////
# Post Build Even for all project
# /////////////////////////////////////////////////////////////////////////////

define POST_BUILD_ALL_PROJECT
$(ECHO) Post Build...
endef
