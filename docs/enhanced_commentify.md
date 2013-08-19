---
layout: page
title: EnhancedCommentify
permalink: /docs/enhanced_commentify/
---

## Intro

EnhancedCommentify is a vim plugin help me comment programme, it support so many programme language and detected the comment syntax automatically so that even my exUtility used some variables from it.

## My settings in vimrc

Here is my settings of EnhancedCommentify in my vimrc file:

{% highlight vim %}
" ------------------------------------------------------------------ 
" Desc: EnhCommentify
" ------------------------------------------------------------------ 

let g:EnhCommentifyFirstLineMode='yes'
let g:EnhCommentifyRespectIndent='yes'
let g:EnhCommentifyUseBlockIndent='yes'
let g:EnhCommentifyAlignRight = 'yes'
let g:EnhCommentifyPretty = 'yes'
let g:EnhCommentifyBindInNormal = 'no'
let g:EnhCommentifyBindInVisual = 'no'
let g:EnhCommentifyBindInInsert = 'no'

" NOTE: VisualComment,Comment,DeComment are plugin mapping(start with <Plug>), so can't use remap here
vmap <unique> <F11> <Plug>VisualComment
nmap <unique> <F11> <Plug>Comment
imap <unique> <F11> <ESC><Plug>Comment
vmap <unique> <C-F11> <Plug>VisualDeComment
nmap <unique> <C-F11> <Plug>DeComment
imap <unique> <C-F11> <ESC><Plug>DeComment
{% endhighlight %}

## Links

* [EnhancedCommentify on vim scripts](http://www.vim.org/scripts/script.php?script_id=23)
* [Author's web site](http://kotka.de/projects/enhancedcommentify/index.html)
