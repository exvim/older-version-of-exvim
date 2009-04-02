# ======================================================================================
# File         : quick_gen_project.sh
# Author       : Wu Jie 
# Last Change  : 04/01/2009 | 21:47:47 PM | Wednesday,April
# Description  : 
# ======================================================================================

errstatus=0
export EX_DEV="/usr/local/share"

# /////////////////////////////////////////////////////////////////////////////
# preprocess arguments
# /////////////////////////////////////////////////////////////////////////////

# ------------------------------------------------------------------ 
# Desc: 
# arguments:
# 1  lang_type: "all", "general", "c", "cpp", "c#", "html", "js", "lua", "math", "python", "uc", "vim"
# 2  gen_type: "all", "tag", "symbol", "inherit", "cscope", "id"
# ------------------------------------------------------------------ 

lang_type=$1
gen_type=$2

# /////////////////////////////////////////////////////////////////////////////
# set variables
# /////////////////////////////////////////////////////////////////////////////

# ------------------------------------------------------------------ 
# Desc: init default variables
# ------------------------------------------------------------------ 

file_filter="*.c *.cpp *.cxx *.h *.hpp *.inl *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.uc *.m"
support_inherit="true"
support_cscope="true"

# ------------------------------------------------------------------ 
# Desc: set variable depends on differnet language
# ------------------------------------------------------------------ 

# all
if test "$lang_type" = "all"; then 
    file_filter="*.c *.cpp *.cxx *.h *.hpp *.inl *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.uc *.m"
    support_inherit="true"
    support_cscope="true"

# cstyle settings
elif test "$lang_type" = "general"; then
    file_filter="*.c *.cpp *.cxx *.h *.hpp *.inl *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.uc *.m"
    support_inherit="true"
    support_cscope="true"

# c-only settings
elif test "$lang_type" = "c"; then
    file_filter="*.c *.h"
    support_inherit="false"
    support_cscope="true"

# cpp-only settings
elif test "$lang_type" = "cpp"; then
    file_filter="*.cpp *.cxx *.h *.hpp *.inl"
    support_inherit="true"
    support_cscope="true"

# c-sharp settings
elif test "$lang_type" = "c#"; then
    file_filter="*.cs"
    support_inherit="true"
    support_cscope="false"

# html settings
elif test "$lang_type" = "html"; then
    file_filter="*.html *.htm *.shtml *.stm"
    support_inherit="false"
    support_cscope="false"

# javascript settings
elif test "$lang_type" = "js"; then
    file_filter="*.js *.as"
    support_inherit="true"
    support_cscope="false"

# lua settings
elif test "$lang_type" = "lua"; then
    file_filter="*.lua"
    support_inherit="false"
    support_cscope="false"

# math settings
elif test "$lang_type" = "math"; then
    file_filter="*.m"
    support_inherit="false"
    support_cscope="false"

# python settings
elif test "$lang_type" = "python"; then
    file_filter="*.py"
    support_inherit="true"
    support_cscope="false"

# unreal-script settings
elif test "$lang_type" = "uc"; then
    file_filter="*.uc"
    support_inherit="true"
    support_cscope="false"

# vim settings
elif test "$lang_type" = "vim"; then
    file_filter="*.vim"
    support_inherit="false"
    support_cscope="false"

# unknown language settings
else
    echo "error: can't find language type"
    errstatus=1
    exit $errstatus
fi

# echo setting infos
echo "language type: ${lang_type}"
echo "support inheirts: ${support_inherit}"
echo "support cscope: ${support_cscope}"
echo "generate type: ${gen_type}"

# /////////////////////////////////////////////////////////////////////////////
# gen functions
# /////////////////////////////////////////////////////////////////////////////

# ------------------------------------------------------------------ 
# Desc: gen_tag 
# ------------------------------------------------------------------ 

