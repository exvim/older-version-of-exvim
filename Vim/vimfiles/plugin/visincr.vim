" visincr.vim: Visual-block incremented lists
"  Author:      Charles E. Campbell, Jr.  Ph.D.
"  Date:        Mar 16, 2006
"  Version:     13
"
"				Visincr assumes that a block of numbers selected by a
"				ctrl-v (visual block) has been selected for incrementing.
"				This function will transform that block of numbers into
"				an incrementing column starting from that topmost number
"				in the visual block.  Also handles dates, daynames, and
"				monthnames.
"
"  Fancy Stuff:
"				* If the visual block is ragged right (as can happen when "$"
"				  is used to select the right hand side), the block will have
"				  spaces appended to straighten it out
"				* If the strlen of the count exceeds the visual-block
"				  allotment of spaces, then additional spaces will be inserted
"				* Handles leading tabs by using virtual column calculations
"
" GetLatestVimScripts: 670 1 :AutoInstall: visincr.vim

" ---------------------------------------------------------------------
" Load Once: {{{1
if &cp || exists("g:loaded_visincr")
  finish
endif
let s:keepcpo        = &cpo
let g:loaded_visincr = "v13"
set cpo&vim

" ------------------------------------------------------------------------------
" Public Interface: {{{1
com! -ra -na=? I    call <SID>VisBlockIncr(0,<f-args>)
com! -ra -na=* II   call <SID>VisBlockIncr(1,<f-args>)
com! -ra -na=* IMDY call <SID>VisBlockIncr(2,<f-args>)
com! -ra -na=* IYMD call <SID>VisBlockIncr(3,<f-args>)
com! -ra -na=* IDMY call <SID>VisBlockIncr(4,<f-args>)
com! -ra -na=? ID   call <SID>VisBlockIncr(5,<f-args>)
com! -ra -na=? IM   call <SID>VisBlockIncr(6,<f-args>)
com! -ra -na=? IA	call <SID>VisBlockIncr(7,<f-args>)

com! -ra -na=? RI    call <SID>VisBlockIncr(10,<f-args>)
com! -ra -na=* RII   call <SID>VisBlockIncr(11,<f-args>)
com! -ra -na=* RIMDY call <SID>VisBlockIncr(12,<f-args>)
com! -ra -na=* RIYMD call <SID>VisBlockIncr(13,<f-args>)
com! -ra -na=* RIDMY call <SID>VisBlockIncr(14,<f-args>)
com! -ra -na=? RID   call <SID>VisBlockIncr(15,<f-args>)
com! -ra -na=? RIM   call <SID>VisBlockIncr(16,<f-args>)

" ------------------------------------------------------------------------------
" Options:
if !exists("g:visincr_leaddate")
 " choose between dates such as 11/ 5/04 and 11/05/04
 let g:visincr_leaddate = '0'
endif

" ------------------------------------------------------------------------------
" VisBlockIncr:	{{{1
fun! <SID>VisBlockIncr(method,...)
"  call Dfunc("VisBlockIncr(method<".a:method.">) a:0=".a:0)

  " avoid problems with user options
  let fokeep    = &fo
  let magickeep = &magic
  let reportkeep= &report
  set fo=tcq magic report=9999

  " visblockincr only uses visual-block! {{{2
"  call Decho("visualmode<".visualmode().">")
  if visualmode() != "\<c-v>"
   echoerr "Please use visual-block mode (ctrl-v)!"
   let &fo    = fokeep
   let &magic = magickeep
   let &report= reportkeep
"   call Dret("VisBlockIncr")
   return
  endif

  " save boundary line numbers and set up method {{{2
  let y1      = line("'<")
  let y2      = line("'>")
  let method  = (a:method >= 10)? a:method - 10 : a:method
  let leaddate= g:visincr_leaddate

  " get increment (default=1) {{{2
  if a:0 > 0
   let incr= a:1
  else
   let incr= 1
  endif

  " set up restriction pattern {{{2
  let leftcol = virtcol("'<")
  let rghtcol = virtcol("'>")
  if leftcol > rghtcol
   let leftcol = virtcol("'>")
   let rghtcol = virtcol("'<")
  endif
  let width= rghtcol - leftcol + 1
