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
OutDir := $(CWD)/_gmakes/$(Platform)

# -------------------
#  Include
# -------------------

# Precompiled Headers
# FIXME Compiler choose gch or pch
PchDir := $(addsuffix .gch,$(FullPath_PchDeps))
FullPath_Pchs := $(addsuffix _$(Platform)_$(Configuration).h.gch,$(addprefix $(PchDir)/,$(basename $(notdir $(FullPath_PchDeps)))))

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
PchDeps := $(patsubst %.gch,%.d,$(notdir $(PchDir)))

# Dependence File With Full Path
FullPath_Deps := $(addprefix $(DepDir)/,$(Deps))
FullPath_PchDeps := $(addprefix $(DepDir)/,$(PchDeps))
FullPath_AllDeps := $(FullPath_Deps) $(FullPath_PchDeps)

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
TargetDir := $(OutDir)/$(Configuration)/Libs
Target := lib$(Project).$(ProjectType)
endif
FullPath_Target := $(TargetDir)/$(Target)

# -------------------
#  Logs
# -------------------

# Error File Output Path
ErrDir := $(OutDir)/$(Configuration)/Logs/BuildLogs/$(Project)
FullPath_Errs := $(wildcard $(ErrDir)/*.err)


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

# -------------------
#  Generate Flag
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
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Target); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Target)) do (echo     \--   %%i)
endif
	$(RM) $(FullPath_Target)
# single
$(Target): $(FullPath_Target)

# commands-target
# FIXME consider dll
$(FullPath_Target): $(FullPath_Objs) $(FullPath_PrjLibs)
	$(ECHO) linking:
ifeq ($(CURRENT_OS),Linux)
	@for obj in $(filter %.o,$^); do echo "    |--"   $$obj; done
else
	@for %%i in ($(filter %.o,$^)) do (echo     \--   %%i)
endif
	$(MKDIR) $(TargetDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) - > $(ErrDir)/$(Target).err
	$(ECHO) --[$(Project)]Link-- >> $(ErrDir)/$(Target).err
ifeq ($(ProjectType),$(EXE_NAME))
	$(CC) $(filter %.o,$^) $(LFlags) -o $@ 2>>$(ErrDir)/$(Target).err
else
	$(AR) r $@ $(filter %.o,$^) 2>>$(ErrDir)/$(Target).err
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

# commands-pch-deps
$(DepDir)/%.h.d: %.h
	$(ECHO) creating $@...
	$(MKDIR) $(DepDir)
	$(RM) $@
ifeq ($(CompileMode),Fast)
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$(FullPath_Pchs): ,g" < $@.tmp > $@
	$(RM) $@.tmp
else
	$(CC) -M $(CFlags) $< -o $@.tmp
	@sed "s,\($*\)\.o[ :]*,$(FullPath_Pchs) $@: ,g" < $@.tmp > $@
	$(RM) $@.tmp
endif

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
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Pchs); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Pchs)) do (echo     \--   %%i)
endif
	$(RM) $(FullPath_Pchs)
endif

# commands-pchs
$(FullPath_Pchs):
	$(MKDIR) $(ErrDir)
	$(MKDIR) $(PchDir)
	$(ECHO) compiling $(basename $@)...
	$(ECHO) - > $(ErrDir)/$(patsubst %/,%,$(notdir $@)).err
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
$(ObjDir)/%.o: %.cpp $(FullPath_Pchs)
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO) - > $(ErrDir)/$*.o.err
	$(ECHO) --[$(Project)]$*.cpp-- >> $(ErrDir)/$*.o.err
	$(CC) -c $(CFlags) $< -o $@ 2>>$(ErrDir)/$*.o.err 

# c files
$(ObjDir)/%.o: %.c $(FullPath_Pchs)
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(ECHO) compiling $<...
	$(ECHO) - > $(ErrDir)/$*.o.err
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
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Errs); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Errs)) do (echo     \--   %%i)
endif
else
	$(ECHO) "    |--"
endif
	$(RM) $(FullPath_Errs)


