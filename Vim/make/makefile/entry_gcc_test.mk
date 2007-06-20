# Copyright (C) 2006 Johnny
# ayacai [at] 163 [dot] com

# ----------------------------------------------------------
#  Global Configuration
# ----------------------------------------------------------
# include general config
include config.mk

# ----------------------------------------------------------
#  User Define
# ----------------------------------------------------------

# Parent Working Directory
PWD := .

# Project Name
Project := Test
ProjectType := exe

# Include Path
IncDirs += .

# Precompiled Headers Dependence Headers
FullPath_PchDeps += # relative-address/header-file-name (sample: ./Incs/pch-header.h)

# Source Path
SrcDirs += .

# Dependent Libaray File Paths
LibDirs += # relative-address (sample: ../Third-Part-Libs)

# Dependent Library File Names
PrjLibs += # lib-file-name (sample: libSDK.a-->SDK) This is libs for project compile depence
ExtLibs += # lib-file-name (sample: libSDK.a-->SDK) This is libs for external libaraies

# Special Flags
# Some space-depent directory flag can't generate automatically, use this instead
CFlag_Spec += # (sample: -I"C:/Program Files/Microsoft DirectX SDK/Include")
LFlag_Spec += # (sample: -L"C:/Program Files/Microsoft DirectX SDK/Lib/x86")

# ----------------------------------------------------------
#  Addvance User Define
# ----------------------------------------------------------

# Parent Working Directory
PWD ?= .

# ----------------------------------------------------------
#  Rules
# ----------------------------------------------------------

include rule.mk
