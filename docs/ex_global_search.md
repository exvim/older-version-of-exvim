---
layout: page
title: exGlobalSearch
permalink: /docs/ex_global_search/
---

## Intro

exGlobalSearch is the most important search method in exVim, its responsibility is similar like grep, but more efficient cause it use id-utils as search engine.  You need to create ID database first by mkid, but this will be done automatically in quick_gen_project shell programme.

exGlobalSearch not just list the result from id-utils in the plugin window, and let you choose to jump. It also give you a series of filtering method so that after several filtering processing, you can get a more exact result by yourself.

The plugin will record jumps in the exJumpStack similar like what exTagSelect do. It help you trace jump history and make you clear what's the code flow like.

## Variables

### exGS_window_height

Set the height of the window. This variable only effect when the g:exGS_use_vertical_window = 0

{% highlight vim %}
let g:exGS_window_height = 20
{% endhighlight %}

### exGS_window_width

Set the width of the window. This variable only effect when the g:exGS_use_vertical_window = 1

{% highlight vim %}
let g:exGS_window_width = 30
{% endhighlight %}

### exGS_window_height_increment

Set the height increase value of window. This variable only effect when the g:exGS_use_vertical_window = 0

{% highlight vim %}
let g:exGS_window_height_increment = 30
{% endhighlight %}

### exGS_window_width_increment

Set the width increase value of window. This variable only effect when the g:exGS_use_vertical_window = 1

{% highlight vim %}
let g:exGS_window_width_increment = 100
{% endhighlight %}

### exGS_window_direction

* topleft
* botright
* belowright

Set the window direction. This variable will be affect by g:exGS_use_vertical_window.  When the vertical is true. it picked left, right direction, when the vertical is false, it picked top, bot direction.

{% highlight vim %}
let g:exGS_window_direction = 'belowright'
{% endhighlight %}

### exGS_use_vertical_window

Use the vertical window or the horizontal window

{% highlight vim %}
let g:exGS_use_vertical_window = 1
{% endhighlight %}

### exGS_backto_editbuf

If the value is 1, after choosing a item from explugin-window, the cursor will jump into the edit-window. Otherwise the cursor will jump back to the explugin-window. 

{% highlight vim %}
let g:exGS_backto_editbuf = 1
{% endhighlight %}

### exGS_close_when_selected

If the value is 1, after choosing a item from explugin-select/quickview-window, the script will close the explugin-select/quickview-window immediatelly.

{% highlight vim %}
let g:exGS_close_when_selected = 0
{% endhighlight %}

### exGS_highlight_result

This indicate that will we apply syntax highlight for the search results.

{% highlight vim %}
let g:exGS_highlight_result = 0
{% endhighlight %}

*Note*: when I say syntax highlight, it means the syntax highlight of the programme language that current project used, not the syntax highlight of ex-plugins.

### exGS_auto_sort

If the value is 1, the exGlobalSearch will sort the search results by filename and line number. ( it depends on the value g:exGS_lines_for_autosort, if the number of the results is more than the lines we define, it will not sort no matter what exGS_auto_sort value is ).

{% highlight vim %}
let g:exGS_auto_sort = 0
{% endhighlight %}

### exGS_lines_for_autosort

When g:exGS_auto_sort = 1, after getting the search result, exGlobalSearch will check if the number of the results is more than the exGS_lines_for_autosort, if yes, it will not sort. You can use \sr operations to force sort the search results.

{% highlight vim %}
let g:exGS_lines_for_autosort = 500
{% endhighlight %}

## Commands

### :GS {word}

Search {word} in ID database, and list the matched results in exGlobalSearch select-window. Recommend mapping:

{% highlight vim %}
nnoremap <unique> <Leader><S-f> :GS 
{% endhighlight %}

**Note**: The result can be partially martch the {word}

### :GSW {word}

Search the whole {word} in ID database, and list the matched results in exGlobalSearch select-window. 

**Note**: the result must be full match the {word}, similar like `\<{word}\>` patern.

