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
# 1  gen_type (none eaqual to all): "all", "filenamelist", "tag", "symbol", "inherit", "cscope", "id"
# ------------------------------------------------------------------ 

if test "$1" = ""; then 
    gen_type=all
else
    gen_type=$1
fi

# /////////////////////////////////////////////////////////////////////////////
# set variables
# /////////////////////////////////////////////////////////////////////////////

# ------------------------------------------------------------------ 
# Desc: init default variables
# ------------------------------------------------------------------ 

file_filter="c\|cpp\|cxx\|h\|hpp\|inl\|hlsl\|vsh\|psh\|fx\|fxh\|cg\|shd\|uc\|m"
support_inherit="true"
support_cscope="true"

# ------------------------------------------------------------------ 
# Desc: set variable depends on differnet language
# ------------------------------------------------------------------ 

# all
if test "$lang_type" = "all"; then 
    file_filter="c\|cpp\|cxx\|h\|hpp\|inl\|hlsl\|vsh\|psh\|fx\|fxh\|cg\|shd\|uc\|m"
    support_inherit="true"
    support_cscope="true"

# cstyle settings
elif test "$lang_type" = "general"; then
    file_filter="c\|cpp\|cxx\|h\|hpp\|inl\|hlsl\|vsh\|psh\|fx\|fxh\|cg\|shd\|uc\|m"
    support_inherit="true"
    support_cscope="true"

# c-only settings
elif test "$lang_type" = "c"; then
    file_filter="c\|h"
    support_inherit="false"
    support_cscope="true"

# cpp-only settings
elif test "$lang_type" = "cpp"; then
    file_filter="cpp\|cxx\|h\|hpp\|inl"
    support_inherit="true"
    support_cscope="true"

# c-sharp settings
elif test "$lang_type" = "c#"; then
    file_filter="cs"
    support_inherit="true"
    support_cscope="false"

# html settings
elif test "$lang_type" = "html"; then
    file_filter="html\|htm\|shtml\|stm"
    support_inherit="false"
    support_cscope="false"

# javascript settings
elif test "$lang_type" = "js"; then
    file_filter="js\|as"
    support_inherit="true"
    support_cscope="false"

# lua settings
elif test "$lang_type" = "lua"; then
    file_filter="lua"
    support_inherit="false"
    support_cscope="false"

# math settings
elif test "$lang_type" = "math"; then
    file_filter="m"
    support_inherit="false"
    support_cscope="false"

# python settings
elif test "$lang_type" = "python"; then
    file_filter="py"
    support_inherit="true"
    support_cscope="false"

# unreal-script settings
elif test "$lang_type" = "uc"; then
    file_filter="uc"
    support_inherit="true"
    support_cscope="false"

# vim settings
elif test "$lang_type" = "vim"; then
    file_filter="vim"
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
echo 

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
    cd ${vimfiles_path}
    if test "$lang_type" = "all"; then 
        ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python,vim,html,lua,javascript,uc,math --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd,javascript:+.as ..
    elif test "$lang_type" = "general"; then 
        ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd ..
    elif test "$lang_type" = "c"; then
        ctags -o./_tags -R --c-kinds=+p --fields=+iaS --extra=+q --languages=c --langmap=c++:+.inl ..
    elif test "$lang_type" = "cpp"; then
        ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ --langmap=c++:+.inl ..
    elif test "$lang_type" = "c#"; then
        ctags -o./_tags -R --fields=+iaS --extra=+q --languages=c# ..
    elif test "$lang_type" = "html"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=html ..
    elif test "$lang_type" = "js"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=javascript --langmap=javascript:+.as ..
    elif test "$lang_type" = "lua"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=lua ..
    elif test "$lang_type" = "math"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=math ..
    elif test "$lang_type" = "python"; then
        ctags -o./_tags -R --fields=+iaS --extra=+q --languages=python ..
    elif test "$lang_type" = "uc"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=uc ..
    elif test "$lang_type" = "vim"; then
        ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=vim ..
    fi

    # force change _tags to tags
    mv -f "_tags" "tags"
    cd ..
}

# ------------------------------------------------------------------ 
# Desc: gen_symbols
# ------------------------------------------------------------------ 

gen_symbols ()
{
    echo "Creating Symbols..."
    gawk -f "${EX_DEV}/vim/toolkit/gawk/prg_NoStripSymbol.awk" ./${vimfiles_path}/tags>./${vimfiles_path}/_symbol
    mv -f "./${vimfiles_path}/_symbol" "./${vimfiles_path}/symbol"
}

# ------------------------------------------------------------------ 
# Desc: gen_inherits
# NOTE: only for OO language
# ------------------------------------------------------------------ 

gen_inherits ()
{
    if test "$support_inherit" = "true"; then
        echo "Creating Inherits..."
        gawk -f "${EX_DEV}/vim/toolkit/gawk/prg_Inherits.awk" ./${vimfiles_path}/tags>./${vimfiles_path}/_inherits
        mv -f "./${vimfiles_path}/_inherits" "./${vimfiles_path}/inherits"
    fi
}

# ------------------------------------------------------------------ 
# Desc: gen_cscope 
# ------------------------------------------------------------------ 

gen_cscope ()
{
    if test "$support_cscope" = "true"; then
        echo "Creating cscope.files..."
        find . -regex '.*\.\('"${file_filter}"'\)' > cscope.files
        echo "Creating cscope.out..."
        cscope -b
        mv -f "cscope.files" "./${vimfiles_path}/cscope.files"
        mv -f "cscope.out" "./${vimfiles_path}/cscope.out"
    fi
}

# ------------------------------------------------------------------ 
# Desc: gen_id 
# ------------------------------------------------------------------ 

gen_id ()
{
    # if we have manual configure id language map, we use it as highest priority
    if [ -f "./${vimfiles_path}/id-lang.map" ]; then
        echo Creating IDs by custom language map...
        mkid --include="text" --lang-map="./${vimfiles_path}/id-lang.map"

        # if not, we try to use auto-gen id language map as second option
    elif [ -f "./${vimfiles_path}/id-lang-autogen.map" ]; then
        echo Creating IDs by auto-gen language map...
        mkid --include="text" --lang-map="./${vimfiles_path}/id-lang-autogen.map"

        # if both file not exists, we use default one in toolkit directory
    else
        echo Creating IDs by default language map...
        mkid --include="text" --lang-map="${EX_DEV}/vim/toolkit/idutils/id-lang.map"
    fi

    # mkid --include="C C++"
    mv -f "ID" "./${vimfiles_path}/ID"
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

echo "Create Diretory: ${vimfiles_path}"
mkdir -p ${vimfiles_path}

# ======================================================== 
# Desc: choose the generate mode
# ======================================================== 

echo 
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

