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
rem  1  gen_type (none eaqual to all): "all", "filenamelist", "tag", "symbol", "inherit", "cscope", "id"
rem  ------------------------------------------------------------------ 

if /I "%1" == "" (
    set gen_type=all
    ) else (
    set gen_type=%1
    )

rem /////////////////////////////////////////////////////////////////////////////
rem set variables
rem /////////////////////////////////////////////////////////////////////////////

rem  ------------------------------------------------------------------ 
rem  Desc: cwd 
rem  ------------------------------------------------------------------ 

if /I "%cwd%" == "" (
    echo error: variable: cwd not set
    goto FINISH
    )

rem  ------------------------------------------------------------------ 
rem  Desc: toolkit_path 
rem  ------------------------------------------------------------------ 

if /I "%toolkit_path%" == "" (
    set toolkit_path=%EX_DEV%\exvim\toolkit
    )

rem  ------------------------------------------------------------------ 
rem  Desc: lang_type
rem  ------------------------------------------------------------------ 

if /I "%lang_type%" == "" (
    set lang_type=auto
    )

rem  ------------------------------------------------------------------ 
rem  Desc: vimfiles_path
rem  ------------------------------------------------------------------ 

if /I "%vimfiles_path%" == "" (
    set vimfiles_path=.vimfiles
    )

rem  ------------------------------------------------------------------ 
rem  Desc: file_filter 
rem  NOTE: dir /s /b accept *.H and output files with *.h, *.H.
rem  ------------------------------------------------------------------ 

if /I "%file_filter%" == "" (
    set file_filter=*.C *.CPP *.CXX *.C++ *.CC *.H *.HH *.HXX *.HPP *.INL *.CS *.UC *.HLSL *.VSH *.PSH *.FX *.FXH *.CG *.SHD *.GLSL *.PY *.PYW *.VIM *.AWK *.M *.DOX *.DOXYGEN *.INI *.CFG *.WIKI *.MK *.ERR *.EXE *.BAT *.SH *.TXT
    )

rem  ------------------------------------------------------------------ 
rem  Desc: file_filter_pattern 
rem  ------------------------------------------------------------------ 

if /I %file_filter_pattern% == "" (
    set file_filter_pattern="\\.c$|\\.C$|\\.cpp$|\\.cxx$|\\.c++$|\\.cc$|\\.h$|\\.H$|\\.hh$|\\.hxx$|\\.hpp$|\\.inl$|\\.cs$|\\.uc$|\\.hlsl$|\\.vsh$|\\.psh$|\\.fx$|\\.fxh$|\\.cg$|\\.shd$|\\.glsl$|\\.py$|\\.pyw$|\\.vim$|\\.awk$|\\.m$|\\.dox$|\\.doxygen$|\\.ini$|\\.cfg$|\\.wiki$|\\.mk$|\\.err$|\\.exe$|\\.bat$|\\.sh$|\\.txt$"
    )

rem  ------------------------------------------------------------------ 
rem  Desc: cscope_file_filter 
rem  NOTE: dir /s /b accept *.H and output files with *.h, *.H.
rem  ------------------------------------------------------------------ 

if /I "%cscope_file_filter%" == "" (
    set cscope_file_filter=*.C *.CPP *.CXX *.C++ *.CC *.H *.HH *.HXX *.HPP *.INL *.HLSL *.VSH *.PSH *.FX *.FXH *.CG *.SHD *.GLSL
    )

rem  ------------------------------------------------------------------ 
rem  Desc: cscope_file_filter_pattern 
rem  ------------------------------------------------------------------ 

if /I %cscope_file_filter_pattern% == "" (
    set cscope_file_filter_pattern="\\.c$|\\.C$\\.cpp$|\\.cxx$|\\.c++$|\\.cc$|\\.h$|\\.H$|\\.hh$|\\.hxx$|\\.hpp$|\\.inl$|\\.hlsl$|\\.vsh$|\\.psh$|\\.fx$|\\.fxh$|\\.cg$|\\.shd$|\\.glsl$"
    )

