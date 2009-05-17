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
# Desc: cwd 
# ------------------------------------------------------------------ 

if test "${cwd}" == ""; then
    echo error: variable: cwd not set
    errstatus=1
    exit $errstatus
fi

# ------------------------------------------------------------------ 
# Desc: lang_type 
# ------------------------------------------------------------------ 

if test "${lang_type}" == ""; then
    lang_type="auto"
fi

# ------------------------------------------------------------------ 
# Desc: vimfiles_path 
# ------------------------------------------------------------------ 

if test "${vimfiles_path}" == ""; then
    vimfiles_path="_vimfiles"
fi

# ------------------------------------------------------------------ 
# Desc: file_filter
# ------------------------------------------------------------------ 

if test "${file_filter}" == ""; then
    file_filter="c\|cpp\|cxx\|c++\|C\|cc\|h\|H\|hh\|hxx\|hpp\|inl\|cs\|uc\|hlsl\|vsh\|psh\|fx\|fxh\|cg\|shd\|glsl\|py\|pyw\|vim\|awk\|m\|dox\|doxygen\|ini\|cfg\|wiki\|mk\|err\|exe\|bat\|sh"
fi

# ------------------------------------------------------------------ 
# Desc: dir_filter 
# ------------------------------------------------------------------ 

if test "${dir_filter}" == ""; then
    dir_filter=""
fi

# ------------------------------------------------------------------ 
# Desc: support_filenamelist 
# ------------------------------------------------------------------ 

if test "${support_filenamelist}" == ""; then
    support_filenamelist="true"
fi

# ------------------------------------------------------------------ 
# Desc: support_ctags 
# ------------------------------------------------------------------ 

if test "${support_ctags}" == ""; then
    support_ctags="true"
fi

# ------------------------------------------------------------------ 
# Desc: support_symbol 
# ------------------------------------------------------------------ 

if test "${support_symbol}" == ""; then
    support_symbol="true"
fi

# ------------------------------------------------------------------ 
# Desc: support_inherit 
# ------------------------------------------------------------------ 

if test "${support_inherit}" == ""; then
    support_inherit="true"
fi

# ------------------------------------------------------------------ 
# Desc: support_cscope 
# ------------------------------------------------------------------ 

if test "${support_cscope}" == ""; then
    support_cscope="true"
fi

# ------------------------------------------------------------------ 
# Desc: support_idutils 
# ------------------------------------------------------------------ 

if test "${support_idutils}" == ""; then
    support_idutils="true"
fi

# ------------------------------------------------------------------ 
# Desc: ctags_options 
# ------------------------------------------------------------------ 

if test "%ctags_options%" == ""; then
    ctags_options="--c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python,vim,html,lua,javascript,java,uc,math --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd,javascript:+.as"
fi

#/////////////////////////////////////////////////////////////////////////////
# echo setting infos
#/////////////////////////////////////////////////////////////////////////////

echo "---------------------------------------------"
echo "pre-check"
echo "---------------------------------------------"
echo
echo "language type: ${lang_type}"
echo "support filenamelist: ${support_filenamelist}"
echo "support ctags: ${support_ctags}"
echo "support symbol: ${support_symbol}"
echo "support inheirts: ${support_inherit}"
echo "support cscope: ${support_cscope}"
echo "support id-utils: ${support_idutils}"
echo
echo "script type: ${script_type}"
echo "generate type: ${gen_type}"
echo "cwd: ${cwd}"
echo "file filter: ${file_filter}"
echo "dir filter: ${dir_filter}"
echo "vimfiles path: ${vimfiles_path}"
echo
echo "---------------------------------------------"
echo "process"
echo "---------------------------------------------"
echo

# /////////////////////////////////////////////////////////////////////////////
# gen functions
# /////////////////////////////////////////////////////////////////////////////

# ------------------------------------------------------------------ 
# Desc: gen_filenamelist 
# ------------------------------------------------------------------ 

gen_filenamelist () 
{
    if test "$support_filenamelist" = "true"; then
        echo Creating Filename List...

        # create filenamelist_cwd
        find ${dir_filter} -regex '.*\.\('"${file_filter}"'\)' >> "./${vimfiles_path}/_filenamelist_cwd"
        # NOTE: if we have dir filter, we still need get files in root directory 
        if test "${dir_filter}" != ""; then
            find . -maxdepth 1 -regex '.*\.\('"${file_filter}"'\)' >> "./${vimfiles_path}/_filenamelist_cwd"
        fi

        # create filenamelist_vimfiles
        sed "s,\(.*\),.\1,g" "./${vimfiles_path}/_filenamelist_cwd" >> "./${vimfiles_path}/_filenamelist_vimfiles"

        # move filenamelist files to vimfiles_path
        mv -f "./${vimfiles_path}/_filenamelist_cwd" "./${vimfiles_path}/filenamelist_cwd"
        mv -f "./${vimfiles_path}/_filenamelist_vimfiles" "./${vimfiles_path}/filenamelist_vimfiles"
    fi
}

# ------------------------------------------------------------------ 
# Desc: gen_tag 
# ------------------------------------------------------------------ 

gen_tag () 
{
    if test "$support_ctags" = "true"; then
        # create tags
        echo "Creating Tags..."

        # choose ctags path first
        if [ -f "./${vimfiles_path}/filenamelist_vimfiles" ]; then
            ctags_path="-L ./filenamelist_vimfiles" 
        else
            ctags_path="-R .." 
        fi

        # process tags by langugage
        cd ${vimfiles_path}
        ctags -o./_tags ${ctags_path} ${ctags_options}

        # force change _tags to tags
        mv -f "_tags" "tags"
        cd ..
    fi
}

# ------------------------------------------------------------------ 
# Desc: gen_symbols
# ------------------------------------------------------------------ 

gen_symbols ()
{
    if test "$support_symbol" = "true"; then
        echo "Creating Symbols..."
        gawk -f "${EX_DEV}/vim/toolkit/gawk/prg_NoStripSymbol.awk" ./${vimfiles_path}/tags>./${vimfiles_path}/_symbol
        mv -f "./${vimfiles_path}/_symbol" "./${vimfiles_path}/symbol"
    fi
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
        if [ -f "./${vimfiles_path}/filenamelist_cwd" ]; then
            cp "./${vimfiles_path}/filenamelist_cwd" cscope.files 
        else
            find . -regex '.*\.\('"${file_filter}"'\)' > cscope.files
        fi

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
        mkid --include="text" --lang-map="./${vimfiles_path}/id-lang.map" ${dir_filter}

        # if not, we try to use auto-gen id language map as second option
    elif [ -f "./${vimfiles_path}/id-lang-autogen.map" ]; then
        echo Creating IDs by auto-gen language map...
        mkid --include="text" --lang-map="./${vimfiles_path}/id-lang-autogen.map" ${dir_filter}

        # if both file not exists, we use default one in toolkit directory
    else
        echo Creating IDs by default language map...
        mkid --include="text" --lang-map="${EX_DEV}/vim/toolkit/idutils/id-lang.map" ${dir_filter}
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
    gen_filenamelist
    gen_tag
    gen_symbols
    gen_inherits
    gen_cscope
    gen_id
    ;;

    # process generate filenamelist
    "filenamelist")
    gen_filenamelist
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

