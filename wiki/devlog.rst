.. _devlog:

devlog
**************

How to merge
================

For developing, you need to  get exVim source directly into install vim path (d:/exDev/exVim) 
for example. To achieve this, just use 

.. code-block:: bash

    git clone --no-checkout git@github.com:jwu/exVim.git
    git checkout --track origin/dev

after several commits, you push the code to github by

.. code-block:: bash

    git push 

Then go to another directory like e:/Project/Dev, then clone a version for master as

.. code-block:: bash

    git clone --no-checkout git@github.com:jwu/exVim.git
    git checkout --track origin/master

Then run

.. code-block:: bash

    git pull
    git merge origin/dev

Another way is put tag in dev branch in the version you want start a merge in master, like

.. code-block:: bash

    git tag TO_MASTER_1

Then go to another repo, pull everything, then use chery-pick to get the changes

.. code-block:: bash

    git pull --all
    git chery-pick -x change_list

vim plugin version
====================

* default installed

  * `AlternateFiles - 2.18 <http://www.vim.org/scripts/script.php?script_id=31>`_
  * `AutoComplPop - 2.14.1 <http://www.vim.org/scripts/script.php?script_id=1879>`_
  * `cmdline-complete - 1.1.3 <http://www.vim.org/scripts/script.php?script_id=2222>`_
  * `echofunc - 1.19 <http://www.vim.org/scripts/script.php?script_id=1735>`_
  * `EnhancedCommentify - 2.3 <http://www.vim.org/scripts/script.php?script_id=23>`_
  * `CRefVim - 1.0.4 <http://www.vim.org/scripts/script.php?script_id=614>`_ 
  * `matchit - 1.13.2 <http://www.vim.org/scripts/script.php?script_id=39>`_
  * `MiniBufExpl - 6.3.2 <http://www.vim.org/scripts/script.php?script_id=159>`_
  * `NERD_tree - 4.1.0 <http://www.vim.org/scripts/script.php?script_id=1658>`_
  * `OmniCppComplete - 0.41 <http://www.vim.org/scripts/script.php?script_id=1520>`_
  * `OOP javascript indentation - 0.1 patch2 <http://www.vim.org/scripts/script.php?script_id=1936>`_
  * `lookupfile - 1.8 <http://www.vim.org/scripts/script.php?script_id=1581>`_

    * `genutils - 2.5 <http://www.vim.org/scripts/script.php?script_id=197>`_

  * `ShowMarks - 2.2 <http://www.vim.org/scripts/script.php?script_id=152>`_
  * `surround - 1.90 <http://www.vim.org/scripts/script.php?script_id=1697>`_
  * `TagList - 4.5 <http://www.vim.org/scripts/script.php?script_id=273>`_
  * `Visincr - 19 <http://www.vim.org/scripts/script.php?script_id=670>`_
  * `visual_studio - 1.2 <http://www.vim.org/scripts/script.php?script_id=864>`_
  * `pythoncomplete - 0.9 <http://www.vim.org/scripts/script.php?script_id=1542>`_
  * `DirDiff - 1.1.2 <http://www.vim.org/scripts/script.php?script_id=102>`_
  * `snipMate - 0.83 <http://www.vim.org/scripts/script.php?script_id=2540>`_
  * `zencoding - 0.43 <http://www.vim.org/scripts/script.php?script_id=2981>`_

* optional

  * `gui2term.py <http://www.vim.org/scripts/script.php?script_id=2778>`_ - script that converts GUI only colorschemes to support 256-color terminal 
  * `css-color-preview <http://www.vim.org/scripts/script.php?script_id=2150>`_
  * `django <http://www.vim.org/scripts/script.php?script_id=1487>`_
  * `vimwiki <http://www.vim.org/scripts/script.php?script_id=2226>`_
