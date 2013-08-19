---
layout: page
title: Search tags and symbols
permalink: /docs/tags_and_symbols/
---

## Create tags and symbols

To generate tags and symbols for exVim, you can use `:Up[date]` command. The command will create all files need for exVim, including tags and symbols. If you just want to create tags and symbols, try `:Up[date]` tag, `:Up[date]` symbol commands.

**Note**: The symbols depends on the tag file, so you have to create tags first so the symbol can extract information from it.

## Concept

In exVim, a tag including information for a special word in the code. The word can be a class name, a variable, a function name and so on. The information could be the definition of the word in the file, is a member or not, its access attribute and so on. Here is a example of tag that in the file "tags" we generate:

{% highlight bash %}
TList    ..\exLibs\Container\List.h    /^    TList()$/;"    f    class:ex::TList    access:public    signature:()
{% endhighlight %}

we can see the first one is the tag name, the second one records the file of the definition, and the third one is the definition pattern...

The symbol is the subset of tag, which only have the name of the tag. So in the example above, the symbol is the tag-name -- TList.

The basic idea is let the exVim use symbols to list the possible tags in the project, to help user search a tag in an easier and faster way. Sometimes you may wonder if the project have a tag-name named "AName", and the symbols can provide you the results, so that you can choose one to get the detail information in tags.

We will discuss more usage of search tags and symbols in exVim later.

## Search tags

The exTagSelect plugin in exVim is responsible for searching tags. You can use `\]` to get the tag information of the word under the cursor. Also you can use `:TS <tag-name>` command to input a tag and get the result.

When you are in tag select-window, you can press `<enter>` to jump to the definition, meanwhile the exTagSelect will record the position to the exJumpStack, you can use `<leader>tt` to check your stack result. And use `<leader>tf`, `<leader>tb` to move backward and forward from the next/last definition.

## Search symbols

The [exSymbolTabl](../ex_symbol_table) plugin in exVim is responsible for searching tags. To browse the whole symbol list use `<leader>ss`, which will open the symbol select-window, list the symbols in it for selection.

You can use the vim's search command `/` or `#` to find a symbol in select-window, when you confirm the search, it would probably like the picture below:

![symbol_table_window.png](../images/symbol_table_window.png)

Now you have the search pattern mark as yellow, in this state let's say you apply a pattern to the select-window. You can use `<leader>r` to pick up the matched result from select-window to quick-view-window, or use `<leader>d` otherwise. The picture below shows how it looks like when use a pick-up command (`<leader>r`).

![symbol_quick_view_window.png](../images/symbol_quick_view_window.png)

By pressing enter on the symbol, you will invoke exTagSelect, and start a tag search and get the result in tag select-window.

You can use `<leader>sg` to get the matched symbols by the word under the cursor. Also you can use `:SL <symbol-name>` command to input a symbol and find the first mathced result in symbol select-window.

## tips, tricks and settings

In chapter [TipsAndTricks](./images/tips_and_tricks), the tips 1, 2, 3, 4 shows how to make symbols and tags works together.

The chapter [exTagSelect](../ex_tag_select) and [exSymbolTable](../ex_symbol_table) shows the detail settings of exTagSelect and exSymbolTable.