"  call Decho("width= [rghtcol=".rghtcol."]-[leftcol=".leftcol."]+1=".width)

  if     a:method == 10	" :I
   let restrict= '\%'.col(".").'c\d'
"   call Decho(":I restricted<".restrict.">")
  elseif a:method == 11	" :II
   let restrict= '\%'.col(".").'c\s\{,'.width.'}\d'
"   call Decho(":II restricted<".restrict.">")
  elseif a:method == 12	" :IMDY
   let restrict= '\%'.col(".").'c\d\{1,2}/\d\{1,2}/\d\{2,4}'
"   call Decho(":IMDY restricted<".restrict.">")
  elseif a:method == 13	" :IYMD
   let restrict= '\%'.col(".").'c\d\{2,4}/\d\{1,2}/\d\{1,2}'
"   call Decho(":IYMD restricted<".restrict.">")
  elseif a:method == 14	" :IDMY
   let restrict= '\%'.col(".").'c\d\{1,2}/\d\{1,2}/\d\{2,4}'
"   call Decho(":IDMY restricted<".restrict.">")
  elseif a:method == 15	" :ID
   if exists("g:visincr_dow")
   	let dowlist = substitute(g:visincr_dow,'\(\a\{1,3}\)[^,]*\%(,\|$\)','\1\\|','ge')
   	let dowlist = substitute(dowlist,'\\|$','','e')
    let restrict= '\c\%'.col(".").'c\('.substitute(dowlist,',','\\|','ge').'\)'
"	call Decho("restrict<".restrict.">")
   else
    let restrict= '\c\%'.col(".").'c\(mon\|tue\|wed\|thu\|fri\|sat\|sun\)'
   endif
"   call Decho(":ID restricted<".restrict.">")
  elseif a:method == 16	" :IM
   if exists("g:visincr_month")
   	let monlist = substitute(g:visincr_month,'\(\a\{1,3}\)[^,]*\%(,\|$\)','\1\\|','ge')
   	let monlist = substitute(monlist,'\\|$','','e')
    let restrict= '\c\%'.col(".").'c\('.substitute(monlist,',','\\|','ge').'\)'
"	call Decho("restrict<".restrict.">")
   else
    let restrict= '\c\%'.col(".").'c\(jan\|feb\|mar\|apr\|may\|jun\|jul\|aug\|sep\|oct\|nov\|dec\)'
   endif
"   call Decho(":IM restricted<".restrict.">")
  endif

  " determine zfill {{{2
"  call Decho("a:0=".a:0." method=".method)
  if a:0 > 1 && ((2 <= method && method <= 4) || (12 <= method && method <= 14))
   let leaddate= a:2
"   call Decho("set leaddate<".leaddate.">")
  elseif a:0 > 1 && method
   let zfill= a:2
   if zfill == "''" || zfill == '""'
   	let zfill=""
   endif
"   call Decho("set zfill<".zfill.">")
  else
   let zfill= ' '
  endif

  " IMDY  IYMD  IDMY  ID  IM: {{{2
  if method >= 2
   let rghtcol = rghtcol + 1
   let curline = getline("'<")

   " ID: {{{3
   if method == 5
    let pat    = '^.*\%'.leftcol.'v\(\a\+\)\%'.rghtcol.'v.*$'
    let dow    = substitute(substitute(curline,pat,'\1','e'),' ','','ge')
    let dowlen = strlen(dow)
