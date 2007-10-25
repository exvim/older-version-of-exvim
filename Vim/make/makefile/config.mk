# Copyright (C) 2006 Johnny
# ayacai [at] 163 [dot] com

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
# 			 FinalRelease
# 			 All
Configuration = Debug


# Platform Name
# parameter: Linux
# 			 Win32
# 			 Xenon
# 			 PS3
# 			 All
Platform = Win32


# Compile Mode
# parameter: Safe
# 		     Fast
CompileMode = Fast

# ----------------------------------------------------------
#  Compiler & Linker Choose 
# ----------------------------------------------------------

# Compiler
# parameter: g++ 			( gcc_version_3 )
#  			 g++-sjlj 		( gcc_version_4 compiled by sjlj )
# 			 ppu-lv2-g++ 	( gcc_ps3 )
# 			 cl 			( msvc )
COMPILER_WIN32=g++-sjlj
COMPILER_LINUX=g++-sjlj
COMPILER_XENON=g++-sjlj
COMPILER_PS3=ppu-lv2-g++

# Linker
# parameter: ar 			( archive )
#  			 ld 			( gcc linker )
# 			 ppu-lv2-ar 	( ps3 linker )
# 			 link 			( msvc linker )
LINKER_WIN32=ar
LINKER_LINUX=ar
LINKER_XENON=ar
LINKER_PS3=ppu-lv2-ar

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
CC := $(SILENT_CMD)$(COMPILER_WIN32)
AR := $(SILENT_CMD)$(LINKER_WIN32)
else
ifeq ($(Platform),Linux)
EXE_NAME := exe
CC := $(SILENT_CMD)$(COMPILER_LINUX)
AR := $(SILENT_CMD)$(LINKER_LINUX)
else
ifeq ($(Platform),Xenon)
EXE_NAME := xex
CC := $(SILENT_CMD)$(COMPILER_XENON)
AR := $(SILENT_CMD)$(LINKER_XENON)
else
ifeq ($(Platform),PS3)
EXE_NAME := elf
CC := $(SILENT_CMD)$(COMPILER_PS3)
AR := $(SILENT_CMD)$(LINKER_PS3)
else #default
EXE_NAME := exe
CC := $(SILENT_CMD)g++
AR := $(SILENT_CMD)ar
endif
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
CMD_PATH_LINUX := c:/msys/1.0/bin/
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
