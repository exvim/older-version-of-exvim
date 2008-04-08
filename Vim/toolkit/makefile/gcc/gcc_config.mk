############################################################
## Copyright (C) 2006 Johnny
## ayacai [at] 163 [dot] com
############################################################

# ----------------------------------------------------------
#  System Auto Dectect
# ----------------------------------------------------------
ifeq ($(@shell uname), Linux)
CURRENT_OS := Linux
else
CURRENT_OS := Win32
endif

# ----------------------------------------------------------
#  User Define
# ----------------------------------------------------------

# Configuration Name
# parameter: Debug
# 			 Release
# 			 Final
# 			 All
Configuration = Debug


# Platform Name
# parameter: Linux
# 			 Win32
# 			 PS3
# 			 All
Platform = Win32


# Compile Mode
# parameter: Safe
# 		     Fast
CompileMode = Fast

# ----------------------------------------------------------
#  C/Cpp Compiler & Linker Choose 
# ----------------------------------------------------------

# Compiler
# parameter: g++ 			( gcc_version_3 )
#  			 g++-sjlj 		( gcc_version_4 compiled by sjlj )
# 			 ppu-lv2-g++ 	( gcc_ps3 )
# 			 cl 			( msvc )
CPP_COMPILER_WIN32=g++-sjlj
CPP_COMPILER_LINUX=g++-sjlj
CPP_COMPILER_PS3=ppu-lv2-g++

# Linker
# parameter: ar 			( archive )
#  			 ld 			( gcc linker )
# 			 ppu-lv2-ar 	( ps3 linker )
# 			 link 			( msvc linker )
CPP_LINKER_WIN32=ar
CPP_LINKER_LINUX=ar
CPP_LINKER_PS3=ppu-lv2-ar

# ----------------------------------------------------------
#  Machine built-in functions
# ----------------------------------------------------------

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

# ----------------------------------------------------------
#  Advance User Define
# ----------------------------------------------------------

# Choose the shell
SHELL := /bin/sh

# Make Debug
SILENT_CMD := @

# Make Silent
ifeq ($(SILENT_CMD),@)
SILENT_MK := --silent
else
SILENT_MK :=
endif

# Executable File Name
# Choose the compiler
# Choose the linker
ifeq ($(Platform),Win32)
EXE_NAME := exe
CC := $(SILENT_CMD)$(CPP_COMPILER_WIN32)
AR := $(SILENT_CMD)$(CPP_LINKER_WIN32)
else
ifeq ($(Platform),Linux)
EXE_NAME := exe
CC := $(SILENT_CMD)$(CPP_COMPILER_LINUX)
AR := $(SILENT_CMD)$(CPP_LINKER_LINUX)
else
ifeq ($(Platform),PS3)
EXE_NAME := elf
CC := $(SILENT_CMD)$(CPP_COMPILER_PS3)
AR := $(SILENT_CMD)$(CPP_LINKER_PS3)
else #default
EXE_NAME := exe
CC := $(SILENT_CMD)g++
AR := $(SILENT_CMD)ar
endif
endif
endif

# General Commands
ECHO := $(SILENT_CMD)echo
SMAKE := $(SILENT_CMD)$(MAKE) $(SILENT_MK)

# Command Path Choose
ifeq ($(CURRENT_OS),Linux)
CMD_PATH_LINUX :=
else
CMD_PATH_LINUX := $(EX_DEV)/msys/1.0/bin/
endif

# Linux Commands
RM := $(SILENT_CMD)$(CMD_PATH_LINUX)rm -f
RMDIR := $(SILENT_CMD)$(CMD_PATH_LINUX)rmdir
MKDIR := $(SILENT_CMD)$(CMD_PATH_LINUX)mkdir -p
CAT := $(SILENT_CMD)$(CMD_PATH_LINUX)cat

# Windows Commands
DEVENV := $(SILENT_CMD)devenv
CLS := $(SILENT_CMD)cls # this is the dos command, temp exist here
COPY := $(SILENT_CMD)copy

# After Build Even
AFTER_BUILD = # programme after target been built, this is the project specific one (sample: make_fself $(@) $(basename $(@)).self)
