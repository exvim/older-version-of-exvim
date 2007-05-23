# Copyright (C) 2006 Johnny
# ayacai [at] 163 [dot] com

# ----------------------------------------------------------
#  Global Configuration
# ----------------------------------------------------------
# include general config
include config.mk

# ----------------------------------------------------------
#  User Define
# ----------------------------------------------------------

# The Solution Name
Sln = # The Solution Name

# Project names
Prjs += # The Sub-Project Name

Configuration = Debug
Platform = Win32

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
	$(DEVENV) $(Sln) /Build "$(Configuration)|$(Platform)"
clean-all: 
	$(DEVENV) $(Sln) /Clean "$(Configuration)|$(Platform)"
rebuild: 
	$(DEVENV) $(Sln) /Rebuild "$(Configuration)|$(Platform)"

.PHONY: $(PrjCmds_All) $(PrjCmds_All) $(PrjCmd_Rebuild)
$(PrjCmd_All):
	$(DEVENV) $(Sln) /Build "$(Configuration)|$(Platform)" /Project $(dir $@)
 
$(PrjCmd_Clean):
	$(DEVENV) $(Sln) /Clean "$(Configuration)|$(Platform)" /Project $(dir $@)
 
$(PrjCmd_Rebuild):
	$(DEVENV) $(Sln) /Rebuild "$(Configuration)|$(Platform)" /Project $(dir $@)

