'''
Companion file to visual_studio.vim
Version 1.2

Copyright (c) 2003-2007 Michael Graz
mgraz.vim@plan10.com
'''

import os, re, sys, time, pywintypes, win32com.client

# jwu ADD: fix UnicodeEncodingError problem { 
reload(sys)
sys.setdefaultencoding('utf-8')
# } jwu ADD end 

import logging
_logging_enabled = False
if _logging_enabled:
    import tempfile
    _filename_log = os.path.join (tempfile.gettempdir(), 'visual_studio.log')
    logging.basicConfig (filename=_filename_log, filemode='w', level=logging.DEBUG,
        format='%(asctime)s %(levelname)-8s %(pathname)s(%(lineno)d)\n%(message)s\n')
else:
    logging.basicConfig (level=sys.maxint)  # disables logging
logging.info ('starting')

vsBuildStateNotStarted = 1   # Build has not yet been started.
vsBuildStateInProgress = 2   # Build is currently in progress.
vsBuildStateDone = 3         # Build has been completed

# Unfortunate side-effect - have to disable vim exit processing
# otherwise there is an exception at exit
sys.exitfunc = lambda: None

#----------------------------------------------------------------------
def dte_break_in_file (vs_pid, filename, modified, line_num, col_num):
    logging.info ('== dte_break_in_file %s' % vars())
    dte = _get_dte(vs_pid)
    if not dte: return
    try:
        # dte.ExecuteCommand ('Debug.BreakInFile')
        # print dte.Debugger.Breakpoints.Item(1).ConditionType
        # print dte.Debugger.Breakpoints.Item(1).HitCountType
        # print dte.Debugger.Breakpoints.Item(1).Language 
        dte.Debugger.Breakpoints.Add( '', filename, line_num, col_num, '', 1, 'C++', '', 0, '', 0, 1 )
    except Exception, e:
        logging.exception (e)
        _dte_exception (e)
        _vim_activate ()
        return
    # ExecuteCommand is not synchronous so we have to wait
    _vim_status ('Break in file complete')
    _vim_activate ()

#----------------------------------------------------------------------
def dte_add_watch (vs_pid, watch_var):
    logging.info ('== dte_add_watch %s' % vars())
    dte = _get_dte(vs_pid)
    if not dte: return
    try:
        dte.ExecuteCommand ('Debug.AddWatch', watch_var)
        # TODO:
        # for window in dte.Windows:
        #     if str(window.Caption).startswith('Watch 1'):
        #         watch_window = window
        # if not watch_window:
        #     _vim_msg ('Error: Watch 1 window not active')
        #     return
        # watch_window.Activate()
        # uih = watch_window.Object
        # print uih.UIHierarchyItems.Count
    except Exception, e:
        logging.exception (e)
        _dte_exception (e)
        _vim_activate ()
        return
    # ExecuteCommand is not synchronous so we have to wait
    _vim_status ('Add watch %s complete' % watch_var)
    _vim_activate ()

#----------------------------------------------------------------------

def dte_compile_file (vs_pid, fn_quickfix):
    logging.info ('== dte_compile_file %s' % vars())
    dte = _get_dte(vs_pid)
    if not dte: return
    _dte_set_autoload (vs_pid)
    try:
        dte.ExecuteCommand ('Build.Compile')
    except Exception, e:
        logging.exception (e)
        _dte_exception (e)
        _vim_activate ()
        return
    # ExecuteCommand is not synchronous so we have to wait
    _dte_wait_for_build (dte)
    dte_output (vs_pid, fn_quickfix, 'Output', 'Build')
    _vim_status ('Compile file complete')
    _vim_activate ()

def _dte_wait_for_build (dte):
    try:
        while dte.Solution.SolutionBuild.BuildState == vsBuildStateInProgress:
            time.sleep (0.1)
    except:
        pass

#----------------------------------------------------------------------

