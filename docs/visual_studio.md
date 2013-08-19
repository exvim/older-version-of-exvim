---
layout: page
title: VisualStudio
permalink: /docs/visual_studio/
---

## Intro

Before I using this plugin, I'm seeking in a way to make vim work with MS-VisualStudio.  None of the them I found can satisfy me. I strongly recommend every programmer working with VS.net install this plugin, it saves me a lot of time.

The basic idea is of the plugin is using python and pywin32 create a com connection between MS-VisualStudio and vim, then sending the command through vim to VS.net, wait for responding. Base on the concept, you can:

* Compile and get compile error in vim 
* Put current edit file to VS.net from vim
* Get current edit file from VS.net to vim
* Set break point
* and so on...

You need to install python2.x and pywin32 for running the plugin. Here is the download address:

* [python](http://www.python.org)
  * [pywin32](http://sourceforge.net/projects/pywin32)

Also I recommend you compile vim with python. 

This can be done by writing the compile option below in unix/linux:

{% highlight bash %}
--enable-pythoninterp
{% endhighlight %}

or writing similar compile command below in windows:

{% highlight bash %}
"PYTHON=d:\exDev\Python25 DYNAMIC_PYTHON=YES PYTHON_VER=25"
{% endhighlight %}

## What I changed

**Use exQuickFix load compile error from VS.net**

The default plugin use quickfix load compile errors when finishing compile in VS.net. I change and load the errors to exQuickFix.

**Add putting break point method**

I add functions so that user can put break point in VS.net directly through vim. This can be done by pressing `<leader>vk`

**Add putting watching variable method**

I add functions so that user can add current word to VS.net watch window directly through vim. This can be done by pressing `<leader>vw`

**Change several key mappings**

Since the key mappings conflict, I changes several key mappings: 

* `<leader>vg` change to `<leader>vo`: Get the VS file into Vim
* `<leader>vp`: Put the Vim file into VS
* `<leader>vt` change to `<leader>vgt`: Load the VS Task List into the Vim quickfix buffer
* `<leader>vo` change to `<leader>vgo`: Load the VS Output window into the Vim quickfix buffer
* `<leader>vf` change to `<leader>vf1`: Load the VS Find Results 1 window into the Vim quickfix buffer
* `<leader>v2` change to `<leader>vf2`: Load the VS Find Results 2 window into the Vim quickfix buffer
* `<leader>vb`: Build the VS Solution
* `<leader>vu`: Build the VS Startup Project
* `<leader>vc`: Compile the current file
* `<leader>vs`: Select the current VS Solution instance
* `<leader>vp` change to `<leader>vj`: Select the current VS Startup Project
* `<leader>va`: About visual_studio.vim
* `<leader>vh`: Online help - this page!
* `<leader>vk` new: add break piont to VS
* `<leader>vw` new: add current word to VS watch window

## My settings in vimrc

Here is my settings of visual-studio in my vimrc file:

{% highlight vim %}
" exEnvironmentSetting post update
" NOTE: this is a post update environment function used for any custom environment update 
function g:exES_PostUpdate()

    " set visual_studio plugin variables
    if exists( 'g:exES_vsTaskList' )
        let g:visual_studio_task_list = g:exES_vsTaskList
    endif
    if exists( 'g:exES_vsOutput' )
        let g:visual_studio_output = g:exES_vsOutput
    endif
    if exists( 'g:exES_vsFindResult1' )
        let g:visual_studio_find_results_1 = g:exES_vsFindResult1
    endif
    if exists( 'g:exES_vsFindResult2' )
        let g:visual_studio_find_results_2 = g:exES_vsFindResult2
    endif

endfunction
{% endhighlight %}

For details of g:exES_PostUpdate, check section [exEnvironment](../ex_environment)

## Links

* [Original version](http://www.vim.org/scripts/script.php?script_id=864)
* [Online document](http://www.plan10.com/vim/visual-studio/doc/1.2)
* [python](http://www.python.org)
  * [pywin32](http://sourceforge.net/projects/pywin32)
