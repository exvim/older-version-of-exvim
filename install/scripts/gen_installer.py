# ======================================================================================
# File         : CreateInstaller.py
# Author       : Wu Jie 
# Last Change  : 05/18/2009 | 21:01:02 PM | Monday,May
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
installer_exe_name = "exvim-installer"

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
    print "dest_root_path = %s" % dest_root_path
    if os.path.isdir(dest_root_path) == False :
        print "dest path not found, create the path."
        os.makedirs (dest_root_path)
        print "dest path %s created!" % dest_root_path

    # check dest package, if not found, show warnning message
    exvim_path = os.path.join(dest_root_path,"rawdata/exvim")
    if os.path.isdir(exvim_path) == False :
        print "exvim path not found!"
        os.makedirs (exvim_path)
        print "exvim path %s created!" % exvim_path

    # check third part packages path, if not found, show warnning message

    rawvim_path = os.path.join(dest_root_path,"rawdata/exvim/vim")
    if os.path.isdir(rawvim_path) == False :
        print "Warnning: raw-vim not found! (%s)" % rawvim_path
    else :
        print "raw-vim OK!"

    diffutils_path = os.path.join(dest_root_path,"rawdata/GnuWin32/diffutils")
    if os.path.isdir(diffutils_path) == False :
        print "Warnning: diffutils not found! (%s)" % diffutils_path
    else :
        print "diffutils OK!"

    gawk_path = os.path.join(dest_root_path,"rawdata/GnuWin32/gawk")
    if os.path.isdir(gawk_path) == False :
        print "Warnning: gawk not found! (%s)" % gawk_path
    else :
        print "gawk OK!"

    idutils_path = os.path.join(dest_root_path,"rawdata/GnuWin32/id-utils")
    if os.path.isdir(idutils_path) == False :
        print "Warnning: id-utils not found! (%s)" % idutils_path
    else :
        print "id-utils OK!"

    libiconv_path = os.path.join(dest_root_path,"rawdata/GnuWin32/libiconv")
    if os.path.isdir(libiconv_path) == False :
        print "Warnning: libiconv not found! (%s)" % libiconv_path
    else :
        print "libiconv OK!"

    libintl_path = os.path.join(dest_root_path,"rawdata/GnuWin32/libintl")
    if os.path.isdir(libintl_path) == False :
        print "Warnning: libintl not found! (%s)" % libintl_path
    else :
        print "libintl OK!"

    sed_path = os.path.join(dest_root_path,"rawdata/GnuWin32/sed")
    if os.path.isdir(sed_path) == False :
        print "Warnning: sed not found! (%s)" % sed_path
    else :
        print "sed OK!"

    regex_path = os.path.join(dest_root_path,"rawdata/GnuWin32/regex")
    if os.path.isdir(regex_path) == False :
        print "Warnning: regex not found! (%s)" % regex_path
    else :
        print "regex OK!"

    srchighlite_path = os.path.join(dest_root_path,"rawdata/GnuWin32/src-highlite")
    if os.path.isdir(srchighlite_path) == False :
        print "Warnning: src-highlite not found! (%s)" % srchighlite_path
    else :
        print "src-highlite OK!"

    graphviz_path = os.path.join(dest_root_path,"rawdata/Graphviz")
    if os.path.isdir(graphviz_path) == False :
        print "Warnning: Graphviz not found! (%s)" % graphviz_path
    else :
        print "Graphviz OK!"

    # finish pre-check
    print "Pre-Check done!"
    return True

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
    # KEEPME: no need { 
    # SafeCopyDirs ( os.path.join(exVim_path, "vim72"), os.path.join(dest_root_path,"rawdata/exvim/vim") )
    # os.makedirs( os.path.join(dest_root_path, "rawdata/exvim/vim/data/backup") )
    # os.makedirs( os.path.join(dest_root_path, "rawdata/exvim/vim/data/swap") )
    # } KEEPME end 

    # update vim-plugins
    print "Update vim-plugins..."

    vimplugins_path = os.path.join(dest_root_path,"rawdata/exvim/vim-plugins")  
    if os.path.isdir(vimplugins_path) == True :
        shutil.rmtree ( vimplugins_path )
    misc.SafeCopyDirs ( os.path.join(settings.exVim_path, "toolkit"), os.path.join(vimplugins_path,"toolkit") )
    misc.SafeCopyDirs ( os.path.join(settings.exVim_path, "vimfiles"), os.path.join(vimplugins_path,"vimfiles") )

    # update .vimrc
    print "Update .vimrc..."
    rawvim_path = os.path.join(dest_root_path,"rawdata/exvim/vim")
    if os.path.isdir(rawvim_path) == False :
        print "%s not found! can't copy .vimrc to it." % rawvim_path
    else :
        shutil.copy ( os.path.join(settings.exVim_path, ".vimrc"), rawvim_path )

    # update gvim.exe, ctags.exe 
    shutil.copy ( os.path.join(settings.exVim_path, "vim72/gvim_nopython.exe"), os.path.join(rawvim_path,"vim72/gvim.exe") )
    shutil.copy ( os.path.join(settings.exVim_path, "vim72/ctags.exe"), os.path.join(rawvim_path,"vim72/ctags.exe") )

    # update EnvVarUpdate.nsh
    print "Update EnvVarUpdate.nsh..."
    shutil.copy ( os.path.join(settings.exVim_path, "install/scripts/EnvVarUpdate.nsh"), dest_root_path )

    # update exvim.nsi
    print "Update exvim.nsi..."
    shutil.copy ( os.path.join(settings.exVim_path, "install/scripts/exvim.nsi"), dest_root_path )

# ------------------------------------------------------------------ 
# Desc: CompileInstaller 
# ------------------------------------------------------------------ 

def CompileInstaller ():
    # 
    installer_exe_path = os.path.join(dest_root_path, installer_exe_name + ".exe")
    installer_exe_ver_path = os.path.join(dest_version_path, installer_exe_name + "-" + settings.version + ".exe")

    # compile installer by exvim.nsi
    if os.path.isfile (installer_exe_ver_path) == True:
        print "%s already exists, if you want to re-generate one, remove it manually." % (installer_exe_name + "-" + settings.version)
        return

    cwd = os.getcwd()
    os.chdir( dest_root_path )
    os.system( 'makensis exvim.nsi')
    os.chdir( cwd )
    if os.path.isfile(installer_exe_path) == True :
        os.rename( installer_exe_path, installer_exe_ver_path) 
        print "Success: %s created!" % installer_exe_ver_path
    else :
        print "Failed: %s not found!" % installer_exe_name


#/////////////////////////////////////////////////////////////////////////////
# main
#/////////////////////////////////////////////////////////////////////////////

if __name__ == "__main__":
    if PreCheck() == True :
        CreateInstaller()
        CompileInstaller()