def dte_build_solution(vs_pid, fn_quickfix, write_first):
    logging.info ('== dte_build_solution %s' % vars())
    dte = _get_dte(vs_pid)
    if not dte: return
    if _dte_has_csharp_projects(dte):
        dte.Documents.CloseAll()
    elif write_first != '0':
        _dte_set_autoload (vs_pid)
    # write_first is passed in as a string
    if write_first != '0':
        _vim_command ('wall')
    _dte_activate (vs_pid)
    _dte_output_activate (vs_pid)
    try:
        dte.Solution.SolutionBuild.Build (1)
        # Build is not synchronous so we have to wait
        _dte_wait_for_build (dte)
    except Exception, e:
        logging.exception (e)
        _dte_exception (e)
        _vim_activate ()
        return
    dte_output (vs_pid, fn_quickfix, 'Output', 'Build')
    _vim_status ('Build solution complete')
    _vim_activate ()

#----------------------------------------------------------------------

# NOTE: new function; build the 'Startup project'
# Renamed from dte_build_startup_project to dte_build_project
def dte_build_project(vs_pid, fn_quickfix, write_first, project_name=None):
    logging.info ('== dte_build_project %s' % vars())
    dte = _get_dte(vs_pid)
    if not dte: return
    if _dte_has_csharp_projects(dte):
        dte.Documents.CloseAll()
    elif write_first != '0':
        _dte_set_autoload (vs_pid)
    # write_first is passed in as a string
    if write_first != '0':
        _vim_command ('wall')
    _dte_activate (vs_pid)
    _dte_output_activate (vs_pid)
    try:
        configuration_name = dte.Solution.SolutionBuild.ActiveConfiguration.Name
        def get_project_unique_name(name):
            for p in dte.Solution.Projects:
                if p.Name == name:
                    return p.UniqueName
        project_unique_name = get_project_unique_name (project_name or
                dte.Solution.Properties("StartupProject").Value)
        logging.info ('SolutionBuild.BuildProject configuration_name: %s, project_unique_name: %s' %
                (configuration_name, project_unique_name, ))
        dte.Solution.SolutionBuild.BuildProject(configuration_name, project_unique_name, 1)
        # Build is not synchronous so we have to wait
        _dte_wait_for_build (dte)
    except Exception, e:
        logging.exception (e)
        _dte_exception (e)
        _vim_activate ()
        return
    dte_output (vs_pid, fn_quickfix, 'Output', 'Build')
    _vim_status ('Build project complete')
    _vim_activate ()

#----------------------------------------------------------------------

# NOTE: new function; set a project as the 'Startup project'
def dte_set_startup_project(vs_pid, project_name, project_index):
    logging.info ('== dte_set_startup_project %s' % vars())
    dte = _get_dte(vs_pid)
    if not dte: return
    try:
        dte.Solution.Properties('StartupProject').Value = project_name
    except Exception, e:
        logging.exception (e)
        _dte_exception(e)
        return
    # Only change the index if the name was successfully changed
    _vim_command ('let s:visual_studio_startup_project_index = %s' % project_index)
    _vim_command ("echo 'Startup project set to: %s'" % project_name)

#----------------------------------------------------------------------

def dte_task_list (vs_pid, fn_quickfix):
    logging.info ('== dte_task_list %s' % vars())
    fp_task_list = file (fn_quickfix, 'w')
    dte = _get_dte(vs_pid)
    dte.ExecuteCommand ('View.TaskList')
    if not dte: return
    task_list = None
    for window in dte.Windows:
        if str(window.Caption).startswith('Task List'):
            task_list = window
    if not task_list:
        _vim_msg ('Error: Task List window not active')
        return
    TL = task_list.Object
    for i in range (1, TL.TaskItems.Count+1):
        TLItem = TL.TaskItems.Item(i)
        try: filename = TLItem.FileName
        except: filename = '<no-filename>'
        try: line = TLItem.Line
        except: line = '<no-line>'
        try: description = TLItem.Description
        except: description = '<no-description>'
        print >>fp_task_list, '%s(%s) : %s' % (filename, line, description)
    fp_task_list.close ()
    _vim_command ('call <Sid>DTEQuickfixOpen ("Task List")')
    _vim_status ('VS Task list')

#----------------------------------------------------------------------

