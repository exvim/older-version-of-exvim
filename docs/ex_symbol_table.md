---
layout: page
title: exSymbolTable
permalink: /docs/ex_symbol_table/
---

## Intro

exSymbolTable lists the names of all available tags in plugin window, and use a faster way to search and get the tag name you desire. We call these tag names "Symbol". To create symbols, you need to use gawk process data in tags file.  But you don't need to worry about it since the quick_gen_project create the symbol file automatically after update tags file.

exSymbolTable consists of two windows, the select-window and quickview-window.  The select-window lists all symbols, and the quickview-window just list thoes matched symbols by the search pattern you gived. Though the exSymbolTable is a tool for searching and filtering symbols, it become powerful in the way you use it. For example you can filter the class name, and then the symbol will list the name of the class and at the result you would see the member is comming cause the symbol could properly be class_name::member_name. check [Tips And Tricks](../tips_and_tricks) section for detail.

## Variables

### exSL_window_height

Set the height of the window. This variable only effect when the g:exSL_use_vertical_window = 0

{% highlight vim %}
let g:exSL_window_height = 20
{% endhighlight %}

### exSL_window_width

Set the width of the window. This variable only effect when the g:exSL_use_vertical_window = 1

{% highlight vim %}
let g:exSL_window_width = 30
{% endhighlight %}

### exSL_window_height_increment

Set the height increase value of window. This variable only effect when the g:exSL_use_vertical_window = 0

{% highlight vim %}
let g:exSL_window_height_increment = 30
{% endhighlight %}

### exSL_window_width_increment

Set the width increase value of window. This variable only effect when the g:exSL_use_vertical_window = 1

{% highlight vim %}
let g:exSL_window_width_increment = 100
{% endhighlight %}

### exSL_window_direction

* topleft
* botright
* belowright

Set the window direction. This variable will be affect by g:exSL_use_vertical_window.  When the vertical is true. it picked left, right direction, when the vertical is false, it picked top, bot direction.

{% highlight vim %}
let g:exSL_window_direction = 'botright'
{% endhighlight %}

### exSL_use_vertical_window

Use the vertical window or the horizontal window

{% highlight vim %}
let g:exSL_use_vertical_window = 1
{% endhighlight %}

### exSL_SymbolSelectCmd

This variable define which tag select tools you prefer to use. Default is 'ts' which means use the default vim tag select command :ts {tagname}. I recommend you use 'TS', the exTagSelect plugin for tag select.

{% highlight vim %}
let g:exSL_SymbolSelectCmd = 'ts'
{% endhighlight %}

## Commands

### :SL {tag-name}

locate first matched {tag-name} in exSymbolTable select-window. You can use <tab> to get matched tags when inputing tag names.

### :SS {tag-name}

list matched {tag-name} in exSymbolTable quickview-window. You can use <tab> to get matched tags when inputing tag names.

### :ExslSelectToggle

Open the exSymbolTable select-window. Recommend mapping:

{% highlight vim %}
nnoremap <unique> <silent> <Leader>ss :ExslSelectToggle<CR>
{% endhighlight %}

### :ExslQuickViewToggle

Open the exSymbolTable quickview-window. Recommend mapping:

{% highlight vim %}
nnoremap <unique> <silent> <Leader>sq :ExslQuickViewToggle<CR>
{% endhighlight %}

### :ExslGoDirectly

Use word under current cursor (<cword>) as tag name, search and list the possible results in quickview-window. as the picture shows: 

![exss_go_directly.png](../images/exss_go_directly.png)

recommend mapping:

{% highlight vim %}
nnoremap <unique> <silent> <Leader>sg :ExslGoDirectly<CR>
{% endhighlight %}

### :ExslQuickSearch

Open exSymbolTable select-window and insert search symbole '/' in command line to help quick search a symbol in the window. Recommend mapping:

{% highlight vim %}
nmap <unique> <A-S-l> :ExslQuickSearch<CR>/
{% endhighlight %}

### :SLigc

Set ignore case for symbol table item search. 

### :SLnoigc

Set no-ignore case for symbol table item search. 

## Key Mappings

### \<return\>

### \<2-leftmouse\>

Select a tag from select/quickview window, when select, it will use g:exSL_SymbolSelectCmd to execute the tag.

### \<ctrl-return\>

This operation will pick up the word in current line, and list matched symbols in quickview-window.

### \<space\>

Resize the exSymbolTable plugin window by exSL_window_height_increment or exSL_window_width_increment

### \<esc\>

Close the exSymbolTable plugin window.

### \<ctrl-right\>

Switch to select-window when you are in quickview-window

### \<ctrl-left\>

Switch to quickview-window when you are in select-window

### \<leader\>r

Pick up symbols those have matched patterns, and list them in quickview window.  The matched pattern gives by / or # search result.

### \<leader\>d

Pick up symbols those have unmatched patterns, and list them in quickview window.  The matched pattern gives by / or # search result.
