# ======================================================================================
# File         : SyncToLocalVersion.py
# Author       : Wu Jie 
# Last Change  : 05/10/2009 | 20:56:56 PM | Sunday,May
# Description  : 
# ======================================================================================

#/////////////////////////////////////////////////////////////////////////////
# imports
#/////////////////////////////////////////////////////////////////////////////

import os.path
import shutil
import string

#/////////////////////////////////////////////////////////////////////////////
# global variables
#/////////////////////////////////////////////////////////////////////////////

# general
local_version_path = "d:/exDev/exVim"
google_version_path = "."

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

    # check source path, if not found, return false
    print "local_version_path = %s" % local_version_path
    if os.path.isdir( local_version_path ) == False :
        print "local version path not found"
        return False

    # check dest path, if not found, create one
    print "google_version_path = %s" % google_version_path
    if os.path.isdir(google_version_path) == False :
        print "google version path not found"
        return False

    print "Pre-Check done!"
    return True

# ------------------------------------------------------------------ 
# Desc: 
# ------------------------------------------------------------------ 

def SyncDir ( _path ):
    # walk through the path
    for root, dirs, files in os.walk( _path, topdown=True ):
        # don't visit .svn directories
        if '.svn' in dirs:
            dirs.remove('.svn') 

        # copy files
        for name in files:
            file_full_path = os.path.join( root, name ) 
            # get relative path
            relative_path = "." + file_full_path[len(local_version_path):]
            # if relative path not exist, create it
            if os.path.isdir( os.path.dirname(relative_path) ) == False :
                print "create directory: %s" % os.path.dirname(relative_path) 
                os.makedirs( os.path.dirname(relative_path) )
            # copy file from local project to google project
            print "coping file: %s" % file_full_path 
            shutil.copy ( file_full_path, relative_path )

# ------------------------------------------------------------------ 
# Desc: 
# ------------------------------------------------------------------ 

def SyncFiles ():
    print "" 
    print "#########################" 
    print "sync files"
    print "#########################" 
    print ""

    # sync dirs
    SyncDir ( os.path.join(local_version_path, "install") )
    SyncDir ( os.path.join(local_version_path, "toolkit") )
    SyncDir ( os.path.join(local_version_path, "vimfiles") )
    shutil.copy ( os.path.join(local_version_path, ".vimrc"), "./" )

    #
    print "file sync done!"

#/////////////////////////////////////////////////////////////////////////////
# main
#/////////////////////////////////////////////////////////////////////////////

if __name__ == "__main__":
    if PreCheck() == True :
        SyncFiles()

