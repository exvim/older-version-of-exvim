# ======================================================================================
# File         : quick_gen_project_custom.sh
# Author       : Wu Jie 
# Last Change  : 05/17/2009 | 13:37:32 PM | Sunday,May
# Description  : 
# ======================================================================================

#/////////////////////////////////////////////////////////////////////////////
# general
#/////////////////////////////////////////////////////////////////////////////

export script_type="custom"
export EX_DEV="/usr/local/share"
export cwd=${PWD}
export lang_type="c cpp c# uc shader python vim math"
export vimfiles_path=_vimfiles
export file_filter="c\|cpp\|cxx\|c++\|C\|cc\|h\|H\|hh\|hxx\|hpp\|inl\|cs\|uc\|hlsl\|vsh\|psh\|fx\|fxh\|cg\|shd\|glsl\|py\|pyw\|vim\|awk\|m\|dox\|doxygen\|ini\|cfg\|wiki\|mk\|err\|exe\|bat\|sh"
export dir_filter=""

#/////////////////////////////////////////////////////////////////////////////
# support
#/////////////////////////////////////////////////////////////////////////////

export support_filenamelist="true"
export support_ctags="true"
export support_symbol="true"
export support_inherit="true"
export support_cscope="true"
export support_idutils="true"

#/////////////////////////////////////////////////////////////////////////////
# options
#/////////////////////////////////////////////////////////////////////////////

export ctags_options=" --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,c,python,vim,math,uc, --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd,"

#/////////////////////////////////////////////////////////////////////////////
# main
#/////////////////////////////////////////////////////////////////////////////

bash ${EX_DEV}/vim/toolkit/quickgen/bash/quick_gen_project.sh $1

