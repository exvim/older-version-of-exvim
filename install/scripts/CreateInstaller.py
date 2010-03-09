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
import Settings

#/////////////////////////////////////////////////////////////////////////////
# global variables
#/////////////////////////////////////////////////////////////////////////////

# general
dest_root_path = "e:/Project/Dev/exVim.GoogleCode/installer" 
installer_exe_name = "exVim-installer"

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

    print "version = %s" % Settings.version

    # check source path, if not found, return false
    print "source_path = %s" % os.path.abspath(Settings.source_path)
    if os.path.isdir( os.path.abspath(Settings.source_path) ) == False :
        print "source path not found"
        return False

    # check dest path, if not found, create one
    print "dest_root_path = %s" % dest_root_path
    if os.path.isdir(dest_root_path) == False :
        print "dest path not found, create the path."
        os.makedirs (dest_root_path)
        print "dest path %s created!" % dest_root_path

    # check dest package, if not found, show warnning message
    exvim_path = os.path.join(dest_root_path,"rawdata/exVim")
    if os.path.isdir(exvim_path) == False :
        print "exVim path not found!"
        os.makedirs (exvim_path)
        print "exVim path %s created!" % exvim_path

    # check third part packages path, if not found, show warnning message

    rawvim_path = os.path.join(dest_root_path,"rawdata/exVim/vim")
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
# Desc: CopyDirs 
# ------------------------------------------------------------------ 

def CopyDirs ( _src, _dest ):
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
            # DISABLE: print "coping file: %s" % file_full_path
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
    # KEEPME: no need { 
    # CopyDirs ( os.path.join(source_path, "vim72"), os.path.join(dest_root_path,"rawdata/exVim/vim") )
    # os.makedirs( os.path.join(dest_root_path, "rawdata/exVim/vim/data/backup") )
    # os.makedirs( os.path.join(dest_root_path, "rawdata/exVim/vim/data/swap") )
    # } KEEPME end 

    # update vim-plugins
    print "Update vim-plugins..."

    vimplugins_path = os.path.join(dest_root_path,"rawdata/exVim/vim-plugins")  
    if os.path.isdir(vimplugins_path) == True :
        shutil.rmtree ( vimplugins_path )
    CopyDirs ( os.path.join(Settings.source_path, "toolkit"), os.path.join(vimplugins_path,"toolkit") )
    CopyDirs ( os.path.join(Settings.source_path, "vimfiles"), os.path.join(vimplugins_path,"vimfiles") )

    # update .vimrc
    print "Update .vimrc..."
    rawvim_path = os.path.join(dest_root_path,"rawdata/exVim/vim")
    if os.path.isdir(rawvim_path) == False :
        print "%s not found! can't copy .vimrc to it." % rawvim_path
    else :
        shutil.copy ( os.path.join(Settings.source_path, ".vimrc"), rawvim_path )

    # update gvim.exe, ctags.exe 
    shutil.copy ( os.path.join(Settings.source_path, "vim72/gvim.exe"), os.path.join(rawvim_path,"vim72/gvim.exe") )
    shutil.copy ( os.path.join(Settings.source_path, "vim72/ctags.exe"), os.path.join(rawvim_path,"vim72/ctags.exe") )

    # update exVim.nsi
    print "Update exVim.nsi..."
    shutil.copy ( os.path.join(Settings.source_path, "install/scripts/exVim.nsi"), dest_root_path )

# ------------------------------------------------------------------ 
# Desc: CompileInstaller 
# ------------------------------------------------------------------ 

def CompileInstaller ():
    # 
    installer_exe_path = os.path.join(dest_root_path, installer_exe_name + ".exe")
    installer_exe_ver_path = os.path.join(dest_root_path, installer_exe_name + "-" + Settings.version + ".exe")

    # compile installer by exVim.nsi
    if os.path.isfile (installer_exe_ver_path) == True:
        print "%s already exists, if you want to re-generate one, remove it manually." % (installer_exe_name + "-" + Settings.version)
        return

    cwd = os.getcwd()
    os.chdir( dest_root_path )
    os.system( 'makensis exVim.nsi')
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
