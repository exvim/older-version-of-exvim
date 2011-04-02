Site
**************

* exVim Official Page: http://www.ex-dev.com/exvim
* exVim Documentation: http://www.ex-dev.com/exvim/wiki
* exVim Source Code: https://github.com/jwu/exvim
* exVim in Vim Script: http://www.vim.org/scripts/script.php?script_id=2627
* exVim in Google Code (for Download only): http://code.google.com/p/exvim

Introduction
**************

What is exVim ?
================

exVim is a package intgerate ex-vim-plugins, 3rd-vim-plugins and external-tools for developing.
By solving the complex communication problem among plugins, external tools, the exVim make
the vim as an IDE like environment all in vimscript.

What can exVim do ?
=====================

With exVim you can:

* use one single file ``your_project.vimentry`` to access your project. 
* update tags, IDs and other things you used in your project in one command.
* browse project files in project window.
* search files, tags, and words in source code by the builtin method.
* a powful way to filter search result. 
* trace your code by jump stack.
* reading code easily by word highlight and macro highlight.
* view classes hierarchy pictures.
* compile project in vc/gcc and get error results from them directly through vim.
* enhanced quick-fix window.
* communicate with visual studio --- get build errors, open files, add break point and send command make vs.net compiling current file.

Usage
=======

The exVim use ``your_project.vimentry`` file as the entry of a project. When you put this 
file in the root directory of the project, and open it by vim, ex-vim-plugins will awared 
and do the rest of the work to help you generate tags, symbols, IDs and other things 
could be used in your project. 

When edit a project, exVim provides several method to help you locate the code, get global 
seach results, also an easy and powerful way to filter the search result!

Compatible
============

exVim is compatible with your original vim. The exVim is nothing but several vim-plugins,
there are not too much reasons make it unable to work in your vim.  

Small, Fast and Stable
========================

The principle for solving problem in exVim are: 

#. try to interact with user dynamically.
#. if the dynamic interactive sufferred performance issue, go for static method.
#. try the best to fulfill a demand in vimscript.
#. if it can't, try the best to fulfill the demand by external tools.
#. if it still can't, try the best to preprocess the result and return to rule No.1

exVim is designed to follow this principle which make it small, fast and stable.
