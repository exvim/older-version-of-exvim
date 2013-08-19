---
layout: page
title: Overview
permalink: /docs/commands_and_mappings/
---

## Global Mappings

### General

- `<leader>y (visual mode)`: copy the selected text to register * (this mapping help copy text to the clipboard).
- `<leader>y1`: copy path name of current buffer (exp: /usr/foo/bar/foobar.txt => /usr/foo/bar/).
- `<leader>y2`: copy file name of current buffer (exp: /usr/foo/bar/foobar.txt => foobar.txt).
- `<leader>y3`: copy path name + file name of current buffer (exp: /usr/foo/bar/foobar.txt => /usr/foo/bar/foobar.txt).
- `<leader>p`: paste the text frome register * (this mapping help read and paste text from the clipboard ).
- `<leader>P`: same as <leader>p, but use “upper case p” paste behavior.
- `<leader>ve`: open and edit the .vimentry file of the project immediately.
- `<leader><TAB>`: switch crusor between last edit window.
- `<leader><ESC>`: close last opened ex-window when cursor in edit-window (this mapping help close ex-window without moving cursor in it).
- `<leader>bd, ctrl-<F4>`: close buffer. (this is standard close buffer operation in exVim, :q is forbidden in exVim).
- `<leader>ws`: Write segment template.
- `<leader>wd`: Write define template.
- `<leader>we`: Write separate template.
- `<leader>wc`: Write class template.
- `<leader>wh`: Write header template.
- `<leader>gv`: Process current word under cursor as class-name, show its inherit map by your image viewer.
- `<leader>mk (visual mode)`: Insert mark lable you entered between the block you select.
- `<leader>mk (normal mode)`: Remove special mark lable while your cursor in it.
- `<leader>sub (visual mode)`: substitue highlight word 1(alt-1) to highlight word 2(alt-2) in the visual block.
- `<leader>sub (normal mode)`: substitue highlight word 1(alt-1) to highlight word 2(alt-2) in the whole buffer.
- `alt-<F1>, <leader><F1> (terminal ver)`: <leader><F1> Switch to encoding latin1 (Default).
- `alt-<F2>, <leader><F2> (terminal ver)`: Switch to encoding cp936(Chinese).
- `alt-<F3>, <leader><F3> (terminal ver)`: Switch to encoding cp932(Japanese).
- `shift-<up>/<down>/<left>/<right>`: move cursor to up/down/left/right window (these mappings help quick jump between windows ).
- `ctrl-<up>/k, ctrl-<down>/j`: move cursor to next/prev diff (these mappings help quick jump and edit differences while in diff-mode ).
- `ctrl-<right>, ctrl-<left>`: move forward/backward buffers.
- `ctrl-<tab>`: switch between last edit buffer.
- `alt-1/2/3/4, <header>h1/2/3/4 (terminal ver)`: Hilight/UnHighlight words with highlight color 1,2,3,4 (can be used in visual mode).
- `alt-0, <leader>h0 (terminal ver)`: Cancle all 1,2,3,4 highlights
- `<F8>`: Cancle search highlight.
- `<F9> (visual mode)`: Insert/Remove macro-extended token \ at the end of the line while you are in visual mode (this mapping help you writting multi-line macros in c/cpp).
- `<F12>`: Insert/Remove macro pair #if 0 and #endif between text you select (you can insert pair in visual mode, remove the pair by moving the cursor in the pair and press F12 in normal mode).

### exProject

- `alt-shift-o`: Open exProject window and turn to search state (this mapping will open the exProject window with / (search) been put).
- `alt-shift-p`: Open exProject window, if exProject window is opened, it will only move cursor to the window.
- `<leader>ff`: Move cursor to exProject window, and use search file pattern to search file in exProject window.
- `<leader>fd`: Move cursor to exProject window, and use search directory/folder pattern to search directory/folder in exProject window.
- `<leader>fc`: Locate current edit file in exProject window if exists.

### exTagSelect

- `<leader>ts`: Toggle exTagSelect window
- `<leader>tg, <leader>]`: Search current word under cursor as tags(defines and declarations), show the result in exTagSelect window.