"	call Decho("pat<".pat."> dow<".dow."> dowlen=".dowlen)

    " set up long daynames
    if exists("g:visincr_dow")
	 let dow_0= substitute(g:visincr_dow,'^\([^,]*\),.*$',               '\1','')
	 let dow_1= substitute(g:visincr_dow,'^\%([^,]*,\)\{1}\([^,]*\),.*$','\1','')
	 let dow_2= substitute(g:visincr_dow,'^\%([^,]*,\)\{2}\([^,]*\),.*$','\1','')
	 let dow_3= substitute(g:visincr_dow,'^\%([^,]*,\)\{3}\([^,]*\),.*$','\1','')
	 let dow_4= substitute(g:visincr_dow,'^\%([^,]*,\)\{4}\([^,]*\),.*$','\1','')
	 let dow_5= substitute(g:visincr_dow,'^\%([^,]*,\)\{5}\([^,]*\),.*$','\1','')
	 let dow_6= substitute(g:visincr_dow,'^\%([^,]*,\)\{6}\([^,]*\)$',   '\1','')
	else
	 let dow_0= "Monday"
	 let dow_1= "Tuesday"
	 let dow_2= "Wednesday"
	 let dow_3= "Thursday"
	 let dow_4= "Friday"
	 let dow_5= "Saturday"
	 let dow_6= "Sunday"
	endif

	" if the daynames under the cursor is <= 3, transform
	" long daynames to short daynames
	if strlen(dow) <= 3
"	 call Decho("transform long daynames to short daynames")
     let dow_0= strpart(dow_0,0,3)
     let dow_1= strpart(dow_1,0,3)
     let dow_2= strpart(dow_2,0,3)
     let dow_3= strpart(dow_3,0,3)
     let dow_4= strpart(dow_4,0,3)
     let dow_5= strpart(dow_5,0,3)
     let dow_6= strpart(dow_6,0,3)
	endif

	" identify day-of-week under cursor
	let idow= 0
	while idow < 7
"	 call Decho("dow<".dow.">  dow_".idow."<".dow_{idow}.">")
	 if dow =~ '\c\<'.strpart(dow_{idow},0,3)
	  break
	 endif
	 let idow= idow + 1
	endwhile
	if idow >= 7
	 echoerr "***error*** misspelled day-of-week <".dow.">"
     let &fo    = fokeep
     let &magic = magickeep
     let &report= reportkeep
"	 call Dret("VisBlockIncr : unable to identify day-of-week")
	 return
	endif

	" generate incremented dayname list
    norm! `<
	norm! gUl
    norm! `<
    let l = y1
    while l < y2
   	 norm! j
"	 call Decho("while [l=".l."] < [y2=".y2."]: line=".line(".")." col[".leftcol.",".rghtcol."] width=".width)
	 if exists("restrict") && getline(".") !~ restrict
	  let l= l + 1
	  continue
	 endif
	 let idow= (idow + incr)%7
	 exe 's/\%'.leftcol.'v.\{'.width.'\}/'.dow_{idow}.'/e'
	 let l= l + 1
	endw
	" return from ID
    let &fo    = fokeep
    let &magic = magickeep
    let &report= reportkeep