### :GSF {file-name}

Search {file-name} in ID database, and list the matched files in exGlobalSearch select-window.

**Note**: the result can be partially martch the {file-name}

### :GSFW {file-name}

Search the whole {file-name} in ID database, and list the matched files in exGlobalSearch select-window. 

**Note**: the result must be full match the {file-name}, similar like \<{file-name}\> patern.

### :ExgsSelectToggle

Open/Close exGlobalSearch select-window. Recommend mapping: 

{% highlight vim %}
nnoremap <unique> <silent> <Leader>gs :ExgsSelectToggle<CR>
{% endhighlight %}

### :ExgsQuickViewToggle

Open/Close exGlobalSearch quickview-window. Recommend mapping:

{% highlight vim %}
nnoremap <unique> <silent> <Leader>gq :ExgsQuickViewToggle<CR>
{% endhighlight %}

### :ExgsGoDirectly

Search word under current cursor ( as known as `<cword>` ), and list the matched results in exGlobalSearch select-window. 

**Note**: the result can be partially match the `<cword>` Recommend mapping:

{% highlight vim %}
nnoremap <unique> <silent> <Leader>gg :ExgsGoDirectly<CR>
{% endhighlight %}

### :ExgsGotoNextResult

Go to the next search result list in the exGlobalSearch's select/quickview window.

{% highlight vim %}
nnoremap <unique> <silent> <Leader>n :ExgsGotoNextResult<CR>
{% endhighlight %}

**Note**: this works only when select/quickview window is opened.

### :ExgsGotoPrevResult

Go to the last search result list in the exGlobalSearch's select/quickview window.

{% highlight vim %}
nnoremap <unique> <silent> <Leader>N :ExgsGotoPrevResult<CR>
{% endhighlight %}

**Note**: this works only when select/quickview window is opened.

### :GSigc

Set ignore case for global search. 

### :GSnoigc

Set no-ignore case for global search. 

### :SUB /{pattern}/{string}/[flags]

It is similar like :s[ubstitute] command in vim, but it apply the sub to the search results listed in select/quickview window.

**Note**: there have a space between the command and /, you need to write command like

{% highlight vim %}
:SUB /foo/bar/g
{% endhighlight %}

## Key Mappings

### terms

Before I introduce the key mappings, I will explain the terms of things in the select/quickview window.  Basically when you get some result it will list in select/quickview. For instance, you global search 'TList' in a cpp project, and the result will like the picture below

![global_search_sections.png](../images/global_search_sections.png)

As the picture show, we define some term for the item in the window. The concept is separate the result as file-section and preview-section so that we can apply filter in different sections. Now you know the terms we defined, let's learn the mappings.

### \<leader\>r

Pick up the matched pattern in {preview-section}, list them in quickview window.  The matched pattern gives by `/` or `#` search result.

### \<leader\>d

Pick up the un-matched pattern in {preview-section}, list them in quickview window.  The matched pattern gives by `/` or `#` search result.

### \<leader\>fr

Pick up the matched pattern in {file-section}, list them in quickview window.  The matched pattern gives by `/` or `#` search result.

### \<leader\>fd

Pick up the un-matched pattern in {file-section}, list them in quickview window.  The matched pattern gives by `/` or `#` search result.

### \<leader\>gr

Pick up the matched pattern in all sections, list them in quickview window.  The matched pattern gives by `/` or `#` search result.

### \<leader\>gd

Pick up the un-matched pattern in all sections, list them in quickview window.  The matched pattern gives by `/` or `#` search result.

### \<leader\>sr

Force sort the search results. can be used in visual mode.

### \<return\>

### \<2-leftmouse\>

Select and jump to the preview position of the item in edit window. 

### \<space\>

Resize the exGlobalSearch plugin window by exGS_window_height_increment or exGS_window_width_increment

### \<esc\>

Close the exGlobalSearch plugin window.

### \<ctrl-right\>

Switch to select-window

### \<ctrl-left\>

Switch to quickview-window