### exGlobalSearch

- `<leader>gs`: Toggle exGlobalSearch select window.
- `<leader>gq`: Toggle exGlobalSearch quickview window.
- `<leader>gg`: Global search current word under cursor, show the result in exGlobalSearch select window.
- `<leader>n, <leader>N`: Go to the next/prev result immediately while exGlobalSearch window is opened and the cursor is in edit-window.

### exSymbolTable

- `<leader>ss`: Toggle exSymbolTable select window.
- `alt-shift-l`: Open exSymbolTable select window and turn to search state (this mapping will open the exSymbolTable window with / (search) been put).
- `<leader>sq`: Toggle exSymbolTable quick-view window.
- `<leader>sg`: Search current word under cursor, filter and show the result in exSymbolTable quick-view window.

### exJumpStack

- `<leader>tt`: Toggle exJumpStack window.
- `<leader>tb, <backspace>`: Go to prev jump stack.
- `<leader>tf`: Go to next jump stack.
- `alt-<left>/<right>`: Go to prev/next jump stack.

### exCscope

- `<leader>cs`: Toggle exCscope select window.
- `<leader>cq`: Toggle exCscope quickview window.
- `<leader>ci`: Search current word under cursor as filename, list files #include it in exCscope select window.
- `<leader>cd`: Search current word under cursor as function name, find functions called by this function and list result in exCscope select window.
- `<leader>cc`: Search current word under cursor as function name, find functions calling this function and list result in exCscope select window.
- `<F2>`: Search and list files #include current file in exCscope select window.
- `<F3>`: Analysis current function the cursor in, show the analysis result in exCscope select window.

### exQuickFix

- `<leader>qf`: Toggle exQuickFix select window.
- `<leader>qq`: Toggle exQuickFix quickview window.

### exMacroHighlight

- `<leader>aa`: Toggle exMacroHighlight window.
- `<leader>ae`: Enable macro highlight.
- `<leader>ad`: Disable macro highlight.

### exBufExplorer

- `alt-shift-b`: Open exBufExplorer window and turn to search state (this mapping will open the exBufExplorer window with / (search) been put).
- `<leader>bs`: Toggle exBufExplorer window.
- `<leader>bk`: Bookmark current buffer into exBufExplorer window.

### exMarksBrowser

- `<leader>ms`: Toggle exMarksBrowser window.

### Other plugin mappings

- `<F4>`: Switch on/off TagList.
- `ctrl-j (insert mode)`: Use OmniCppComplete complete the code.
- `<F11>`: Comment a line or a visual block (can be used in visual mode).
- `ctrl-<F11>`: UnComment a line or a visual block (can be used in visual mode).
- `<leader>lf, alt-shift-i`: Search files in LookupFile plugin.
- `<leader>lb`: Search buffers in LookupFile plugin.
- `<leader>ll`: Search current word under cursor as filename in LookupFile plugin.

## ex-vim-plugin Mappings

### all ex-vim-plugin mappings

- `<esc>`: Close current ex-plugin window.
- `<space>`: Resize current ex-plugin window.
- `<enter>`: Confirm/Process/Jump to select result.

### exProject only mappings

- `<leader>C`: Build up the project file with dialog asking the working directory, file filter and dir filter you want.
- `<leader>R`: Refresh the project file using the working directory, file filter and dir filter you already setted.
- `<leader>cf`: Refresh the directory current cursor in with a file filter dialog.
- `<leader>r`: Refresh the directory current cursor in follow the global file filter rules.
- `o`: Add a new file in the folder current cursor in.
- `O`: Add a new folder in the folder current cursor in, the new folder will be created under current folder.
- `<leader>e`: Show path of the file under current cursor in command window.
- `ctrl-<left>/<right>`: Switch between exProject/NERD_Tree window.
- `ctrl-<up>/<down>`: Find and jump to the up/down nearst error file which name is ErrorLog.err.
- `ctrl-j/k`: Jump to the prev/next folder.

### exGlobal only mappings

