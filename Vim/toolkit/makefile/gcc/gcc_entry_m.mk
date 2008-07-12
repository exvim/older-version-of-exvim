############################################################
## Copyright (C) 2006 Johnny
## ayacai [at] 163 [dot] com
############################################################

# ----------------------------------------------------------
#  User Define
# ----------------------------------------------------------

# include general config
include gcc_config.mk

# Sub-Directry names as known as project names for batched projects
Batched_Prjs += # The Sub-Dir name

# Sub-Directry names as known as project names for stand-alone projects
StandAlone_Prjs += # The Sub-Dir name

# ----------------------------------------------------------
#  Advance User Define
# ----------------------------------------------------------

# Batched Project Commands
Batched_Prj_Cmds := $(addsuffix /%,$(Batched_Prjs))
Batched_Prj_Cmd_All := $(addsuffix /all,$(Batched_Prjs))
Batched_Prj_Cmd_Clean := $(addsuffix /clean-all,$(Batched_Prjs))
Batched_Prj_Cmd_Rebuild := $(addsuffix /rebuild,$(Batched_Prjs))
Batched_Prj_Cmd_Clean_Deps := $(addsuffix /clean-deps,$(Batched_Prjs))

# Stand-alone Project Commands
StandAlone_Prj_Cmds := $(addsuffix /%,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_All := $(addsuffix /all,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_Clean := $(addsuffix /clean-all,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_Rebuild := $(addsuffix /rebuild,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_Clean_Deps := $(addsuffix /clean-deps,$(StandAlone_Prjs))

# All Project Commands
Prjs := $(Batched_Prjs) $(StandAlone_Prjs)
Prj_Cmds := $(Batched_Prj_Cmds) $(StandAlone_Prj_Cmds)
Prj_Cmd_All := $(Batched_Prj_Cmd_All) $(StandAlone_Prj_Cmd_All)
Prj_Cmd_Clean := $(Batched_Prj_Cmd_Clean) $(StandAlone_Prj_Cmd_Clean)
Prj_Cmd_Rebuild := $(Batched_Prj_Cmd_Rebuild) $(StandAlone_Prj_Cmd_Rebuild)
Prj_Cmd_Clean_Deps := $(Batched_Prj_Cmd_Clean_Deps) $(StandAlone_Prj_Cmd_Clean_Deps)


# ----------------------------------------------------------
#  Rules
# ----------------------------------------------------------

.PHONY: all clean-all rebuild clean-deps
all: |$(Batched_Prj_Cmd_All)
clean-all: |$(Batched_Prj_Cmd_Clean)
clean-deps: |$(Batched_Prj_Cmd_Clean_Deps)
rebuild: |clean-all all

.PHONY: $(Prjs) $(Prj_Cmds) $(Prj_Cmd_All) $(Prj_Cmd_Clean) $(Prj_Cmd_Rebuild)
$(Prjs):
	$(ECHO) Making Project-$@...
	$(SMAKE) -C$@ -f$@.mk
	$(ECHO) Project-$@ making done

$(Prj_Cmds):
	$(ECHO) ==========================================================
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(ECHO) ==========================================================
	$(ECHO) ^|
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)
 
$(Prj_Cmd_All):
	$(ECHO) ==========================================================
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(ECHO) ==========================================================
	$(ECHO) ^|
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)
 
$(Prj_Cmd_Clean):
	$(ECHO) ==========================================================
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(ECHO) ==========================================================
	$(ECHO) ^|
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)
 
$(Prj_Cmd_Rebuild):
	$(ECHO) ==========================================================
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(ECHO) ==========================================================
	$(ECHO) ^|
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)
 
$(Prj_Cmd_Clean_Deps):
	$(ECHO) ==========================================================
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(ECHO) ==========================================================
	$(ECHO) ^|
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)