def dte_output (vs_pid, fn_output, window_caption, item=None, notify=None):
    logging.info ('== dte_output %s' % vars())
    if window_caption not in ['Find Results 1', 'Find Results 2', 'Output']:
        _vim_msg ('Error: unrecognized window (%s)' % window_caption)
        return
    dte = _get_dte(vs_pid)
    if not dte: return
    window = _dte_get_window(dte, window_caption)
    if not window:
        _vim_msg ('Error: window not active (%s)' % window_caption)
        return
    if window_caption == 'Output':
        owp = window.Object.OutputWindowPanes.Item (item)
        sel = owp.TextDocument.Selection
    else:
        sel = window.Selection
    sel.SelectAll()
    lst_text = str(sel.Text).splitlines()
    lst_text = _fix_filenames (os.path.dirname(dte.Solution.FullName), lst_text)
    sel.Collapse()
    fp_output = file (fn_output, 'w')
    fp_output.write ('\n'.join(lst_text))
    fp_output.close()
    _vim_command ('call <Sid>DTEQuickfixOpen ("%s")' % window_caption)
    # notify is passed in as a string
    if notify and notify != '0':
        _vim_status ('VS %s' % window_caption)

#----------------------------------------------------------------------

_fix_filenames_pattern = re.compile ('(.*)\(\d+\) :')

def _fix_filenames (dirname, lst_text):
    '''Fixup the filenames if they are just relative to the solution'''
    lst_result = []
    for text in lst_text:
        m = _fix_filenames_pattern.match (text)
        if m:
            filename = m.group(1)
            if not os.path.isfile(filename):
                pathname = os.path.join (dirname, filename)
                if os.path.isfile(pathname):
                    text = pathname + text[m.end(1):]
        lst_result.append (text)
    return lst_result

#----------------------------------------------------------------------

def dte_get_file (vs_pid, modified=None):
    logging.info ('== dte_get_file %s' % vars())
    dte = _get_dte(vs_pid)
    if not dte: return
    doc = dte.ActiveDocument
    if not doc:
        _vim_status ('No VS file!')
        return
    pt = doc.Selection.ActivePoint
    file = os.path.join (doc.Path, doc.Name)
    # modified may be passed in as a string
    if modified != '0':
        action = 'split'
    else:
        action = 'edit'
    lst_cmd = [
        '%s +%d %s' % (action, pt.Line, file),
        'normal %d|' % pt.DisplayColumn,
    ]
    _vim_command (lst_cmd)

#----------------------------------------------------------------------

def dte_put_file (vs_pid, filename, modified, line_num, col_num):
    logging.info ('== dte_put_file %s' % vars())
    if not filename:
        return
    dte = _get_dte(vs_pid)
    if not dte: return
    # modified is passed in as a string
    if modified != '0':
        _dte_set_autoload (vs_pid)
        _vim_command ('write')
    io = dte.ItemOperations
    logging.info ('dte_put_file abspath: >%s<' % (os.path.abspath(filename), ))
    rc = io.OpenFile (os.path.abspath (filename))
    doc = dte.ActiveDocument
    if not doc:
        _vim_status ('No VS file!')
        return
    sel = doc.Selection
    try: sel.MoveToLineAndOffset (line_num, col_num)
    except:
        pass
    _dte_activate (vs_pid)

#----------------------------------------------------------------------

def dte_list_instances (vs_pid):
    logging.info ('== dte_list_instances %s' % vars())
    lst_result = [[x[1], x[2]] for x in _get_dte_from_rot()]
    _vim_command ('let s:visual_studio_lst_dte = %s' % lst_result)

#----------------------------------------------------------------------

def dte_list_projects (vs_pid):
    logging.info ('== dte_list_projects %s' % vars())
    dte = _get_dte(vs_pid)
    if not dte: return
    startup_project_name = str(dte.Solution.Properties("StartupProject").Value)
    # collect all the names in a list so they can be processed in sorted order
    startup_project_index = -1
    index = 0
    lst_result = []
    # JWU MODIFY { 
    # lst_project = [project for project in dte.Solution.Projects]
    # for project in sorted(dte.Solution.Projects, cmp=lambda x,y: cmp(x.Name, y.Name)):
    # } JWU MODIFY end 
    for project in dte.Solution.Projects:
        if project.Name == startup_project_name:
            startup_project_index = index
        # jwu ADD: to judge is this a project or a folder (if folder it will not have FullName)
        if len(project.FullName) != 0:
            lst_result.append (_dte_project_tree(project))
            print 'add project: %s' %project.Name
        else:
            print 'skip project: %s' %project.Name
        index += 1
    _vim_command ('let s:visual_studio_lst_project = %s' % lst_result)
    _vim_command ('let s:visual_studio_startup_project_index = %s' % startup_project_index)

