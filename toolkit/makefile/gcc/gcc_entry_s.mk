#  ======================================================================================
#  File         : gcc_entry_s.mk
#  Author       : Wu Jie 
#  Last Change  : 10/19/2008 | 11:17:25 AM | Sunday,October
#  Description  : 
#  ======================================================================================

# /////////////////////////////////////////////////////////////////////////////
#  Global Configuration
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: include general config
#  ------------------------------------------------------------------ 

include gcc_config.mk

# /////////////////////////////////////////////////////////////////////////////
#  User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Parent Working Directory
#  ------------------------------------------------------------------ 

CWD := .

#  ------------------------------------------------------------------ 
#  Desc: Project Name
#  ------------------------------------------------------------------ 

Project := # TODO: current directory name
ProjectType := # TODO: choose: lib/dll/exe

#  ------------------------------------------------------------------ 
#  Desc: Include Path
#  ------------------------------------------------------------------ 

IncDirs += .
IncDirs += # TODO: relative-address (sample: ./Incs)

#  ------------------------------------------------------------------ 
#  Desc: Precompiled Headers Dependence Headers
#  ------------------------------------------------------------------ 

FullPath_GchSrcs += # TODO: relative-address/header-file-name (sample: ./Incs/Gch-header.h)

#  ------------------------------------------------------------------ 
#  Desc: Source Path
#  ------------------------------------------------------------------ 

SrcDirs += .
SrcDirs += # TODO: relative-address (sample: ./Srcs)

#  ------------------------------------------------------------------ 
#  Desc: Dependent Libaray File Paths
#  ------------------------------------------------------------------ 

LibDirs += # TODO: relative-address (sample: ../Third-Part-Libs)

#  ------------------------------------------------------------------ 
#  Desc: Dependent Library File Names
#  ------------------------------------------------------------------ 

PrjLibs += # TODO: lib-file-name (sample: libSDK.a-->SDK) This is libs for project compile depence
ExtLibs += # TODO: lib-file-name (sample: libSDK.a-->SDK) This is libs for external libaraies

#  ------------------------------------------------------------------ 
#  Desc: Special Flags
#   Some space-depent directory flag can't generate automatically, use this instead
#  ------------------------------------------------------------------ 

CFlag_Spec += # TODO: (sample: -I"C:/Program Files/Microsoft DirectX SDK/Include")
LFlag_Spec += # TODO: (sample: -L"C:/Program Files/Microsoft DirectX SDK/Lib/x86")

# /////////////////////////////////////////////////////////////////////////////
#  Advanced User Define
#  NOTE: in this section, you can define advanced macros by uncomment them
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Target output directory 
#  ------------------------------------------------------------------ 

#  OutDir := $(EX_SDK)/_build/gcc/$(Platform)/$(Configuration)
#  ErrDir := $(CWD)/_logs/errors

#  ------------------------------------------------------------------ 
#  Desc: Pre defines
#  ------------------------------------------------------------------ 

# PreDefs +=

# /////////////////////////////////////////////////////////////////////////////
#  Post Build Even
# 	programme after target been built, this is the project specific one (sample: make_fself $(@) $(basename $(@)).self)
# /////////////////////////////////////////////////////////////////////////////

define POST_BUILD
$(ECHO) Post Build $(Project)...
endef

# /////////////////////////////////////////////////////////////////////////////
#  Rules
# /////////////////////////////////////////////////////////////////////////////

ifeq ($(Platform),Win32) # win32
include $(EX_DEV)/exvim/toolkit/makefile/gcc/gcc_rule_s.mk
else
ifeq ($(Platform),Linux) # unix/linux
include ~/.toolkit/makefile/gcc/gcc_rule_s.mk
else # other system
include ~/.toolkit/makefile/gcc/gcc_rule_s.mk
endif
endif
