-- ======================================================================================
-- File         : gen_installer.lua
-- Author       : Wu Jie 
-- Last Change  : 01/04/2011 | 23:28:35 PM | Tuesday,January
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- requires
--/////////////////////////////////////////////////////////////////////////////

require "lfs"
require "ex.futil"
require "settings"

--/////////////////////////////////////////////////////////////////////////////
-- scripts
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: precheck 
-- ------------------------------------------------------------------ 

local function precheck () 
    print "" 
    print "#########################" 
    print "Checking settings..."
    print "#########################" 
    print ""

    -- get version info
    print ("version = " .. settings.version)

    -- check if dest path exists
    print ("dest path = " .. settings.build_path)
    if lfs.attributes(settings.build_path) ~= nil then
        -- local ret,info = lfs.rmdir(settings.build_path)
        -- if ret == nil then
        --     print ("failed to remove directory " .. settings.build_path .. " the error message is: " .. info)
        --     return false
        -- end
        ex.futil.rmdirs(settings.build_path)
    end
    ret,info = lfs.mkdir(settings.build_path) -- create dest path
    if ret == nil then
        print ("failed to create dest path at " .. settings.build_path .. " the error message is: " .. info)
        return false
    end

    -- check exvim path
    print ("exvim path = " .. settings.exvim_path)
    if lfs.attributes(settings.exvim_path) == nil then
        print "can not found exvim"
        return false
    else
        print "exvim path OK!"
    end

    -- check exenv path
    print ("exenv path = " .. settings.exenv_path)
    if lfs.attributes(settings.exenv_path) == nil then
        print "can not found exenv"
        return false
    else
        print "exenv path OK!"
    end

    -- check graphviz path 
    print ("graphviz path = " .. settings.graphviz_path)
    if lfs.attributes(settings.graphviz_path) == nil then
        print "can not found graphviz"
        return false
    else
        print "graphviz path OK!"
    end

    -- finish pre-check
    print "done!"
    return true
end

-- ------------------------------------------------------------------ 
-- Desc: gen_installer 
-- ------------------------------------------------------------------ 

local function gen_installer () 
    print "" 
    print "#########################" 
    print "preparing install files..."
    print "#########################" 
    print ""

    print "copying vim73..."
    ex.futil.cpdir( settings.exvim_path.."/vim73", settings.build_path.."/rawdata/vim/vim73" )

    print "copying exvim..."
    ex.futil.cpdir( settings.exvim_path.."/toolkit", settings.build_path.."/rawdata/vim/exvim/toolkit" )
    ex.futil.cpdir( settings.exvim_path.."/vimfiles", settings.build_path.."/rawdata/vim/exvim/vimfiles" )
    ex.futil.cp( settings.exvim_path.."/.vimrc", settings.build_path.."/rawdata/vim/exvim" )

    print "copying resources..."
    ex.futil.cpdir( settings.exvim_path.."/distribute/installer/fonts", settings.build_path.."/rawdata/fonts" )
    ex.futil.cpdir( settings.exvim_path.."/distribute/installer/images", settings.build_path.."/rawdata/images" )

    print "copying gnu tools..."
    ex.futil.cpdir( settings.exenv_path.."/win32/bin", settings.build_path.."/rawdata/gnu/bin" )
    ex.futil.cpdir( settings.exenv_path.."/win32/share", settings.build_path.."/rawdata/gnu/share" )

    print "copying GraphViz..."
    ex.futil.cpdir( settings.graphviz_path, settings.build_path.."/rawdata/graphviz" )

    print "copying IrfanView..."
    ex.futil.cpdir( settings.irfanview_path, settings.build_path.."/rawdata/irfanview" )

    print "copying NSIS scripts..."
    ex.futil.cp( settings.exvim_path.."/distribute/installer/EnvVarUpdate.nsh", settings.build_path )
    ex.futil.cp( settings.exvim_path.."/distribute/installer/exvim.nsi", settings.build_path )
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function compile ()
    local dest = settings.target_path .. "/" .. settings.version
    ex.futil.mkdirs(dest)

    local cwd = lfs.currentdir ()
    lfs.chdir(settings.build_path)
    os.execute("makensis exvim.nsi")
    lfs.chdir(cwd)

    ex.futil.mv( settings.build_path .. "/exvim_installer.exe",
                 dest.."/exvim_installer-"..settings.version..".exe" )
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

precheck()
gen_installer()
compile()
