" tselectbuffer.vim -- A simplicistic buffer selector/switcher
" @Author:      Thomas Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-04-15.
" @Last Change: 2007-09-11.
" @Revision:    0.4.303
" GetLatestVimScripts: 1866 1 tselectbuffer.vim

if &cp || exists("loaded_tselectbuffer")
    finish
endif
if !exists('loaded_tlib') || loaded_tlib < 12
    echoerr 'tlib >= 0.12 is required'
    finish
endif
let loaded_tselectbuffer = 4

function! s:SNR()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSNR$')
endf

if !exists('g:tselectbuffer_autopick') | let g:tselectbuffer_autopick = 1 | endif
if !exists('g:tselectbuffer_handlers')
    let g:tselectbuffer_handlers = [
                \ {'key':  4, 'agent': s:SNR().'AgentDeleteBuffer', 'key_name': '<c-d>', 'help': 'Delete buffer(s)'},
                \ {'key': 21, 'agent': s:SNR().'AgentRenameBuffer', 'key_name': '<c-u>', 'help': 'Rename buffer(s)'},
                \ {'key': 19, 'agent': s:SNR().'AgentSplitBuffer',  'key_name': '<c-s>', 'help': 'Show in split buffer'},
                \ {'key': 20, 'agent': s:SNR().'AgentTabBuffer',    'key_name': '<c-t>', 'help': 'Show in tab'},
                \ {'key': 22, 'agent': s:SNR().'AgentVSplitBuffer', 'key_name': '<c-v>', 'help': 'Show in vsplit buffer'},
                \ {'key': 23, 'agent': s:SNR().'AgentOpenBuffer',   'key_name': '<c-w>', 'help': 'View in window'},
                \ {'key': 60, 'agent': s:SNR().'AgentJumpBuffer',   'key_name': '<',     'help': 'Jump to opened window/tab à la swb=opentab'},
                \ {'return_agent': s:SNR() .'Callback'},
                \ ]
    if !g:tselectbuffer_autopick
        call add(g:tselectbuffer_handlers, {'pick_last_item': 0})
    endif
endif

function! s:PrepareSelectBuffer()
    let [s:selectbuffer_nr, s:selectbuffer_list] = tlib#buffer#GetList(s:selectbuffer_hidden, 1)
    let s:selectbuffer_alternate = ''
    let s:selectbuffer_alternate_n = 0
    for b in s:selectbuffer_list
        let s:selectbuffer_alternate_n -= 1
        if b[1] == '#'
            let s:selectbuffer_alternate = b
            let s:selectbuffer_alternate_n = -s:selectbuffer_alternate_n
            break
        endif
    endfor
    if s:selectbuffer_alternate_n < 0
        let s:selectbuffer_alternate_n = 0
    endif
    return s:selectbuffer_list
endf

function! s:GetBufNr(buffer)
    " TLogVAR a:buffer
    let bi = index(s:selectbuffer_list, a:buffer)
    " TLogVAR bi
    let bx = s:selectbuffer_nr[bi]
    " TLogVAR bx
    return 0 + bx
endf

function! s:RenameThisBuffer(buffer)
    let bx = s:GetBufNr(a:buffer)
    let on = bufname(bx)
    let nn = input('Rename buffer: ', on)
    if !empty(nn) && nn != on
        exec 'buffer '. bx
        if filereadable(on) && &buftype !~ '\<nofile\>'
            " if filewritable(nn)
                call rename(on, nn)
                echom 'Rename file: '. on .' -> '. nn
            " else
            "     echoerr 'File cannot be renamed: '. nn
            " endif
        endif
        exec 'file! '. escape(nn, ' %#')
        echom 'Rename buffer: '. on .' -> '. nn
        return 1
    endif
    return 0
endf

function! s:AgentRenameBuffer(world, selected)
    call a:world.CloseScratch()
    for buffer in a:selected
        call s:RenameThisBuffer(buffer)
    endfor
    let a:world.state = 'reset'
    let a:world.base  = s:PrepareSelectBuffer()
    " let a:world.index_table = s:selectbuffer_nr
    return a:world
endf

function! s:DeleteThisBuffer(buffer)
    let bx = s:GetBufNr(a:buffer)
    let doit = input('Delete buffer "'. bufname(bx) .'"? (y/N) ', s:delete_this_buffer_default)
    echo
    if doit ==? 'y'
        if doit ==# 'Y'
            let s:delete_this_buffer_default = 'y'
        endif
        if bufloaded(bx)
            exec 'bdelete '. bx
            echom 'Delete buffer '. bx .': '. a:buffer
        else
            exec 'bwipeout '. bx
            echom 'Wipe out buffer '. bx .': '. a:buffer
        end
        return 1
    endif
    return 0
endf