def _dte_project_tree (project):
    '''Will return tree of projects.  Each node in tree has list with:
    offset 0: project or project_item name
    offset 1: child items list or filename of project item'''
    name = _com_property (project, 'Name')
    if not name:
        return []
    name = str(name)
    properties = _com_property(project, 'Properties')
    if properties: 
        try: full_path = str(properties['FullPath'])
        except: full_path = None
        if full_path and os.path.isfile(full_path):
            return [name, full_path]
    sub_project = _com_property (project, 'SubProject')
    if sub_project:
        return [name, _dte_project_tree(sub_project)]
    project_items = _com_property (project, 'ProjectItems')
    if project_items:
        lst_children = [_dte_project_tree(project_item) for project_item in project_items]
        return [name, lst_children]
    return [name, []]

def _com_property (object, attr, default=None):
    try:
        return getattr (object, attr, default)
    except:
        return default

#----------------------------------------------------------------------

_dte = None
_vs_pid = 0
def _get_dte (vs_pid):
    logging.info ('_get_dte vs_pid: %s' % (vs_pid, ))
    global _dte
    global _vs_pid
    try: vs_pid = int(vs_pid)
    except: vs_pid = 0
    if _dte is not None:
        # make sure there is still a valid dte
        try: _dte.Solution
        except: _dte = None
    if _dte is not None:
        if vs_pid == 0 or vs_pid == _vs_pid:
            return _dte
    try:
        dte = _get_dte_from_rot (vs_pid)
        if dte:
            if type(dte) is type([]):
                dte = dte[0][0]
            _dte = dte
            _vs_pid = vs_pid
            return dte
        # GetActiveObject is less useful since if a different version is running
        # than the default registered the it will not be found
        dte = win32com.client.GetActiveObject ('VisualStudio.DTE')
        if dte:
            _dte = dte
            return dte
    except pywintypes.com_error:
        pass
    _vim_msg ('Cannot access VisualStudio. Not running?')
    return None

#----------------------------------------------------------------------

def _get_dte_from_rot (pid=None, sln=None):
    '''Returns single dte if pid or sln is passed.
    Otherwise returns a list of (dte, pid, sln) tuples.'''
    import pythoncom
    try:
        lst_dte = []
        rot = pythoncom.GetRunningObjectTable ()
        rot_enum = rot.EnumRunning()
        while 1:
            monikers = rot_enum.Next()
            if not monikers:
                break
            ctx = pythoncom.CreateBindCtx (0)
            display_name = monikers[0].GetDisplayName (ctx, None)
            if display_name.startswith ('!VisualStudio.DTE'):
                logging.info ('_get_dte_from_rot display_name: >%s<' % display_name)
                dte_pid = 0
                pos = display_name.rfind(':')
                if pos >= 0:
                    try: dte_pid = int(display_name[pos+1:])
                    except ValueError: dte_pid = 0
                if pid and pid != dte_pid:
                    continue
                obj = rot.GetObject (monikers[0])
                interface = obj.QueryInterface (pythoncom.IID_IDispatch)
                import win32com.client
                dte = win32com.client.Dispatch (interface)
                if pid:
                    logging.info ('_get_dte_from_rot returning dte for pid: %s' % (pid, ))
                    return dte
                # MODIFY: jwu, support unicode encoding project { 
                # dte_sln = str(dte.Solution.FullName)
                dte_sln = str(dte.Solution.FullName.encode('utf8'))
                # } MODIFY end 
                if sln and dte_sln.endswith (sln):
                    return dte
                if not dte_sln:
                    dte_sln = '(pid: %s - no open solution)' % (dte_pid, )
                lst_dte.append ((dte, dte_pid, dte_sln, ))
        return lst_dte
    finally:
        rot = None

#----------------------------------------------------------------------

def _dte_has_csharp_projects (dte):
    try:
        if dte.CSharpProjects.Count:
            return 1
    except pywintypes.com_error:
        pass
    return 0

#----------------------------------------------------------------------

