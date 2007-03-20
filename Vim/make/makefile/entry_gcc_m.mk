# Copyright (C) 2006 Johnny
# ayacai [at] 163 [dot] com

# ----------------------------------------------------------
#  User Define
# ----------------------------------------------------------

# include general config
include config.mk

# Sub-Directry names as known as project names
Prjs += # The Sub-Dir name

# ----------------------------------------------------------
#  Advance User Define
# ----------------------------------------------------------

# Project Commands
PrjCmds := $(addsuffix /%,$(Prjs))
PrjCmd_All := $(addsuffix /all,$(Prjs))
PrjCmd_Clean := $(addsuffix /clean-all,$(Prjs))
PrjCmd_Rebuild := $(addsuffix /rebuild,$(Prjs))

# ----------------------------------------------------------
#  Rules
# ----------------------------------------------------------

.PHONY: all clean-all rebuild
all: |$(PrjCmd_All)
clean-all: |$(PrjCmd_Clean)
rebuild: |clean-all all

.PHONY: $(Prjs) $(PrjCmds)
$(Prjs):
	$(ECHO) Making Project-$@...
	$(SMAKE) -C$@ -f$@.mk
	$(ECHO) Project-$@ making done

$(PrjCmds):
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)
 
$(PrjCmd_All):
	$(ECHO)
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)
 
$(PrjCmd_Clean):
	$(ECHO)
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)
 
$(PrjCmd_Rebuild):
	$(ECHO)
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)
 
