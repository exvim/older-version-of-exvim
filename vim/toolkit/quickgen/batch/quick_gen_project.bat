@echo off

rem  ======================================================================================
rem  File         : quick_gen_project.bat
rem  Author       : Wu Jie 
rem  Last Change  : 10/19/2008 | 15:27:53 PM | Sunday,October
rem  Description  : 
rem  ======================================================================================

rem /////////////////////////////////////////////////////////////////////////////
rem preprocess arguments
rem /////////////////////////////////////////////////////////////////////////////

rem  ------------------------------------------------------------------ 
rem  Desc: 
rem  arguments:
rem  1  lang_type: "all", "general", "c", "cpp", "c#", "html", "js", "lua", "math", "python", "uc", "vim"
rem  2  gen_type (none eaqual to all): "all", "tag", "symbol", "inherit", "cscope", "id"
rem  3  vimfiles_path (none eaqual to _vimfiles): 
rem  ------------------------------------------------------------------ 

set lang_type=%1

if /I "%2" == "" (
    set gen_type=all
    ) else (
    set gen_type=%2
    )

if /I "%3" == "" (
    set vimfiles_path=_vimfiles
    ) else (
    set vimfiles_path=%3
    )


rem /////////////////////////////////////////////////////////////////////////////
rem set variables
rem /////////////////////////////////////////////////////////////////////////////

rem  ------------------------------------------------------------------ 
rem  Desc: init default variables
rem  ------------------------------------------------------------------ 

set return=FINISH
set file_filter=*.c *.cpp *.cxx *.h *.hpp *.inl *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.uc *.m
set support_inherit=true
set support_cscope=true

rem  ------------------------------------------------------------------ 
rem  Desc: set variable depends on differnet language
rem  ------------------------------------------------------------------ 

rem all
if /I "%lang_type%" == "all" (
    set file_filter=*.c *.cpp *.cxx *.h *.hpp *.inl *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.uc *.m
    set support_inherit=true
    set support_cscope=true

rem cstyle settings
    ) else if /I "%lang_type%" == "general" (
    set file_filter=*.c *.cpp *.cxx *.h *.hpp *.inl *.hlsl *.vsh *.psh *.fx *.fxh *.cg *.shd *.uc *.m
    set support_inherit=true
    set support_cscope=true

rem c-only settings
    ) else if /I "%lang_type%" == "c" (
    set file_filter=*.c *.h
    set support_inherit=false
    set support_cscope=true

rem cpp-only settings
    ) else if /I "%lang_type%" == "cpp" (
    set file_filter=*.cpp *.cxx *.h *.hpp *.inl
    set support_inherit=true
    set support_cscope=true

rem c-sharp settings
    ) else if /I "%lang_type%" == "c#" (
    set file_filter=*.cs
    set support_inherit=true
    set support_cscope=false

rem html settings
    ) else if /I "%lang_type%" == "html" (
    set file_filter=*.html *.htm *.shtml *.stm
    set support_inherit=false
    set support_cscope=false

rem javascript settings
    ) else if /I "%lang_type%" == "js" (
    set file_filter=*.js *.as
    set support_inherit=true
    set support_cscope=false

rem lua settings
    ) else if /I "%lang_type%" == "lua" (
    set file_filter=*.lua
    set support_inherit=false
    set support_cscope=false

rem math settings
    ) else if /I "%lang_type%" == "math" (
    set file_filter=*.m
    set support_inherit=false
    set support_cscope=false

rem python settings
    ) else if /I "%lang_type%" == "python" (
    set file_filter=*.py
    set support_inherit=true
    set support_cscope=false

rem unreal-script settings
    ) else if /I "%lang_type%" == "uc" (
    set file_filter=*.uc
    set support_inherit=true
    set support_cscope=false

rem vim settings
    ) else if /I "%lang_type%" == "vim" (
    set file_filter=*.vim
    set support_inherit=false
    set support_cscope=false

rem unknown language settings
    ) else (
    echo error: can't find language type
    goto FINISH
    )

rem echo setting infos
echo language type: %lang_type%
echo support inheirts: %support_inherit%
echo support cscope: %support_cscope%
echo generate type: %gen_type%
echo.
goto START

rem /////////////////////////////////////////////////////////////////////////////
rem gen functions 
rem /////////////////////////////////////////////////////////////////////////////

rem  ------------------------------------------------------------------ 
rem  Desc: create tags
rem  ------------------------------------------------------------------ 

rem  ######################### 
:GEN_TAG
rem  ######################### 

rem create tags
echo Creating Tags...

rem process tags by langugage
cd "%vimfiles_path%"
if /I "%lang_type%" == "all" ( 
    ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python,vim,html,lua,javascript,uc,math --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd,javascript:+.as ..
) else if /I "%lang_type%" == "general" (
    ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd ..
) else if /I "%lang_type%" == "c" (
    ctags -o./_tags -R --c-kinds=+p --fields=+iaS --extra=+q --languages=c --langmap=c++:+.inl ..
) else if /I "%lang_type%" == "cpp" ( 
    ctags -o./_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ --langmap=c++:+.inl ..
) else if /I "%lang_type%" == "c#" (
    ctags -o./_tags -R --fields=+iaS --extra=+q --languages=c# ..
) else if /I "%lang_type%" == "html" (
    ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=html ..
) else if /I "%lang_type%" == "js" ( 
    ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=javascript --langmap=javascript:+.as ..
) else if /I "%lang_type%" == "lua" (
    ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=lua ..
) else if /I "%lang_type%" == "math" (
    ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=math ..
) else if /I "%lang_type%" == "python" ( 
    ctags -o./_tags -R --fields=+iaS --extra=+q --languages=python ..
) else if /I "%lang_type%" == "uc" ( 
    ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=uc ..
) else if /I "%lang_type%" == "vim" (
    ctags -o./_tags -R  --fields=+iaS --extra=+q --languages=vim ..
)
move /Y "_tags" "tags"
cd ..
goto %return%

