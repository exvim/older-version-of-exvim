" char.vim
" @Author:      Thomas Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-06-30.
" @Last Change: 2007-09-11.
" @Revision:    0.0.12

if &cp || exists("loaded_tlib_char_autoload")
    finish
endif
let loaded_tlib_char_autoload = 1


" :def: function! tlib#char#Get(?timeout=0)
" Get a character.
"
" EXAMPLES: >
"   echo tlib#char#Get()
"   echo tlib#char#Get(5)
function! tlib#char#Get(...) "{{{3
    let timeout = a:0 >= 1 ? a:1 : 0
    if timeout == 0
        return getchar()
    else
        let start = localtime()
        while 1
            let c = getchar(0)
            if c != 0
                return c
            elseif localtime() - start > timeout
                return -1
            endif
        endwh
    endif
    return -1
endf