rem  ------------------------------------------------------------------ 
rem  Desc: dir_filter 
rem  ------------------------------------------------------------------ 

if /I "%dir_filter%" == "" (
    set dir_filter=
    )

rem  ------------------------------------------------------------------ 
rem  Desc: support_filenamelist
rem  ------------------------------------------------------------------ 

if /I "%support_filenamelist%" == "" (
    set support_filenamelist=true
    )

rem  ------------------------------------------------------------------ 
rem  Desc: support_ctags
rem  ------------------------------------------------------------------ 

if /I "%support_ctags%" == "" (
    set support_ctags=true
    )

rem  ------------------------------------------------------------------ 
rem  Desc: support_symbol 
rem  ------------------------------------------------------------------ 

if /I "%support_symbol%" == "" (
    set support_symbol=true
    )

rem  ------------------------------------------------------------------ 
rem  Desc: support_inherit
rem  ------------------------------------------------------------------ 

if /I "%support_inherit%" == "" (
    set support_inherit=true
    )

rem  ------------------------------------------------------------------ 
rem  Desc: support_cscope 
rem  ------------------------------------------------------------------ 

if /I "%support_cscope%" == "" (
    set support_cscope=true
    )

rem  ------------------------------------------------------------------ 
rem  Desc: support_idutils 
rem  ------------------------------------------------------------------ 

if /I "%support_idutils%" == "" (
    set support_idutils=true
    )

rem  ------------------------------------------------------------------ 
rem  Desc: ctags_cmd 
rem  ------------------------------------------------------------------ 

if /I "%ctags_cmd%" == "" (
    set ctags_cmd=ctags
    )

rem  ------------------------------------------------------------------ 
rem  Desc: ctags_options 
rem  ------------------------------------------------------------------ 

if /I "%ctags_options%" == "" (
    set ctags_options=--c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python,vim,html,lua,javascript,java,uc,math --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd,javascript:+.as
    )

rem  ------------------------------------------------------------------ 
rem  Desc: return
rem  ------------------------------------------------------------------ 

set return=FINISH

rem /////////////////////////////////////////////////////////////////////////////
rem echo setting infos
rem /////////////////////////////////////////////////////////////////////////////

echo ---------------------------------------------
echo pre-check
echo ---------------------------------------------
echo.
echo language type: %lang_type%
echo support filenamelist: %support_filenamelist%
echo support ctags: %support_ctags%
echo support symbol: %support_symbol%
echo support inheirts: %support_inherit%
echo support cscope: %support_cscope%
echo support id-utils: %support_idutils%
echo.
echo script type: %script_type%
echo generate type: %gen_type%
echo cwd: %cwd%
echo file filter: %file_filter%
echo cscope file filter: %cscope_file_filter%
echo dir filter: %dir_filter%
echo vimfiles path: %vimfiles_path%
echo.
echo ---------------------------------------------
echo process
echo ---------------------------------------------
echo.
goto START

rem /////////////////////////////////////////////////////////////////////////////
rem gen functions 
rem /////////////////////////////////////////////////////////////////////////////

rem  ------------------------------------------------------------------ 
rem  Desc: create filenamelist_cwd and filenamelist_vimfiles 
rem  ------------------------------------------------------------------ 

rem  ######################### 
:GEN_FILENAME_LIST
rem  ######################### 

echo Creating Filename List...

rem create cwd pattern for sed
set cwd_pattern=%cwd%
echo %cwd%>.\%vimfiles_path%\_cwd_
for /f "delims=" %%a in ('type .\%vimfiles_path%\_cwd_^|sed "s,\\,\\\\,g"') do (
    set cwd_pattern=%%a
    )

