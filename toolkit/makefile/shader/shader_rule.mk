#  ======================================================================================
#  File         : shader_rule.mk
#  Author       : Wu Jie 
#  Last Change  : 10/19/2008 | 14:03:13 PM | Sunday,October
#  Description  : 
#  ======================================================================================

# /////////////////////////////////////////////////////////////////////////////
#  Pre-generate Target
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Out Directory
#  ------------------------------------------------------------------ 

OutDir := $(CWD)/bin/shader/$(SHADER_Platform)

#  ------------------------------------------------------------------ 
#  Desc: Source
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  Source Files With Full Path
#  ======================================================== 

FullPath_FX_Srcs := $(wildcard $(addsuffix /*.fx,$(SrcDirs)))
FullPath_VS_Srcs := $(wildcard $(addsuffix /*.vsh,$(SrcDirs))) 
FullPath_PS_Srcs := $(wildcard $(addsuffix /*.psh,$(SrcDirs))) 
FullPath_GS_Srcs := $(wildcard $(addsuffix /*.gsh,$(SrcDirs))) 

#  ======================================================== 
#  Source Files
#  ======================================================== 

FX_Srcs :=$(notdir $(FullPath_FX_Srcs))
VS_Srcs :=$(notdir $(FullPath_VS_Srcs))
PS_Srcs :=$(notdir $(FullPath_PS_Srcs))
GS_Srcs :=$(notdir $(FullPath_GS_Srcs))

#  ------------------------------------------------------------------ 
#  Desc: Object
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  Object File Output Path
#  ======================================================== 

ObjDir := $(OutDir)/$(SHADER_Configuration)/objs/$(Project)

#  ======================================================== 
#  Object File Output Names
#  ======================================================== 

VS_Objs := $(patsubst %.vsh,%.vso,$(VS_Srcs))
PS_Objs := $(patsubst %.psh,%.pso,$(PS_Srcs))
GS_Objs := $(patsubst %.gsh,%.gso,$(GS_Srcs))
FX_Objs := $(patsubst %.fx,%.fxo,$(FX_Srcs))

#  ======================================================== 
#  All Objs
#  ======================================================== 

Objs += $(FX_Objs)
Objs += $(VS_Objs)
Objs += $(PS_Objs)
Objs += $(GS_Objs)

#  ======================================================== 
#  Object File With Full Path
#  ======================================================== 

FullPath_Objs := $(addprefix $(ObjDir)/,$(Objs))

#  ------------------------------------------------------------------ 
#  Desc: Logs
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  Error File Output Path
#  ======================================================== 

ErrDir := $(OutDir)/$(SHADER_Configuration)/logs/BuildLogs
FullPath_Errs := $(ErrDir)/$(Project).err
ErrLogName := ErrorLog.err

# /////////////////////////////////////////////////////////////////////////////
# Compiler Flags
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Pre-define
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  SHADER_Configuration Pre-define
#  ======================================================== 

ifeq ($(SHADER_Configuration),Debug)
PreDefs += DEBUG
PreDefs += _DEBUG
else 
ifeq ($(SHADER_Configuration),Release)
PreDefs += NDEBUG
PreDefs += RELEASE
PreDefs += _RELEASE
else
ifeq ($(SHADER_Configuration),FinalRelease)
PreDefs += NDEBUG
PreDefs += FINAL_RELEASE
PreDefs += _FINAL_RELEASE
endif
endif
endif

#  ======================================================== 
#  SHADER_Platform Pre-defeine
#  ======================================================== 

ifeq ($(SHADER_Platform),Linux)
PreDefs += __LINUX__
PreDefs += _LINUX
PreDefs += LINUX
PreDefs += _EX_LINUX
else 
ifeq ($(SHADER_Platform),Win32)
PreDefs += __WIN32__
PreDefs += _WIN32
PreDefs += WIN32
PreDefs += WIN
PreDefs += WINDOWS
PreDefs += _EX_WIN32
else 
ifeq ($(SHADER_Platform),Xenon)
PreDefs += __XENON__
PreDefs += _XENON
PreDefs += XENON
PreDefs += _XBOX
PreDefs += _EX_XENON
else 
ifeq ($(SHADER_Platform),PS3)
PreDefs += __PS3__
PreDefs += _PS3
PreDefs += PS3
PreDefs += _EX_PS3
endif
endif
endif
endif

#  ------------------------------------------------------------------ 
#  Desc: Generate Flag
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  General Flag
#  ======================================================== 

Flag_PreDef := $(addprefix /D,$(PreDefs))
Flag_Inc := $(addprefix /I,$(IncDirs))

#  ======================================================== 
#  Debug Flag ( choose debug or not )
#  Optimization Flag ( -O0:disable -O/-O1:general opt -O2:advance opt -O3:all opt )
#  ======================================================== 

ifeq ($(SHADER_Configuration),Debug)
Flag_Debug := /Zi
Flag_Opt := /Od
else
Flag_Debug :=
Flag_Opt := /O1
endif 

#  ======================================================== 
#  pack matrices in row-major order or column-major order
#  ======================================================== 

ifeq ($(PACK_MATRICES),column_major)
Flag_PackMatrices := /Zpc
else
Flag_PackMatrices := /Zpr
endif

#  ======================================================== 
#  Compile Flag
#  ======================================================== 

CFlags := $(Flag_Debug) $(Flag_Opt) $(Flag_PreDef) $(Flag_Inc) $(Flag_PackMatrices) $(CFlag_Spec)

# /////////////////////////////////////////////////////////////////////////////
# VPATH
# /////////////////////////////////////////////////////////////////////////////

VPATH := $(IncDirs)
VPATH += $(SrcDirs)

# /////////////////////////////////////////////////////////////////////////////
# Rules
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: All Rules
#  ------------------------------------------------------------------ 

.PHONY: all clean-all rebuild
all: |clean-errs objs
clean-all: |clean-objs clean-errs
rebuild: |clean-all all

#  ------------------------------------------------------------------ 
#  Desc: Object Rules
#  ------------------------------------------------------------------ 

.PHONY: objs clean-objs $(Objs)

#  ======================================================== 
#  all
#  ======================================================== 

objs: $(FullPath_Objs)
clean-objs:
	$(ECHO) -------------------
	$(ECHO) delete objs:
	$(ECHO) -------------------
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Objs); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Objs)) do (echo     ^|--   %%i)
endif
	$(RM) $(FullPath_Objs)

#  ======================================================== 
#  single
#  ======================================================== 

$(Objs):
	$(SMAKE) -f$(Project).mk $(ObjDir)/$@
clean-%.vso:
	$(ECHO) delete $(ObjDir)/$*.vso
	$(RM) $(ObjDir)/$*.vso
clean-%.pso:
	$(ECHO) delete $(ObjDir)/$*.pso
	$(RM) $(ObjDir)/$*.pso
clean-%.gso:
	$(ECHO) delete $(ObjDir)/$*.gso
	$(RM) $(ObjDir)/$*.gso
clean-%.fxo:
	$(ECHO) delete $(ObjDir)/$*.fxo
	$(RM) $(ObjDir)/$*.fxo

#  ======================================================== 
#  commands-objs
#  ======================================================== 

# vsh files
$(ObjDir)/%.vso: %.vsh
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO). > $(ErrDir)/$(ErrLogName)
	$(ECHO) ^<^<^<^<^<^< $(patsubst %/,%,$(notdir $@)): '$(Project)' >> $(ErrDir)/$(ErrLogName)
	$(SHDC) /E$(VS_ENTRY) /T$(VS_VER) $(CFlags) $< /Fo$@ 2>>$(ErrDir)/$(ErrLogName) 
	$(ECHO) ^>^>^>^>^>^> >> $(ErrDir)/$(ErrLogName)
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

# psh files
$(ObjDir)/%.pso: %.psh
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO). > $(ErrDir)/$(ErrLogName)
	$(ECHO) ^<^<^<^<^<^< $(patsubst %/,%,$(notdir $@)): '$(Project)' >> $(ErrDir)/$(ErrLogName)
	$(SHDC) /E$(PS_ENTRY) /T$(PS_VER) $(CFlags) $< /Fo$@ 2>>$(ErrDir)/$(ErrLogName) 
	$(ECHO) ^>^>^>^>^>^> >> $(ErrDir)/$(ErrLogName)
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

# gsh files
$(ObjDir)/%.gso: %.gsh
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO). > $(ErrDir)/$(ErrLogName)
	$(ECHO) ^<^<^<^<^<^< $(patsubst %/,%,$(notdir $@)): '$(Project)' >> $(ErrDir)/$(ErrLogName)
	$(SHDC) /E$(GS_ENTRY) /T$(GS_VER) $(CFlags) $< /Fo$@ 2>>$(ErrDir)/$(ErrLogName) 
	$(ECHO) ^>^>^>^>^>^> >> $(ErrDir)/$(ErrLogName)
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

# fx files
$(ObjDir)/%.fxo: %.fx
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO). > $(ErrDir)/$(ErrLogName)
	$(ECHO) ^<^<^<^<^<^< $(patsubst %/,%,$(notdir $@)): '$(Project)' >> $(ErrDir)/$(ErrLogName)
	$(SHDC) /E$(FX_ENTRY) /T$(FX_VER) $(CFlags) $< /Fo$@ 2>>$(ErrDir)/$(ErrLogName) 
	$(ECHO) ^>^>^>^>^>^> >> $(ErrDir)/$(ErrLogName)
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

# /////////////////////////////////////////////////////////////////////////////
# Output Rules
# /////////////////////////////////////////////////////////////////////////////

.PHONY: clean-errs
# all
clean-errs:
	$(ECHO) -------------------
	$(ECHO) delete errs:
	$(ECHO) -------------------
ifneq ($(FullPath_Errs),)
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Errs); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Errs)) do (echo     ^|--   %%i)
endif
else
	$(ECHO) "    |--"
endif
	$(RM) $(FullPath_Errs)