"    call Dret("VisBlockIncr : ID")
   	return
   endif

   " IM: {{{3
   if method == 6
    let pat    = '^.*\%'.leftcol.'v\(\a\+\)\%'.rghtcol.'v.*$'
    let mon    = substitute(substitute(curline,pat,'\1','e'),' ','','ge')
    let monlen = strlen(mon)
	if exists("g:visincr_month")
	 let mon_0 = substitute(g:visincr_month,'^\([^,]*\),.*$',                '\1','')
	 let mon_1 = substitute(g:visincr_month,'^\%([^,]*,\)\{1}\([^,]*\),.*$', '\1','')
	 let mon_2 = substitute(g:visincr_month,'^\%([^,]*,\)\{2}\([^,]*\),.*$', '\1','')
	 let mon_3 = substitute(g:visincr_month,'^\%([^,]*,\)\{3}\([^,]*\),.*$', '\1','')
	 let mon_4 = substitute(g:visincr_month,'^\%([^,]*,\)\{4}\([^,]*\),.*$', '\1','')
	 let mon_5 = substitute(g:visincr_month,'^\%([^,]*,\)\{5}\([^,]*\),.*$', '\1','')
	 let mon_6 = substitute(g:visincr_month,'^\%([^,]*,\)\{6}\([^,]*\),.*$', '\1','')
	 let mon_7 = substitute(g:visincr_month,'^\%([^,]*,\)\{7}\([^,]*\),.*$', '\1','')
	 let mon_8 = substitute(g:visincr_month,'^\%([^,]*,\)\{8}\([^,]*\),.*$', '\1','')
	 let mon_9 = substitute(g:visincr_month,'^\%([^,]*,\)\{9}\([^,]*\),.*$', '\1','')
	 let mon_10= substitute(g:visincr_month,'^\%([^,]*,\)\{10}\([^,]*\),.*$','\1','')
	 let mon_11= substitute(g:visincr_month,'^\%([^,]*,\)\{11}\([^,]*\)$',   '\1','')
	else
	 let mon_0 = "January"
	 let mon_1 = "February"
	 let mon_2 = "March"
	 let mon_3 = "April"
	 let mon_4 = "May"
	 let mon_5 = "June"
	 let mon_6 = "July"
	 let mon_7 = "August"
	 let mon_8 = "September"
	 let mon_9 = "October"
	 let mon_10= "November"
	 let mon_11= "December"
	endif

	" identify month under cursor
	let imon= 0
	while imon < 12
	 if mon =~ '\c\<'.strpart(mon_{imon},0,3)
	  break
	 endif
	 let imon= imon + 1
	endwhile
	if imon >= 12
	 echoerr "***error*** misspelled month <".mon.">"
     let &fo    = fokeep
     let &magic = magickeep
     let &report= reportkeep
"     call Dret("VisBlockIncr")
     return
	endif

	" if monthname is three or fewer characters long,
	" transform monthnames to three character versions
	if strlen(mon) <= 3
"	 call Decho("transform monthnames to short versions")
	 let jmon= 0
	 while jmon < 12
	  let mon_{jmon} = strpart(mon_{jmon},0,3)
	  let jmon       = jmon + 1
	 endwhile
	endif

	" generate incremented monthname list
    norm! `<
	norm! gUl
    norm! `<
    let l = y1
    while l < y2
   	 norm! j
	 if exists("restrict") && getline(".") !~ restrict
	  let l= l + 1
	  continue
	 endif
	 let imon= (imon + incr)%12
	 exe 's/\%'.leftcol.'v.\{'.width.'\}/'.mon_{imon}.'/e'
	 let l= l + 1
	endw
	" return from IM
    let &fo    = fokeep
    let &magic = magickeep
    let &report= reportkeep
