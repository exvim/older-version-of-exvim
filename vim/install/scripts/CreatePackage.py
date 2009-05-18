# ======================================================================================
# File         : CreatePackage.py
# Author       : Wu Jie 
# Last Change  : 05/10/2009 | 16:28:29 PM | Sunday,May
# Description  : 
# ======================================================================================

#/////////////////////////////////////////////////////////////////////////////
# imports
#/////////////////////////////////////////////////////////////////////////////

import os.path
import shutil
import zipfile

#/////////////////////////////////////////////////////////////////////////////
# global variables
#/////////////////////////////////////////////////////////////////////////////

# general
version = "7.05a"
source_path = "d:/exDev/vim"
dest_root_path = "d:/Project/Dev/exVim_google/release_version" 
dest_version_path = dest_root_path + "/" + version

#
full_package_name = "full-package"
ex_package_name = "ex-plugins-package"
patched_package_name = "patched-plugins-package"
installer_name = "installer"

#/////////////////////////////////////////////////////////////////////////////
# functions
#/////////////////////////////////////////////////////////////////////////////

# ------------------------------------------------------------------ 
# Desc: 
# ------------------------------------------------------------------ 

def PreCheck ():
    print "" 
    print "#########################" 
    print "Pre-Checking..."
    print "#########################" 
    print ""

    print "version = %s" % version

    # check source path, if not found, return false
    print "source_path = %s" % os.path.abspath(source_path)
    if os.path.isdir( os.path.abspath(source_path) ) == False :
        print "source path not found"
        return False

    # check dest path, if not found, create one
    print "dest_version_path = %s" % dest_version_path
    if os.path.isdir(dest_version_path) == False :
        print "dest path not found, create the path."
        os.makedirs (dest_version_path)
        print "dest path %s created!" % dest_version_path

    print "Pre-Check done!"
    return True

# ------------------------------------------------------------------ 
# Desc: 
# ------------------------------------------------------------------ 

def AddDirToZip ( _zipfp, _dir_path ):
    # walk through the path
    for root, dirs, files in os.walk( _dir_path, topdown=True ):
        # don't visit .svn directories
        if '.svn' in dirs:
            dirs.remove('.svn') 

        # compress files
        for name in dirs:
            dir_full_path = os.path.join( root, name ) 
            print "adding folder: %s" % dir_full_path 

        # compress files
        for name in files:
            file_full_path = os.path.join( root, name ) 
            _zipfp.write ( file_full_path )

# ------------------------------------------------------------------ 
# Desc: CreateFullPackage 
# ------------------------------------------------------------------ 

def CreateFullPackage ():
    print "" 
    print "#########################" 
    print "full-package"
    print "#########################" 
    print ""

    print "Creating full-package"

    # create a full-package zip file
    full_package_path = dest_version_path + "/" + full_package_name + "-" + version + ".zip"
    zipfp = zipfile.ZipFile( full_package_path, "w", zipfile.ZIP_DEFLATED )

    # copy toolkit folder
    AddDirToZip ( zipfp, os.path.join( source_path, "toolkit" ) )
    # copy vimfiles
    AddDirToZip ( zipfp, os.path.join( source_path, "vimfiles" ) )
    # copy _vimrc and rename to _vimrc_ex 
    zipfp.write ( os.path.join( source_path, "_vimrc" ), "_vimrc_ex" )
    
    # close zip file
    zipfp.close()
    print "full-package created!"

# ------------------------------------------------------------------ 
# Desc: CreateExPluginsPackage 
# ------------------------------------------------------------------ 