gen_tag () 
{
    # create tags
    echo "Creating Tags..."

    # process tags by langugage
    if test "$lang_type" = "all"; then 
        ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python,vim,html,lua,javascript,uc,math --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd,javascript:+.as
    elif test "$lang_type" = "general"; then 
        ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd
    elif test "$lang_type" = "c"; then
        ctags -o./_tags -R --c-kinds=+p --fields=+iaS --extra=+q --languages=c --langmap=c++:+.inl
    elif test "$lang_type" = "cpp"; then
        ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ --langmap=c++:+.inl
    elif test "$lang_type" = "c#"; then
        ctags -o./_tags -R --fields=+iaS --extra=+q --languages=c#
    elif test "$lang_type" = "html"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=html
    elif test "$lang_type" = "js"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=javascript --langmap=javascript:+.as
    elif test "$lang_type" = "lua"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=lua
    elif test "$lang_type" = "math"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=math
    elif test "$lang_type" = "python"; then
        ctags -o./_tags -R --fields=+iaS --extra=+q --languages=python
    elif test "$lang_type" = "uc"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=uc
    elif test "$lang_type" = "vim"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=vim
    fi

    # force change _tags to tags
    mv -f "_tags" "tags"
}

# ------------------------------------------------------------------ 
# Desc: gen_symbols
# ------------------------------------------------------------------ 

gen_symbols ()
{
    echo "Creating Symbols..."
    gawk -f "${EX_DEV}/vim/toolkit/gawk/prg_NoStripSymbol.awk" ./tags>./_vimfiles/_symbol
    mv -f "./_vimfiles/_symbol" "./_vimfiles/symbol"
}

# ------------------------------------------------------------------ 
# Desc: gen_inherits
# NOTE: only for OO language
# ------------------------------------------------------------------ 

gen_inherits ()
{
    if test "$support_inherit" = "true"; then
        echo "Creating Inherits..."
        gawk -f "${EX_DEV}/vim/toolkit/gawk/prg_Inherits.awk" ./tags>./_vimfiles/_inherits
        mv -f "./_vimfiles/_inherits" "./_vimfiles/inherits"
    fi
}

# ------------------------------------------------------------------ 
# Desc: gen_cscope 
# ------------------------------------------------------------------ 

gen_cscope ()
{
    if test "$support_cscope" = "true"; then
        echo "Creating cscope.files..."
        dir /s /b %file_filter%|sed "s,\(.*\),\"\1\",g" > cscope.files
        echo "Creating cscope.out..."
        cscope -b
        mv -f "cscope.files" "./_vimfiles/cscope.files"
        mv -f "cscope.out" "./_vimfiles/cscope.out"
    fi
}

# ------------------------------------------------------------------ 
# Desc: gen_id 
# ------------------------------------------------------------------ 

gen_id ()
{
    echo "Creating IDs..."
    mkid --include="text"
    # mkid --include="C C++"
    mv -f "ID" "./_vimfiles/ID"
}

# /////////////////////////////////////////////////////////////////////////////
# Start Process
# /////////////////////////////////////////////////////////////////////////////

# ======================================================== 
# Desc: start generate
# ======================================================== 

echo "Start Generate Project..."

# ======================================================== 
# Desc: create directory first
# ======================================================== 

echo "Create Diretory: _vimfiles"
mkdir -p _vimfiles

# ======================================================== 
# Desc: choose the generate mode
# ======================================================== 

case "$gen_type" in

    # process generate all
    "all")
    gen_tag
    gen_symbols
    gen_inherits
    gen_cscope
    gen_id
    ;;

    # process generate tag
    "tag")
    gen_tag
    ;;

    # process generate symbol
    "symbol")
    gen_symbols
    ;;

    # process generate inherits
    "inherit")
    gen_inherits
    ;;

    # process generate cscope
    "cscope")
    gen_cscope
    ;;

    # process generate id
    "id")
    gen_id
    ;;

    # process invalid arg
    *)
    echo "Please specify tag, symbol, inherit, cscope, id or NA as the second arg"
    ;;
esac

# ------------------------------------------------------------------ 
# Desc: finish process
# ------------------------------------------------------------------ 

echo "Finish"

exit $errstatus