"    call Dret("VisBlockIncr : IM")
   	return
   endif

   " IA: {{{3
   if method == 7
	let pat    = '^.*\%'.leftcol.'v\(\a\).*$'
	let letter = substitute(curline,pat,'\1','e')
	if letter !~ '\a'
	 let letter= 'A'
	endif
	if letter =~ '[a-z]'
	 let alphabet='abcdefghijklmnopqrstuvwxyz'
	else
	 let alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	endif
	let ilet= stridx(alphabet,letter)

    norm! `<
    let l = y1
    while l <= y2
"	 call Decho("letter<".letter."> l=".l." ilet=".ilet)
	 exe 's/\%'.leftcol.'v.*\%'.rghtcol.'v/'.letter.'/e'
	 let ilet   = (ilet + incr)%26
	 let letter = strpart(alphabet,ilet,1)
	 if l < y2
   	  silent norm! j
	 endif
	 let l= l + 1
	endw
	" return from IA
	let &fo    = fokeep
	let &magic = magickeep
    let &report= reportkeep
"    call Dret("VisBlockIncr : IA")
	return
   endif

   let pat= '^.*\%'.leftcol.'v\( \=[0-9]\{1,4}\)/\( \=[0-9]\{1,2}\)/\( \=[0-9]\{1,4}\)\%'.rghtcol.'v.*$'

   " IMDY: {{{3
   if method == 2
    let m     = substitute(substitute(curline,pat,'\1',''),' ','','ge')+0
    let d     = substitute(substitute(curline,pat,'\2',''),' ','','ge')+0
    let y     = substitute(substitute(curline,pat,'\3',''),' ','','ge')+0
	let type  = 2
"    call Decho("IMDY: y=".y." m=".m." d=".d." leftcol=".leftcol." rghtcol=".rghtcol)

   " IYMD: {{{3
   elseif method == 3
    let y     = substitute(substitute(curline,pat,'\1',''),' ','','ge')+0
    let m     = substitute(substitute(curline,pat,'\2',''),' ','','ge')+0
    let d     = substitute(substitute(curline,pat,'\3',''),' ','','ge')+0
	let type  = 1
"    call Decho("IYMD: y=".y." m=".m." d=".d." leftcol=".leftcol." rghtcol=".rghtcol)

   " IDMY: {{{3
   elseif method == 4
    let d     = substitute(substitute(curline,pat,'\1',''),' ','','ge')+0
    let m     = substitute(substitute(curline,pat,'\2',''),' ','','ge')+0
    let y     = substitute(substitute(curline,pat,'\3',''),' ','','ge')+0
	let type  = 3
"    call Decho("IDMY: y=".y." m=".m." d=".d." leftcol=".leftcol." rghtcol=".rghtcol)
   else
   	echoerr "***error in <visincr.vim> script"
   endif

   " Julian day/Calendar day calculations {{{3
   let julday= Cal2Jul(y,m,d)
   norm! `<
   let l = y1
   while l <= y2
	 if exists("restrict") && getline(".") !~ restrict
	  norm! j
	  let l= l + 1
	  continue
	 endif
	let doy   = Jul2Cal(julday,type)

	" IYMD: {{{3
	if type == 1
     let doy   = substitute(doy,'^\d/',leaddate.'&','e')
     let doy   = substitute(doy,'/\(\d/\)','/'.leaddate.'\1','e')
     let doy   = substitute(doy,'/\(\d\)$','/'.leaddate.'\1','e')

	" IMDY IDMY: {{{3
	else
     let doy   = substitute(doy,'^\d/',' &','e')
     let doy   = substitute(doy,'/\(\d/\)','/'.leaddate.'\1','e')
     let doy   = substitute(doy,'/\(\d\)$','/'.leaddate.'\1','e')
	endif

	let doy   = escape(doy,'/')
	if leaddate != ' '
	 let doy= substitute(doy,' ',leaddate,'ge')
	endif
	exe 's/\%'.leftcol.'v.*\%'.rghtcol.'v/'.doy.'/e'
    let l     = l + 1
	let julday= julday + incr
	if l <= y2
   	 norm! j
	endif
   endw
   let &fo    = fokeep
   let &magic = magickeep
   let &report= reportkeep
"   call Dret("VisBlockIncr : IMDY  IYMD  IDMY  ID  IM")
   return
  endif " IMDY  IYMD  IDMY  ID  IM

  " I II: {{{2
  " construct a line from the first line that {{{3
  " only has the number in it
  let rml   = rghtcol - leftcol
  let rmlp1 = rml  + 1
  let lm1   = leftcol  - 1
"  call Decho("rghtcol=".rghtcol." leftcol=".leftcol." rmlp1=".rmlp1." lm1=".lm1)
  if lm1 <= 0
   let lm1 = 1
   let pat = '^\([0-9 \t]\{1,'.rmlp1.'}\).*$'
   let cnt = substitute(getline("'<"),pat,'\1',"")
  else
   let pat = '^\(.\{-}\)\%'.leftcol.'v\([0-9 \t]\{1,'.rmlp1.'}\).*$'
   let cnt = substitute(getline("'<"),pat,'\2',"")
  endif
  let cntlen = strlen(cnt)
  let cnt    = substitute(cnt,'\s','',"ge")
  let ocnt   = cnt
  let cnt    = substitute(cnt,'^0*\([1-9]\|0$\)','\1',"ge")
"  call Decho("cnt=".cnt." pat<".pat.">")

  " left-method with zeros {{{3
  " IF  top number is zero-modeded
  " AND we're justified right
  " AND increment is positive
  " AND user didn't specify a modeding character
  if a:0 < 2 && method > 0 && cnt != ocnt && incr > 0
   let zfill= '0'
  endif

  " determine how much incrementing is needed {{{3
  let maxcnt   = cnt + incr*(y2 - y1)
  let maxcntlen= strlen(maxcnt)
  if cntlen > maxcntlen
   let maxcntlen= cntlen
  endif
"  call Decho("maxcntlen=".maxcntlen)

  " go through visual block incrementing numbers based {{{3
  " on first number (saved in cnt), taking care to
  " avoid issuing "0h" commands.
  norm! `<
  let l = y1
  while l <= y2
"   call Decho("[l=".l."] still <= [y2=".y2."]")
	if exists("restrict") && getline(".") !~ restrict
"	 call Decho("skipping <".getline(".")."> (restrict)")
	 norm! j
	 let l= l + 1
	 continue
	endif
    let cntlen= strlen(cnt)

	" Straighten out ragged-right visual-block selection {{{3
	" by appending spaces as needed
	norm! $
	while virtcol("$") <= rghtcol
	 exe "norm! A \<Esc>"
	endwhile
	norm! 0

	" convert visual block line to all spaces {{{3
	if virtcol(".") != leftcol
	 exe 'norm! /\%'.leftcol."v\<Esc>"
	endif
    exe "norm! " . rmlp1 . "r "

	" cnt has gotten bigger than the visually-selected {{{3
	" area allows.  Will insert spaces to accommodate it.
	if maxcntlen > 0
	 let ins= maxcntlen - rmlp1
	else
	 let ins= strlen(cnt) - rmlp1
	endif
    while ins > 0
     exe "norm! i \<Esc>"
     let ins= ins - 1
    endwhile

	" back up to left-of-block (plus optional left-hand-side modeling) {{{3
	norm! 0
	if method == 0
	 let bkup= leftcol
	elseif maxcntlen > 0
	 let bkup= leftcol + maxcntlen - cntlen
	else
	 let bkup= leftcol
	endif
"	call Decho("cnt=".cnt." bkup= [leftcol=".leftcol."]+[maxcntlen=".maxcntlen."]-[cntlen=".cntlen."]=".bkup)
	if virtcol(".") != bkup
	 exe 'norm! /\%'.bkup."v\<Esc>"
	endif

	" replace with count {{{3
	exe "norm! R" . cnt . "\<Esc>"
	if cntlen > 1
	 let cntlenm1= cntlen - 1
	 exe "norm! " . cntlenm1 . "h"
	endif
	if zfill != " "
	 let gdkeep= &gd
	 set nogd
	 silent! exe 's/\%'.leftcol.'v\( \+\)/\=substitute(submatch(1)," ","'.zfill.'","ge")/e'
	 let &gd= gdkeep
	endif

	" set up for next line {{{3
	if l != y2
	 norm! j
	endif
    let cnt= cnt + incr
    let l  = l  + 1
  endw
  " }}}2

  let &fo    = fokeep
  let &magic = magickeep
  let &report= reportkeep
"  call Dret("VisBlockIncr")
endfun

" ------------------------------------------------------------------------------
"  Restoration: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" ------------------------------------------------------------------------------
"  Modelines: {{{1
"  vim: ts=4 fdm=marker
