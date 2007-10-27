############################################################
## Copyright (C) 2006 Johnny
## ayacai [at] 163 [dot] com
############################################################

# ----------------------------------------------------------
#  Pre-generate Target
# ----------------------------------------------------------

# -------------------
#  Out Directory
# -------------------
OutDir := $(PWD)/_smakes/$(SHADER_Platform)

# -------------------
#  Source
# -------------------

# Source Files With Full Path
#FullPath_HLSL_Srcs := $(wildcard $(addsuffix /*.hlsl,$(SrcDirs))) 
FullPath_FX_Srcs := $(wildcard $(addsuffix /*.fx,$(SrcDirs)))
FullPath_VS_Srcs := $(wildcard $(addsuffix /*.vsh,$(SrcDirs))) 
FullPath_PS_Srcs := $(wildcard $(addsuffix /*.psh,$(SrcDirs))) 
FullPath_GS_Srcs := $(wildcard $(addsuffix /*.gsh,$(SrcDirs))) 

# Source Files
#HLSL_Srcs :=$(notdir $(FullPath_HLSL_Srcs))
FX_Srcs :=$(notdir $(FullPath_FX_Srcs))
VS_Srcs :=$(notdir $(FullPath_VS_Srcs))
PS_Srcs :=$(notdir $(FullPath_PS_Srcs))
GS_Srcs :=$(notdir $(FullPath_GS_Srcs))

# -------------------
#  Object
# -------------------

# Object File Output Path
ObjDir := $(OutDir)/$(SHADER_Configuration)/SHD_Objs/$(Project)

# Object File Output Names
#HLSL_Objs := $(patsubst %.hlsl,%.hlslo,$(HLSL_Srcs))
VS_Objs := $(patsubst %.vsh,%.vso,$(VS_Srcs))
PS_Objs := $(patsubst %.psh,%.pso,$(PS_Srcs))
GS_Objs := $(patsubst %.gsh,%.gso,$(GS_Srcs))
FX_Objs := $(patsubst %.fx,%.fxo,$(FX_Srcs))

# All Objs
#Objs += $(HLSL_Objs)
Objs += $(FX_Objs)
Objs += $(VS_Objs)
Objs += $(PS_Objs)
Objs += $(GS_Objs)

# Object File With Full Path
FullPath_Objs := $(addprefix $(ObjDir)/,$(Objs))

# -------------------
#  Logs
# -------------------

# Error File Output Path
ErrDir := $(OutDir)/$(SHADER_Configuration)/Logs/BuildLogs
FullPath_Errs := $(ErrDir)/$(Project).err
ErrLogName := ErrorLog.err


# ----------------------------------------------------------
#  Compiler Flags
# ----------------------------------------------------------

# -------------------
#  Pre-define
# -------------------

# SHADER_Configuration Pre-define
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

# SHADER_Platform Pre-defeine
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

# -------------------
#  Generate Flag
# -------------------

# General Flag
Flag_PreDef := $(addprefix /D,$(PreDefs))
Flag_Inc := $(addprefix /I,$(IncDirs))

# Debug Flag ( choose debug or not )
# Optimization Flag ( -O0:disable -O/-O1:general opt -O2:advance opt -O3:all opt )
ifeq ($(SHADER_Configuration),Debug)
Flag_Debug := /Zi
Flag_Opt := /Od
else
Flag_Debug :=
Flag_Opt := /O1
endif 

# pack matrices in row-major order or column-major order
ifeq ($(PACK_MATRICES),column_major)
Flag_PackMatrices := /Zpc
else
Flag_PackMatrices := /Zpr
endif

# Compile Flag
CFlags := $(Flag_Debug) $(Flag_Opt) $(Flag_PreDef) $(Flag_Inc) $(Flag_PackMatrices) $(CFlag_Spec)

# -------------------
#  VPATH
# -------------------

VPATH := $(IncDirs)
VPATH += $(SrcDirs)

# ----------------------------------------------------------
#  Rules
# ----------------------------------------------------------

# -------------------
# All Rules
# -------------------
.PHONY: all clean-all rebuild
all: |clean-errs objs
clean-all: |clean-objs clean-errs
rebuild: |clean-all all

# -------------------
# Object Rules
# -------------------
.PHONY: objs clean-objs $(Objs)
# all
objs: $(FullPath_Objs)
clean-objs:
	$(ECHO)
	$(ECHO) delete objs:
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Objs); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Objs)) do (echo     \--   %%i)
endif
	$(RM) $(FullPath_Objs)
# single
$(Objs):
	$(SMAKE) -f$(Project).mk $(ObjDir)/$@
#clean-%.hlslo:
#	$(ECHO) delete $(ObjDir)/$*.hlslo
#	$(RM) $(ObjDir)/$*.hlslo
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

# commands-objs
# hlsl files
#$(ObjDir)/%.hlslo: %.hlsl
#	$(MKDIR) $(ObjDir)
#	$(MKDIR) $(ErrDir)
#	$(ECHO) compiling $<...
#	$(ECHO) - > $(ErrDir)/$(ErrLogName)
#	$(ECHO) --[$(Project)]$*.hlsl-- >> $(ErrDir)/$(ErrLogName)
#	$(SHDC) /E$(FX_ENTRY) $(CFlags) $< -o $@ 2>>$(ErrDir)/$(ErrLogName) 
#	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

# vsh files
$(ObjDir)/%.vso: %.vsh
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO) - > $(ErrDir)/$(ErrLogName)
	$(ECHO) --[$(Project)]$*.vsh-- >> $(ErrDir)/$(ErrLogName)
	$(SHDC) /E$(VS_ENTRY) /T$(VS_VER) $(CFlags) $< /Fo$@ 2>>$(ErrDir)/$(ErrLogName) 
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

# psh files
$(ObjDir)/%.pso: %.psh
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO) - > $(ErrDir)/$(ErrLogName)
	$(ECHO) --[$(Project)]$*.psh-- >> $(ErrDir)/$(ErrLogName)
	$(SHDC) /E$(PS_ENTRY) /T$(PS_VER) $(CFlags) $< /Fo$@ 2>>$(ErrDir)/$(ErrLogName) 
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

# gsh files
$(ObjDir)/%.gso: %.gsh
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO) - > $(ErrDir)/$(ErrLogName)
	$(ECHO) --[$(Project)]$*.gsh-- >> $(ErrDir)/$(ErrLogName)
	$(SHDC) /E$(GS_ENTRY) /T$(GS_VER) $(CFlags) $< /Fo$@ 2>>$(ErrDir)/$(ErrLogName) 
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

# fx files
$(ObjDir)/%.fxo: %.fx
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO) - > $(ErrDir)/$(ErrLogName)
	$(ECHO) --[$(Project)]$*.fx-- >> $(ErrDir)/$(ErrLogName)
	$(SHDC) /E$(FX_ENTRY) /T$(FX_VER) $(CFlags) $< /Fo$@ 2>>$(ErrDir)/$(ErrLogName) 
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

# -------------------
# Output Rules
# -------------------
.PHONY: clean-errs
# all
clean-errs:
	$(ECHO)
	$(ECHO) delete errs:
ifneq ($(FullPath_Errs),)
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Errs); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Errs)) do (echo     \--   %%i)
endif
else
	$(ECHO) "    |--"
endif
	$(RM) $(FullPath_Errs)


