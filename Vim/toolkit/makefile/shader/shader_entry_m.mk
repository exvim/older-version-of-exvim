#  ======================================================================================
#  File         : shader_entry_m.mk
#  Author       : Wu Jie 
#  Last Change  : 10/19/2008 | 13:55:22 PM | Sunday,October
#  Description  : 
#  ======================================================================================

# /////////////////////////////////////////////////////////////////////////////
#  User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: include general config
#  ------------------------------------------------------------------ 

include shader_config.mk

#  ------------------------------------------------------------------ 
#  Desc: Sub-Directry names as known as project names for batched projects
#  ------------------------------------------------------------------ 

Batched_Prjs += # The Sub-Dir name

#  ------------------------------------------------------------------ 
#  Desc: Sub-Directry names as known as project names for stand-alone projects
#  ------------------------------------------------------------------ 

StandAlone_Prjs += # The Sub-Dir name

# /////////////////////////////////////////////////////////////////////////////
#  Advance User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Batched Project Commands
#  ------------------------------------------------------------------ 

Batched_Prj_Cmds := $(addsuffix /%,$(Batched_Prjs))
Batched_Prj_Cmd_All := $(addsuffix /all,$(Batched_Prjs))
Batched_Prj_Cmd_Clean := $(addsuffix /clean-all,$(Batched_Prjs))
Batched_Prj_Cmd_Rebuild := $(addsuffix /rebuild,$(Batched_Prjs))

#  ------------------------------------------------------------------ 
#  Desc: Stand-alone Project Commands
#  ------------------------------------------------------------------ 

StandAlone_Prj_Cmds := $(addsuffix /%,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_All := $(addsuffix /all,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_Clean := $(addsuffix /clean-all,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_Rebuild := $(addsuffix /rebuild,$(StandAlone_Prjs))

#  ------------------------------------------------------------------ 
#  Desc: All Project Commands
#  ------------------------------------------------------------------ 

Prjs := $(Batched_Prjs) $(StandAlone_Prjs)
Prj_Cmds := $(Batched_Prj_Cmds) $(StandAlone_Prj_Cmds)
Prj_Cmd_All := $(Batched_Prj_Cmd_All) $(StandAlone_Prj_Cmd_All)
Prj_Cmd_Clean := $(Batched_Prj_Cmd_Clean) $(StandAlone_Prj_Cmd_Clean)
Prj_Cmd_Rebuild := $(Batched_Prj_Cmd_Rebuild) $(StandAlone_Prj_Cmd_Rebuild)


# /////////////////////////////////////////////////////////////////////////////
#  Rules
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: all project rules 
# 	make -f shader_entry_m.mk all/clean-all/rebuild
#  ------------------------------------------------------------------ 

.PHONY: all clean-all rebuild
all: |$(Batched_Prj_Cmd_All)
clean-all: |$(Batched_Prj_Cmd_Clean)
rebuild: |clean-all all

#  ------------------------------------------------------------------ 
#  Desc: single project rules 
#  ------------------------------------------------------------------ 

.PHONY: $(Prjs) $(Prj_Cmds) $(Prj_Cmd_All) $(Prj_Cmd_Clean) $(Prj_Cmd_Rebuild)

#  ======================================================== 
#  make -f shader_entry_m.mk PrjName 
#  ======================================================== 

$(Prjs):
	$(ECHO) Making Project-$@...
	$(SMAKE) -C$@ -f$@.mk
	$(ECHO) Project-$@ making done

#  ======================================================== 
#  make -f shader_entry_m.mk PrjName/cmd 
#  ======================================================== 

$(Prj_Cmds):
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)

#  ======================================================== 
#  make -f shader_entry_m.mk PrjName/(all) 
#  ======================================================== 
 
$(Prj_Cmd_All):
	$(ECHO)
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)

#  ======================================================== 
#  make -f shader_entry_m.mk PrjName/clean-all
#  ======================================================== 
 
$(Prj_Cmd_Clean):
	$(ECHO)
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)

#  ======================================================== 
#  make -f shader_entry_m.mk PrjName/rebuild
#  ======================================================== 
 
$(Prj_Cmd_Rebuild):
	$(ECHO)
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)
 
