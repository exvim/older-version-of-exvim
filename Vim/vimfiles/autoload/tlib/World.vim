" World.vim -- The World prototype for tlib#input#List()
" @Author:      Thomas Link (micathom AT gmail com?subject=[vim])
" @Website:     http://members.a1.net/t.link/
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-05-01.
" @Last Change: 2007-09-29.
" @Revision:    0.1.320

" :filedoc:
" A prototype used by |tlib#input#List|.
" Inherits from |tlib#Object#New|.


if &cp || exists("loaded_tlib_world_autoload")
    finish
endif
let loaded_tlib_world_autoload = 1


let s:prototype = tlib#Object#New({
            \ '_class': 'World',
            \ 'name': 'world',
            \ 'allow_suspend': 1,
            \ 'base': [], 
            \ 'bufnr': -1,
            \ 'display_format': '',
            \ 'filter': [['']],
            \ 'filter_format': '',
            \ 'index_table': [],
            \ 'initial_filter': [['']],
            \ 'initial_index': 1,
            \ 'initialized': 0,
            \ 'key_handlers': [],
            \ 'list': [], 
            \ 'numeric_chars': tlib#var#Get('tlib_numeric_chars', 'bg'),
            \ 'offset': 1,
            \ 'offset_horizontal': 0,
            \ 'pick_last_item': tlib#var#Get('tlib_pick_last_item', 'bg'),
            \ 'post_handlers': [],
            \ 'query': '',
            \ 'resize': 0,
            \ 'resize_vertical': 0,
            \ 'retrieve_eval': '',
            \ 'return_agent': '',
            \ 'rv': '',
            \ 'scratch': '__InputList__',
            \ 'scratch_filetype': 'tlibInputList',
            \ 'scratch_vertical': 0,
            \ 'sel_idx': [],
            \ 'show_empty': 0,
            \ 'state': 'display', 
            \ 'state_handlers': [],
            \ 'timeout': 0,
            \ 'type': '', 
            \ 'win_wnr': -1,
            \ })
            " \ 'handlers': [],

function! tlib#World#New(...)
    let object = s:prototype.New(a:0 >= 1 ? a:1 : {})
    return object
endf


function! s:prototype.Set_display_format(value) dict "{{{3
    if a:value == 'filename'
        let self.display_format = 's:FormatFilename(world, %s)'
        let self.tlib_UseInputListScratch = 
                    \ 'syn match TLibMarker /\%>'. (2 + eval(g:tlib_inputlist_width_filename)) .'c |.\{-}| / | hi def link TLibMarker Special'
        let self.tlib_UseInputListScratch .= '| syn match TLibDir /\%>'. (4 + eval(g:tlib_inputlist_width_filename)) .'c\S\{-}[\/].*$/ | hi def link TLibDir Directory'
    else
        let self.display_format = a:value
    endif
endf


function! s:prototype.GetSelectedItems(current) dict "{{{3
    if stridx(self.type, 'i') != -1
        let rv = copy(self.sel_idx)
    else
        let rv = map(copy(self.sel_idx), 'self.GetBaseItem(v:val)')
    endif
    if a:current != ''
        let ci = index(rv, a:current)
        if ci != -1
            call remove(rv, ci)
        endif
        call insert(rv, a:current)
    endif
    if stridx(self.type, 'i') != -1
        if !empty(self.index_table)
            " TLogVAR rv, self.index_table
            call map(rv, 'self.index_table[v:val - 1]')
            " TLogVAR rv
        endif
    endif
    return rv
endf


function! s:prototype.SelectItem(mode, index) dict "{{{3
    let bi = self.GetBaseIdx(a:index)
    " if self.RespondTo('MaySelectItem')
    "     if !self.MaySelectItem(bi)
    "         return 0
    "     endif
    " endif
    " TLogVAR bi
    let si = index(self.sel_idx, bi)
    " TLogVAR self.sel_idx
    " TLogVAR si
    if si == -1
        call add(self.sel_idx, bi)
    elseif a:mode == 'toggle'
        call remove(self.sel_idx, si)
    endif
    return 1
endf


function! s:prototype.FormatArgs(format_string, arg) dict "{{{3
    let nargs = len(substitute(a:format_string, '%%\|[^%]', '', 'g'))
    return [a:format_string] + repeat([string(a:arg)], nargs)
endf


function! s:prototype.GetRx(filter) dict "{{{3
    return '\('. join(filter(copy(a:filter), 'v:val[0] != "!"'), '\|') .'\)' 
endf


