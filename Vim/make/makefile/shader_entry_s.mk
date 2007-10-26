############################################################
## Copyright (C) 2006 Johnny
## ayacai [at] 163 [dot] com
############################################################

# ----------------------------------------------------------
#  Global Configuration
# ----------------------------------------------------------
# include general config
include shader_config.mk

# ----------------------------------------------------------
#  User Define
# ----------------------------------------------------------

# Parent Working Directory
PWD := .

# Project Name
Project := # current directory name

# Include Path
IncDirs += .
IncDirs += # relative-address (sample: ./Incs)

# Source Path
SrcDirs += .
SrcDirs += # relative-address (sample: ./Srcs)

# Special Flags
# Some space-depent directory flag can't generate automatically, use this instead
CFlag_Spec += # (sample: -I"C:/Program Files/Microsoft DirectX SDK/Include")

# ----------------------------------------------------------
#  Shader Entrypoint Name
# ----------------------------------------------------------

# VS Entrypoint Name
VS_ENTRY=VS_Main

# PS Entrypoint Name
PS_ENTRY=PS_Main

# GS Entrypoint Name
GS_ENTRY=GS_Main

# FX Entrypoint Name
FX_ENTRY=FX_Main

# ----------------------------------------------------------
#  Addvance User Define
# ----------------------------------------------------------

# Parent Working Directory
PWD ?= .

# ----------------------------------------------------------
#  Rules
# ----------------------------------------------------------

include shader_rule.mk
