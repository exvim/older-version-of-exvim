---
layout: page
title: Working with compiler
permalink: /docs/work_with_compiler/
---

## Intro

We have discussed how to use exVim to jump, read and write codes, but when you finish all this things, you have to compile the code and run it. It is easy if you are use exVim working on a exists project, which already setup its makefiles or solution (in vs.net).  But what if you start your work from beginning, you may need to write or distribute the makefiles by yourself. 

The exVim provide a series of makefiles for creating a gcc project. Also some vcproj files for creating a vs.net project. In this chapter we will show you how to setup this files to compile a project.

## Create gcc project

### Create a single gcc project

A single gcc project is a project that its source code only generate a library or an executable program. To create a single gcc project, copy the makefile below into your project root directory:

* toolkit/makefile/gcc/gcc_entry_s.mk
* toolkit/makefile/gcc/gcc_config.mk
* toolkit/makefile/gcc/gcc_rule.mk

Then you need to setup the value in gcc_entry_s.mk. Check the section setup values below to learn it. 

Once you finish setting up the values, use command :GM[ake] to compile the whole project.

***Download File:***

Here is a sample project to show you how to use single-gcc-project: [single.project.7z](./downloads/single.project.7z)

### Create multiple gcc project

A multiple gcc project is a project consists of several libraries, exeutable files. We can think the source code to generate one library or executable programme as one project, and a multiple project contains all of them. 

Base on the concept, each sub-project in multiple project should have a makefile to let the make programme knows how to compile this project.

To create a multiple project, you need to guarantee each project is a first level directory in root project. Copy the makefiles below into your project root directory:

* toolkit/makefile/gcc/gcc_entry_m.mk
* toolkit/makefile/gcc/gcc_config.mk
* toolkit/makefile/gcc/gcc_rule.mk

Then copy the toolkit/makefile/gcc/gcc_project.mk to each sub-project directory, and rename it with the same as the name of sub-project directory.

Setup the variable Batched_Prjs in gcc_entry_m.mk by filling the sub-project name. 

*Note*: the order of the value you set, will be the order of the project compiled.

***Download File:***

Here is a sample project to show you how to use multiple-gcc-project: [multi.project.7z](./downloads/multi.project.7z).

Setup the variable in the makefile in each sub-project follow the section "Setup values" below.

## Setup values

***Project***

The Project is the name of the project, it should be the same as the root directory name. 

***ProjectType***

The ProjectType is a variable to specific what kind of the project you generate. The option is lib, dll or exe. The value here doesn't relate with the suffix of the final file you generate, for example, you choose lib, in windows, it will compile the project and generate a static library named MyProject.lib, but in unix/linux it will be libMyProject.a.

***IncDirs***

The IncDirs is a variable contains one or more directory path you set. The value specific the path of files you include when you use #include in the code. It will search these paths if the file not found, compile error.

***FullPath_GchSrcs***

THe FullPath_GchSrcs sets the path of the full path of the header file we want to compile as gch ( aka. precomipled header file ).

***SrcDirs***

The SrcDirs specific the source directories, then the programme will search recursively and get those .c,.cpp file into the compile list.

***LibDirs***

The LibDirs includes the path of the third party libraries so that during link, those library can be found.

***PrjLibs***

The PrjLibs is the name of the library you want to link, but the library generate by you.  This option only work in multiple gcc project. 

***ExtLibs***

The ExtLibs is the name of the library you want to link, but the library belongs to third party.

***CFlag_Spec***

The CFlag_Spec is the value to let you set additional option flag in compiling.

***LFlag_Spec***

The LFlag_Spec is the value to let you set additional option flag in linking.

## Option of GMake command

The command `:GM[ake]` can follow options to achieve different task.

- `all`: compile the whole project
- `clean-all`: clean all generated files
- `clean-deps`: clean all dependence files
- `clean-errs`: clean all error logs
- `clean-gchs`: clean all gch files
- `clean-objs`: clean all object files
- `clean-target`: clean generate target
- `rebuild`: clean then compile the project again
- `rebuild-deps`: clean then generate the dependency files again
- `rebuild-gchs`: clean then generate the gch files again
- `rebuild-objs`: clean then generate the object files again
- `rebuild-target`: clean then generate the target again

You can apply sub-project name in the front of the options and separate with '/', to specific the command will only apply on a sub-project. for example if you want to rebuild sub_project_1, you can write:

{% highlight bash %}
:GMake sub_project_1/rebuild
{% endhighlight %}

## Create msvc project

Just copy the files in toolkit/makefile/msvc/vc_project to create your vs.net project.