function! s:prototype.GetRx0(...) dict "{{{3
    exec tlib#arg#Let(['negative'])
    let rx0 = []
    for filter in self.filter
        " TLogVAR filter
        let rx = join(reverse(filter(copy(filter), '!empty(v:val)')), '\|')
        " TLogVAR rx
        if !empty(rx) && (negative ? rx[0] == g:tlib_inputlist_not : rx[0] != g:tlib_inputlist_not)
            call add(rx0, rx)
        endif
    endfor
    let rx0s = join(rx0, '\|')
    if empty(rx0s)
        return ''
    else
        return '\V\('. rx0s .'\)'
    endif
endf


function! s:prototype.GetItem(idx) dict "{{{3
    return self.list[a:idx - 1]
endf


function! s:prototype.GetListIdx(baseidx) dict "{{{3
    " if empty(self.index_table)
        let baseidx = a:baseidx
    " else
    "     let baseidx = 0 + self.index_table[a:baseidx - 1]
    "     " TLogVAR a:baseidx, baseidx, self.index_table 
    " endif
    let rv = index(self.table, baseidx)
    " TLogVAR rv, self.table
    return rv
endf


function! s:prototype.GetBaseIdx(idx) dict "{{{3
    " TLogVAR a:idx, self.table, self.index_table
    if !empty(self.table) && a:idx > 0 && a:idx <= len(self.table)
        return self.table[a:idx - 1]
    else
        return ''
    endif
endf


function! s:prototype.GetBaseItem(idx) dict "{{{3
    return self.base[a:idx - 1]
endf


function! s:prototype.SetBaseItem(idx, item) dict "{{{3
    let self.base[a:idx - 1] = a:item
endf


function! s:prototype.GetCurrentItem() dict "{{{3
    let idx = self.prefidx
    if stridx(self.type, 'i') != -1
        return idx
    elseif !empty(self.list)
        if len(self.list) >= idx
            return self.list[idx - 1]
        endif
    else
        return ''
    endif
endf


function! s:prototype.Match(text, ...) dict "{{{3
    let mrx = '\V'. (a:0 >= 1 && a:1 ? '\C' : '')
    for filter in self.filter
        " TLogVAR filter
        let rx = join(reverse(filter(copy(filter), '!empty(v:val)')), '\|')
        " TLogVAR rx
        if rx[0] == g:tlib_inputlist_not
            if len(rx) > 1 && a:text =~ mrx .'\('. rx[1:-1] .'\)'
                return 0
            endif
        elseif a:text !~ mrx .'\('. rx .'\)'
            return 0
        endif
        " if a:text !~ mrx. self.GetRx(filter)
        "     return 0
        " endif
    endfor
    return 1
endf


function! s:prototype.MatchBaseIdx(filter_format, idx, ...) dict "{{{3
    let mrx  = '\V'. (a:0 >= 1 && a:1 ? '\C' : '')
    let text = self.GetBaseItem(a:idx)
    if !empty(a:filter_format)
        let text = eval(call(function("printf"), self.FormatArgs(a:filter_format, text)))
    endif
    return self.Match(text, mrx)
endf


function! s:prototype.ReduceFilter() dict "{{{3
    " TLogVAR self.filter
    if self.filter[0] == [''] && len(self.filter) > 1
        call remove(self.filter, 0)
    elseif empty(self.filter[0][0]) && len(self.filter[0]) > 1
        call remove(self.filter[0], 0)
    else
        let self.filter[0][0] = self.filter[0][0][0:-2]
    endif
endf


function! s:prototype.PopFilter() dict "{{{3
    " TLogVAR self.filter
    if len(self.filter[0]) > 1
        call remove(self.filter[0], 0)
    elseif len(self.filter) > 1
        call remove(self.filter, 0)
    else
        let self.filter[0] = ['']
    endif
endf


function! s:prototype.FilterIsEmpty() dict "{{{3
    " TLogVAR self.filter
    return self.filter == copy(self.initial_filter)
endf


function! s:prototype.DisplayFilter() dict "{{{3
    " TLogVAR self.filter
    let filter1 = map(deepcopy(self.filter), '"(". join(reverse(v:val), " OR ") .")"')
    " TLogVAR filter1
    return join(reverse(filter1), ' AND ')
endf


function! s:prototype.UseScratch() dict "{{{3
    return tlib#scratch#UseScratch(self)
endf


function! s:prototype.CloseScratch(...) dict "{{{3
    TVarArg ['reset_scratch', 0]
    " TVarArg ['reset_scratch', 1]
    " TLogVAR reset_scratch
    return tlib#scratch#CloseScratch(self, reset_scratch)
