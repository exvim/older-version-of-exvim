#  ======================================================================================
#  File         : gcc_rule_m.mk
#  Author       : Wu Jie 
#  Last Change  : 12/06/2009 | 14:17:33 PM | Sunday,December
#  Description  : 
#  ======================================================================================

# /////////////////////////////////////////////////////////////////////////////
#  Cmds
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: Batched Project Commands
#  ------------------------------------------------------------------ 

Batched_Prj_Cmds := $(addsuffix /%,$(Batched_Prjs))
Batched_Prj_Cmd_All := $(addsuffix /all,$(Batched_Prjs))
Batched_Prj_Cmd_Clean := $(addsuffix /clean-all,$(Batched_Prjs))
Batched_Prj_Cmd_Rebuild := $(addsuffix /rebuild,$(Batched_Prjs))
Batched_Prj_Cmd_Clean_Deps := $(addsuffix /clean-deps,$(Batched_Prjs))

#  ------------------------------------------------------------------ 
#  Desc: Stand-alone Project Commands
#  ------------------------------------------------------------------ 

StandAlone_Prj_Cmds := $(addsuffix /%,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_All := $(addsuffix /all,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_Clean := $(addsuffix /clean-all,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_Rebuild := $(addsuffix /rebuild,$(StandAlone_Prjs))
StandAlone_Prj_Cmd_Clean_Deps := $(addsuffix /clean-deps,$(StandAlone_Prjs))

#  ------------------------------------------------------------------ 
#  Desc: All Project Commands
#  ------------------------------------------------------------------ 

Prjs := $(Batched_Prjs) $(StandAlone_Prjs)
Prj_Cmds := $(Batched_Prj_Cmds) $(StandAlone_Prj_Cmds)
Prj_Cmd_All := $(Batched_Prj_Cmd_All) $(StandAlone_Prj_Cmd_All)
Prj_Cmd_Clean := $(Batched_Prj_Cmd_Clean) $(StandAlone_Prj_Cmd_Clean)
Prj_Cmd_Rebuild := $(Batched_Prj_Cmd_Rebuild) $(StandAlone_Prj_Cmd_Rebuild)
Prj_Cmd_Clean_Deps := $(Batched_Prj_Cmd_Clean_Deps) $(StandAlone_Prj_Cmd_Clean_Deps)

# /////////////////////////////////////////////////////////////////////////////
#  Rules
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: all project rules 
# 	make -f gcc_entry_m.mk all/clean-all/clean-deps/rebuild
#  ------------------------------------------------------------------ 

.PHONY: all clean-all clean-deps rebuild
all: |$(Batched_Prj_Cmd_All)
clean-all: |$(Batched_Prj_Cmd_Clean)
clean-deps: |$(Batched_Prj_Cmd_Clean_Deps)
rebuild: |clean-all all

#  ------------------------------------------------------------------ 
#  Desc: single project rules 
#  ------------------------------------------------------------------ 

.PHONY: $(Prjs) $(Prj_Cmds) $(Prj_Cmd_All) $(Prj_Cmd_Clean) $(Prj_Cmd_Rebuild)

#  ======================================================== 
#  make -f gcc_entry_m.mk PrjName 
#  ======================================================== 

$(Prjs):
	$(ECHO) Making Project-$@...
	$(SMAKE) -C$@ -f$@.mk
	$(ECHO) Project-$@ making done

#  ======================================================== 
#  make -f gcc_entry_m.mk PrjName/cmd 
#  ======================================================== 

$(Prj_Cmds):
	$(ECHO) ==========================================================
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(ECHO) ==========================================================
	$(ECHO) $(VERTICAL_BAR)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)

#  ======================================================== 
#  make -f gcc_entry_m.mk PrjName/all 
#  ======================================================== 

$(Prj_Cmd_All):
	$(ECHO) ==========================================================
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(ECHO) ==========================================================
	$(ECHO) $(VERTICAL_BAR)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)

#  ======================================================== 
#  make -f gcc_entry_m.mk PrjName/clean-all 
#  ======================================================== 

$(Prj_Cmd_Clean):
	$(ECHO) ==========================================================
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(ECHO) ==========================================================
	$(ECHO) $(VERTICAL_BAR)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)

#  ======================================================== 
#  make -f gcc_entry_m.mk PrjName/rebuild 
#  ======================================================== 

$(Prj_Cmd_Rebuild):
	$(ECHO) ==========================================================
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(ECHO) ==========================================================
	$(ECHO) $(VERTICAL_BAR)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)

#  ======================================================== 
#  make -f gcc_entry_m.mk PrjName/clean-deps
#  ======================================================== 

$(Prj_Cmd_Clean_Deps):
	$(ECHO) ==========================================================
	$(ECHO) Project: $(dir $@)
	$(ECHO) Command: $(notdir $@)
	$(ECHO) ==========================================================
	$(ECHO) $(VERTICAL_BAR)
	$(SMAKE) -C$(dir $@) -f$(patsubst %/,%,$(dir $@)).mk $(notdir $@)

