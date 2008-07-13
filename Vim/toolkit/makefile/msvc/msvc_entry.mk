############################################################
## Copyright (C) 2006 Johnny
## ayacai [at] 163 [dot] com
############################################################

# ----------------------------------------------------------
#  Global Configuration
# ----------------------------------------------------------
# include general config
include msvc_config.mk

# ----------------------------------------------------------
#  Pre-generate Target
# ----------------------------------------------------------

# -------------------
#  Out Directory
# -------------------

OutDir := ./_build/msvc/$(Platform)

# -------------------
#  Logs
# -------------------

# Error File Output Path
ErrDir := $(OutDir)/$(Configuration)/logs/errors
ErrLogName := ErrorLog.err
FullPath_Errs := $(ErrDir)/$(ErrLogName)

# ----------------------------------------------------------
#  User Define
# ----------------------------------------------------------

# The Solution Name
Sln =

# Project names
Prjs +=

# ----------------------------------------------------------
#  Advance User Define
# ----------------------------------------------------------

# Project Commands
PrjCmd_All := $(addsuffix /all,$(Prjs))
PrjCmd_Clean := $(addsuffix /clean-all,$(Prjs))
PrjCmd_Rebuild := $(addsuffix /rebuild,$(Prjs))

# ----------------------------------------------------------
#  Rules
# ----------------------------------------------------------

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

.PHONY: $(PrjCmds_All) $(PrjCmds_All) $(PrjCmd_Rebuild)
$(PrjCmd_All):
	$(MKDIR) $(ErrDir)
	$(ECHO) ^<^<^<^<^<^< $(Compiler) error log ^>^>^>^>^>^> > $(FullPath_Errs)
	$(DEVENV) $(Sln) /Build "$(Configuration)|$(Platform)" /Project $(patsubst %/,%,$(dir $@)) /Out $(FullPath_Errs)
 
$(PrjCmd_Clean):
	$(MKDIR) $(ErrDir)
	$(ECHO) ^<^<^<^<^<^< $(Compiler) error log ^>^>^>^>^>^> > $(FullPath_Errs)
	$(DEVENV) $(Sln) /Clean "$(Configuration)|$(Platform)" /Project $(patsubst %/,%,$(dir $@)) /Out $(FullPath_Errs)
 
$(PrjCmd_Rebuild):
	$(MKDIR) $(ErrDir)
	$(ECHO) ^<^<^<^<^<^< $(Compiler) error log ^>^>^>^>^>^> > $(FullPath_Errs)
	$(DEVENV) $(Sln) /Rebuild "$(Configuration)|$(Platform)" /Project $(patsubst %/,%,$(dir $@)) /Out $(FullPath_Errs)

