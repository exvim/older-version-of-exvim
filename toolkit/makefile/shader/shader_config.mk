#  ======================================================================================
#  File         : shader_config.mk
#  Author       : Wu Jie 
#  Last Change  : 10/19/2008 | 13:50:00 PM | Sunday,October
#  Description  : 
#  ======================================================================================

# /////////////////////////////////////////////////////////////////////////////
#  System Auto Dectect
# /////////////////////////////////////////////////////////////////////////////

ifeq ($(@shell uname), Linux)
CURRENT_OS := Linux
else
CURRENT_OS := Win32
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
#  Desc: General Commands
#  ------------------------------------------------------------------ 

ECHO := $(SILENT_CMD)echo
SMAKE := $(SILENT_CMD)$(MAKE) $(SILENT_MK)

#  ------------------------------------------------------------------ 
#  Desc: Command Path Choose
#  ------------------------------------------------------------------ 

ifeq ($(CURRENT_OS),Linux)
CMD_PATH_LINUX :=
else
CMD_PATH_LINUX := $(EX_DEV)/tools/msys/1.0/bin/
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

CLS := $(SILENT_CMD)cls # this is the dos command, temp exist here
COPY := $(SILENT_CMD)copy

# /////////////////////////////////////////////////////////////////////////////
#  User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Configuration Name
# 	parameter: Debug
# 			   Release
# 			   FinalRelease
# 			   All
#  ------------------------------------------------------------------ 

SHADER_Configuration = Debug

#  ------------------------------------------------------------------ 
#  Desc: Platform Name
# 	parameter: Linux
# 			   Win32
# 			   Xenon
# 			   PS3
# 			   All
#  ------------------------------------------------------------------ 

SHADER_Platform = Win32

#  ------------------------------------------------------------------ 
#  Desc: Shader Compiler Path
#  ------------------------------------------------------------------ 

SHADER_COMPILER_PATH_WIN32=D:\Program Files\Microsoft DirectX SDK (August 2007)\Utilities\Bin\x86
SHADER_COMPILER_PATH_LINUX=
SHADER_COMPILER_PATH_XENON=D:\Program Files\Microsoft DirectX SDK (August 2007)\Utilities\Bin\x86
SHADER_COMPILER_PATH_PS3=

#  ------------------------------------------------------------------ 
#  Desc: Shader Compiler
# 	parameter: fxc 		( directx hlsl shader compiler )
#  			   cg 		( nVidia cg shader compiler )
#  ------------------------------------------------------------------ 

SHADER_COMPILER_WIN32=fxc
SHADER_COMPILER_LINUX=cg
SHADER_COMPILER_XENON=fxc
SHADER_COMPILER_PS3=cg

# /////////////////////////////////////////////////////////////////////////////
#  General Compile Detail
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Pack Matrices
# 	parameter: column_major
#  			   row_major
#  ------------------------------------------------------------------ 

PACK_MATRICES_WIN32=column_major
PACK_MATRICES_LINUX=column_major
PACK_MATRICES_XENON=column_major
PACK_MATRICES_PS3=column_major

# /////////////////////////////////////////////////////////////////////////////
#  Vertex Shader Compile Detail
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Vertex Shader Mode Version
# 	parameter: vs_1_1
#  			   vs_2_0
#  			   vs_2_a
#  			   vs_2_sw
#  			   vs_3_0
#  			   vs_3_sw
#  			   vs_4_0
#  			   vs_4_1
#  ------------------------------------------------------------------ 

VS_WIN32=vs_3_0
VS_LINUX=vs_3_0
VS_XENON=vs_3_0
VS_PS3=vs_3_0

# /////////////////////////////////////////////////////////////////////////////
#  Pixel Shader Compile Detail
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Pixel Shader Mode Version
# 	parameter: ps_2_0
#  			   ps_2_a
#  			   ps_2_b
#  			   ps_2_sw
#  			   ps_3_0
#  			   ps_4_0
#  			   ps_4_1
#  ------------------------------------------------------------------ 

PS_WIN32=ps_3_0
PS_LINUX=ps_3_0
PS_XENON=ps_3_0
PS_PS3=ps_3_0

# /////////////////////////////////////////////////////////////////////////////
#  Geometry Shader Compile Detail
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Geometry Shader Mode Version
# 	parameter: gs_4_0
#  			   gs_4_1
#  ------------------------------------------------------------------ 

GS_WIN32=gs_4_0
GS_LINUX=gs_4_0
GS_XENON=gs_4_0
GS_PS3=gs_4_0

# /////////////////////////////////////////////////////////////////////////////
#  FX Shader Compile Detail
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Fx Shader Mode Version
# 	parameter: fx_2_0
#  			   fx_4_0
#  			   fx_4_1
#  ------------------------------------------------------------------ 

FX_WIN32=fx_4_0
FX_LINUX=fx_4_0
FX_XENON=fx_4_0
FX_PS3=fx_4_0

# /////////////////////////////////////////////////////////////////////////////
#  Advance User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: 
#  ------------------------------------------------------------------ 

ifeq ($(SHADER_Platform),Win32)
SHDC := $(SILENT_CMD)"$(SHADER_COMPILER_PATH_WIN32)"\$(SHADER_COMPILER_WIN32)
PACK_MATRICES := $(COLUMN_MAJOR_WIN32)
VS_VER := $(VS_WIN32)
PS_VER := $(PS_WIN32)
GS_VER := $(GS_WIN32)
FX_VER := $(FX_WIN32)
else
ifeq ($(SHADER_Platform),Linux)
SHDC := $(SILENT_CMD)$(SHADER_COMPILER_PATH_LINUX)\$(SHADER_COMPILER_LINUX)
PACK_MATRICES := $(COLUMN_MAJOR_LINUX)
VS_VER := $(VS_LINUX)
PS_VER := $(PS_LINUX)
GS_VER := $(GS_LINUX)
FX_VER := $(FX_LINUX)
else
ifeq ($(SHADER_Platform),Xenon)
SHDC := $(SILENT_CMD)"$(SHADER_COMPILER_PATH_XENON)"\$(SHADER_COMPILER_XENON)
PACK_MATRICES := $(COLUMN_MAJOR_XENON)
VS_VER := $(VS_XENON)
PS_VER := $(PS_XENON)
GS_VER := $(GS_XENON)
FX_VER := $(FX_XENON)
else
ifeq ($(SHADER_Platform),PS3)
SHDC := $(SILENT_CMD)$(SHADER_COMPILER_PATH_PS3)\$(SHADER_COMPILER_PS3)
PACK_MATRICES := $(COLUMN_MAJOR_PS3)
VS_VER := $(VS_PS3)
PS_VER := $(PS_PS3)
GS_VER := $(GS_PS3)
FX_VER := $(FX_PS3)
else #default
SHDC := $(SILENT_CMD)fxc
PACK_MATRICES := column_major
VS_VER := vs_3_0
PS_VER := ps_3_0
GS_VER := gs_4_0
FX_VER := fx_4_0
endif
endif
endif
endif

# /////////////////////////////////////////////////////////////////////////////
# Post Build Even for all project
# /////////////////////////////////////////////////////////////////////////////

define POST_BUILD_ALL_PROJECT
$(ECHO) Post Build...
endef
