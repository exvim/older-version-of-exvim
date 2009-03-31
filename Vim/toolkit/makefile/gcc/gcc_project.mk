#  ======================================================================================
#  File         : gcc_project.mk
#  Author       : Wu Jie 
#  Last Change  : 10/19/2008 | 11:23:17 AM | Sunday,October
#  Description  : 
#  ======================================================================================

# /////////////////////////////////////////////////////////////////////////////
#  Global Configuration
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: include general config
#  ------------------------------------------------------------------ 

include ../gcc_config.mk

# /////////////////////////////////////////////////////////////////////////////
#  User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Parent Working Directory
#  ------------------------------------------------------------------ 

PWD := # TODO: relative-address (sample: ..)

#  ------------------------------------------------------------------ 
#  Desc: Project Name
#  ------------------------------------------------------------------ 

Project := # TODO: current directory name
ProjectType := # TODO: choose: a,lib,so,dll,exe

#  ------------------------------------------------------------------ 
#  Desc: Include Path
#  ------------------------------------------------------------------ 

IncDirs += # TODO: relative-address (sample: ./Incs)

#  ------------------------------------------------------------------ 
#  Desc: Precompiled Headers Dependence Headers
#  ------------------------------------------------------------------ 

FullPath_GchSrcs += # TODO: relative-address/header-file-name (sample: ./Incs/gch-header.h)

#  ------------------------------------------------------------------ 
#  Desc: Source Path
#  ------------------------------------------------------------------ 

SrcDirs += # TODO: relative-address (sample: ./Srcs)

#  ------------------------------------------------------------------ 
#  Desc: Dependent Library File Paths
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
#  Addvance User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Parent Working Directory
#  ------------------------------------------------------------------ 

PWD ?= ..

# /////////////////////////////////////////////////////////////////////////////
#  Post Build Even
#   programme after target been built, this is the project specific one (sample: make_fself $(@) $(basename $(@)).self)
# /////////////////////////////////////////////////////////////////////////////

define POST_BUILD
$(ECHO) Post Build $(Project)...
endef

# /////////////////////////////////////////////////////////////////////////////
#  Rules
# /////////////////////////////////////////////////////////////////////////////

include ../gcc_rule.mk