if /I "%support_filenamelist%" == "true" (
    echo    ^|- generate _filenamelist_cwd_gawk
    rem create filenamelist_cwd
    if /I "%dir_filter%" == "" (
        dir /s /b %file_filter%|sed "s,\(%cwd_pattern%\)\(.*\),.\\\2,gI" >> ".\%vimfiles_path%\_filenamelist_cwd_gawk"
        ) else (
        dir /b %file_filter%|sed "s,\(.*\),.\\\1,gI" >> ".\%vimfiles_path%\_filenamelist_cwd_gawk"
        for %%i in (%dir_filter%) do (
            cd %%i
            dir /s /b %file_filter%|sed "s,\(%cwd_pattern%\)\(.*\),.\\\2,gI" >> "..\%vimfiles_path%\_filenamelist_cwd_gawk"
            cd ..
            )
        )
    echo    ^|- process _filenamelist_cwd_gawk to _filenamelist_cwd
    rem NOTE: dir /s /b *.cpp will list xxx.cpp~, too. So use gawk here to filter out thoes things.
    gawk -v filter_pattern=%file_filter_pattern% -f "%toolkit_path%\gawk\prg_FileFilter.awk" ".\%vimfiles_path%\_filenamelist_cwd_gawk">".\%vimfiles_path%\_filenamelist_cwd"
    del ".\%vimfiles_path%\_filenamelist_cwd_gawk" > nul
    if exist .\%vimfiles_path%\_filenamelist_cwd (
        echo    ^|- rename _filenamelist_cwd to filenamelist_cwd
        move /Y ".\%vimfiles_path%\_filenamelist_cwd" ".\%vimfiles_path%\filenamelist_cwd" > nul
    )
    
    rem create filenamelist_vimfiles
    echo    ^|- generate _filenamelist_vimfiles
    sed "s,\(.*\),.\1,g" ".\%vimfiles_path%\filenamelist_cwd" >> ".\%vimfiles_path%\_filenamelist_vimfiles"
    if exist .\%vimfiles_path%\_filenamelist_vimfiles (
        echo    ^|- rename _filenamelist_vimfiles to filenamelist_vimfiles
        move /Y ".\%vimfiles_path%\_filenamelist_vimfiles" ".\%vimfiles_path%\filenamelist_vimfiles" > nul
    )
    
    rem create filenametags
    echo    ^|- generate _filenametags
    gawk -f "%toolkit_path%\gawk\prg_FilenameTagWin.awk" ".\%vimfiles_path%\filenamelist_vimfiles">".\%vimfiles_path%\_filenametags"
    if exist .\%vimfiles_path%\_filenametags (
        echo    ^|- rename _filenametags to filenametags
        move /Y ".\%vimfiles_path%\_filenametags" ".\%vimfiles_path%\filenametags" > nul
    )

    echo    ^|- done!
)
goto %return%

rem  ------------------------------------------------------------------ 
rem  Desc: create tags
rem  ------------------------------------------------------------------ 

rem  ######################### 
:GEN_TAG
rem  ######################### 
    
rem choose ctags path first
rem NOTE: the set ctags_path can't put in support_ctags if scope, or it will failed. 
if exist .\%vimfiles_path%\filenamelist_vimfiles (
    set ctags_path=-L filenamelist_vimfiles 
) else (
    set ctags_path=-R .. 
)

rem process ctags 
if /I "%support_ctags%" == "true" (
    rem create tags
    echo Creating Tags...
    
    rem process tags by langugage
    cd "%vimfiles_path%"
    echo    ^|- generate _tags
    %ctags_cmd% -o./_tags %ctags_options% %ctags_path%
    if exist _tags (
        echo    ^|- rename _tags to tags
        move /Y "_tags" "tags" > nul
    )
    cd ..
    echo    ^|- done!
)
goto %return%

rem  ------------------------------------------------------------------ 
rem  Desc: create symbols
rem  ------------------------------------------------------------------ 

rem  ######################### 
:GEN_SYMBOL
rem  ######################### 