- `<leader>r`: Pick up the matched pattern in {preview-section}, list them in quickview window. The matched pattern gives by / or # search result.
- `<leader>d`: Pick up the un-matched pattern in {preview-section}, list them in quickview window. The matched pattern gives by / or # search result.
- `<leader>fr`: Pick up the matched pattern in {file-section}, list them in quickview window. The matched pattern gives by / or # search result.
- `<leader>fd`: Pick up the un-matched pattern in {file-section}, list them in quickview window. The matched pattern gives by / or # search result.
- `<leader>gr`: Pick up the matched pattern in all sections, list them in quickview window. The matched pattern gives by / or # search result.
- `<leader>gd`: Pick up the un-matched pattern in all sections, list them in quickview window. The matched pattern gives by / or # search result.
- `<leader>sr`: Force sort the search results. can be used in visual mode.
- `ctrl-<left>/<right>`: Switch between quickview/select window.

### exSymbolTable only mappings

- `<leader>r`: Pick up symbols those have matched patterns, and list them in quickview window. The matched pattern gives by / or # search result.
- `<leader>d`: Pick up symbols those have unmatched patterns, and list them in quickview window. The matched pattern gives by / or # search result.

### exQuickFix only mappings

- `ctrl-<left>/<right>`: Switch between quickview/select window.
- `ctrl-<up>/<down>`: Jump to next/prev error in exQuickFix window.

### exBufExplorer only mappings

- `dd`: Close the selected buffer or delete selected bookmarks.

## Commands

- `:HL{1-4} [{pattern}]`: Highlight a {pattern} with 1/2/3/4 color. If the {pattern} is empty, it will remove the last highlight.
- `:Up[date] [{args}]`: Update exVim project files.
- `:GV {class-name}`: Draw the class hierarchy graphic by the name user gives and save the picture in .vimfiles\.hierarchies\SymbolName.png.
- `:GVP {class-name}`: Similar like :GV command, but draw only hierarchy of the parent classes for {class-name} you give.
- `:GVC {class-name}`: Similar like :GV command, but draw only hierarchy of the children classes for {class-name} you give.
- `:[range]SHL`: convert the highlight of the source code in visual block into html. If no range gvien, it will convert the whole file. The converted html file will saved in .vimfiles/_temp/_src_highlight.txt.html.
- `:[range]MK {args}`: Mark a visual block of code with the {args} you give.
- `:LINE`: The command will put a 86 words long line in the line current cursor in.
- `:[range]NS {args}`: Put a namespace pair between a visual block.
- `:NSS {args}:` Similar like :NS command, but put only namespace header.
- `:NSE {args}:` Similar like :NS command, but put only namespace tail.
- `:HEADER`: Put a header at the beginning of a file you edit.
- `:SEP`: Put a separator under the cursor line.
- `:NOTE`: Put a note under the cursor line.
- `:DEF`: Put a define under the cursor line.
- `:MAIN`: Put a simple main function under the cursor line.
- `:CLASS {class-name}, :STRUCT {struct-name}`: Put a simple class/struct under the cursor line.
- `:TS {tag-name}`: Search a tag by {tag-name}, list the possible results in select-window.
- `:GS {word}`: Search {word} in ID database, and list the matched results in exGlobalSearch select-window.
- `:GSW {word}`: Search the whole {word} in ID database, and list the matched results in exGlobalSearch select-window.
- `:GSF {file-name}`: Search {file-name} in ID database, and list the matched files in exGlobalSearch select-window.
- `:GSFW {file-name}`: Search the whole {file-name} in ID database, and list the matched files in exGlobalSearch select-window.
- `:SUB /{pattern}/{string}/[flags]`: It is similar like :s[ubstitute] command in vim, but it apply the sub to the search results listed in select/quickview window.
- `:SL {tag-name}`: locate first matched {tag-name} in exSymbolTable select-window.
- `:SS {tag-name}`: list matched {tag-name} in exSymbolTable quickview-window.
- `:QF {file-name}`: Load a quickfix list from a file, and shows the contents in the exQuickFix select-window.
