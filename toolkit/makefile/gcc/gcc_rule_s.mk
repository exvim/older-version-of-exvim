#  ======================================================================================
#  File         : gcc_rule_s.mk
#  Author       : Wu Jie 
#  Last Change  : 12/06/2009 | 14:16:29 PM | Sunday,December
#  Description  : 
#  ======================================================================================

# /////////////////////////////////////////////////////////////////////////////
#  Pre-generate Target
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Out Directory
#  ------------------------------------------------------------------ 

OutDir ?= $(CWD)/_build/gcc/$(Platform)/$(Configuration)

#  ------------------------------------------------------------------ 
#  Desc: Include
#  ------------------------------------------------------------------ 

# TODO: ??? where is include?

#  ------------------------------------------------------------------ 
#  Desc: Precompiled Headers
#  ------------------------------------------------------------------ 

GchDir := $(addsuffix .gch,$(FullPath_GchSrcs))
FullPath_Gchs := $(addsuffix _$(Platform)_$(Configuration).h.gch,$(addprefix $(GchDir)/,$(basename $(notdir $(FullPath_GchSrcs)))))

#  ------------------------------------------------------------------ 
#  Desc: Source
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  Source Files With Full Path
#  ======================================================== 

FullPath_Srcs := $(wildcard $(addsuffix /*.c,$(SrcDirs))) $(wildcard $(addsuffix /*.cpp,$(SrcDirs))) 

#  DISABLE { 
#  ======================================================== 
#  Source Files
#  ======================================================== 

#  Srcs := $(notdir $(FullPath_Srcs))
#  } DISABLE end 

#  ------------------------------------------------------------------ 
#  Desc: Object
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  Object File Output Path
#  ======================================================== 

ObjDir := $(OutDir)/objs/$(Project)

#  ======================================================== 
#  Object File Output Names
#  ======================================================== 

Objs := $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(FullPath_Srcs)))

#  ======================================================== 
#  Object File With Full Path
#  ======================================================== 

FullPath_Objs := $(addprefix $(ObjDir)/,$(Objs))

#  ------------------------------------------------------------------ 
#  Desc: Dependence
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  Dependence File Output Path
#  ======================================================== 

DepDir := $(OutDir)/deps/$(Project)

#  ======================================================== 
#  Dependence File Output Names
#  ======================================================== 

Deps := $(patsubst %.o,%.d,$(Objs))
GchDeps := $(patsubst %.gch,%.d,$(notdir $(GchDir)))

#  ======================================================== 
#  Dependence File With Full Path
#  ======================================================== 

FullPath_Deps := $(addprefix $(DepDir)/,$(Deps))
FullPath_GchDeps := $(addprefix $(DepDir)/,$(GchDeps))
FullPath_AllDeps := $(FullPath_Deps) $(FullPath_GchDeps)

#  ------------------------------------------------------------------ 
#  Desc: Dependence Library
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  Dependence Libraries
#  ======================================================== 

Libs := $(PrjLibs) $(ExtLibs)

#  ======================================================== 
#  Project Compile Dependence Libraries Output Path
#  ======================================================== 

PrjLibDir := $(OutDir)/bin

#  ======================================================== 
#  Project compile dependence libraries with Full Path
#  ======================================================== 

FullPath_PrjLibs := $(addprefix $(PrjLibDir)/,$(addprefix lib,$(addsuffix .a,$(PrjLibs))))
LibDirs += $(PrjLibDir)

#  ------------------------------------------------------------------ 
#  Desc: Target
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  Target File Output Path & Name
#  ======================================================== 

ifeq ($(ProjectType),exe)
TargetDir := $(OutDir)/bin
Target := $(Project)_$(Configuration).$(EXE_NAME)
else
ifeq ($(ProjectType),lib)
TargetDir := $(OutDir)/bin
Target := lib$(Project).$(LIB_NAME)
else
ifeq ($(ProjectType),dll)
TargetDir := $(OutDir)/bin
Target := $(Project).$(DLL_NAME)
libTarget := lib$(Project).a
endif
endif
endif
FullPath_Target := $(TargetDir)/$(Target)

#  ------------------------------------------------------------------ 
#  Desc: Logs
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  Error File Output Path
#  ======================================================== 

ErrDir ?= $(OutDir)/logs/errors
FullPath_Errs := $(ErrDir)/$(Project).err
ErrLogName := ErrorLog.err

# /////////////////////////////////////////////////////////////////////////////
#  Compiler Flags
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Pre-define
#  ------------------------------------------------------------------ 

#  ======================================================== 
#  Configuration Pre-define
#  ======================================================== 

ifeq ($(Configuration),Debug)
PreDefs += DEBUG
PreDefs += _DEBUG
PreDefs += __EX_DEBUG
else 
ifeq ($(Configuration),Release)
PreDefs += NDEBUG
PreDefs += RELEASE
PreDefs += _RELEASE
PreDefs += __EX_RELEASE
else
ifeq ($(Configuration),Final)
PreDefs += NDEBUG
PreDefs += FINAL
PreDefs += __EX_FINAL
endif
endif
endif

#  ======================================================== 
#  Platform Pre-defeine
#  ======================================================== 

ifeq ($(Platform),Linux)
PreDefs += __LINUX__
PreDefs += _LINUX
PreDefs += LINUX
PreDefs += __EX_LINUX
else 
ifeq ($(Platform),Win32)
PreDefs += __WIN32__
PreDefs += _WIN32
PreDefs += WIN32
PreDefs += WIN
PreDefs += WINDOWS
PreDefs += __EX_WIN32
else 
ifeq ($(Platform),PS3)
PreDefs += __PS3__
PreDefs += _PS3
PreDefs += PS3
PreDefs += __EX_PS3
endif
endif
endif

#  ======================================================== 
#  Build as DLL or not
#  ======================================================== 

ifeq ($(ProjectType),dll)
PreDefs += DLL
PreDefs += _DLL
PreDefs += __EX_DLL
endif

# /////////////////////////////////////////////////////////////////////////////
# Generate Flag
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: pre-define
#  ------------------------------------------------------------------ 

Flag_PreDef := $(addprefix -D,$(PreDefs))

#  ------------------------------------------------------------------ 
#  Desc: includes
#  ------------------------------------------------------------------ 

Flag_Inc := $(addprefix -I,$(IncDirs))

#  ------------------------------------------------------------------ 
#  Desc: libaray directory
#  ------------------------------------------------------------------ 

Flag_LibDir := $(addprefix -L,$(LibDirs))

#  ------------------------------------------------------------------ 
#  Desc: libaray link
#  ------------------------------------------------------------------ 

Flag_Lib := $(addprefix -l,$(Libs))

#  ------------------------------------------------------------------ 
#  Desc: build as dll
#  ------------------------------------------------------------------ 

ifeq ($(ProjectType),dll)
Flag_BuildDll := -shared -Wl,--out-implib,$(TargetDir)/$(libTarget)
else
Flag_BuildDll :=
endif

#  ------------------------------------------------------------------ 
#  Desc: built-in function
#  ------------------------------------------------------------------ 

# mmx
ifeq ($(USE_MMX),1)
Flag_BuiltIn_Functions += -mmmx
endif
# sse
ifeq ($(USE_SSE),1)
Flag_BuiltIn_Functions += -msse
endif
# sse3
ifeq ($(USE_SSE3),1)
Flag_BuiltIn_Functions += -msse3
endif

#  ------------------------------------------------------------------ 
#  Desc: Debug Flag ( choose debug or not )
# 	Optimization Flag ( -O0:disable -O/-O1:general opt -O2:advance opt -O3:all opt )
#  ------------------------------------------------------------------ 

ifeq ($(Configuration),Debug)
Flag_Debug := -g
Flag_Opt := -O0
else
Flag_Debug :=
Flag_Opt := -O1
endif 

#  ------------------------------------------------------------------ 
#  Desc: Compile Flag
#  ------------------------------------------------------------------ 

CFlags := $(Flag_Debug) $(Flag_Opt) $(Flag_PreDef) $(Flag_Inc) $(Flag_BuiltIn_Functions) $(CFlag_Spec)

#  ------------------------------------------------------------------ 
#  Desc: Link Flag
#  ------------------------------------------------------------------ 

LFlags := $(Flag_LibDir) $(Flag_Lib) $(Flag_BuildDll) $(LFlag_Spec)

#  ------------------------------------------------------------------ 
#  Desc: VPATH
#  ------------------------------------------------------------------ 

VPATH := $(IncDirs)
VPATH += $(SrcDirs)
VPATH += $(TargetDir)

#  ------------------------------------------------------------------ 
#  Desc: MARKS to create directory enter/exit able error log
#  ------------------------------------------------------------------ 

ifeq ($(CURRENT_OS),Linux)
OPEN_MARK := "<<<<<<"
CLOSE_MARK := ">>>>>>"
PROJECT_MARK := \'$(Project)\'
else
OPEN_MARK := ^<^<^<^<^<^<
CLOSE_MARK := ^>^>^>^>^>^>
PROJECT_MARK := '$(Project)'
endif

# /////////////////////////////////////////////////////////////////////////////
#  Rules
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: All Rules
#  ------------------------------------------------------------------ 

.PHONY: all clean-all rebuild
all: |clean-errs $(FullPath_Target)
clean-all: |clean-gchs clean-objs clean-errs clean-target
rebuild: |clean-all all

#  ------------------------------------------------------------------ 
#  Desc: Target Rules
#  ------------------------------------------------------------------ 

.PHONY: target clean-target rebuild-target $(Target)

#  ======================================================== 
#  all
#  ======================================================== 

rebuild-target: |clean-target target
target: $(FullPath_Target)
clean-target:
	$(ECHO) -------------------
	$(ECHO) delete target:
	$(ECHO) -------------------
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Target); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Target)) do (echo     ^|--   %%i)
endif
	$(RM) $(FullPath_Target)
ifeq ($(ProjectType),dll)
	$(RM) $(TargetDir)/$(libTarget)
endif

#  ======================================================== 
#  single
#  ======================================================== 

$(Target): $(FullPath_Target)

#  ======================================================== 
#  commands-target
#  ======================================================== 

$(FullPath_Target): $(FullPath_Objs) $(FullPath_PrjLibs)
	$(ECHO) -------------------
	$(ECHO) linking:
	$(ECHO) -------------------
ifeq ($(CURRENT_OS),Linux)
	@for obj in $(filter %.o,$^); do echo "    |--"   $$obj; done
else
	@for %%i in ($(filter %.o,$^)) do (echo     ^|--   %%i)
endif
	$(MKDIR) $(TargetDir)
	$(MKDIR) $(ErrDir)
	$(ECHO_EMPTY_LINE) > $(ErrDir)/$(ErrLogName)
	$(ECHO) $(OPEN_MARK) $(Target): $(PROJECT_MARK) >> $(ErrDir)/$(ErrLogName)
ifeq ($(ProjectType),exe)
	$(CC) $(filter %.o,$^) $(LFlags) -o $@ 2>>$(ErrDir)/$(ErrLogName)
else
ifeq ($(ProjectType),lib)
	$(AR) r $@ $(filter %.o,$^) 2>>$(ErrDir)/$(ErrLogName)
else
ifeq ($(ProjectType),dll)
	$(CC) $(filter %.o,$^) $(LFlags) -o $@ 2>>$(ErrDir)/$(ErrLogName)
endif
endif
endif
	$(ECHO) $(CLOSE_MARK) >> $(ErrDir)/$(ErrLogName)
	$(ECHO) generate $(@)
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err
	$(POST_BUILD_ALL_PROJECT)
	$(POST_BUILD)

#  ------------------------------------------------------------------ 
#  Desc: Dependence Rules
#  ------------------------------------------------------------------ 

.PHONY: deps clean-deps rebuild-deps $(Deps)

#  ======================================================== 
#  all
#  ======================================================== 

rebuild-deps: |clean-deps deps
deps: $(FullPath_AllDeps)
clean-deps: 
	$(ECHO) -------------------
	$(ECHO) delete deps:
	$(ECHO) -------------------
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_AllDeps); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_AllDeps)) do (echo     ^|--   %%i)
endif
	$(RM) $(FullPath_AllDeps)

#  ======================================================== 
#  single
#  ======================================================== 

$(Deps):
	$(SMAKE) -f$(Project).mk $(DepDir)/$@
clean-%.d:
	$(ECHO) delete $(DepDir)/$*.d
	$(RM) $(DepDir)/$*.d

#  ======================================================== 
#  commands-deps
#  ======================================================== 

#  ======================================================== 
#  cpp-files
#  ======================================================== 

$(DepDir)/%.d: %.cpp
	$(ECHO) creating $@...
	$(MKDIR) $(DepDir)
	$(MKDIR) $(dir $@)
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

#  ======================================================== 
#  c-files
#  ======================================================== 

$(DepDir)/%.d: %.c
	$(ECHO) creating $@...
	$(MKDIR) $(DepDir)
	$(MKDIR) $(dir $@)
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

#  ======================================================== 
#  commands-gch-deps
#  ======================================================== 

$(DepDir)/%.h.d: %.h
	$(ECHO) creating $@...
	$(MKDIR) $(DepDir)
	$(MKDIR) $(dir $@)
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

#  ------------------------------------------------------------------ 
#  Desc: GCH Rules
#  ------------------------------------------------------------------ 

.PHONY: gchs clean-gchs rebuild-gchs
	
#  ======================================================== 
#  all
#  ======================================================== 

rebuild-gchs: |clean-gchs gchs
gchs: $(FullPath_Gchs)
clean-gchs: 
	$(ECHO) -------------------
	$(ECHO) delete gchs:
	$(ECHO) -------------------
ifneq ($(FullPath_Gchs),)
ifeq ($(CURRENT_OS),Linux)
	@for item in $(FullPath_Gchs); do echo "    |--"   $$item; done
else
	@for %%i in ($(FullPath_Gchs)) do (echo     ^|--   %%i)
endif
	$(RM) $(FullPath_Gchs)
endif

#  ======================================================== 
#  commands-gchs
#  ======================================================== 

$(FullPath_Gchs):
	$(MKDIR) $(ErrDir)
	$(MKDIR) $(GchDir)
	$(MKDIR) $(dir $@)
	$(ECHO) compiling $(basename $@)...
	$(ECHO_EMPTY_LINE) > $(ErrDir)/$(ErrLogName)
	$(ECHO) $(OPEN_MARK) $(patsubst %/,%,$(notdir $@)): $(PROJECT_MARK) >> $(ErrDir)/$(ErrLogName)
	$(CC) -c $(CFlags) $(basename $(GchDir)) -o $@ 2>>$(ErrDir)/$(ErrLogName)
	$(ECHO) $(CLOSE_MARK) >> $(ErrDir)/$(ErrLogName)
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

#  ------------------------------------------------------------------ 
#  Desc: Object Rules
#  ------------------------------------------------------------------ 

.PHONY: objs clean-objs rebuild-objs $(Objs)

#  ======================================================== 
#  all
#  ======================================================== 

rebuild-objs: |clean-objs objs
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
clean-%.o:
	$(ECHO) delete $(ObjDir)/$*.o
	$(RM) $(ObjDir)/$*.o

#  ======================================================== 
#  commands-objs
#  ======================================================== 

#  ======================================================== 
#  cpp files
#  ======================================================== 

-include $(FullPath_AllDeps)
$(ObjDir)/%.o: %.cpp $(FullPath_Gchs)
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(MKDIR) $(dir $@)
	$(ECHO) compiling $<...
	$(ECHO_EMPTY_LINE) > $(ErrDir)/$(ErrLogName)
	$(ECHO) $(OPEN_MARK) $*.cpp: $(PROJECT_MARK) >> $(ErrDir)/$(ErrLogName)
	$(CC) -c $(CFlags) $< -o $@ 2>>$(ErrDir)/$(ErrLogName) 
	$(ECHO) $(CLOSE_MARK) >> $(ErrDir)/$(ErrLogName)
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

#  ======================================================== 
#  c files
#  ======================================================== 

$(ObjDir)/%.o: %.c $(FullPath_Gchs)
	$(MKDIR) $(ObjDir)
	$(MKDIR) $(ErrDir)
	$(MKDIR) $(dir $@)
	$(ECHO) compiling $<...
	$(ECHO_EMPTY_LINE) > $(ErrDir)/$(ErrLogName)
	$(ECHO) $(OPEN_MARK) $*.c: $(PROJECT_MARK) >> $(ErrDir)/$(ErrLogName)
	$(CC) -c $(CFlags) $< -o $@ 2>>$(ErrDir)/$(ErrLogName) 
	$(ECHO) $(CLOSE_MARK) >> $(ErrDir)/$(ErrLogName)
	$(CAT) $(ErrDir)/$(ErrLogName) >> $(ErrDir)/$(Project).err

#  ------------------------------------------------------------------ 
#  Desc: Output Rules
#  ------------------------------------------------------------------ 

.PHONY: clean-errs

#  ======================================================== 
#  all
#  ======================================================== 

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


