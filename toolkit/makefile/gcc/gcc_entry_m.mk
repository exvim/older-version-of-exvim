#  ======================================================================================
#  File         : gcc_entry_m.mk
#  Author       : Wu Jie 
#  Last Change  : 10/19/2008 | 11:13:31 AM | Sunday,October
#  Description  : 
#  ======================================================================================

# /////////////////////////////////////////////////////////////////////////////
#  User Define
# /////////////////////////////////////////////////////////////////////////////

#  ------------------------------------------------------------------ 
#  Desc: include general config
#  ------------------------------------------------------------------ 

include gcc_config.mk

#  ------------------------------------------------------------------ 
#  Desc: Sub-Directry names as known as project names for batched projects
#  ------------------------------------------------------------------ 

Batched_Prjs += # TODO: The Sub-Dir name

#  ------------------------------------------------------------------ 
#  Desc: Sub-Directry names as known as project names for stand-alone projects
#  ------------------------------------------------------------------ 

StandAlone_Prjs += # TODO: The Sub-Dir name

# /////////////////////////////////////////////////////////////////////////////
#  Rules
# /////////////////////////////////////////////////////////////////////////////

ifeq ($(Platform),Win32) # win32
include $(EX_DEV)/exvim/toolkit/makefile/gcc/gcc_rule_m.mk
else
ifeq ($(Platform),Linux) # unix/linux
include ~/.toolkit/makefile/gcc/gcc_rule_m.mk
else # other system
include ~/.toolkit/makefile/gcc/gcc_rule_m.mk
endif
endif
