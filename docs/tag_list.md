---
layout: page
title: TagList
permalink: /docs/tag_list/
---

## Intro

TagList could be the most famous plugin in vim, no need for introducing it.

## What I changed

**Change resize window method**

The original taglist plugin use button `<x>` to resize window, I change it to `<space>` so that make it have same behavior like other ex-plugin window. Also I export a variable named Tlist_WinIncreament outside for user setup the size for window increasement.
    
{% highlight vim %}
let Tlist_WinIncreament = 100
{% endhighlight %}

**Add back to edit buffer method**

Like other ex-plugin window, you can define backto_editbuf setting. I add a variable named Tlist_BackToEditBuffer

If the value is 1, after choosing a item from TagList window, the cursor will jump into the edit-window. Otherwise the cursor will jump back to the plugin-window. 

{% highlight vim %}
let Tlist_BackToEditBuffer = 0
{% endhighlight %}

**Add object line highlight and confirmatory highlight**

When you choose a item in TagList window, you will jump to the position in edit buffer.  I add highlight in both selected line and the target position. As showed as below:

![taglist_highlight.png](../images/taglist_highlight.png)

## My settings in vimrc

Here is my settings of TagList in my vimrc file:

{% highlight vim %}
let g:ex_plugin_registered_bufnames = ["-MiniBufExplorer-","__Tag_List__","\[Lookup File\]", "\[BufExplorer\]"] 
let g:ex_plugin_registered_filetypes = ["ex_plugin","ex_project","taglist","nerdtree"] 

" ------------------------------------------------------------------ 
" Desc: TagList
" ------------------------------------------------------------------ 

" F4:  Switch on/off TagList
nnoremap <unique> <silent> <F4> :TlistToggle<CR>

"let Tlist_Ctags_Cmd = $VIM.'/vimfiles/ctags.exe' " location of ctags tool 
let Tlist_Show_One_File = 1 " Displaying tags for only one file~
let Tlist_Exist_OnlyWindow = 1 " if you are the last, kill yourself 
let Tlist_Use_Right_Window = 1 " split to the right side of the screen 
let Tlist_Sort_Type = "order" " sort by order or name
let Tlist_Display_Prototype = 0 " do not show prototypes and not tags in the taglist window.
let Tlist_Compart_Format = 1 " Remove extra information and blank lines from the taglist window.
let Tlist_GainFocus_On_ToggleOpen = 1 " Jump to taglist window on open.
let Tlist_Display_Tag_Scope = 1 " Show tag scope next to the tag name.
let Tlist_Close_On_Select = 0 " Close the taglist window when a file or tag is selected.
let Tlist_BackToEditBuffer = 0 " If no close on select, let the user choose back to edit buffer or not
let Tlist_Enable_Fold_Column = 0 " Don't Show the fold indicator column in the taglist window.
let Tlist_WinWidth = 40
let Tlist_Compact_Format = 1 " do not show help

" update custom highlights
function g:ex_CustomHighlight()

    " ======================================================== 
    " TagList
    " ======================================================== 

    " TagListTagName  - Used for tag names
    hi MyTagListTagName term=bold cterm=none ctermfg=Black ctermbg=DarkYellow gui=none guifg=Black guibg=#ffe4b3
    " TagListTagScope - Used for tag scope
    hi MyTagListTagScope term=NONE cterm=NONE ctermfg=Blue gui=NONE guifg=Blue 
    " TagListTitle    - Used for tag titles
    hi MyTagListTitle term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray gui=bold guifg=DarkRed guibg=LightGray 
    " TagListComment  - Used for comments
    hi MyTagListComment ctermfg=DarkGreen guifg=DarkGreen 
    " TagListFileName - Used for filenames
    hi MyTagListFileName term=bold cterm=bold ctermfg=Black ctermbg=LightBlue gui=bold guifg=Black guibg=LightBlue

endfunction
{% endhighlight %}

For details of g:exUT_plugin_list and g:ex_CustomHighlight, check section [exUtility](../ex_utility)

## Links

* [Original version in vim scripts](http://www.vim.org/scripts/script.php?script_id=273)
* [Original version in sourceforge](http://vim-taglist.sourceforge.net)
* [TagList yahoo group](http://tech.groups.yahoo.com/group/taglist)