endf


function! s:prototype.UseInputListScratch() dict "{{{3
    let scratch = self.UseScratch()
    " TLogVAR scratch
    syntax match InputlListIndex /^\d\+:/
    syntax match InputlListCursor /^\d\+\* .*$/ contains=InputlListIndex
    syntax match InputlListSelected /^\d\+# .*$/ contains=InputlListIndex
    hi def link InputlListIndex Constant
    hi def link InputlListCursor Search
    hi def link InputlListSelected IncSearch
    " exec "au BufEnter <buffer> call tlib#input#Resume(". string(self.name) .")"
    setlocal nowrap
    " hi def link InputlListIndex Special
    " let b:tlibDisplayListMarks = {}
    let b:tlibDisplayListMarks = []
    call tlib#hook#Run('tlib_UseInputListScratch', self)
    return scratch
endf


" :def: function! s:prototype.Reset(?initial=0)
function! s:prototype.Reset(...) dict "{{{3
    TVarArg ['initial', 0]
    " TLogVAR initial
    let self.state     = 'display'
    let self.offset    = 1
    let self.filter    = deepcopy(self.initial_filter)
    let self.idx       = ''
    let self.prefidx   = 0
    call self.UseInputListScratch()
    call self.ResetSelected()
    call self.Retrieve(!initial)
    return self
endf


function! s:prototype.ResetSelected() dict "{{{3
    let self.sel_idx   = []
endf


function! s:prototype.Retrieve(anyway) dict "{{{3
    " TLogVAR a:anyway, self.base
    " TLogDBG (a:anyway || empty(self.base))
    if (a:anyway || empty(self.base))
        let ra = self.retrieve_eval
        " TLogVAR ra
        if !empty(ra)
            let back = self.SwitchWindow('win')
            let world = self
            let self.base = eval(ra)
            " TLogVAR self.base
            exec back
            return 1
        endif
    endif
    return 0
endf


function! s:prototype.DisplayHelp(world) dict "{{{3
    let help = [
                \ 'Help:',
                \ 'Mouse        ... Pick an item            Letter          ... Filter the list',
                \ printf('Number       ... Pick an item            "%s", "%s", %sWORD ... AND, OR, NOT',
                \   g:tlib_inputlist_and, g:tlib_inputlist_or, g:tlib_inputlist_not),
                \ 'Enter        ... Pick the current item   <bs>, <c-bs>    ... Reduce filter',
                \ '<c|m-r>      ... Reset the display       Up/Down         ... Next/previous item',
                \ '<c|m-q>      ... Edit top filter string  Page Up/Down    ... Scroll',
                \ '<Esc>        ... Abort',
                \ ]

    if a:world.allow_suspend
        call add(help,
                \ '<c|m-z>      ... Suspend/Resume          <c-o>           ... Switch to origin')
    endif

    if stridx(a:world.type, 'm') != -1
        let help += [
                \ '#, <c-space> ... (Un)Select the current item',
                \ '<c|m-a>      ... (Un)Select all currently visible items',
                \ '<s-up/down>  ... (Un)Select items',
                \ ]
                    " \ '<c-\>        ... Show only selected',
    endif
    for handler in a:world.key_handlers
        let key = get(handler, 'key_name', '')
        if !empty(key)
            let desc = get(handler, 'help', '')
            call add(help, printf('%-12s ... %s', key, desc))
        endif
    endfor
    let help += [
                \ '',
                \ 'Warning:',
                \ 'Please don''t try to resize the window with the mouse.',
                \ '',
                \ 'Note on filtering:',
                \ 'The filter is prepended with "\V". Basically, filtering is case-insensitive.',
                \ 'Letters at word boundaries or upper-case lettes in camel-case names is given',
                \ 'more weight. If an OR-joined pattern start with "!", matches will be excluded.',
                \ '',
                \ 'Press any key to continue.',
                \ ]
    norm! ggdG
    call append(0, help)
    norm! Gddgg
    call self.Resize(len(help), 0)
endf


function! s:prototype.Resize(hsize, vsize) dict "{{{3
    if self.scratch_vertical
        if a:vsize
            exec 'vert resize '. a:vsize
        endif
    else
        if a:hsize
            exec 'resize '. a:hsize
        endif
    endif
endf


