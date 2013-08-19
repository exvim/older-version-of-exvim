---
layout: page
title: Install
permalink: /docs/install/
---

## Choose Your Install Method

exVim provide several install method for different vim user.

**exVim Installer**: 

The exVim installer is a windows install rountine contains original vim, ex-vim-plugins 3rd-party-vim-plugins and 3rd-party-external-tools. The installer will automatically configure the environment variable in windows. If you are new in vim, or if you don't like to do too much configuration for exVim, download and install this pacakge.

**Full Package**: 

The full-package contains ex-vim-plugins and 3rd-party-vim-plugins used in exVim. You can use this packages install exVim manually into your original vim. You have to download and install 3rd-party-external-tools used by exVim manually. This package is prepared for advanced vim user.

**exVim Plugins Package**: 

The ex-vim-plugins packages only contains plugins I wrote for exVim. Those user who would like to partially integrate exVim can use this package.

**3rd Party Vim Plugins Package**: 

The 3rd-party-vim-plugins pacakge contains all patched version of 3rd-party vim plugins used in exVim. The vim plugins have sometimes compatible problem when use together, it is necessary to do some modification, and this packages contains those modified version of those plugins. When you integrate exVim, you probably want to compare the difference of those plugins you already install, and make a decision for those modifications by yourself.

## Which one should I choose?

For new comer of vim, lazy vim user and those who want to have a try exVim, I recommend choose exVim Installer.

For user who already uses vim, and have their own custom .vimrc and plugins, I recommend choose full-packages or ex-vim-plugins packages + 3rd-party-vim-plugins packages, and follow the manually install instruction below to integrate it.

## Install exVim in Windows

**Note:** you can skip this section if you choose exVim installer.

**1. install/compile vim**

