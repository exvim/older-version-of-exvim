############################################################
## Copyright (C) 2006 Johnny
## ayacai [at] 163 [dot] com
############################################################

# ----------------------------------------------------------
#  System Auto Dectect
# ----------------------------------------------------------
CURRENT_OS := Win32

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
# 			 Xenon
# 			 PS3
# 			 All
Platform = Win32

# Compiler
# parameter: msvc2003
# 			 msvc2005
# 			 msvc2008
Compiler = msvc2005

# ----------------------------------------------------------
#  Advance User Define
# ----------------------------------------------------------

# Make Debug
SILENT_CMD := @

# Make Silent
ifeq ($(SILENT_CMD),@)
SILENT_MK := --silent
else
SILENT_MK :=
endif

# General Commands
ECHO := $(SILENT_CMD)echo
SMAKE := $(SILENT_CMD)$(MAKE) $(SILENT_MK)

# Command Path Choose
CMD_PATH_WINDOWS := $(EX_DEV)/msys/1.0/bin/
VC_PATH_WINDOWS := d:/Program Files/Microsoft Visual Studio 8/Common7/IDE/

# System Commands
RM := $(SILENT_CMD)$(CMD_PATH_WINDOWS)rm -f
RMDIR := $(SILENT_CMD)$(CMD_PATH_WINDOWS)rmdir
MKDIR := $(SILENT_CMD)$(CMD_PATH_WINDOWS)mkdir -p
CAT := $(SILENT_CMD)$(CMD_PATH_WINDOWS)cat
CLS := $(SILENT_CMD)cls # this is the dos command, temp exist here
COPY := $(SILENT_CMD)copy

# VC Commands
DEVENV := $(SILENT_CMD)"$(VC_PATH_WINDOWS)devenv"

# Post Build Even for all project
define POST_BUILD_ALL_PROJECT
$(ECHO) Post Build...
endef