" :def: function! s:prototype.DisplayList(world, query, ?list)
function! s:prototype.DisplayList(world, query, ...) dict "{{{3
    " TLogVAR a:query
    " TLogVAR self.state
    let list = a:0 >= 1 ? a:1 : []
    call self.UseScratch()
    " TLogVAR self.scratch
    " TAssert IsNotEmpty(self.scratch)
    if self.state == 'scroll'
        exec 'norm! '. self.offset .'zt'
    elseif self.state == 'help'
        call self.DisplayHelp(a:world)
    else
        " let ll = len(list)
        let ll = a:world.llen
        " let x  = len(ll) + 1
        let x  = a:world.index_width + 1
        " TLogVAR ll
        if self.state =~ '\<display\>'
            let resize = get(self, 'resize', 0)
            " TLogVAR resize
            let resize = resize == 0 ? ll : min([ll, resize])
            let resize = min([resize, (&lines * g:tlib_inputlist_pct / 100)])
            " TLogVAR resize, ll, &lines
            call self.Resize(resize, get(self, 'resize_vertical', 0))
            norm! ggdG
            let w = winwidth(0) - &fdc
            " let w = winwidth(0) - &fdc - 1
            let lines = copy(list)
            let lines = map(lines, 'printf("%-'. w .'.'. w .'s", substitute(v:val, ''[[:cntrl:][:space:]]'', " ", "g"))')
            call append(0, lines)
            norm! Gddgg
        endif
        " TLogVAR self.prefidx
        let base_pref = self.GetBaseIdx(self.prefidx)
        " TLogVAR base_pref
        if self.state =~ '\<redisplay\>'
            call filter(b:tlibDisplayListMarks, 'index(self.sel_idx, v:val) == -1 && v:val != base_pref')
            " TLogVAR b:tlibDisplayListMarks
            call map(b:tlibDisplayListMarks, 'self.DisplayListMark(x, v:val, ":")')
            " let b:tlibDisplayListMarks = map(copy(self.sel_idx), 'self.DisplayListMark(x, v:val, "#")')
            " call add(b:tlibDisplayListMarks, self.prefidx)
            " call self.DisplayListMark(x, self.GetBaseIdx(self.prefidx), '*')
        endif
        let b:tlibDisplayListMarks = map(copy(self.sel_idx), 'self.DisplayListMark(x, v:val, "#")')
        call add(b:tlibDisplayListMarks, base_pref)
        call self.DisplayListMark(x, base_pref, '*')
        call self.SetOffset()
        " TLogVAR self.offset
        " TLogDBG winheight('.')
        " if self.prefidx > winheight(0)
            " let lt = len(list) - winheight('.') + 1
            " if self.offset > lt
            "     exec 'norm! '. lt .'zt'
            " else
                exec 'norm! '. self.offset .'zt'
            " endif
        " else
        "     norm! 1zt
        " endif
        let rx0 = self.GetRx0()
        " TLogVAR rx0
        if !empty(g:tlib_inputlist_higroup)
            if empty(rx0)
                match none
            else
                exec 'match '. g:tlib_inputlist_higroup .' /\c'. escape(rx0, '/') .'/'
            endif
        endif
        let &statusline = a:query
    endif
    redraw
endf


function! s:prototype.SetOffset() dict "{{{3
    " TLogVAR self.prefidx, self.offset
    " TLogDBG winheight(0)
    " TLogDBG self.prefidx > self.offset + winheight(0) - 1
    let listtop = len(self.list) - winheight(0) + 1
    if listtop < 1
        let listtop = 1
    endif
    if self.prefidx > listtop
        let self.offset = listtop
    elseif self.prefidx > self.offset + winheight(0) - 1
        let listoff = self.prefidx - winheight(0) + 1
        let self.offset = min([listtop, listoff])
    "     TLogVAR self.prefidx
    "     TLogDBG len(self.list)
    "     TLogDBG winheight(0)
    "     TLogVAR listtop, listoff, self.offset
    elseif self.prefidx < self.offset
        let self.offset = self.prefidx
    endif
    " TLogVAR self.offset
endf


function! s:prototype.DisplayListMark(x, y, mark) dict "{{{3
    " TLogVAR a:y, a:mark
    if a:x > 0 && a:y >= 0
        " TLogDBG a:x .'x'. a:y .' '. a:mark
        let sy = self.GetListIdx(a:y) + 1
        " TLogVAR sy
        if sy >= 1
            call setpos('.', [0, sy, a:x, 0])
            exec 'norm! r'. a:mark
            " exec 'norm! '. a:y .'gg'. a:x .'|r'. a:mark
        endif
    endif
    return a:y
endf


function! s:prototype.SwitchWindow(where) dict "{{{3
    let wnr = get(self, a:where.'_wnr')
    " TLogVAR wnr
    return tlib#win#Set(wnr)
endf