Please go to the [Vim download page](http://www.vim.org/download.php) download Vim first.

Some user probably like to compile vim by himself. I recommend compile the vim with +python. Since a great 3rd-party vim plugin -- visual-studio.vim use it! 

Here is my compile options:

{% highlight bash %}
nmake -f Make_mvc.mak GUI=yes PYTHON=d:\exDev\tools\Python25 DYNAMIC_PYTHON=YES PYTHON_VER=25
{% endhighlight %}

**2. install vim-plugins**

extract the full-package to your vim directory. 

**3. install external tools**

There are several external tools exVim used. 

**Tools must have**

* [cTags](http://ctags.sourceforge.net)
* Gnu Win32
  * [gawk](http://gnuwin32.sourceforge.net/packages/gawk.htm)
  * [id-utils](http://gnuwin32.sourceforge.net/packages/id-utils.htm)
    * [libiconv](http://gnuwin32.sourceforge.net/packages/libiconv.htm)
    * [libintl](http://gnuwin32.sourceforge.net/packages/libintl.htm)
  * [sed](http://gnuwin32.sourceforge.net/packages/sed.htm)
    * [regex](http://gnuwin32.sourceforge.net/packages/regex.htm) 

**Optional tools**

if you want to use [visual-studio.vim](http://www.vim.org/scripts/script.php?script_id=864) help you work with visual studio, you need to install python and pywin32:

* [python](http://www.python.org)
* [pywin32](http://sourceforge.net/projects/pywin32)

if you want to use makefiles provided in toolkit/makefile/gcc to compile cpp projects, you need to install MinGW and make.

* [MinGW](http://www.mingw.org)
* [make](http://gnuwin32.sourceforge.net/packages/make.htm)

if you want to use exCscope plugin which helping you work with cscope, you need to install cscope:

* [cscope](http://cscope.sourceforge.net)

if you want to use :GV command drawing class hierarchies for OO language project, you need to install graphviz:

* [graphviz](http://www.graphviz.org)

if you want to use the exVim command :SHL to generate source code with highlights in html format, you need to install src-highlite:

* [src-highlite](http://gnuwin32.sourceforge.net/packages/src-highlite.htm)

**4. Setup Environment Variables**

Create an environment variable named EX_DEV in "System Properties" -> "Advanced" -> "Environment Variables" The value must be the **parent** driectory you install vim. For example, if you install vim in "d:\exDev\vim", the value is 

{% highlight bash %}
EX_DEV = d:\exDev
{% endhighlight %}

Also you need to add the path of external tools you installed into environment variables Here is what I set:

{% highlight bash %}
EX_DEV = d:\exDev
PATH += %EX_DEV%\exVim\vim72
PATH += %EX_DEV%\tools\MinGW\bin
PATH += %EX_DEV%\tools\GnuWin32\bin
PATH += %EX_DEV%\tools\Graphviz\bin
{% endhighlight %}

**5. Setup .vimrc**

The last step of installation is setup your .vimrc file. Check the [Setup .vimrc](#setup_vimrc) section below for detail.

## Install exVim in Linux/Mac

**1. install/compile vim**

You can get a vim by apt-get in linux. If you want to have python, cscope integrate in vim, you would probably like me, compile vim by yourself.

Before you compile vim in linux/unix, you need to install several develop libraries. I choose gtk-2.0 as my gui library for vim, and here is my install commands

{% highlight bash %}
sudo apt-get install ncurses-dev
sudo apt-get install libqt4-dev
sudo apt-get install libgtk2.0-dev
{% endhighlight %}

Once you done, you need to config Makefile of vim. Here is my configuration:

{% highlight bash %}
CONF_OPT_PYTHON = --enable-pythoninterp
CONF_OPT_CSCOPE = --enable-cscope
CONF_OPT_GUI = --enable-gui=gtk
CONF_OPT_GUI = --enable-gui=gtk2
{% endhighlight %}

Then compile the vim:

{% highlight vim %}
sudo make distclean
sudo make config
sudo make
sudo make install
{% endhighlight %}

For Mac user, there is greate project [MacVim](http://code.google.com/p/macvim) which contains a runnable version of vim in Mac-OS. 

**2. install exVim packages**

After you install vim, extract your chosen package, copy and rename the folders as:

{% highlight bash %}
cp -R toolkit ~/.toolkit
cp -R vimfiles ~/.vim
{% endhighlight %}

**3. install external tools**

**tools you must have**

{% highlight bash %}
sudo apt-get install exuberant-ctags
sudo apt-get install id-utils
sudo apt-get install gawk
sudo apt-get install sed
sudo apt-get install findutils
{% endhighlight %}

**optional tools**

{% highlight bash %}
sudo apt-get install cscope
sudo apt-get install graphviz
sudo apt-get install src-highlite
sudo apt-get install python
{% endhighlight %}

**4. Setup toolkit path**

By default, exVim install the toolkit folder in the path $EX_DEV/exVim/toolkit. But you can specific the path. set ex_toolkit_path variable in .vimrc to the path you want:

{% highlight vim %}
let g:ex_toolkit_path = '~/.toolkit'
{% endhighlight %}

**5. Setup .vimrc**

The last step of installation is setup your .vimrc file. Check the [Setup .vimrc](#setup_vimrc) section below for detail.

**6. Setup gvimrc in MacVim**

If you are installing exVim in Mac, you also need to setup gvimrc file in MacVim. Go to **/Applications/MacVim.app/Contents/Resources/vim**, edit file gvimrc, **comment out** the script below:

{% highlight vim %}
  no   <M-Left>       <C-Left>
  no!  <M-Left>       <C-Left>

  no   <M-Right>      <C-Right>
  no!  <M-Right>      <C-Right>
{% endhighlight %}

These mappings are conflict with exJumpStack.

<a name="setup_vimrc"></a>

## Setup .vimrc

**1. set from .vimrc_ex**

You have two way to setup your .vimrc:

* source the .vimrc_ex directly.
* merge the .vimrc_ex to your .vimrc.

By sourcing the .vimrc_ex, you can write code below at the end of you .vimrc:

{% highlight vim %}
source $VIM\.vimrc_ex
{% endhighlight %}

By merging, here is my suggestions. Go to the section mark:

{% highlight vim %}
"/////////////////////////////////////////////////////////////////////////////
" Plugin Configurations
"/////////////////////////////////////////////////////////////////////////////
{% endhighlight %}

Check the script below it. The settings of each plugin are separate by the mark:

{% highlight vim %}
" ------------------------------------------------------------------ 
" Desc: plugin-name
" ------------------------------------------------------------------ 
{% endhighlight %}

You could copy all of them to your .vimrc.

**2. must have .vimrc settings**

exVim provides lots of variable for customization. For more details, check Details Of ex-vim-plugins. But there are settings you must have before using exVim.

The setting below let tags jump relate to current directory, since we will put tags in .vimfiles_your_project, it is important to have it for every buffer we used:

{% highlight vim %}
au BufNewFile,BufEnter * set cpoptions+=d
{% endhighlight %}

To avoid buffer close problem, you need to have:

{% highlight vim %}
nnoremap <unique> <Leader>bd :call exUtility#Kwbd(1)<CR>
{% endhighlight %}

And keep in mind never use :q close a edit-buffer, instead use <leader>bd. Actually this is a problem discussed in vim tips wiki -- [tip 165](http://takewii.com/index.php?hl=f5&q=uggc%3A%2F%2Fivz.jvxvn.pbz%2Fjvxv%2FQryrgvat_n_ohssre_jvgubhg_pybfvat_gur_jvaqbj) For more details, [Known Issues](../KnownIssues)

## Partially install exVim

You can pick up the ex-vim-plugins you want, and partially install them. Though this is not recommended, you can check chapter [Misc](../misc) for details.
