# ======================================================================================
# File         : gen_package.py
# Author       : Wu Jie 
# Last Change  : 05/26/2010 | 14:55:47 PM | Wednesday,May
# Description  : 
# ======================================================================================

#/////////////////////////////////////////////////////////////////////////////
# imports
#/////////////////////////////////////////////////////////////////////////////

import os.path
import shutil
import zipfile
import settings
import misc

#/////////////////////////////////////////////////////////////////////////////
# global variables
#/////////////////////////////////////////////////////////////////////////////

# general
dest_root_path = settings.release_path
dest_version_path = os.path.join ( settings.release_path, settings.version )

#
full_package_name = "full-package"
ex_package_name = "ex-plugins-package"
patched_package_name = "patched-plugins-package" + "-" + settings.patched_plugins_version

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

    print "version = %s" % settings.version

    # check source path, if not found, return false
    print "exVim_path = %s" % os.path.abspath(settings.exVim_path)
    if os.path.isdir( os.path.abspath(settings.exVim_path) ) == False :
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
    full_package_path = dest_version_path + "/" + full_package_name + "-" + settings.version + ".zip"
    zipfp = zipfile.ZipFile( full_package_path, "w", zipfile.ZIP_DEFLATED )

    # copy toolkit folder
    misc.AddDirToZip ( zipfp, os.path.join( settings.exVim_path, "toolkit" ), settings.exVim_path )
    # copy vimfiles
    misc.AddDirToZip ( zipfp, os.path.join( settings.exVim_path, "vimfiles" ), settings.exVim_path )
    # copy .vimrc and rename to .vimrc_ex 
    zipfp.write ( os.path.join( settings.exVim_path, ".vimrc" ), ".vimrc_ex" )
    
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
    ex_package_path = dest_version_path + "/" + ex_package_name + "-" + settings.version + ".zip"
    zipfp = zipfile.ZipFile( ex_package_path, "w", zipfile.ZIP_DEFLATED )

    # copy toolkit folder
    misc.AddDirToZip ( zipfp, os.path.join( settings.exVim_path, "toolkit" ), settings.exVim_path )

    # copy ex-plugins in vimfiles { 

    # filetype
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/filetype.vim" ), "vimfiles/filetype.vim" )

    # after-compiler
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/compiler/exgcc.vim" ), "vimfiles/after/compiler/exgcc.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/compiler/hlsl.vim" ), "vimfiles/after/compiler/hlsl.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/compiler/exmsvc.vim" ), "vimfiles/after/compiler/exmsvc.vim" )

    # after-syntax
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/syntax/c.vim" ), "vimfiles/after/syntax/c.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/syntax/cpp.vim" ), "vimfiles/after/syntax/cpp.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/syntax/exUtility.vim" ), "vimfiles/after/syntax/exUtility.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/syntax/hlsl.vim" ), "vimfiles/after/syntax/hlsl.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/syntax/make.vim" ), "vimfiles/after/syntax/make.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/syntax/maxscript.vim" ), "vimfiles/after/syntax/maxscript.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/syntax/python.vim" ), "vimfiles/after/syntax/python.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/syntax/syncolor.vim" ), "vimfiles/after/syntax/syncolor.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/after/syntax/vim.vim" ), "vimfiles/after/syntax/vim.vim"  )

    # autoload
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/autoload/exUtility.vim" ), "vimfiles/autoload/exUtility.vim"  )

    # colors
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/colors/ex.vim" ), "vimfiles/colors/ex.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/colors/ex_lightgray.vim" ), "vimfiles/colors/ex_lightgray.vim"  )

    # doc
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/exVim.txt" ), "vimfiles/doc/exVim.txt"  )

    # plugin
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exBufExplorer.vim" ), "vimfiles/plugin/exBufExplorer.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exCscope.vim" ), "vimfiles/plugin/exCscope.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exEnvironmentSetting.vim" ), "vimfiles/plugin/exEnvironmentSetting.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exGlobalSearch.vim" ), "vimfiles/plugin/exGlobalSearch.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exJumpStack.vim" ), "vimfiles/plugin/exJumpStack.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exMacroHighlight.vim" ), "vimfiles/plugin/exMacroHighlight.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exMarksBrowser.vim" ), "vimfiles/plugin/exMarksBrowser.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exProject.vim" ), "vimfiles/plugin/exProject.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exQuickFix.vim" ), "vimfiles/plugin/exQuickFix.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exSearchComplete.vim" ), "vimfiles/plugin/exSearchComplete.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exSymbolTable.vim" ), "vimfiles/plugin/exSymbolTable.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exTagSelect.vim" ), "vimfiles/plugin/exTagSelect.vim"  )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/exUtility.vim" ), "vimfiles/plugin/exUtility.vim"  )

    # } end 

    # copy .vimrc and rename to .vimrc_ex 
    zipfp.write ( os.path.join( settings.exVim_path, ".vimrc" ), ".vimrc_ex" )
    
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
    patched_package_path = os.path.join ( dest_version_path,  patched_package_name + ".zip" )
    zipfp = zipfile.ZipFile( patched_package_path, "w", zipfile.ZIP_DEFLATED )

    # copy patched-plugins files
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/autoload/lookupfile.vim" ), "vimfiles/autoload/lookupfile.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/crefvim.vim" ), "vimfiles/plugin/crefvim.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/echofunc.vim" ), "vimfiles/plugin/echofunc.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/lookupfile.vim" ), "vimfiles/plugin/lookupfile.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/minibufexpl.vim" ), "vimfiles/plugin/minibufexpl.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/showmarks.vim" ), "vimfiles/plugin/showmarks.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/taglist.vim" ), "vimfiles/plugin/taglist.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/visual_studio.vim" ), "vimfiles/plugin/visual_studio.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/visual_studio.py" ), "vimfiles/plugin/visual_studio.py" )

    # copy patched-plugins dependence files
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/autoload/genutils.vim" ), "vimfiles/autoload/genutils.vim" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/plugin/genutils.vim" ), "vimfiles/plugin/genutils.vim" )

    # copy doc
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/crefvim.txt" ), "vimfiles/doc/crefvim.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/crefvimdoc.txt" ), "vimfiles/doc/crefvimdoc.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/EnhancedCommentify.txt" ), "vimfiles/doc/EnhancedCommentify.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/lookupfile.txt" ), "vimfiles/doc/lookupfile.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/minibufexpl.txt" ), "vimfiles/doc/minibufexpl.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/NERD_tree.txt" ), "vimfiles/doc/NERD_tree.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/omnicppcomplete.txt" ), "vimfiles/doc/omnicppcomplete.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/showmarks.txt" ), "vimfiles/doc/showmarks.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/surround.txt" ), "vimfiles/doc/surround.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/taglist.txt" ), "vimfiles/doc/taglist.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/vimwiki.txt" ), "vimfiles/doc/vimwiki.txt" )
    zipfp.write ( os.path.join( settings.exVim_path, "vimfiles/doc/visincr.txt" ), "vimfiles/doc/visincr.txt" )

    # close zip file
    zipfp.close()
    print "patched-pugins-package created!"

#/////////////////////////////////////////////////////////////////////////////
# main
#/////////////////////////////////////////////////////////////////////////////

if __name__ == "__main__":
    if PreCheck() == True :
        CreateFullPackage()
        CreateExPluginsPackage()
        CreatePatchedPluginsPackage()

