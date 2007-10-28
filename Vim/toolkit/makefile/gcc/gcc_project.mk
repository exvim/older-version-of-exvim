############################################################
## Copyright (C) 2006 Johnny
## ayacai [at] 163 [dot] com
############################################################

# ----------------------------------------------------------
#  Global Configuration
# ----------------------------------------------------------
# include general config
include ../gcc_config.mk

# ----------------------------------------------------------
#  User Define
# ----------------------------------------------------------

# Parent Working Directory
PWD := # relative-address (sample: ..)

# Project Name
Project := # current directory name
ProjectType := # choose: a,lib,so,dll,exe

# Include Path
IncDirs += # relative-address (sample: ./Incs)

# Precompiled Headers Dependence Headers
FullPath_GchSrcs += # relative-address/header-file-name (sample: ./Incs/gch-header.h)

# Source Path
SrcDirs += # relative-address (sample: ./Srcs)

# Dependent Library File Paths
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
PWD ?= ..

# After Build Even
AFTER_BUILD = # programme after target been built, this is the project specific one (sample: make_fself $(@) $(basename $(@)).self)

# ----------------------------------------------------------
#  Rules
# ----------------------------------------------------------

include ../gcc_rule.mk
