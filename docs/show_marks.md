---
layout: page
title: ShowMarks
permalink: /docs/show_marks/
---

## Intro

ShowMakrs like its name, shows the makrs defined in vim. It also provides highlight configuration and marks specification for user, which make it flexible in use. The picture shows how the plugin works.

![show_marks.png](../images/show_marks.png)

## What I changed

**Apply the patched come from Easwy's blog**

Easwy in his blog (http://easwy.com/blog/) published a patch for showmarks plugin, in the article [advanced vim skills: advanced move method](http://easwy.com/blog/archives/advanced-vim-skills-advanced-move-method) Since it is all in Chinese, I'll give you an explanation of what he have done. 

The patch will fix a bug that the uppercase marks will showed in every file in the line you define it. After the patch, it only show up in the line in the file last time you define it.

**Add toggle method for mark define**

When you define mark "a", the way you can remove the mark highlight is use `<leader>mh` in the place you define it, or use `<leader>ma` to remove all marks. I think it make people comfortable to remove makrs just by typeing the mark define again in the same place. So I add this method. 

So now when you define mark "a" in place 1, and move around to some where, when you back, you can remove it by typing "ma" again.

**Add unique method for mark define**

You can define multiple marks in same place, and showmakrs plugin even provide you different color when a line have marks more than one. But I don't understand why people want to define two or more makrs in same place, it is wasted, and hard to remember marks. 

So I change the mark define behavior in showmarks plugin, now if you define mark "a" in place1, and then when you define mark "b" in same place, it will occupy the place by taking mark "a" off.  So you will have only one mark in one place.

## My settings in vimrc

Here is my settings of ShowMarks in my vimrc file:

{% highlight vim %}
" ------------------------------------------------------------------ 
" Desc: ShowMarks
" ------------------------------------------------------------------ 

let g:showmarks_enable = 1
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = "hqm"
" Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 0 

" update custom highlights
function g:ex_CustomHighlight()

    " ======================================================== 
    " ShowMarks
    " ======================================================== 

    " For marks a-z
    hi clear ShowMarksHLl
    hi ShowMarksHLl term=bold cterm=none ctermbg=LightBlue gui=none guibg=LightBlue
    " For marks A-Z
    hi clear ShowMarksHLu
    hi ShowMarksHLu term=bold cterm=bold ctermbg=LightRed ctermfg=DarkRed gui=bold guibg=LightRed guifg=DarkRed
    " For all other marks
    hi clear ShowMarksHLo
    hi ShowMarksHLo term=bold cterm=bold ctermbg=LightYellow ctermfg=DarkYellow gui=bold guibg=LightYellow guifg=DarkYellow
    " For multiple marks on the same line.
    hi clear ShowMarksHLm
    hi ShowMarksHLm term=bold cterm=none ctermbg=LightBlue gui=none guibg=SlateBlue

endfunction
{% endhighlight %}

For details of g:ex_CustomHighlight, check section [exUtility](../ex_utility)

## Links

* [Original version](http://www.vim.org/scripts/script.php?script_id=152)
