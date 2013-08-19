---
layout: page
title: exCscope
permalink: /docs/ex_cscope/
---

## Intro

exCscope help shows cscope results in the plugin window, and you can jump to the result in edit window easily like the other ex plugins. You need to have both cscope tool and a gVim compile with cscope option. 

Though the cscope is powerful, it is really seldom used in exVim. Since you have exGlobalSearch, exTagSelect and exSymbols, these three plugin almost do what cscope can do, even better! Since the cscope is a c analysis tool, with limited cpp support. 

But there still have one thing shows the power of cscope and make valuable for me.  It is the "cscope find i" command, which will find files #including the specific file.  This is very useful when you want to know which file includes me, also can help you detect those redundant includes. I map it as:

{% highlight vim %}
nnoremap <unique> <silent> <F2> :CSIC<CR>
{% endhighlight %}

you can press `<F2>` in a header file to have a try. 

## Variables

### exCS_window_height

Set the height of the window. This variable only effect when the `g:exCS_use_vertical_window = 0`

{% highlight vim %}
let g:exCS_window_height = 20
{% endhighlight %}

### exCS_window_width

Set the width of the window. This variable only effect when the `g:exCS_use_vertical_window = 1`

{% highlight vim %}
let g:exCS_window_width = 30
{% endhighlight %}

### exCS_window_height_increment

Set the height increase value of window. This variable only effect when the `g:exCS_use_vertical_window = 0`

{% highlight vim %}
let g:exCS_window_height_increment = 30
{% endhighlight %}

### exCS_window_width_increment

Set the width increase value of window. This variable only effect when the `g:exCS_use_vertical_window = 1`

{% highlight vim %}
let g:exCS_window_width_increment = 100
{% endhighlight %}

### exCS_window_direction

* topleft
* botright
* belowright

Set the window direction. This variable will be affect by `g:exCS_use_vertical_window`. When the vertical is true. it picked left, right direction, when the vertical is false, it picked top, bot direction.

{% highlight vim %}
let g:exCS_window_direction = 'belowright'
{% endhighlight %}

### exCS_use_vertical_window

Use the vertical window or the horizontal window

{% highlight vim %}
let g:exCS_use_vertical_window = 1
{% endhighlight %}

### exCS_backto_editbuf

If the value is 1, after choosing a item from explugin-window, the cursor will jump into the edit-window. Otherwise the cursor will jump back to the explugin-window. 

{% highlight vim %}
let g:exCS_backto_editbuf = 1
{% endhighlight %}

### exCS_close_when_selected

If the value is 1, after choosing a item from explugin-select/quickview-window, the script will close the explugin-select/quickview-window immediatelly.

{% highlight vim %}
let g:exCS_close_when_selected = 0
{% endhighlight %}

## Commands

### :CSI {file-name}

will find files #including {file-name}, and list the result in exCscope select window.

### :CSD {name}

will find functions called by function in {name}. 

### :CSC {name}

will find functions calling function in {name}. 

### :CSS {name}

will find C symbol in {name}.

### :CSG {name}

will find definition in {name}.

### :CSE {name}

will egrep pattern in {name}.

### :CSIC

will find files #including current edit file, and list the result in exCscope select window.  Recommanded mapping:

{% highlight vim %}
nnoremap <unique> <silent> <F2> :CSIC<CR>
{% endhighlight %}

### :CSID

will find files #including current file under cursor (aka `<cfile>`), and list the result in exCscope select window. Recommanded mapping:

{% highlight vim %}
nnoremap <unique> <silent> <Leader>ci :CSID<CR>
{% endhighlight %}

### :CSDD

will find functions called by current function under cursor, and list the result in exCscope select window. Recommanded mapping:

{% highlight vim %}
nnoremap <unique> <silent> <Leader>cd :CSDD<CR>
{% endhighlight %}

### :CSDC

will find functions calling the function under cursor, and list the result in exCscope select window. Recommanded mapping:

{% highlight vim %}
nnoremap <unique> <silent> <Leader>cc :CSDC<CR>
{% endhighlight %}

### :ExcsParseFunction

List functions called by the function the cursor in, and list the result in exCscope select window.  Unlike :CSDD, this command will use the function current cursor in. Recommanded mapping:

{% highlight vim %}
nnoremap <unique> <silent> <F3> :ExcsParseFunction<CR>
{% endhighlight %}

### :ExcsSelectToggle

Open/Close exCscope select-window. Recommend mapping: 

{% highlight vim %}
nnoremap <unique> <silent> <Leader>cs :ExcsSelectToggle<CR>
{% endhighlight %}

### :ExcsQuickViewToggle

Open/Close exCscope quickview-window. Recommend mapping:

{% highlight vim %}
nnoremap <unique> <silent> <Leader>cq :ExcsQuickViewToggle<CR>
{% endhighlight %}
 
## Key Mappings

### \<return\>

Enable/Disable macro highlight or group highlight

### \<space\>

Resize the exCscope plugin window by `exMH_window_height_increment` or `exMH_window_width_increment`

### \<esc\>

Close the exCscope plugin window.
