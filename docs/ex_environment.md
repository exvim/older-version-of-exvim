---
layout: page
title: exEnvironment
permalink: /docs/ex_environment/
---

## Intro

When you create a new ".vimentry" file, and open it, there always have some path or variable settings automatically fill in the file, that is what exEnvironment do. 

exEnvironment help exVim parsing the value write in ".vimentry" file to the script, and it will create a global variable with the value behind "=".  The variabale name will defined with prefix g:exES_. For example, you have a line of value define as:

{% highlight bash %}
Variable1='this is a test'
{% endhighlight %}

Then the exEnvironment will parse the line, and create a variable named g:exES_Variable1, its value is 'this is a test'. Also exEnvironment support list variable, instead of using "=" to assign value, you choose "+=" to assign each item in the list. For example:

{% highlight bash %}
List1+='item1'
List1+='item2'
List1+='item3'
{% endhighlight %}

*Note*: exEnvironment always parse value as string.

At the beginning, when you create a ".vimentry" file, exEnvironment will write a default template, which contains variable definitions. Meanwhile it will record its current version number in that file. Then saved the ".vimentry" file. After that, it will parse the text create the variables in script.

* When you open the ".vimentry" file again, exEnvironment will check if the version is lower then the script version. 
  * If yes, it will over write the original ".vimentry" file information, this may let you loose the information you add. 
  * If no, it will parse the text from current file.
* When you edit the .vimentry file, and save it by `:w`, the exEnvironment will detect and re-parse the variables. 
* When you want to apply default template again in current .vimentry file, just clean the text in the file, and save it. The exEnvironment will detect is it a blank page in .vimentry file, and then fill in default template.

## Variables

### exES_vimfile_dir

exES_vimfile_dir will set the directory name which stores exVim project files. Default is ".vimfiles". This value also affect the default template value writing in ".vimentry".

{% highlight vim %}
let g:exES_vimfile_dir = ".vimfiles"
{% endhighlight %}

### exES_project_cmd

The exES_project_cmd will be used to open a project in project window. It is a fallback solution for those who prefer to use the project.vim plugin than exProject plugin. By default the value is 'EXProject'.

{% highlight vim %}
let g:exES_project_cmd = 'EXProject'
{% endhighlight %}

### exES_ImageViewer

The exES_ImageViewer will store the picture viewer tool you specified for browsing pciture files in vim. By default it use IrfanView in win32.

{% highlight vim %}
let g:exES_ImageViewer = 'd:\exDev\IrfanView\i_view32.exe'
{% endhighlight %}

### exES_WebBrowser

The exES_WebBrowser will store a full path html browsing tool you specified for browsing html files in vim. By default it use firefox.

{% highlight vim %}
let g:exES_WebBrowser = 'c:\Program Files\Mozilla Firefox\firefox.exe'
{% endhighlight %}

## Post update function

If you want to do something after exEnvironment parsing the vimentry file, you need to define a function named g:exES_PostUpdate() and write scripts in it in .vimrc. You can use the script "if exists()" to detect if a variable been parsed from vimentry, for example, you have write a "CWD=..." line in the vimentry file, and you want it be your current working directory every time you open that entry file, you write:

{% highlight vim %}
function g:exES_PostUpdate()
    if exists( 'g:exES_CWD' )
        silent exec 'cd ' . g:exES_CWD
    endif
endfunction
{% endhighlight %}

And here is example shows what I do in my .vimrc:

{% highlight vim %}
function g:exES_PostUpdate()

    " set lookup file plugin variables
    if exists( 'g:exES_LookupFileTag' )
        let g:LookupFile_TagExpr='"'.g:exES_LookupFileTag.'"'
    endif

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

    " set vimwiki
    if exists( 'g:exES_wikiHome' )
        " clear the list first
        if exists( 'g:vimwiki_list' ) && !empty(g:vimwiki_list)
            silent call remove( g:vimwiki_list, 0, len(g:vimwiki_list)-1 )
        endif

        " assign vimwiki pathes, 
        " NOTE: vimwiki need full path.
        let g:vimwiki_list = [ { 'path': fnamemodify(g:exES_wikiHome,":p"), 
                    \ 'path_html': fnamemodify(g:exES_wikiHomeHtml,":p"),
                    \ 'html_header': fnamemodify(g:exES_wikiHtmlHeader,":p") } ]

        " create vimwiki files
        call exUtility#CreateVimwikiFiles ()
    endif
endfunction
{% endhighlight %}
