---
layout: page
title: exJumpStack
permalink: /docs/ex_jump_stack/
---

## Intro

exJumpStack records your jump history when you use exVim jumping to the search results. It also records the operations you used for jumping. By using exJumpStack you can easily trace the code, and have a clear view of how you jump to here or there.

The exJumpStack records the jump operations from exSymbolTable, exTagSelect, exGlobalSearch and exCscope. The chapter [Jump Stack](../jump_stack) give you the whole idea of exJumpStack in exVim.

## Variables

### exJS_window_height

Set the height of the window. This variable only effect when the g:exJS_use_vertical_window = 0

{% highlight vim %}
let g:exJS_window_height = 20
{% endhighlight %}

### exJS_window_width

Set the width of the window. This variable only effect when the g:exJS_use_vertical_window = 1

{% highlight vim %}
let g:exJS_window_width = 30
{% endhighlight %}

### exJS_window_height_increment

Set the height increase value of window. This variable only effect when the g:exJS_use_vertical_window = 0

{% highlight vim %}
let g:exJS_window_height_increment = 30
{% endhighlight %}

### exJS_window_width_increment

Set the width increase value of window. This variable only effect when the g:exJS_use_vertical_window = 1

{% highlight vim %}
let g:exJS_window_width_increment = 100
{% endhighlight %}

### exJS_window_direction

* topleft
* botright
* belowright

Set the window direction. This variable will be affect by g:exJS_use_vertical_window.  When the vertical is true. it picked left, right direction, when the vertical is false, it picked top, bot direction.

{% highlight vim %}
let g:exJS_window_direction = 'belowright'
{% endhighlight %}

### exJS_use_vertical_window

Use the vertical window or the horizontal window

{% highlight vim %}
let g:exJS_use_vertical_window = 1
{% endhighlight %}

### exJS_backto_editbuf

If the value is 1, after choosing a item from explugin-window, the cursor will jump into the edit-window. Otherwise the cursor will jump back to the explugin-window. 

{% highlight vim %}
let g:exJS_backto_editbuf = 1
{% endhighlight %}

### exJS_close_when_selected

If the value is 1, after choosing a item from explugin-select/quickview-window, the script will close the explugin-select/quickview-window immediatelly.

{% highlight vim %}
let g:exJS_close_when_selected = 0
{% endhighlight %}

## Commands

### :ExjsToggle

Open/Close exJumpStack window. Recommend mapping: 

{% highlight vim %}
nnoremap <unique> <silent> <Leader>tt :ExjsToggle<CR>
{% endhighlight %}

### :BackwardStack

Go to the last jumped position directly. Recommend mapping:

{% highlight vim %}
nnoremap <unique> <silent> <Leader>tb :BackwardStack<CR>
{% endhighlight %}

### :ForwardStack

Go to the next jumped position directly. Recommend mapping: 

{% highlight vim %}
nnoremap <unique> <silent> <Leader>tf :ForwardStack<CR>
{% endhighlight %}

## Key Mappings

### \<return\>

### \<2-leftmouse\>

Select and jump to the position of the item in edit window. 

### \<space\>

Resize the exGlobalSearch plugin window by exJS_window_height_increment or exJS_window_width_increment

### \<esc\>

Close the exJumpStack plugin window.
