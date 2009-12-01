#  ======================================================================================
#  File         : msvc_entry.mk
#  Author       : Wu Jie 
#  Last Change  : 10/19/2008 | 11:42:59 AM | Sunday,October
#  Description  : 
#  ======================================================================================

# /////////////////////////////////////////////////////////////////////////////
#  Global Configuration
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: include general config
#  ------------------------------------------------------------------ 

include msvc_config.mk

# /////////////////////////////////////////////////////////////////////////////
#  Pre-generate Target
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Out Directory
#  ------------------------------------------------------------------ 

OutDir := ./_build/msvc/$(Platform)

#  ------------------------------------------------------------------ 
#  Desc: Logs 
#  	Error File Output Path
#  ------------------------------------------------------------------ 

ErrDir := $(OutDir)/$(Configuration)/logs/errors
ErrLogName := ErrorLog.err
FullPath_Errs := "$(ErrDir)/$(ErrLogName)"

# /////////////////////////////////////////////////////////////////////////////
#  User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: The Solution Name
#  ------------------------------------------------------------------ 

Sln =

#  ------------------------------------------------------------------ 
#  Desc: Project names
#  ------------------------------------------------------------------ 

Prjs +=

# /////////////////////////////////////////////////////////////////////////////
#  Advance User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Project Commands
#  ------------------------------------------------------------------ 

PrjCmd_All := $(addsuffix /all,$(Prjs))
PrjCmd_Clean := $(addsuffix /clean-all,$(Prjs))
PrjCmd_Rebuild := $(addsuffix /rebuild,$(Prjs))

# /////////////////////////////////////////////////////////////////////////////
#  Rules
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: all project rules 
# 	make -f msvc_entry.mk all/clean-all/rebuild
#  ------------------------------------------------------------------ 

.PHONY: all clean-all rebuild
all: 
	$(MKDIR) $(ErrDir)
	$(ECHO) ^<^<^<^<^<^< $(Compiler) error log ^>^>^>^>^>^> > $(FullPath_Errs)
	$(DEVENV) $(Sln) /Build "$(Configuration)|$(Platform)" /Out $(FullPath_Errs) 
clean-all: 
	$(MKDIR) $(ErrDir)
	$(ECHO) ^<^<^<^<^<^< $(Compiler) error log ^>^>^>^>^>^> > $(FullPath_Errs)
	$(DEVENV) $(Sln) /Clean "$(Configuration)|$(Platform)" /Out $(FullPath_Errs)
rebuild: 
	$(MKDIR) $(ErrDir)
	$(ECHO) ^<^<^<^<^<^< $(Compiler) error log ^>^>^>^>^>^> > $(FullPath_Errs)
	$(DEVENV) $(Sln) /Rebuild "$(Configuration)|$(Platform)" /Out $(FullPath_Errs)

#  ------------------------------------------------------------------ 
#  Desc: single project rules 
#  ------------------------------------------------------------------ 

.PHONY: $(PrjCmds_All) $(PrjCmds_All) $(PrjCmd_Rebuild)

#  ======================================================== 
#  make -f msvc_entry.mk PrjName/(all) 
#  ======================================================== 

$(PrjCmd_All):
	$(MKDIR) $(ErrDir)
	$(ECHO) ^<^<^<^<^<^< $(Compiler) error log ^>^>^>^>^>^> > $(FullPath_Errs)
	$(DEVENV) $(Sln) /Build "$(Configuration)|$(Platform)" /Project $(patsubst %/,%,$(dir $@)) /Out $(FullPath_Errs)
 
#  ======================================================== 
#  make -f msvc_entry.mk PrjName/clean-all 
#  ======================================================== 

$(PrjCmd_Clean):
	$(MKDIR) $(ErrDir)
	$(ECHO) ^<^<^<^<^<^< $(Compiler) error log ^>^>^>^>^>^> > $(FullPath_Errs)
	$(DEVENV) $(Sln) /Clean "$(Configuration)|$(Platform)" /Project $(patsubst %/,%,$(dir $@)) /Out $(FullPath_Errs)
 
#  ======================================================== 
#  make -f msvc_entry.mk PrjName/rebuild
#  ======================================================== 

$(PrjCmd_Rebuild):
	$(MKDIR) $(ErrDir)
	$(ECHO) ^<^<^<^<^<^< $(Compiler) error log ^>^>^>^>^>^> > $(FullPath_Errs)
	$(DEVENV) $(Sln) /Rebuild "$(Configuration)|$(Platform)" /Project $(patsubst %/,%,$(dir $@)) /Out $(FullPath_Errs)

