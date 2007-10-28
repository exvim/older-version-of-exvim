# Copyright (C) 2006 Johnny
# ayacai [at] 163 [dot] com

# ----------------------------------------------------------
#  Pre-generate Target
# ----------------------------------------------------------

# -------------------
#  Out Directory
# -------------------
OutDir := $(PWD)/_gmakes/$(Platform)

# -------------------
#  Include
# -------------------

# Precompiled Headers
GchDir := $(addsuffix .gch,$(FullPath_GchSrcs))
FullPath_Gchs := $(addsuffix _$(Platform)_$(Configuration).h.gch,$(addprefix $(GchDir)/,$(basename $(notdir $(FullPath_GchSrcs)))))

# -------------------
#  Source
# -------------------

# Source Files With Full Path
FullPath_Srcs := $(wildcard $(addsuffix /*.c,$(SrcDirs))) $(wildcard $(addsuffix /*.cpp,$(SrcDirs))) 

# Source Files
Srcs := $(notdir $(FullPath_Srcs))

# -------------------
#  Object
# -------------------

# Object File Output Path
ObjDir := $(OutDir)/$(Configuration)/Objs/$(Project)

# Object File Output Names
Objs := $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(Srcs)))

# Object File With Full Path
FullPath_Objs := $(addprefix $(ObjDir)/,$(Objs))

# -------------------
#  Dependence
# -------------------

# Dependence File Output Path
DepDir := $(OutDir)/$(Configuration)/Deps/$(Project)

# Dependence File Output Names
Deps := $(patsubst %.o,%.d,$(Objs))
GchDeps := $(patsubst %.gch,%.d,$(notdir $(GchDir)))

# Dependence File With Full Path
FullPath_Deps := $(addprefix $(DepDir)/,$(Deps))
FullPath_GchDeps := $(addprefix $(DepDir)/,$(GchDeps))
FullPath_AllDeps := $(FullPath_Deps) $(FullPath_GchDeps)

# -------------------
#  Dependence Library
# -------------------

# Dependence Libraries
Libs := $(PrjLibs) $(ExtLibs)

# Project Compile Dependence Libraries Output Path
PrjLibDir := $(OutDir)/$(Configuration)/Libs

# Project compile dependence libraries with Full Path
FullPath_PrjLibs := $(addprefix $(PrjLibDir)/lib,$(addsuffix .a,$(PrjLibs)))

# -------------------
#  Target
# -------------------

# Target File Output Path & Name
ifeq ($(ProjectType),$(EXE_NAME))
TargetDir := $(OutDir)/$(Configuration)/Bin
Target := $(Project)_$(Configuration).$(ProjectType)
else
ifeq ($(ProjectType),a)
TargetDir := $(OutDir)/$(Configuration)/Libs
Target := lib$(Project).$(ProjectType)
else
ifeq ($(ProjectType),dll)
TargetDir := $(OutDir)/$(Configuration)/Libs
Target := $(Project).$(ProjectType)
libTarget := lib$(Project).a
endif
endif
endif
FullPath_Target := $(TargetDir)/$(Target)

# -------------------
#  Logs
# -------------------

# Error File Output Path
ErrDir := $(OutDir)/$(Configuration)/Logs/BuildLogs
FullPath_Errs := $(ErrDir)/$(Project).err
ErrLogName := ErrorLog.err


# ----------------------------------------------------------
#  Compiler Flags
# ----------------------------------------------------------

# -------------------
#  Pre-define
# -------------------

# Configuration Pre-define
ifeq ($(Configuration),Debug)
PreDefs += DEBUG
PreDefs += _DEBUG
else 
ifeq ($(Configuration),Release)
PreDefs += NDEBUG
PreDefs += RELEASE
PreDefs += _RELEASE
else
ifeq ($(Configuration),FinalRelease)
PreDefs += NDEBUG
PreDefs += FINAL_RELEASE
PreDefs += _FINAL_RELEASE
endif
endif
endif

# Platform Pre-defeine
ifeq ($(Platform),Linux)
PreDefs += __LINUX__
PreDefs += _LINUX
PreDefs += LINUX
PreDefs += _EX_LINUX
else 
ifeq ($(Platform),Win32)
PreDefs += __WIN32__
PreDefs += _WIN32
PreDefs += WIN32
PreDefs += WIN
PreDefs += WINDOWS
PreDefs += _EX_WIN32
else 
ifeq ($(Platform),Xenon)
PreDefs += __XENON__
PreDefs += _XENON
PreDefs += XENON
PreDefs += _XBOX
PreDefs += _EX_XENON
else 
ifeq ($(Platform),PS3)
PreDefs += __PS3__
PreDefs += _PS3
PreDefs += PS3
PreDefs += _EX_PS3
endif
endif
endif
endif

# Build as DLL or not
ifeq ($(ProjectType),dll)
PreDefs += DLL
PreDefs += _DLL
endif

# -------------------
#  Generate Flag
# -------------------

# General Flag
Flag_PreDef := $(addprefix -D,$(PreDefs))
Flag_Inc := $(addprefix -I,$(IncDirs))
Flag_LibDir := $(addprefix -L,$(LibDirs))
Flag_Lib := $(addprefix -l,$(Libs))
ifeq ($(ProjectType),dll)
Flag_BuildDll := -shared -Wl,--out-implib,$(TargetDir)/$(libTarget)
else
Flag_BuildDll :=
endif

# Debug Flag ( choose debug or not )
# Optimization Flag ( -O0:disable -O/-O1:general opt -O2:advance opt -O3:all opt )
ifeq ($(Configuration),Debug)
Flag_Debug := -g
Flag_Opt := -O0
else
Flag_Debug :=
Flag_Opt := -O1
endif 

# Compile Flag
CFlags := $(Flag_Debug) $(Flag_Opt) $(Flag_PreDef) $(Flag_Inc) $(CFlag_Spec)
# Link Flag
LFlags := $(Flag_LibDir) $(Flag_Lib) $(Flag_BuildDll) $(LFlag_Spec)

# -------------------
#  VPATH
# -------------------

VPATH := $(IncDirs)
VPATH += $(SrcDirs)
VPATH += $(TargetDir)

# ----------------------------------------------------------
#  Rules
# ----------------------------------------------------------

# -------------------
# All Rules
# -------------------
.PHONY: all clean-all rebuild
all: |clean-errs $(FullPath_Target)
clean-all: |clean-deps clean-gchs clean-objs clean-errs clean-target
rebuild: |clean-all all

# -------------------
# Target Rules
# -------------------
.PHONY: target clean-target $(Target)
# all
target: $(FullPath_Target)
clean-target:
	$(ECHO)
	$(ECHO) delete target:
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Target); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Target)) do (echo     \--   %%i)
endif
	$(RM) $(FullPath_Target)
ifeq ($(ProjectType),dll)
	$(RM) $(TargetDir)/$(libTarget)
endif
# single
$(Target): $(FullPath_Target)

# commands-target
$(FullPath_Target): $(FullPath_Objs) $(FullPath_PrjLibs)
	$(ECHO) linking:
ifeq ($(CURRENT_OS),Linux)
	@for obj in $(filter %.o,$^); do echo "    |--"   $$obj; done
else
	@for %%i in ($(filter %.o,$^)) do (echo     \--   %%i)
endif
	$(MKDIR) $(TargetDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) - > $(ErrDir)/$(ErrLogName)
	$(ECHO) --[$(Project)]Link-- >> $(ErrDir)/$(ErrLogName)
ifeq ($(ProjectType),$(EXE_NAME))
	$(CC) $(filter %.o,$^) $(LFlags) -o $@ 2>>$(ErrDir)/$(ErrLogName)
else
ifeq ($(ProjectType),a)
	$(AR) r $@ $(filter %.o,$^) 2>>$(ErrDir)/$(ErrLogName)
else
ifeq ($(ProjectType),dll)
	$(CC) $(filter %.o,$^) $(LFlags) -o $@ 2>>$(ErrDir)/$(ErrLogName)
endif
endif
endif
	$(ECHO) generate $(@)
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err
	$(AFTER_BUILD)

# -------------------
# Dependence Rules
# -------------------
.PHONY: deps clean-deps $(Deps)
# all
deps: $(FullPath_AllDeps)
clean-deps: 
	$(ECHO)
	$(ECHO) delete deps:
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_AllDeps); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_AllDeps)) do (echo     \--   %%i)
endif
	$(RM) $(FullPath_AllDeps)
# single
$(Deps):
	$(SMAKE) -f$(Project).mk $(DepDir)/$@
clean-%.d:
	$(ECHO) delete $(DepDir)/$*.d
	$(RM) $(DepDir)/$*.d

# commands-deps
# cpp files
$(DepDir)/%.d: %.cpp
	$(ECHO) creating $@...
	$(MKDIR) $(DepDir)
	$(RM) $@
ifeq ($(CompileMode),Fast)
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$(ObjDir)/\1.o: ,g" < $@.tmp > $@
	$(RM) $@.tmp
else
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$(ObjDir)/\1.o $@: ,g" < $@.tmp > $@
	$(RM) $@.tmp
endif

# c files
$(DepDir)/%.d: %.c
	$(ECHO) creating $@...
	$(MKDIR) $(DepDir)
	$(RM) $@
ifeq ($(CompileMode),Fast)
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$(ObjDir)/\1.o: ,g" < $@.tmp > $@
	$(RM) $@.tmp
else
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$(ObjDir)/\1.o $@: ,g" < $@.tmp > $@
	$(RM) $@.tmp
endif

# commands-gch-deps
$(DepDir)/%.h.d: %.h
	$(ECHO) creating $@...
	$(MKDIR) $(DepDir)
	$(RM) $@
ifeq ($(CompileMode),Fast)
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$(FullPath_Gchs): ,g" < $@.tmp > $@
	$(RM) $@.tmp
else
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$(FullPath_Gchs) $@: ,g" < $@.tmp > $@
	$(RM) $@.tmp
endif

# -------------------
# GCH Rules
# -------------------
.PHONY: gchs clean-gchs
# all
gchs: $(FullPath_Gchs)
clean-gchs: 
	$(ECHO)
	$(ECHO) delete gchs:
ifneq ($(FullPath_Gchs),)
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Gchs); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Gchs)) do (echo     \--   %%i)
endif
	$(RM) $(FullPath_Gchs)
endif

# commands-gchs
$(FullPath_Gchs):
	$(MKDIR) $(ErrDir)
	$(MKDIR) $(GchDir)
	$(ECHO) compiling $(basename $@)...
	$(ECHO) - > $(ErrDir)/$(ErrLogName)
	$(ECHO) --[$(Project)]$(patsubst %/,%,$(notdir $@))-- >> $(ErrDir)/$(ErrLogName)
	$(CC) -c $(CFlags) $(basename $(GchDir)) -o $@ 2>>$(ErrDir)/$(ErrLogName)
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

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
clean-%.o:
	$(ECHO) delete $(ObjDir)/$*.o
	$(RM) $(ObjDir)/$*.o

# commands-objs
# cpp files
-include $(FullPath_AllDeps)
$(ObjDir)/%.o: %.cpp $(FullPath_Gchs)
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO) - > $(ErrDir)/$(ErrLogName)
	$(ECHO) --[$(Project)]$*.cpp-- >> $(ErrDir)/$(ErrLogName)
	$(CC) -c $(CFlags) $< -o $@ 2>>$(ErrDir)/$(ErrLogName) 
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

# c files
$(ObjDir)/%.o: %.c $(FullPath_Gchs)
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO) - > $(ErrDir)/$(ErrLogName)
	$(ECHO) --[$(Project)]$*.c-- >> $(ErrDir)/$(ErrLogName)
	$(CC) -c $(CFlags) $< -o $@ 2>>$(ErrDir)/$(ErrLogName) 
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