if /I "%support_symbol%" == "true" (
    echo Creating Symbols...
    echo    ^|- generate _symbol
    gawk -f "%toolkit_path%\gawk\prg_NoStripSymbol.awk" ".\%vimfiles_path%\tags">".\%vimfiles_path%\_symbol"
    if exist .\%vimfiles_path%\_symbol (
        echo    ^|- rename _symbol to symbol
        move /Y ".\%vimfiles_path%\_symbol" ".\%vimfiles_path%\symbol" > nul
    )
    echo    ^|- done
)
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
    echo    ^|- generate _inherits
    gawk -f "%toolkit_path%\gawk\prg_Inherits.awk" ".\%vimfiles_path%\tags">".\%vimfiles_path%\_inherits"
    if exist .\%vimfiles_path%\_inherits (
        echo    ^|- rename _inherits to inherits
        move /Y ".\%vimfiles_path%\_inherits" ".\%vimfiles_path%\inherits" > nul
    )
    echo    ^|- done
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
    echo Creating cscope data...
    echo    ^|- generate cscope.files
    if exist .\%vimfiles_path%\filenamelist_cwd (
        gawk -v filter_pattern=%cscope_file_filter_pattern% -f "%toolkit_path%\gawk\prg_FileFilterWithQuotes.awk" ".\%vimfiles_path%\filenamelist_cwd" > cscope.files
    ) else (
        dir /s /b %cscope_file_filter%|sed "s,\(.*\),\"\1\",g" > cscope.files
    )
    echo    ^|- generate cscope.out
    cscope -b
    if exist cscope.files (
        echo    ^|- move cscope.files to .\%vimfiles_path%\cscope.files
        move /Y cscope.files ".\%vimfiles_path%\cscope.files" > nul
    )
    if exist cscope.out (
        echo    ^|- move cscope.out to .\%vimfiles_path%\cscope.out
        move /Y cscope.out ".\%vimfiles_path%\cscope.out" > nul
    )
    echo    ^|- done
)
goto %return%

rem  ------------------------------------------------------------------ 
rem  Desc: create IDs
rem  ------------------------------------------------------------------ 

rem  ######################### 
:GEN_ID
rem  ######################### 

if /I "%support_idutils%" == "true" (
    rem mkid --include="C C++"
    rem TODO: mkid --include="text" --lang-map=".\%vimfiles_path%\id-lang.map" "./folder1" "./folder2" ... 
    rem TODO: but how to include files in root directory???
    
    echo Creating ID...
    rem if we have manual configure id language map, we use it as highest priority
    if exist .\%vimfiles_path%\id-lang-custom.map (
        echo    ^|- generate ID by custom language map 
        mkid --include="text" --lang-map=".\%vimfiles_path%\id-lang-custom.map" %dir_filter%
    
    rem if not, we try to use auto-gen id language map as second option
    ) else if exist .\%vimfiles_path%\id-lang-autogen.map (
        echo    ^|- generate ID by auto-gen language map 
        mkid --include="text" --lang-map=".\%vimfiles_path%\id-lang-autogen.map" %dir_filter%
    
    rem if both file not exists, we use default one in toolkit directory
    ) else (
        echo    ^|- generate ID by default language map 
        mkid --include="text" --lang-map="%toolkit_path%\idutils\id-lang.map" %dir_filter%
    )
    
    if exist ID (
        echo    ^|- move ID to .\%vimfiles_path%\ID
        move /Y ID ".\%vimfiles_path%\ID" > nul
    )
    echo    ^|- done
)
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
    goto GEN_FILENAME_LIST
:all_1
    set return=all_2
    goto GEN_TAG
:all_2
    set return=all_3
    goto GEN_SYMBOL
:all_3
    set return=all_4
    goto GEN_INHERIT
:all_4
    set return=all_5
    goto GEN_CSCOPE
:all_5
    set return=all_6
    goto GEN_ID
:all_6
    goto FINISH

rem process generate filenamelist
) else if /I "%gen_type%" == "filenamelist" (
    set return=filenamelist_1
    goto GEN_FILENAME_LIST
:filenamelist_1
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