function! s:AgentDeleteBuffer(world, selected)
    call a:world.CloseScratch(0)
    let s:delete_this_buffer_default = ''
    for buffer in a:selected
        " TLogVAR buffer
        call s:DeleteThisBuffer(buffer)
    endfor
    let a:world.state = 'reset'
    let a:world.base  = s:PrepareSelectBuffer()
    " let a:world.index_table = s:selectbuffer_nr
    return a:world
endf

function! s:GetBufferNumbers(selected) "{{{3
    return map(copy(a:selected), 's:GetBufNr(v:val)')
endf

function! s:AgentSplitBuffer(world, selected)
    return tlib#agent#EditFileInSplit(a:world, s:GetBufferNumbers(a:selected))
endf

function! s:AgentVSplitBuffer(world, selected)
    return tlib#agent#EditFileInVSplit(a:world, s:GetBufferNumbers(a:selected))
endf

function! s:AgentOpenBuffer(world, selected)
    return tlib#agent#ViewFile(a:world, s:GetBufferNumbers(a:selected))
endf

function! s:AgentTabBuffer(world, selected)
    return tlib#agent#EditFileInTab(a:world, s:GetBufferNumbers(a:selected))
endf

function! s:AgentJumpBuffer(world, selected) "{{{3
    let bn = s:GetBufNr(a:selected[0])
    " TLogVAR bn
    let tw = tlib#tab#TabWinNr(bn)
    " TLogVAR tw
    if !empty(tw)
        call a:world.CloseScratch()
        " let w = tlib#agent#Suspend(a:world, a:selected)
        " if w.state =~ '\<suspend\>'
            " call w.SwitchWindow('win')
            let [tn, wn] = tw
            call tlib#tab#Set(tn)
            call tlib#win#Set(wn)
            " return w
        " endif
    else
        let a:world.status = 'redisplay'
    endif
    return a:world
endf

function! s:SwitchToBuffer(world, buffer, ...)
    TVarArg ['cmd', 'buffer']
    let bi = s:GetBufNr(a:buffer)
    " TLogVAR a:buffer
    " TLogVAR bi
    if bi > 0
        let back = a:world.SwitchWindow('win')
        " TLogDBG cmd .' '. bi
        exec cmd .' '. bi
        " exec back
    endif
endf


function! s:Callback(world, selected) "{{{3
    let cmd = len(a:selected) > 1 ? 'sbuffer' : 'buffer'
    for b in a:selected
        " TLogVAR b
        call s:SwitchToBuffer(a:world, b, cmd)
    endfor
endf


function! TSelectBuffer(show_hidden)
    let s:selectbuffer_hidden = a:show_hidden
    let bs  = s:PrepareSelectBuffer()
    let bhs = copy(g:tselectbuffer_handlers)
    " call add(bhs, {'index_table': s:selectbuffer_nr})
    if !empty(s:selectbuffer_alternate_n)
        call add(bhs, {'initial_index': s:selectbuffer_alternate_n})
    endif
    let b = tlib#input#List('m', 'Select buffer', bs, bhs)
endf
command! -count=0 -bang TSelectBuffer call TSelectBuffer(!empty("<bang>") || v:count)


finish

This plugin provides a simple buffer selector. It doesn't have all the 
features other buffer selectors have but can be useful for quickly 
switching to a different buffer or for deleting buffers.

The idea is to view the buffer list, to do something, and to close the 
buffer list. If you really want to permanently watch the buffer list to 
see whether it's changed, you might want to use a different plugin.

Features:
    - list buffers, dynamically filter buffers matching a pattern
    - switch to a buffer
    - rename a buffer (you may need to use :saveas! or :w! when writing 
    the renamed buffer to disk)
    - delete one or more buffer(s)

:[N]TSelectBuffer[!]
    List buffers. With a count or a !, show also hidden buffers.
    Keys:
    <cr>  ... Select (close the buffer list)
    <c-s> ... Open in split window
    <c-v> ... Open in vertically split window
    <c-t> ... Open in new tab
    <c-w> ... Show in original window (continue with the buffer list)
    <c-d> ... Delete a buffer
    <c-u> ... Rename a buffer
    <     ... Jump to opened buffer in window/tab

Suggested keymaps (put something like this into ~/.vimrc):
    noremap <m-b> :TSelectBuffer<cr>
    inoremap <m-b> <c-o>:TSelectBuffer<cr>


CHANGES:
0.1
Initial release

0.2
- Minor improvements

0.3
- <c-u>: Rename buffer (and file on disk)
- <c-v>: Show buffers in vertically split windows
- Require tlib 0.9
- "Delete buffer" will wipe-out unloaded buffers.

0.4
- <c-w> ... View file in original window
- < ... Jump to already opened window, preferably on the current tab 
page (if any)
- Enabled <c-t> to open buffer in tab
- Require tlib 0.13
- Initially select the alternate buffer
- Make a count act as bang.
- Can be "suspended" (i.e. you can switch back to the orignal window)

