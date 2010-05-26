# ======================================================================================
# File         : global.py
# Author       : Wu Jie 
# Last Change  : 05/06/2010 | 17:40:05 PM | Thursday,May
# Description  : 
# ======================================================================================

#/////////////////////////////////////////////////////////////////////////////
# imports
#/////////////////////////////////////////////////////////////////////////////

from os import path
import os
import shutil

# ------------------------------------------------------------------ 
# Desc: 
# ------------------------------------------------------------------ 

def SafeCopyFile ( _src, _dest ):
    dest_dir = path.dirname(_dest) 
    if path.isdir( dest_dir ) == False: 
        os.makedirs( dest_dir )
        print "create path %s" % dest_dir
    shutil.copy ( _src, _dest )
    print "file %s copied" % _src

# ------------------------------------------------------------------ 
# Desc: SafeCopyDirs 
# ------------------------------------------------------------------ 

def SafeCopyDirs ( _src, _dest ):
    # walk through the path
    for root, dirs, files in os.walk( _src, topdown=True ):
        # don't visit .svn directories
        if '.svn' in dirs:
            dirs.remove('.svn') 

        # copy files
        for name in files:
            file_full_path = path.join( root, name ) 
            # get relative path
            relative_path = "." + file_full_path[len(_src):]
            dest_ex_editor_path = path.abspath( path.join( _dest, relative_path ) )

            # if relative path not exist, create it
            if path.isdir( path.dirname(dest_ex_editor_path) ) == False :
                os.makedirs( path.dirname(dest_ex_editor_path) )
            # copy file from exEditor project to google project
            shutil.copy ( file_full_path, dest_ex_editor_path )
            print "file %s copied" % file_full_path
    # DISABLE print "dir %s copied" % _src

# ------------------------------------------------------------------ 
# Desc: 
# ------------------------------------------------------------------ 

def AddDirToZip ( _zipfp, _dir_path, _src_path="" ):
    # walk through the path
    for root, dirs, files in os.walk( _dir_path, topdown=True ):
        # compress files
        for name in dirs:
            dir_full_path = path.join( root, name ) 
            print "adding folder: %s" % dir_full_path 

        # compress files
        for name in files:
            file_full_path = path.join( root, name ) 
            dest_ex_editor_path = file_full_path 
            # if src_path been provided, strip it.
            if _src_path != "":
                dest_ex_editor_path = file_full_path.split(_src_path)[1]
            _zipfp.write ( file_full_path, dest_ex_editor_path )