rem  ------------------------------------------------------------------ 
rem  Desc: create symbols
rem  ------------------------------------------------------------------ 

rem  ######################### 
:GEN_SYMBOL
rem  ######################### 

echo Creating Symbols...
gawk -f "%EX_DEV%\Vim\toolkit\gawk\prg_NoStripSymbol.awk" ".\%vimfiles_path%\tags">".\%vimfiles_path%\_symbol"
move /Y ".\%vimfiles_path%\_symbol" ".\%vimfiles_path%\symbol"
goto %return%

rem  ------------------------------------------------------------------ 
rem  Desc: create inherits
rem  NOTE: only for OO language
rem  ------------------------------------------------------------------ 

rem  ######################### 
:GEN_INHERIT
rem  ######################### 

if /I "%support_inherit%" == "true" (
    echo Creating Inherits...
    gawk -f "%EX_DEV%\Vim\toolkit\gawk\prg_Inherits.awk" ".\%vimfiles_path%\tags">".\%vimfiles_path%\_inherits"
    move /Y ".\%vimfiles_path%\_inherits" ".\%vimfiles_path%\inherits"
)
goto %return%

rem  ------------------------------------------------------------------ 
rem  Desc: create cscope files
rem  NOTE: only for c/cpp
rem  ------------------------------------------------------------------ 

rem  ######################### 
:GEN_CSCOPE
rem  ######################### 

if /I "%support_cscope%" == "true" (
    echo Creating cscope.files...
    dir /s /b %file_filter%|sed "s,\(.*\),\"\1\",g" > cscope.files
    echo Creating cscope.out...
    cscope -b
    move /Y cscope.files ".\%vimfiles_path%\cscope.files"
    move /Y cscope.out ".\%vimfiles_path%\cscope.out"
)
goto %return%

rem  ------------------------------------------------------------------ 
rem  Desc: create IDs
rem  ------------------------------------------------------------------ 

rem  ######################### 
:GEN_ID
rem  ######################### 

rem if we have manual configure id language map, we use it as highest priority
if exist .\%vimfiles_path%\id-lang.map (
    echo Creating IDs by custom language map...
    mkid --include="text" --lang-map=".\%vimfiles_path%\id-lang.map"

rem if not, we try to use auto-gen id language map as second option
) else if exist .\%vimfiles_path%\id-lang-autogen.map (
    echo Creating IDs by auto-gen language map...
    mkid --include="text" --lang-map=".\%vimfiles_path%\id-lang-autogen.map"

rem if both file not exists, we use default one in toolkit directory
) else (
    echo Creating IDs by default language map...
    mkid --include="text" --lang-map="%EX_DEV%\vim\toolkit\idutils\id-lang.map"
)

rem mkid --include="C C++"
move /Y ID ".\%vimfiles_path%\ID"
goto %return%

rem /////////////////////////////////////////////////////////////////////////////
rem Start Process
rem /////////////////////////////////////////////////////////////////////////////

rem  ######################### 
:START
rem  ######################### 

rem  ======================================================== 
rem  Desc: start generate
rem  ======================================================== 

echo Start Generate Project...

rem  ======================================================== 
rem  Desc: create directory first
rem  ======================================================== 

echo Create Diretory: %vimfiles_path%
mkdir "%vimfiles_path%"

rem  ======================================================== 
rem  Desc: choose the generate mode
rem  ======================================================== 

rem process generate all
echo.
if /I "%gen_type%" == "all" ( 
    set return=all_1
    goto GEN_TAG
:all_1
    set return=all_2
    goto GEN_SYMBOL
:all_2
    set return=all_3
    goto GEN_INHERIT
:all_3
    set return=all_4
    goto GEN_CSCOPE
:all_4
    set return=all_5
    goto GEN_ID
:all_5
    goto FINISH

rem process generate tag
) else if /I "%gen_type%" == "tag" (
    set return=tag_1
    goto GEN_TAG
:tag_1
    goto FINISH

rem process generate symbol
) else if /I "%gen_type%" == "symbol" ( 
    set return=symbol_1
    goto GEN_SYMBOL
:symbol_1
    goto FINISH

rem process generate inherits
) else if /I "%gen_type%" == "inherit" ( 
    set return=inherit_1
    goto GEN_INHERIT
:inherit_1
    goto FINISH

rem process generate cscope
) else if /I "%gen_type%" == "cscope" ( 
    set return=cscope_1
    goto GEN_CSCOPE
:cscope_1
    goto FINISH

rem process generate id
) else if /I "%gen_type%" == "id" ( 
    set return=id_1
    goto GEN_ID
:id_1
    goto FINISH

rem process generate unknown
) else (
    echo "Please specify tag, symbol, inherit, cscope, id or NA as the second arg"
)

rem  ------------------------------------------------------------------ 
rem  Desc: finish process
rem  ------------------------------------------------------------------ 

rem  ######################### 
:FINISH
rem  ######################### 

echo Finish
echo on