_wsh = None
def _get_wsh ():
    global _wsh
    if not _wsh:
        try:
            _wsh = win32com.client.Dispatch ('WScript.Shell')
        except pywintypes.com_error:
            _vim_msg ('Cannot access WScript.Shell')
    return _wsh

#----------------------------------------------------------------------

_vim_pid = None
def _vim_activate ():
    if _vim_pid:
        vim_pid = _vim_pid
    else:
        vim_pid = os.getpid ()
    try:
        _get_wsh().AppActivate (vim_pid)
    except:
        pass

#----------------------------------------------------------------------

def _dte_activate (vs_pid):
    dte = _get_dte(vs_pid)
    if not dte: return
    try:
        dte.MainWindow.Activate ()
        _get_wsh().AppActivate (dte.MainWindow.Caption)
    except:
        pass

#----------------------------------------------------------------------

def _dte_output_activate (vs_pid):
    dte = _get_dte(vs_pid)
    if not dte: return
    window = _dte_get_window(dte, 'Output')
    if not window: return
    window.Activate()

#----------------------------------------------------------------------

def _dte_get_window(dte, caption):
    try: return dte.Windows[caption]
    except pywintypes.com_error: return None

#----------------------------------------------------------------------

def _dte_set_autoload (vs_pid):
    dte = _get_dte(vs_pid)
    if not dte: return
    p = dte.Properties ('Environment', 'Documents')
    lst_msg = []
    for item in ['DetectFileChangesOutsideIDE', 'AutoloadExternalChanges']:
        if not p.Item(item).Value:
            p.Item(item).Value = 1
            lst_msg.append (item)
    if lst_msg:
        msg = 'echo "Enabled %s in VisualStudio"' % ' and '.join(lst_msg)
        _vim_command (msg)

#----------------------------------------------------------------------

def _vim_command (lst_cmd):
    logging.info ('_vim_command lst_cmd: %s' % (lst_cmd, ))
    if type(lst_cmd) is not type([]):
        lst_cmd = [lst_cmd]
    has_vim = _vim_has_python()
    for cmd in lst_cmd:
        cmd = cmd.replace ('\\\\', '\\')
        if has_vim:
            import vim
            vim.command (cmd)
        else:
            if cmd.startswith ('normal'):
                print 'exe "%s"' % cmd
            else:
                print cmd

#----------------------------------------------------------------------

def _vim_has_python ():
    try: import vim
    except ImportError: return 0
    visual_studio_has_python = vim.eval ('g:visual_studio_has_python')
    # eval of g:visual_studio_has_python returns string '0' or '1'
    return int(vim.eval ('g:visual_studio_has_python'))

#----------------------------------------------------------------------

def _dte_exception (e):
    if isinstance (e, pywintypes.com_error):
        try:
            msg = e[2][2]
        except:
            msg = None
    else:
        msg = e
    if not msg:
        msg = 'Encountered unknown exception'
    _vim_status ('ERROR %s' % msg)

#----------------------------------------------------------------------

def _vim_status (msg):
    logging.info ('vim_status msg: %s' % (msg, ))
    try:
        caption = _get_dte().MainWindow.Caption.split()[0]
    except:
        caption = None
    if caption:
        msg = msg + ' (' + caption + ')'
    _vim_msg (msg)

#----------------------------------------------------------------------

def _vim_msg (msg):
    _vim_command ('echo "%s"' % str(msg).replace('"', '\\"'))

#----------------------------------------------------------------------

def main ():
    prog = os.path.basename(sys.argv[0])
    logging.info ('main sys.argv: %s' % sys.argv)
    if len(sys.argv) == 1:
        print 'echo "ERROR: not enough args to %s"' % prog
        return

    fcn_name = sys.argv[1]
    if not globals().has_key(fcn_name):
        print 'echo "ERROR: no such function %s in %s"' % (fcn_name, prog)
        return

    if sys.argv[-1].startswith ('vim_pid='):
        global _vim_pid
        _vim_pid = int (sys.argv[-1][8:])
        del sys.argv [-1]

    fcn = globals()[fcn_name]
    try:
        fcn (*sys.argv[2:])
    except TypeError, e:
        print 'echo "ERROR in %s: %s"' % (prog, str(e))
        return

if __name__ == '__main__': main()

# vim: set sts=4 sw=4:
