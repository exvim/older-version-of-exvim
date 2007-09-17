" Plugin:		SpellChecker.vim
" Author:		Ajit J. Thakkar (ajit AT unb DOT ca)
" Last Change:	2003 Mar. 09
" Version:	1.8
" URL:		http://www.unb.ca/chem/ajit/vim.htm
" Credits:	Inspired by Charles Campbell's engspchk.vim
"
" Description:
" Global Vim Variables:
"  language		default is English (no alternatives at present)
"  dialect		one of US (default), CA, UK for English
"  formal			disallow contractions if formal exists
"  no_spellchecker_maps	no key mappings if it exists
"
" User Dictionaries:
" english_user.vim	User words for all files.
" 		Must be in a dict subdirectory anywhere in the runtime path.
" dirname_words.vim or project_words.vim
" 		Extra user words for files in current directory.
" 		Must be in directory of the file being spell checked.
" 		Words containing an upper-case letter are saved
" 		in a case-sensitive fashion in all user dictionaries.
"
" Usage:
" The key mappings use <Leader>, which is \ by default.
"  Command	Key Mapping	Action:
" :SPCheck	<Leader>sc	Turn spell checking on/off
"
" :SPInteract	<Leader>si	Interactively step through errors
" :SPHarvest	<Leader>sh	Harvest all errors to user dictionary
" 				in a single step
"	The three commands above may be all some users need.
"
"         jwu modify it is conflict with symbol list hot-key, so use upper
"         case for SpellChecker
" :SPNext		<Leader>Sn	Move to next error
" :SPPrevious	<Leader>Sp	Move to previous error
" :SPModify	<Leader>Sm	Modify all occurrences of cursor word
" :SPAllow	<Leader>Sa	Allow word in current document
" :SPLocalSave	<Leader>Sl	Save word in local project dictionary
"				dirname_words.vim
" :SPGlobalSave	<Leader>Sg	Save word in global user dictionary
"				english_user.vim
" :SPRemove	<Leader>Sr	Remove word from any user dictionary
"
" :SPDialect	<Leader>Sd	Change dialect
" :SPFormal	<Leader>Sf	Toggle "allow word contractions"
" :SPQuery	<Leader>Sq	Query SpellChecker settings
"
" Deprecated Command:
" :SPOff (<Leader>so)	Use :SPCheck instead
"
" Commands No Longer Available:
" Use :SPInteract instead of
" :SPSave	(<Leader>ss)
" :SPToggleScanMode (<Leader>st)
"
" In the absence of similarly named, user-defined commands, the SpellChecker
" commands can be issued with just the first three letters, e.g. :SPC
"
" Popup Menu:
" If you have
"	set mousemodel=popup_setpos
" in your vimrc, then after spellchecker has been invoked, right-clicking on a
" word will pop up a menu offering various actions that can be performed on
" that word.
"
" The dialect can be preset for a file by including a directive of the form:
" 		dialect=CA
" in the first &modelines (default 5) lines of your document. The directive
" line can have whatever prefix is required to turn it into a comment for that
" filetype. For example, a % prefix would normally be used in a LaTeX file to
" have the directive line treated as a comment by the compiler.
"
" The default name for a project-specific dictionary is dirname_words.vim
" where dirname is the name of the directory. For example, if your document is
" in the directory ~/write/submit/trel then the default name for the
" dictionary local to that directory is trel_words.vim. For compatibility with
" early versions of SpellChecker, the local dictionary is called
" project_words.vim if such a file exists in that directory. A user-defined
" name for the project-specific dictionary can be chosen by placing a
" directive among the first &modelines (default five) lines of your document.
" For example, a directive such as
"	project_file=gos
" will lead to the local project-specific dictionary being named gos_words.vim.
"
" Limitations:
" You cannot spellcheck files named english_user.vim or *_words.vim
" If you need to do so, just rename them first.
"
" You need Vim version 6 or later, compiled with +syntax,
" and NOT run in vi compatible mode
"
if version < 600 || &cp || !has('syntax')
    finish
endif

" Quick pre-load {{{
if !exists(":SPCheck")
  fun! s:SPCheck()
    if expand("%:t") == "english_user.vim" || expand("%:t") =~? '_words\.vim$'
      return
    endif
    if !exists('b:spellcheck')
      if !exists('syntax_on')
        syntax enable
      endif
      ru plugin/SpellChecker.vim
    else
      call s:SPOff()
    endif
  endfun
  com SPCheck call s:SPCheck()
  if !exists("g:no_plugin_maps") && !exists("g:no_spellchecker_maps")
    nnoremap <silent> <unique> <Leader>sc :SPCheck<cr>
  endif
  if has("gui_running") && has("menu") && &go =~# "m"
    nmenu <silent> 899.960 S&pell.&Check\ on/off<tab>:SPC	:SPCheck<cr>
  endif
  let g:language="english"
  finish
endif
"}}}

" One-time load of functions needed early {{{
if !exists("*s:SP_GetModeLine")
  " SP_GetModeLine {{{
  fun! s:SP_GetModeLine(identifier)
    let pattern=a:identifier.'\s*='
    let info=""
    let maxlines=&mls
    if maxlines > line('$')
      let maxlines=line('$')
    endif
    let line=1
    while line <= maxlines
      let curline=getline(line)
      if curline =~? pattern
        let info=substitute(curline,'^.*'.pattern.'\s*',"","")
        let info=substitute(info,'\>.*$',"","")
        break
      endif
      let line=line + 1
    endwhile
    unlet! pattern maxlines line curline
    return info
  endfun
  " }}}
  " SP_FindUserDict {{{
  fun! s:SP_FindUserDict()
    silent 1sp
    let upath=&path
    if has('win32')
      let temp=substitute(&rtp,'"','','g')
      let &path=substitute(temp,' ','\\\ ','g')
    else
      let &path=&rtp
    endif
    let v:errmsg=""
    exe "silent! find dict/".g:language."_user.vim"
    if v:errmsg != ""
      exe "silent find dict/".g:language."_special.vim"
    endif
    let userdict=expand("%:p:h")."/".g:language."_user.vim"
    let &path=upath
    silent bwipe
    unlet! upath temp
    return userdict
  endfun
  "}}}
endif
"}}}

" Set initial dialect, user and local project dictionary {{{
if !exists('g:dialect')
  let g:dialect="us"
elseif g:dialect !~? '^\(US\|UK\|CA\)'
  let g:dialect="us"
endif
let s:temp=s:SP_GetModeLine("dialect")
if s:temp =~? '^\(us\|am\)'
  let b:dialect="us"
elseif s:temp =~? '^\(uk\|br\)'
  let b:dialect="uk"
elseif s:temp =~? '^ca'
  let b:dialect="ca"
else
  let b:dialect=g:dialect
endif
if !exists('b:formal') && exists('g:formal')
  let b:formal=1
endif
let s:userdict=s:SP_FindUserDict()
let s:temp=s:SP_GetModeLine("project_file")
if s:temp !~? '^\s*$'
  let b:projdict=expand("%:p:h")."/".s:temp."_words.vim"
elseif filereadable("project_words.vim")
  let b:projdict=expand("%:p:h")."/project_words.vim"
else
  let b:projdict=expand("%:p:h")."/".substitute(expand("%:p:h"), '^.*[/\\]', "", "")."_words.vim"
endif
unlet s:temp
let b:spellcheck=1
" }}}

" One-time load of functions, menus, autocommands {{{
if !exists("*s:SP_DisableMenus")
  fun! s:SP_EnableMenus() "{{{
    if has("gui_running") && has("menu") && &go =~# "m"
      if exists("b:spellcheck")
        silent! nmenu enable Spell.*
        if &mousemodel == "popup_setpos"
	nmenu <silent> PopUp.-SpellPop-	:
	nmenu <silent> PopUp.&Allow\ word\ here<tab>:SPA	:SPAllow<cr>
	nmenu <silent> PopUp.Save\ to\ &Local\ project\ dictionary<tab>:SPL	:SPLocalSave<cr>
	nmenu <silent> PopUp.Save\ to\ &Global\ user\ dictionary<tab>:SPG	:SPGlobalSave<cr>
	nmenu <silent> PopUp.&Remove\ word\ from\ user\ dictionary<tab>:SPR	:SPRemove<cr>
	nmenu <silent> PopUp.&Modify\ all\ occurences\ of\ word<tab>:SPM	:SPModify<cr>
        endif
      endif
    endif
  endfun "}}}
  fun! s:SP_DisableMenus() "{{{
    if has("gui_running") && has("menu") && &go =~# "m"
      silent! nmenu disable Spell.*
      silent! nmenu enable  Spell.Check\ on/off
      if &mousemodel == "popup_setpos"
        silent! unmenu PopUp.-SpellPop-
        silent! unmenu PopUp.&Allow\ word\ here
        silent! unmenu PopUp.Save\ to\ &Local\ project\ dictionary
        silent! unmenu PopUp.Save\ to\ &Global\ user\ dictionary
        silent! unmenu PopUp.&Remove\ word\ from\ user\ dictionary
        silent! unmenu PopUp.&Modify\ all\ occurences\ of\ word
      endif
    endif
  endfun "}}}
  fun! s:SP_DeleteWord(word,dict) "{{{
    exe "silent! 1sp ".a:dict
    let pattern="\\<".a:word."\\>"
    let test=search(pattern,"w")
    if test > 0
      norm! dw
      silent g/GoodWord transparent\s*$/d
      silent update
    endif
    silent! bwipe
    unlet pattern
    return test
  endfun "}}}
  fun! s:SP_Position() "{{{
    norm! H
    let position="norm! ".line(".")."Gzt"
    norm! ``
    let position=position.line(".")."G".virtcol(".")."|"
    redraw
    return position
  endfun " }}}
  fun! s:SPQuery() "{{{
    let msg=toupper(b:dialect)." ".g:language
    if exists("b:formal")
      let msg="Formal ".msg
    else
      let msg="Informal ".msg
    endif
    if exists("b:spellcheck")
      let msg=msg." spellchecking On."
    else
      let msg=msg." spellchecking OFF."
    endif
    let msg=msg." v1.8"
    echo msg
    unlet msg
  endfun "}}}
  fun! s:SPFormal() "{{{
    if !exists("b:spellcheck")
      echohl WarningMsg | echo "Spellchecking is off" | echoh None
      return
    endif
    if exists("b:formal")
      unlet b:formal
      echo 'Formal off'
    else
      let b:formal=1
      echo 'Formal on'
    endif
    exe "ru dict/".g:language."_special.vim"
  endfun "}}}
  fun! s:SPOff() "{{{
    unlet! b:spellcheck
    syntax enable
    call s:SP_DisableMenus()
    redraw
    echo "Spellchecking turned off"
  endfun "}}}
  fun! s:SPDialect(...) "{{{
    if !exists("b:spellcheck")
      echohl WarningMsg | echo "Spellchecking is off" | echoh None
      return
    endif
    if a:0 == 0
      let choice=confirm("Dialect?",
	  \ "&American-US\n&British-UK\n&Canadian-CA\n&No change",1,"q")
    else
      let choice=a:1
    endif
    if choice == 1
      let b:dialect="us"
    elseif choice == 2
      let b:dialect="uk"
    elseif choice == 3
      let b:dialect="ca"
    else
      return
    endif
    exe "ru dict/".g:language."_dialects.vim"
    echo toupper(b:dialect)." ".g:language." spellchecking on"
    unlet choice
  endfun "}}}
  fun! s:SP_Word(word) "{{{
    if a:word =~# '^\l\+$'
      syn case ignore
    else
      syn case match
    endif
    exe "syn keyword GoodWord transparent ".a:word
    syn case ignore
  endfun "}}}
  fun! s:SP_AlreadyIn(newword) "{{{
    if !exists("s:quiet")
      let message=a:newword." is already in a dictionary"
      let choice=confirm(message,"&OK",1,"i")
      unlet! choice message
    endif
  endfun "}}}
  fun! s:SPAllow(newword) "{{{
    if !exists("b:spellcheck")
      echohl WarningMsg | echo "Spellchecking is off" | echoh None
      return
    endif
    let test=synIDtrans(synID(line("."),col("."),1))
    if test == s:badword || test == s:variant
      call s:SP_Word(a:newword)
    else
      call s:SP_AlreadyIn(a:newword)
    endif
    unlet test
    redraw
  endfun "}}}
  fun! s:SPSave(newword,...) "{{{
    if !exists("b:spellcheck")
      echohl WarningMsg | echo "Spellchecking is off" | echoh None
      return
    endif
    let test=synIDtrans(synID(line("."),col("."),1))
    if test == s:badword
      if a:0 == 0
        if filereadable(b:projdict)
	let b:defaultdic=2
        endif
        let choice=confirm("Add ".a:newword." to dictionary?",
	    \ "Global\ &User\ dict\nLocal\ &Project\ dict\n&Cancel",b:defaultdic,"q")
      elseif a:0 >= 0
        let choice=a:1
      endif
      if choice == 1 || choice == 2
        if choice == 1
	exe "silent! 1sp ".s:userdict
        else
	exe "silent! 1sp ".b:projdict
        endif
        if getline(1) !~? 'syn case match'
	0put='syn case match'
	1put='syn case ignore'
	silent g/^$/d
        endif
        if a:newword =~# '^\l\+$'
	$put='syn keyword GoodWord transparent '.a:newword
        else
	1put='syn keyword GoodWord transparent '.a:newword
        endif
        silent w
        silent bwipe
        call s:SP_Word(a:newword)
      else
        unlet! test choice
        return
      endif
    elseif test == s:variant
      call s:SP_Word(a:newword)
      call s:SP_AlreadyIn(a:newword)
    else
      call s:SP_AlreadyIn(a:newword)
    endif
    unlet! test upath choice
    redraw
  endfun "}}}
  fun! s:SPNext(direction) "{{{
    if !exists("b:spellcheck")
      echohl WarningMsg | echo "Spellchecking is off" | echoh None
      return 0
    endif
    let found=1
    let user_fen=&fen
    set nofen
    let position=s:SP_Position()
    if a:direction == 1
      let EOF=line("$")
      let cmd="norm! w"
    else
      let EOF=1
      let cmd="norm! b"
    endif
    let curcol=0
    while 1 > 0
      exe cmd
      let cursyn=synIDtrans(synID(line("."),col("."),1))
      if cursyn == s:badword || cursyn == s:variant
        break
      elseif line(".") == EOF
        let prvcol=curcol
        let curcol=col(".")
        if curcol == prvcol
          silent exe position
	redraw
	if !exists("s:quiet")
	  echo "No more errors"
	endif
	let found=0
	break
        endif
      endif
    endwhile
    let &fen=user_fen
    if foldlevel(".") > 0
      norm! zO
    endif
    unlet! user_fen EOF cmd curcol cursyn prvcol position
    return found
  endfun "}}}
  fun! s:SPRemove(word) "{{{
      if !exists("b:spellcheck")
        echohl WarningMsg | echo "Spellchecking is off" | echoh None
        return
      endif
      let test=s:SP_DeleteWord(a:word,s:userdict)
      if test == 0 && filereadable(b:projdict)
        let test=s:SP_DeleteWord(a:word,b:projdict)
      endif
      if test == 0
        echo a:word." not in user dictionary"
      else
        if a:word =~# '^\l\+$'
	syn case ignore
        else
	syn case match
        endif
        exe "syn keyword BadWord ".a:word
        syn case ignore
      endif
      unlet test
  endfun "}}}
  fun! s:SPHarvest(...) "{{{
    if a:0 == 0
      let choice=confirm("Add all words marked as errors to dictionary?",
	  \ "&Global\ user\n&Local\ project\n&Allow\n&Cancel",4,"q")
      if choice < 1 || choice >= 4
        unlet choice
        return
      endif
      let position=s:SP_Position()
      1
    endif
    let s:quiet=1
    let test=synIDtrans(synID(line("."),col("."),1))
    if test == s:badword
      let loop=1
    else
      let loop=s:SPNext(+1)
    endif
    while loop == 1
      if a:0 > 0
        let choice=confirm("Action for ".expand("<cword>")."?",
	    \ "To &Global\ user\ dic\nTo &Local\ project \dic\n&Allow\n&Modify\n&Next error\n&Quit"
	    \,5,"q")
      endif
      if choice < 1 || choice >= 6
        break
      elseif choice == 1 || choice == 2
        call s:SPSave(expand("<cword>"),choice)
      elseif choice == 3
        call s:SPAllow(expand("<cword>"))
      elseif choice == 4
        call s:SPModify(expand("<cword>"))
      endif
      redraw
      let loop=s:SPNext(+1)
    endwhile
    if a:0 == 0
      silent exe position
      redraw
    endif
    unlet! choice loop s:quiet position
  endfun "}}}
  fun! s:SPModify(word) " {{{
    let newspell=input("change ".a:word." to? ",a:word)
    let cmd="%s/\\<".a:word."\\>/".newspell
    if !&gd
      let cmd=cmd."/g"
    endif
    let uic=&ic
    let uscs=&scs
    set ic scs
    exe cmd
    let &ic=uic
    let &scs=uscs
    unlet! newspell cmd uscs uic
  endfun "}}}
  " Menus {{{
  if has("gui_running") && has("menu") && &go =~# "m"
    nmenu <silent> 899.964 S&pell.&Next\ spelling\ error<tab>:SPN	:SPNext<cr>
    nmenu <silent> 899.966 Spell.&Previous\ spelling\ error<tab>:SPP	:SPPrevious<cr>
    nmenu <silent> 899.967 Spell.-Sec1-	:
    nmenu <silent> 899.968 Spell.&Allow\ word\ here<tab>:SPA	:SPAllow<cr>
    tmenu Spell.Allow\ word\ here Accept word for this document
    nmenu <silent> 899.972 Spell.Save\ word\ to\ &Local\ dictionary<tab>:SPL	:SPLocalSave<cr>
    tmenu Spell.Save\ word\ to\ Local\ dictionary Add this word to local project dictionary
    nmenu <silent> 899.976 Spell.Save\ word\ to\ &Global\ dictionary<tab>:SPG	:SPGlobalSave<cr>
    tmenu Spell.Save\ word\ to\ Global\ dictionary Add this word to global user dictionary
    nmenu <silent> 899.980 Spell.&Remove\ word\ from\ user\ dictionary<tab>:SPR	:SPRemove<cr>
    tmenu Spell.Remove\ word\ from\ user\ dictionary Remove this word from user or project dictionary
    nmenu <silent> 899.982 Spell.&Modify\ all\ occurences\ of\ word<tab>:SPM	:SPModify<cr>
    nmenu <silent> 899.984 Spell.&Interactive\ mode<tab>:SPI	:SPInteract<cr>
    tmenu Spell.&Interactive\ mode Step through errors, add to user dictionaries
    nmenu <silent> 899.986 Spell.&Harvest\ all\ errors<tab>:SPH	:SPHarvest<cr>
    tmenu Spell.&Harvest\ all\ errors Harvest all errors to user dictionary at once
    nmenu <silent> 899.990 Spell.-Sec2-	:
    nmenu <silent> 899.994 Spell.&Formal\ on/off<tab>:SPF	:SPFormal<cr>
    tmenu Spell.Formal\ on/off Toggle use of contractions
    if g:language == "english"
      nmenu <silent> 899.996.10 Spell.&Dialect\ change<tab>:SPD.&American\ (US)<tab>	:SPDialect(1)<cr>
      nmenu <silent> 899.996.20 Spell.&Dialect\ change.&British\ (UK)<tab> 	:SPDialect(2)<cr>
      nmenu <silent> 899.996.30 Spell.&Dialect\ change.&Canadian\ (CA)<tab>	:SPDialect(3)<cr>
    endif
    nmenu <silent> 899.998 Spell.&Query\ settings<tab>:SPQ	:SPQuery<cr>
    tmenu Spell.Query\ settings Show SpellChecker settings
  endif
  " }}}
  " Autocommands {{{
  augroup SpellChecker
  au!
  au BufLeave * call s:SP_DisableMenus()
  au Syntax * unlet! b:spellcheck
  au BufEnter * call s:SP_EnableMenus()
  augroup END
  " }}}
endif
"}}}

" Spellchecking {{{
" Spellchecking inside comments {{{
" This can be done only if the syntax files' comment blocks contains=@cluster.
syn case ignore
if     &ft == "amiga"
  syn cluster amiCommentGroup		add=GoodWord,BadWord,Variant
  syn match BadWord contained		"\<\a\+\>"
elseif &ft == "bib"
  syn cluster bibVarContents		contains=GoodWord,BadWord,Variant
  syn cluster bibCommentContents	contains=GoodWord,BadWord,Variant
  syn match BadWord contained		"\<\a\+\>"
elseif &ft == "c" || &ft == "cpp"
  syn cluster cCommentGroup		add=GoodWord,BadWord,Variant
  syn match BadWord contained		"\<\a\+\>"
elseif &ft == "csh"
  syn cluster cshCommentGroup		add=GoodWord,BadWord,Variant
  syn match BadWord contained		"\<\a\+\>"
elseif &ft == "dcl"
  syn cluster dclCommentGroup		add=GoodWord,BadWord,Variant
  syn match BadWord contained		"\<\a\+\>"
elseif &ft == "fortran"
  syn cluster fortranCommentGroup	add=GoodWord,BadWord,Variant
  syn match BadWord contained		"\<\a\+\>"
elseif &ft == "sh" || &ft == "ksh" || &ft == "bash"
  syn cluster shCommentGroup		add=GoodWord,BadWord,Variant
  syn match BadWord contained		"\<\a\+\>"
elseif &ft == "tex"
  syn cluster texCommentGroup		add=GoodWord,BadWord,Variant
  syn cluster texMatchGroup		add=GoodWord,BadWord,Variant
  syn match BadWord "\<\a\+\>"
elseif &ft == "vim"
  syn cluster vimCommentGroup		add=GoodWord,BadWord,Variant
  syn match BadWord contained		"\<\a\+\>"
else
  syn match BadWord "\<\a\+\>"
endif
" Refinements for fortran and tex
if &ft == "fortran"
  syn match   fortranGoodWord contained	"^c\>"
  hi def link fortranGoodWord fortranComment
  syn cluster fortranCommentGroup	add=fortranGoodWord
elseif &ft == "tex"
  syn match GoodWord	"{[a-zA-Z|@]\+}"lc=1,me=e-1
  syn match GoodWord	"\[[a-zA-Z]\+]"lc=1,me=e-1
  syn match texGoodWord	"\\[a-zA-Z]\+"lc=1,me=e-1	contained
  hi def link texGoodWord texComment
  syn cluster texCommentGroup	add=texGoodWord
endif
" Prevent error highlighting of words while one is typing them.
syn match GoodWord "\<\k\+\%#\>"
syn match GoodWord "\<\k\+'\%#"
" Highlight errors and variants
hi def link BadWord	Error
hi def link Variant	Todo
let s:badword=synIDtrans(hlID("BadWord"))
let s:variant=synIDtrans(hlID("Variant"))
" }}}
" Load dictionaries {{{
let s:user_ch=&ch
let &ch=2
echo "Loading dictionaries ..."
exe "ru dict/".g:language.".vim"
exe "ru dict/".g:language."_dialects.vim"
exe "ru dict/".g:language."_special.vim"
exe "ru dict/".g:language."_user.vim"
let b:defaultdic=1
if filereadable(b:projdict)
  exe "so ".b:projdict
  let b:defaultdic=2
endif
echo toupper(b:dialect)." ".g:language." spellchecking on"
let &ch=s:user_ch
unlet s:user_ch
call s:SP_EnableMenus()
"}}}
" Buffer-local commands {{{
if !exists(":SPNext")
  com -buffer SPNext call s:SPNext(1)
  com -buffer SPPrevious call s:SPNext(-1)
  com -buffer SPOff call s:SPOff()
  com -buffer SPAllow call s:SPAllow(expand("<cword>"))
  com -buffer SPGlobalSave call s:SPSave(expand("<cword>"),1)
  com -buffer SPLocalSave call s:SPSave(expand("<cword>"),2)
  com -buffer -nargs=? SPDialect call s:SPDialect(<args>)
  com -buffer SPQuery call s:SPQuery()
  com -buffer SPRemove call s:SPRemove(expand("<cword>"))
  com -buffer SPHarvest call s:SPHarvest()
  com -buffer SPInteract call s:SPHarvest(1)
  com -buffer SPFormal call s:SPFormal()
  com -buffer SPModify call s:SPModify(expand("<cword>"))
endif
"}}}
" Buffer-local key mappings {{{
if !exists("g:no_plugin_maps") && !exists("g:no_spellchecker_maps")
  " jwu modify 
  " if it conflict with symbol list, so use Upper case for s
  nmap <silent> <buffer> <Leader>Sn	:SPNext<cr>
  nmap <silent> <buffer> <Leader>Sp	:SPPrevious<cr>
  nmap <silent> <buffer> <Leader>So	:SPOff<cr>
  nmap <silent> <buffer> <Leader>Sa	:SPAllow<cr>
  nmap <silent> <buffer> <Leader>Ss	<Nop>
  nmap <silent> <buffer> <Leader>Sg	:SPGlobalSave<cr>
  nmap <silent> <buffer> <Leader>Sl	:SPLocalSave<cr>
  nmap <silent> <buffer> <Leader>Sd	:SPDialect<cr>
  nmap <silent> <buffer> <Leader>St	<Nop>
  nmap <silent> <buffer> <Leader>Sq	:SPQuery<cr>
  nmap <silent> <buffer> <Leader>Sr	:SPRemove<cr>
  nmap <silent> <buffer> <Leader>Sh	:SPHarvest<cr>
  nmap <silent> <buffer> <Leader>Si	:SPInteract<cr>
  nmap <silent> <buffer> <Leader>Sf	:SPFormal<cr>
  nmap <silent> <buffer> <Leader>Sm	:SPModify<cr>
endif
"}}}
"}}}

" vim: ts=10:fdm=marker:
