---
layout: page
title: exQuickFix
permalink: /docs/ex_quickfix/
---

## Intro

exQuickFix load the compile error result from file or buffer, and create quickfix list, then show the warnings/errors in the plugin-window let you choose to jump to it.

Compare with the quickfix in vim, the exQuickFix is almost the same but more easy to operate. Also it is write to work with other plugin such as exProject and visual-studio.  You can directly open the exQuickFix window by open a ".err" file in exProject.  Also when you compile single file in MS-VS.net through visual-studio plugin(patched version) you will get the error result in exQuickFix window when compile finished. 

## Variables

### exQF_window_height

Set the height of the window. This variable only effect when the g:exQF_use_vertical_window = 0

{% highlight vim %}
let g:exQF_window_height = 20
{% endhighlight %}

### exQF_window_width

Set the width of the window. This variable only effect when the g:exQF_use_vertical_window = 1

{% highlight vim %}
let g:exQF_window_width = 30
{% endhighlight %}

### exQF_window_height_increment

Set the height increase value of window. This variable only effect when the g:exQF_use_vertical_window = 0

{% highlight vim %}
let g:exQF_window_height_increment = 30
{% endhighlight %}

### exQF_window_width_increment

Set the width increase value of window. This variable only effect when the g:exQF_use_vertical_window = 1

{% highlight vim %}
let g:exQF_window_width_increment = 100
{% endhighlight %}

### exQF_window_direction

* topleft
* botright
* belowright

Set the window direction. This variable will be affect by g:exQF_use_vertical_window.  When the vertical is true. it picked left, right direction, when the vertical is false, it picked top, bot direction.

{% highlight vim %}
let g:exQF_window_direction = 'belowright'
{% endhighlight %}

### exQF_use_vertical_window

Use the vertical window or the horizontal window

{% highlight vim %}
let g:exQF_use_vertical_window = 1
{% endhighlight %}

### exQF_backto_editbuf

If the value is 1, after choosing a item from explugin-window, the cursor will 
jump into the edit-window. Otherwise the cursor will jump back to the explugin-window. 

{% highlight vim %}
let g:exQF_backto_editbuf = 1
{% endhighlight %}

### exQF_close_when_selected

If the value is 1, after choosing a item from explugin-select/quickview-window, 
the script will close the explugin-select/quickview-window immediatelly.

{% highlight vim %}
let g:exQF_close_when_selected = 0
{% endhighlight %}

## Commands

### :QF {file-name}

load a quickfix list from a file, and shows the contents in the exQuickFix select-window. You can jump to the quick fix position by press `<enter>` on the line have quickfix information. Also you can use `<ctrl-left>` to switch to the quickview-window to see all the available quick fixes. To swtich back to select-window, press `<ctrl-right>`.

### :ExqfSelectToggle

Open/Close a exQuickFix select-window.

### :ExqfQuickViewToggle

Open/Close a exQuickFix quickview-window.

## Key Mappings

### \<return\>

### \<2-leftmouse\>

Select and jump to the preview position of the item in edit window. 

### \<space\>

Resize the exQuickFix plugin window by exGS_window_height_increment or exGS_window_width_increment

### \<esc\>

Close the exQuickFix plugin window.

### \<ctrl-right\>

Switch to select-window

### \<ctrl-left\>

Switch to quickview-window

### \<ctrl-down\>

Jump to next error in select/quickview window.

**Note**: The error here means the line have words "error" or "warning"

### \<ctrl-up\>

Jump to prev error in select/quickview window.

**Note**: The error here means the line have words "error" or "warning"
