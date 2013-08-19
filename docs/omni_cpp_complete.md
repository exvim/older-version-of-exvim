---
layout: page
title: OmniCppComplete
permalink: /docs/omni_cpp_complete/
---

## Intro

To be honest, I seldom use this plugin. Since it is limited in parsing the template members.  But the Omni become powerful if you use it in normal class completion.

So it's up to use whether use it or not.

## My settings in vimrc

{% highlight vim %}
" ------------------------------------------------------------------ 
" Desc: OmniCppComplete
" ------------------------------------------------------------------ 

" set Ctrl+j in insert mode, like VS.Net
imap <unique> <C-]> <C-X><C-O>
" :inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>" 

" set completeopt as don't show menu and preview
set completeopt=menuone

" use global scope search
let OmniCpp_GlobalScopeSearch = 1

" 0 = namespaces disabled
" 1 = search namespaces in the current buffer
" 2 = search namespaces in the current buffer and in included files
let OmniCpp_NamespaceSearch = 1

" 0 = auto
" 1 = always show all members
let OmniCpp_DisplayMode = 1

" 0 = don't show scope in abbreviation
" 1 = show scope in abbreviation and remove the last column
let OmniCpp_ShowScopeInAbbr = 0

" This option allows to display the prototype of a function in the abbreviation part of the popup menu.
" 0 = don't display prototype in abbreviation
" 1 = display prototype in abbreviation
let OmniCpp_ShowPrototypeInAbbr = 1

" This option allows to show/hide the access information ('+', '#', '-') in the popup menu.
" 0 = hide access
" 1 = show access
let OmniCpp_ShowAccess = 1

" This option can be use if you don't want to parse using namespace declarations in included files and want to add namespaces that are always used in your project.
let OmniCpp_DefaultNamespaces = ["std"]

" Complete Behaviour
let OmniCpp_MayCompleteDot = 0
let OmniCpp_MayCompleteArrow = 0
let OmniCpp_MayCompleteScope = 0

" When 'completeopt' does not contain "longest", Vim automatically select the first entry of the popup menu. You can change this behaviour with the OmniCpp_SelectFirstItem option.
let OmniCpp_SelectFirstItem = 0
{% endhighlight %}

## Links

* [OmniCppComplete on vim script](http://www.vim.org/scripts/script.php?script_id=1520)
