# Copyright (C) 2006 Johnny
# ayacai [at] 163 [dot] com

# ----------------------------------------------------------
#  User Define
# ----------------------------------------------------------

# include general config
include config.mk

# Parent Working Directory
PWD := .

# Project Name
Project := Test
ProjectType := Test

# Include Path
IncDirs += .

# Precompiled Headers Dependence Headers
FullPath_PchDeps += # relative-address/header-file-name (sample: ./Incs/pch-header.h)

# Source Path
SrcDirs += .

# Dependent Libaray File Paths
LibDirs += # relative-address (sample: ../Third-Part-Libs)

# Dependent Libaray File Names
Libs += # lib-file-name (sample: libSDK.lib-->SDK)

# Special Flags
# Some space-depent directory flag can't generate automatically, use this instead
CFlag_Spec += # (sample: -I"C:/Program Files/Microsoft DirectX SDK/Include")
LFlag_Spec += # (sample: -L"C:/Program Files/Microsoft DirectX SDK/Lib/x86")

# ----------------------------------------------------------
#  Addvance User Define
# ----------------------------------------------------------

# Parent Working Directory
PWD ?= .
OutDir := $(PWD)/_gmakes

# Configuration Pre-define
ifeq ($(Configuration),Debug)
PreDefs += Debug
else 
ifeq ($(Configuration),Release)
PreDefs += Release
endif
endif

# Platform Pre-defeine
ifeq ($(Platform),Linux)
PreDefs += LINUX
else 
ifeq ($(Platform),Win32)
PreDefs += WIN
PreDefs += WIN32
PreDefs += WINDOWS
endif
endif

# -------------------
#  Include
# -------------------

# Precompiled Headers
# FIXME Compiler choose gch or pch
FullPath_Pchs := $(addsuffix .gch,$(FullPath_PchDeps))

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
ObjDir := $(OutDir)/Objs/$(Configuration)/$(Project)

# Object File Output Names
Objs := $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(Srcs)))

# Object File With Full Path
FullPath_Objs := $(addprefix $(ObjDir)/,$(Objs))

# -------------------
#  Dependence
# -------------------

# Dependence File Output Path
DepDir := $(OutDir)/Deps/$(Project)

# Dependence File Output Names
Deps := $(patsubst %.o,%.d,$(Objs))
PchDeps := $(patsubst %.gch,%.d,$(notdir $(FullPath_Pchs)))

# Dependence File With Full Path
FullPath_Deps := $(addprefix $(DepDir)/,$(Deps))
FullPath_PchDeps := $(addprefix $(DepDir)/,$(PchDeps))
FullPath_AllDeps := $(FullPath_Deps) $(FullPath_PchDeps)

# -------------------
#  Libaray
# -------------------

# -------------------
#  Target
# -------------------

# Target File Output Path & Name
ifneq ($(ProjectType),exe)
TargetDir := $(OutDir)/Libs/$(Configuration)
Target := lib$(Project).$(ProjectType)
else
TargetDir := $(OutDir)/Bin/$(Configuration)
Target := $(Project).$(ProjectType)
endif
FullPath_Target := $(TargetDir)/$(Target)

# -------------------
#  Logs
# -------------------

# Error File Output Path
ErrDir := $(OutDir)/Logs/BuildLogs/$(Configuration)/$(Project)
FullPath_Errs := $(wildcard $(ErrDir)/*.err)

# -------------------
#  Compiler Flag
# -------------------

# General Flag
Flag_PreDef := $(addprefix -D,$(PreDefs))
Flag_Inc := $(addprefix -I,$(IncDirs))
Flag_LibDir := $(addprefix -L,$(LibDirs))
Flag_Lib := $(addprefix -l,$(Libs))

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
LFlags := $(Flag_LibDir) $(Flag_Lib) $(LFlag_Spec)

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
all: $(FullPath_Target)
clean-all: |clean-deps clean-pchs clean-objs clean-errs clean-target
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
ifeq ($(Platform),Linux)
	@for item in $(FullPath_Target); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Target)) do (echo     \--   %%i)
endif
	$(RM) $(FullPath_Target)
# single
$(Target): $(FullPath_Target)

# commands-target
# FIXME consider dll
$(FullPath_Target): $(FullPath_Objs)
	$(ECHO) linking:
ifeq ($(Platform),Linux)
	@for obj in $(filter %.o,$^); do echo "    |--"   $$obj; done
else
	@for %%i in ($(filter %.o,$^)) do (echo     \--   %%i)
endif
	$(MKDIR) $(TargetDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) > $(ErrDir)/$(Target).err
	$(ECHO) --[$(Project)]Link-- >> $(ErrDir)/$(Target).err
ifneq ($(ProjectType),exe)
	$(AR) r $@ $(filter %.o,$^) 2>>$(ErrDir)/$(Target).err
else
	$(CC) $(filter %.o,$^) $(LFlags) -o $@ 2>>$(ErrDir)/$(Target).err
endif
	$(ECHO) generate $(@)
ifeq ($(FullPath_PchDeps),)
	$(CAT) $(ErrDir)/*.o.err > $(ErrDir)/../$(Project).err
	$(CAT) $(ErrDir)/$(Target).err >> $(ErrDir)/../$(Project).err
else
	$(CAT) $(ErrDir)/*.gch.err > $(ErrDir)/../$(Project).err
	$(CAT) $(ErrDir)/*.o.err >> $(ErrDir)/../$(Project).err
	$(CAT) $(ErrDir)/$(Target).err >> $(ErrDir)/../$(Project).err
endif

# -------------------
# Dependence Rules
# -------------------
.PHONY: deps clean-deps $(Deps)
# all
deps: $(FullPath_AllDeps)
clean-deps: 
	$(ECHO)
	$(ECHO) delete deps:
ifeq ($(Platform),Linux)
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
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$(ObjDir)/\1.o $@: ,g" < $@.tmp > $@
	$(RM) $@.tmp

# c files
$(DepDir)/%.d: %.c
	$(ECHO) creating $@...
	$(MKDIR) $(DepDir)
	$(RM) $@
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$(ObjDir)/\1.o $@: ,g" < $@.tmp > $@
	$(RM) $@.tmp

# commands-pch-deps
$(DepDir)/%.h.d: %.h
	$(ECHO) creating $@...
	$(MKDIR) $(DepDir)
	$(RM) $@
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$<.gch $@: ,g" < $@.tmp > $@
	$(RM) $@.tmp

# -------------------
# PCH Rules
# -------------------
.PHONY: pchs clean-pchs
# all
pchs: $(FullPath_Pchs)
clean-pchs: 
	$(ECHO)
	$(ECHO) delete pchs:
ifneq ($(FullPath_Pchs),)
ifeq ($(Platform),Linux)
	@for item in $(FullPath_Pchs); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Pchs)) do (echo     \--   %%i)
endif
	$(RM) $(FullPath_Pchs)
endif

# commands-pchs
$(FullPath_Pchs):
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $(basename $@)...
	$(ECHO) > $(ErrDir)/$(patsubst %/,%,$(notdir $@)).err
	$(ECHO) --[$(Project)]$(patsubst %/,%,$(notdir $@))-- >> $(ErrDir)/$(patsubst %/,%,$(notdir $@)).err
	$(CC) -c $(CFlags) $(basename $@) 2>>$(ErrDir)/$(patsubst %/,%,$(notdir $@)).err

# -------------------
# Object Rules
# -------------------
.PHONY: objs clean-objs $(Objs)
# all
objs: $(FullPath_Objs)
clean-objs:
	$(ECHO)
	$(ECHO) delete objs:
ifeq ($(Platform),Linux)
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
$(ObjDir)/%.o: %.cpp $(FullPath_Pchs)
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO) > $(ErrDir)/$*.o.err
	$(ECHO) --[$(Project)]$*.cpp-- >> $(ErrDir)/$*.o.err
	$(CC) -c $(CFlags) $< -o $@ 2>>$(ErrDir)/$*.o.err 

# c files
$(ObjDir)/%.o: %.c $(FullPath_Pchs)
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO) > $(ErrDir)/$*.o.err
	$(ECHO) --[$(Project)]$*.c-- >> $(ErrDir)/$*.o.err
	$(CC) -c $(CFlags) $< -o $@ 2>>$(ErrDir)/$*.o.err 

# -------------------
# Output Rules
# -------------------
.PHONY: clean-errs
# all
clean-errs:
	$(ECHO)
	$(ECHO) delete errs:
ifneq ($(FullPath_Errs),)
ifeq ($(Platform),Linux)
	@for item in $(FullPath_Errs); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Errs)) do (echo     \--   %%i)
endif
else
	$(ECHO) "    |--"
endif
	$(RM) $(FullPath_Errs)


