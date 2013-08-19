---
layout: page
title: exBufExplorer
permalink: /docs/ex_buf_explorer/
---

## Intro

The exBufExplorer is a plugin used to manage the opened buffers. You can use it search, open, close your listed buffer in exVim. Also it provide bookmarks to let you store your frequently edit files.

## Variables

### exBE_window_height

Set the height of the window. This variable only effect when the `g:exBE_use_vertical_window` = 0

{% highlight vim %}
let g:exBE_window_height = 20
{% endhighlight %}

### exBE_window_width

Set the width of the window. This variable only effect when the `g:exBE_use_vertical_window` = 1

{% highlight vim %}
let g:exBE_window_width = 30
{% endhighlight %}

### exBE_window_height_increment

Set the height increase value of window. This variable only effect when the `g:exBE_use_vertical_window` = 0

{% highlight vim %}
let g:exBE_window_height_increment = 30
{% endhighlight %}

### exBE_window_width_increment

Set the width increase value of window. This variable only effect when the `g:exBE_use_vertical_window` = 1

{% highlight vim %}
let g:exBE_window_width_increment = 100
{% endhighlight %}

### exBE_window_direction

* topleft
* botright
* belowright

Set the window direction. This variable will be affect by `g:exBE_use_vertical_window`.  When the vertical is true. it picked left, right direction, when the vertical is false, it picked top, bot direction.

{% highlight vim %}
let g:exBE_window_direction = 'topleft'
{% endhighlight %}

### exBE_use_vertical_window

Use the vertical window or the horizontal window

{% highlight vim %}
let g:exBE_use_vertical_window = 1
{% endhighlight %}


### exBE_backto_editbuf

If the value is 1, after choosing a item from explugin-window, the cursor will jump into the edit-window. Otherwise the cursor will jump back to the explugin-window. 

{% highlight vim %}
let g:exBE_backto_editbuf = 1
{% endhighlight %}

### exBE_close_when_selected

If the value is 1, after choosing a item from explugin-window, the script will close the explugin-window immediatelly.

{% highlight vim %}
let g:exBE_close_when_selected = 0
{% endhighlight %}

## Commands

### :EXB[ufExplorer]

Open the exBufExplorer window. 

{% highlight vim %}
nmap <unique> <A-S-b> :EXBufExplorer<CR>:redraw<CR>/
{% endhighlight %}

### EXAddBookmarkDirectly

Add current edit file to bookmarks.

{% highlight vim %}
nnoremap <unique> <leader>bk :EXAddBookmarkDirectly<CR>
{% endhighlight %}

## Key Mappings

### \<return\>

### \<2-leftmouse\>

Select and jump to the preview position of the item in edit window. 

### \<space\>

Resize the exBufExplorer plugin window by exBE_window_height_increment or exBE_window_width_increment

### \<esc\>

Close the exBufExplorer plugin window.

### dd

Close the selected buffer or delete selected bookmarks.
