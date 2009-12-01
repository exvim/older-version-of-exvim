# Copyright (C) 2006 Johnny
# ayacai [at] 163 [dot] com

# ----------------------------------------------------------
#  User Define
# ----------------------------------------------------------

# Configuration Name
# parameter: Debug
# 			 Release
# 			 All
Configuration = Debug


# Configuration Name
# parameter: Linux
# 			 Win32
# 			 All
Platform = Linux


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

# Choose the compiler
CC := $(SILENT_CMD)g++
# Choose the linker
AR := $(SILENT_CMD)ar

# General Commands
ECHO := $(SILENT_CMD)echo
SMAKE := $(SILENT_CMD)$(MAKE) $(SILENT_MK)

# Linux Commands
RM := $(SILENT_CMD)rm -f
RMDIR := $(SILENT_CMD)rmdir
MKDIR := $(SILENT_CMD)mkdir -p
CAT := $(SILENT_CMD)cat

# Windows Commands
DEVENV := $(SILENT_CMD)devenv
CLS := $(SILENT_CMD)cls # this is the dos command, temp exist here
COPY := $(SILENT_CMD)copy

