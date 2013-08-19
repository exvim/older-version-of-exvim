---
layout: page
title: Install
permalink: /docs/setup_vimentry/
---

## Create .vimentry file

exVim uses your_project.vimentry file access the project. The main purpose is let the exVim can open several different projects in the same time, and each project have its own settings.

When starting a new project, create a file with suffix `.vimentry` under the root directory, and open the file by vim. You may see your vim like this:

![exVim_windows.png](../images/exVim_windows.png)

The "Edit Window" shows the contents of vimentry file you create. These contents are automatically generate when first time you open a project.

You can modify the settings to fulfill your demands, when you edit the settings and save the file, exVim will aware the changes and update to the new one.

## Syntax

There are two types of variable you can define in vimentry file --- normal variable and list variable. The value of the variable always quoted by single quotes '.  The "=" will tells exVim the line contains a normal variable, otherwise "+=" will tells exVim it is a list variable.

**Normal Variable**

{% highlight bash %}
Variable1='this is a normal variable'
{% endhighlight %}

**List Variable**

{% highlight bash %}
List1+='item1'
List1+='item2'
List1+='item3'
{% endhighlight %}

When parsing vimentry file, exVim will create the variables with prefix **g:exES_**.  For example the **Variable1** above will be **g:exES_Variable1** in the vimscript.

<a name="update_vimentry_file"></a>
## Update vimentry file

When you create a .vimentry file, exVim will write a default template at the beginning, the settings usually break into several sections. The first one is auto-gen section, you probably see the section like this:

{% highlight bash %}
-- auto-gen settings (DO NOT MODIFY) --

CWD=D:/Project/Dev/exUtility/src/exLibs
Version=21
VimEntryName=exLibs
VimfilesDirName=.vimfiles.exLibs
{% endhighlight %}

The user are not allowed to change the value in this section. Everytime you open the vimentry file, the exVim will load the section, and check if it is consist with current settings.  it will force exVim rewrite and update the vimentry file if the settings are not the same.

The conditions to force the exVim update the vimentry are listed here:

1. The value of CWD different with the path vimentry file exists.
1. Version is different with exVim's internal version aka. (s:exES_CurrentVersion).
1. VimEntryName is different with the filename of vimentry. 
1. The vimentry file is empty.

When user edit the vimentry file, and save it by :w, exVim will detect and load the new settings.

## Builtin vimentry settings

Most variables in vimentry files are relate with file name or path. They are obviously known by the name. This section will only discuss some special variable.

**LangType**

- default: auto
- options: c,cpp,c#,shader,python,vim,math,uc,javascript,java,html,lua

The language type of the project will be set automatically by the file type filter (s:ex_project_file_filter in exProject). 
You can specific your own language type as:

{% highlight bash %}
LangType=lang1,lang2,lang3
{% endhighlight %}

The LangType will be used in quick_gen_project file, and will let the project update by specific language you define.

**vimentryRefs**

This is a list used to reference other vimentry files in current project. User then can access the tags, symbols and inherits of the reference vimentry.

To make it works, you need to add the absolute path of the referenced vimentry file.

**RestoreBuffer**

`default: false`

exVim can save all opened buffers when you exit, and restore them in your next time editing. By default, this function is turn off. Set the "RestoreBuffer=true" to turn it on.

Before restore buffers, exVim will ask if restore when "AskForRestoration" is true.

## .vimfiles

When you open the vimentry, exVim will do the things below in order:

1. Check if need to [Update vimentry file](#update_vimentry_file) in vimentry settings.
1. Parse settings, generate global variables in vimscript.
1. Create .vimfiles.${VimEntryName} folder ( **NOTE:** the ${VimEntryName} here is the name of your vimentry file ).
1. Create `id-lang-autogen.map` in .vimfiles.${VimEntryName}.
1. Create `quick_gen_project_${VimEntryName}_autogen.bat` [[1]](#footnotes).
1. Create `quick_gen_project_${VimEntryName}_pre_custom.bat` [[1]](#footnotes) and `quick_gen_project_${VimEntryName}_post_custom.bat` [[1]](#footnotes) in .vimfiles.${VimEntryName}.

The .vimfiles.${VimEntryName} folder includes all the files used exVim. The reason we create the name of the folder use the .${VimEntryName} behind .vimfiles is we can have different vimentry files under the same root directory, we have to distinguish them and apply right settings and files for each entry.

The `id-lang-autogen.map` used in id-utils -- our global search tool. The file describe the filetype filter used in id-utils, which come from the filter settings in exProject. The id-utils uses the id-lang map in exVim in this order:

1. Check if there have a file named `id-lang-custom.map` in `.vimfiles.${VimEntryName}`, if exists use it, and skip the following step.
1. Check if there have a file named `id-lang-autogen.map` in `.vimfiles.${VimEntryName}`, if exists use it, and skip the following step.
1. Check if there have a file named `id-lang.map` in ${VIM}/toolkit/idutils/, if not, report an error.

By this rule, you could customize your own id-lang.map.

The quick_gen_project_${VimEntryName}_autogen is the shell programme to invoke exVim update the project. You can run it outside exVim or use `:Up[date]` command.

You can not edit quick_gen_project_${VimEntryName}_autogen, it will be overwrite next time you use `:Up[date]` command. exVim provide 2 different way let your customize the script.

1. You can find `quick_gen_project_${VimEntryName}_pre_custom.bat` [[1]](#footnotes) and `quick_gen_project_${VimEntryName}_post_custom.bat` [[1]](#footnotes) in .vimfiles.${VimEntryName}, When you run the quick_gen_project_${VimEntryName}_autogen script, it will run the xxx_pre_custom, then the main shell script, finally the xxx_post_custom. You can edit put your custom script in these two files.
1. If you want to change the whole `_autogen.bat` [[1]](#footnotes),  you could put a shell programme named `quick_gen_project_${VimEntryName}_custom` in the same path, the `:Up[date]` command will skip the execute `_autogen` script if there exists a `_custom` one.

## Edit vimentry file in exVim

The `<leader>ve` commands provides you a faster way to edit vimentry file in exVim. If you don't find the command in your `.vimrc`, write the script:

{% highlight vim %}
nnoremap <unique> <leader>ve :call exUtility#EditVimEntry ()<CR>
{% endhighlight %}

## Add new language support

### Add new exvim language maps===

The default languages support by exVim shows in the table below:

- `asm`: asm, ASM
- `awk`: awk, gawk, mawk
- `batch`: bat
- `c`: c, C
- `cpp`: c++, cc, cp, cpp, cxx, h, H, h++, hh, hp, hpp, hxx, inl, ipp
- `c#`: cs
- `doxygen`: dox, doxygen
- `debug`: log, err, exe
- `html`: htm, html
- `ini`: ini, cfg
- `java`: java
- `javascript`: js
- `lua`: lua
- `make`: mak, mk, Makefile, makefile
- `math`: m
- `python`: py, pyw, pyx, pxd
- `ruby`: rb, ruby
- `sh`: sh, SH, bsh, bash, ksh, zsh
- `shader`: hlsl, vsh, psh, fx, fxh, cg, shd, glsl
- `uc`: uc
- `vim`: vim
- `wiki`: wiki
- `xml`: xml

The table will affect the exProject file filter and `quick_gen_project` script in exVim.  When you set the LangType 'auto' in vimentry, exVim will get the "Language Type" through the "File Type" provided by exProject file filter. When the LangType is set to any of the Language Type above (e.g. `LangType=c,cpp,python`), exVim will look up the "File Type" apply them to the exProject file filter and `quick_gen_project` script.

You can use the function below add new language type:

{% highlight vim %}
function exUtility#AddLangMap( langmap_type, lang_type, file_type_list )
{% endhighlight %}

1. "langmap_type" controlls the maps you operated. The value could be "exvim" and "ctags", I'll explain the 'ctags' later, here we choose 'exvim'
1. "lang_type" is the language type you want to add your file type list in. If the "lang_type" is not in the default language maps, it will create a new one.
1. "file_type_list" is a list carries the file types you want to add. If the file type already exists, the function will skip it.

Here is an example to add filetype 'as' into language 'javascript' 

{% highlight vim %}
call exUtility#AddLangMap ( 'exvim', 'javascript', ['as'] )
{% endhighlight %}

You can use the function reset specific language mapping:

{% highlight vim %}
function exUtility#ResetLangMap( langmap_type, lang_type, file_type_list )
{% endhighlight %}

The function will erase any exists mappings and apply the new.

### Add new ctags language maps

ctags use its own language mappings in exVim:

- `asm`: asm, ASM, s, S, A51
- `asp`: asp, asa
- `awk`: awk, gawk, mawk
- `basic`: bas, bi, bb, pb
- `beta`: bet
- `c`: c
- `cpp`: c++, cc, cp, cpp, cxx, h, h++, hh, hp, hpp, hxx
- `c#`: cs
- `cobol`: cbl, cob, CBL, COB
- `eiffel`: e
- `erlang`: erl, ERL, hrl, HRL
- `fortran`: fo, ft, f7, f9, f95
- `html`: htm, html
- `java`: java
- `javascript`: js
- `lisp`: cl, clisp, el, l, lisp, lsp, ml
- `lua`: lua
- `make`: mak, mk, Makefile, makefile
- `pascal`: p, pas
- `perl`: pl, pm, plx, perl
- `php`: php, php3, phtml
- `python`: py, pyx, pxd, scons
- `rexx`: cmd, rexx, rx
- `ruby`: rb, ruby
- `scheme`: SCM, SM, sch, scheme, scm, sm
- `sh`: sh, SH, bsh, bash, ksh, zsh
- `slang`: sl
- `sml`: sml, sig
- `sql`: sql
- `tcl`: tcl, tk, wish, itcl
- `vera`: vr, vri, vrh
- `verilog`: v
- `vim`: vim
- `yacc`: y

In exVim, since we generate the ctags options automatically, the user need to specific their new language mappings manually by use: 

{% highlight vim %}
function exUtility#AddLangMap( langmap_type, lang_type, file_type_list )
{% endhighlight %}

With the first parameter langmap_type equals to 'ctags'. exVim will compare two maps, and decide how to write the options in quick_gen_project script.

For example, you can let ctags parse *.ms files in the syntax of maxscript in the script:

{% highlight vim %}
call exUtility#AddLangMap ( 'ctags', 'maxscript', ['ms'] )
{% endhighlight %}

### Add new cscope file type

The cscope is mainly used in c pgrogramme, people sometimes use it in cpp or asm programme. You need add new language type in list `g:ex_cscope_langs` to make it support in cscope. 

{% highlight vim %}
let g:ex_cscope_langs = ['c', 'cpp', 'shader', 'asm' ] 
{% endhighlight %}

<a name="footnotes"></a>
## Footnotes

1. in unix/linux, it is .sh