def CreateExPluginsPackage ():
    print "" 
    print "#########################" 
    print "ex-plugins-package"
    print "#########################" 
    print ""

    print "Creating ex-plugins-package"

    # create a ex-package zip file
    ex_package_path = dest_version_path + "/" + ex_package_name + "-" + version + ".zip"
    zipfp = zipfile.ZipFile( ex_package_path, "w", zipfile.ZIP_DEFLATED )

    # copy toolkit folder
    AddDirToZip ( zipfp, os.path.join( source_path, "toolkit" ) )

    # copy ex-plugins in vimfiles
    zipfp.write ( os.path.join( source_path, "vimfiles/filetype.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/compiler/exgcc.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/compiler/hlsl.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/compiler/msvc2005.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/syntax/c.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/syntax/cpp.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/syntax/exUtility.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/syntax/hlsl.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/syntax/maxscript.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/syntax/python.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/syntax/syncolor.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/after/syntax/vim.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/autoload/exUtility.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/colors/ex.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/exVim.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exCscope.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exEnvironmentSetting.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exGlobalSearch.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exMacroHighlight.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exMarksBrowser.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exProject.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exQuickFix.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exSearchComplete.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exSymbolTable.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exTagSelect.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/exUtility.vim" ) )

    # copy _vimrc and rename to _vimrc_ex 
    zipfp.write ( os.path.join( source_path, "_vimrc" ), "_vimrc_ex" )
    
    # close zip file
    zipfp.close()
    print "ex-plugin-package created!"

# ------------------------------------------------------------------ 
# Desc: CreatePatchedPluginsPackage 
# ------------------------------------------------------------------ 

def CreatePatchedPluginsPackage ():
    print "" 
    print "#########################" 
    print "patched-plugins-package"
    print "#########################" 
    print ""

    print "Creating patched-plugins-package"

    # create a patched-package zip file
    patched_package_path = dest_root_path + "/" + patched_package_name + ".zip"
    zipfp = zipfile.ZipFile( patched_package_path, "w", zipfile.ZIP_DEFLATED )

    # copy patched-plugins files
    zipfp.write ( os.path.join( source_path, "vimfiles/autoload/lookupfile.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/crefvim.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/echofunc.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/lookupfile.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/minibufexpl.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/showmarks.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/taglist.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/visual_studio.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/visual_studio.py" ) )

    # copy patched-plugins dependence files
    zipfp.write ( os.path.join( source_path, "vimfiles/autoload/genutils.vim" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/plugin/genutils.vim" ) )

    # copy doc
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/crefvim.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/crefvimdoc.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/EnhancedCommentify.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/lookupfile.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/minibufexpl.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/NERD_tree.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/omnicppcomplete.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/showmarks.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/surround.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/taglist.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/vimwiki.txt" ) )
    zipfp.write ( os.path.join( source_path, "vimfiles/doc/visincr.txt" ) )

    # close zip file
    zipfp.close()
    print "patched-pugins-package created!"

# ------------------------------------------------------------------ 
# Desc: CopyDir 
# ------------------------------------------------------------------ 

def CopyDir ( _src, _dest ):
    # walk through the path
    for root, dirs, files in os.walk( _src, topdown=True ):
        # don't visit .svn directories
        if '.svn' in dirs:
            dirs.remove('.svn') 

        # copy files
        for name in files:
            file_full_path = os.path.join( root, name ) 
            # get relative path
            relative_path = "." + file_full_path[len(_src):]
            dest_path = os.path.abspath( os.path.join( _dest, relative_path ) )

            # if relative path not exist, create it
            if os.path.isdir( os.path.dirname(dest_path) ) == False :
                os.makedirs( os.path.dirname(dest_path) )
            # copy file from local project to google project
            print "coping file: %s" % file_full_path
            shutil.copy ( file_full_path, dest_path )

# ------------------------------------------------------------------ 
# Desc: CreateInstaller 
# ------------------------------------------------------------------ 

def CreateInstaller ():
    print "" 
    print "#########################" 
    print "installer"
    print "#########################" 
    print ""

    print "Creating installer"
    installer_path = dest_version_path + "/" + installer_name
    CopyDir ( os.path.join(source_path, "vim72"), os.path.join(installer_path,"exDev/exVim/vim") )
    # TODO: in NSIS copy only vim-plugins, no matter ex-plugins or other-plugins.

    # TODO: confirm this
    os.makedirs( os.path.join(installer_path, "exDev/exVim/data/backup") )
    os.makedirs( os.path.join(installer_path, "exDev/exVim/data/swap") )

    

#/////////////////////////////////////////////////////////////////////////////
# main
#/////////////////////////////////////////////////////////////////////////////

if __name__ == "__main__":
    if PreCheck() == True :
        CreateFullPackage()
        CreateExPluginsPackage()
        CreatePatchedPluginsPackage()
        CreateInstaller()
