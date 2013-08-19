---
layout: page
title: exProject
permalink: /docs/ex_project/
---

## Intro

The exProject manage files in project window. You can create files by filter, also choose the directory you wanna browsing. It provides tree view files like the other file browser plugin in vim web-site. But unlike thoes plugin, exProject put more focus on project itself, that make it more effecient on browing and searching files.

## Variables

### exPJ_window_height

Set the height of the window. This variable only effect when the g:exPJ_use_vertical_window = 0

{% highlight vim %}
let g:exPJ_window_height = 20
{% endhighlight %}

### exPJ_window_width

Set the width of the window. This variable only effect when the g:exPJ_use_vertical_window = 1

{% highlight vim %}
let g:exPJ_window_width = 30
{% endhighlight %}

### exPJ_window_height_increment

Set the height increase value of window. This variable only effect when the g:exPJ_use_vertical_window = 0

{% highlight vim %}
let g:exPJ_window_height_increment = 30
{% endhighlight %}

### exPJ_window_width_increment

Set the width increase value of window. This variable only effect when the g:exPJ_use_vertical_window = 1

{% highlight vim %}
let g:exPJ_window_width_increment = 100
{% endhighlight %}

### exPJ_window_direction

* topleft
* botright
* belowright

Set the window direction. This variable will be affect by g:exPJ_use_vertical_window.  When the vertical is true. it picked left, right direction, when the vertical is false, it picked top, bot direction.

{% highlight vim %}
let g:exPJ_window_direction = 'topleft'
{% endhighlight %}

### exPJ_use_vertical_window

Use the vertical window or the horizontal window

{% highlight vim %}
let g:exPJ_use_vertical_window = 1
{% endhighlight %}

### exPJ_backto_editbuf

If the value is 1, after choosing a item from explugin-window, the cursor will jump into the edit-window. Otherwise the cursor will jump back to the explugin-window. 

{% highlight vim %}
let g:exPJ_backto_editbuf = 1
{% endhighlight %}

### exPJ_close_when_selected

If the value is 1, after choosing a item from explugin-window, the script will close the explugin-window immediatelly.

{% highlight vim %}
let g:exPJ_close_when_selected = 0
{% endhighlight %}

## Commands

### :EXP[roject] [{file-name}]

Open a project file in project window with the {file-name} user gives. Actually you seldom use this command, cause it will be run automatically in g:exES_UpdateEnvironment when you define g:exES_project_cmd = EXProject.

**Note**: if there is not {file-name} gived, the command will move the cursor to the project window if it opened, or it will open a project window.

recommended mapping:

{% highlight vim %}
nnoremap <unique> <silent> <A-S-p> :EXProject<CR>
nmap <unique> <A-S-o> :EXProject<CR>:redraw<CR>/
{% endhighlight %}

**Note**: the second mapping is not just open/goto the project window, it also put a '/' in the command line, which means you can type word for searching directly.

### :ExpjS[electToggle]

Open/Close the project window.

### :ExpjG[otoCurrentFile]

When the cursor is in edit window, use the command will let the cursor jump back to the exProject select-window, and locate the current edit file in project window if the file can be found.

**Note**: the command is useful when you edit a file opened by exProject, but after several operation, you jump to other file, and you want to locate that file in exProject window, so that you can know what are the other files in the same folder.

recommended mapping:

{% highlight vim %}
nnoremap <unique> <leader>fc :ExpjGotoCurrentFile<CR>
{% endhighlight %}

## Key Mappings

### \<return\>

### \<2-LeftMouse\>

If cursor on a file line, it will open the file in edit-window. If cursor on a folder line, it will fold/unfold the folder.

### \<shift-return\>

### \<shift-2-LeftMouse\>

If cursor on a file line, it will open the file and split it in edit-window. If cursor on a folder line, it will prompt a command line window with the path of current directory. (win32 only)

### \<space\>

Resize the project window by exPJ_window_height_increment or exPJ_window_width_increment

### \<leader\>C

Build up the project file with dialog asking the working directory, file filter and dir filter you want.

### \<leader\>R

Refresh the project file using the working directory, file filter and dir filter you already setted.

**Note**: You can manually modify the first two lines to change the file filter and dir filter without pop up a dialog. When refreshing, the script will read them first.

### \<leader\>cf

Refresh the directory current cursor in with a file filter dialog.

### \<leader\>r

Refresh the directory current cursor in follow the global file filter rules.

### \<ctrl-up\>

### \<ctrl-down\>

Find and jump to the up/down nearst error file which name is ErrorLog.err.

### \<ctrl-j\>

### \<ctrl-k\>

Jump to the prev/next folder.

### o

Add a new file in the folder current cursor in.

**Note**: When add a new file, the cursor must in the folder or in a existed file under that folder. You can't create a file in a empty line.

**Note**: You don't need to fill the file type in [], use \r instead.

### O

Add a new folder in the folder current cursor in. The new folder will be created under current folder.

**Note**: When add a new folder, the cursor must in a existed folder. You can't create a folder in a file line or a empty line.

**Note**: The folder you create must already exsits. Yeah, I know, it make me sick, too.

### \<leader\>e

Show path of the file under current cursor in command window.

### \<leader\>ff

default mapping:

{% highlight vim %}
nnoremap <unique> <leader>ff :EXProject<CR>:redraw<CR>/\[[^\CF]'''\]\c.'''
{% endhighlight %}

find only files in the project window.

**Note**: This can be use when you outside the exProject window.

### \<leader\>fd

default mapping:

{% highlight vim %}
nnoremap <unique> <leader>fd :EXProject<CR>:redraw<CR>/\[\CF\]\c.*
{% endhighlight %}

find only folders in the project window.
