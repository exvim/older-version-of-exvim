" Vim syntax file
" Language:	gmsh
" Maintainer:	CHAMPANEY Laurent laurent.champaney@meca.uvsq.fr
" Location:     http://www.lema.uvsq.fr/champaney/outils/gmsh.vim
" Last change:	Wed May 14 21:27:58 2003
"
" Installation :
" Add this file in ~/.vim/syntax/
"
" Add the following lines in your .vim/filetype.vim
" 	augroup filetypedetect
"	au! BufRead,BufNewFile *.geo		setfiletype gmsh
"	augroup END
"
" Add the following comment at the end of your other gmsh files
" // vim: set filetype=gmsh :  //

" Remove any old syntax stuff hanging around
set tabstop=2
set shiftwidth=2
set expandtab
syn clear
syn case ignore
" 
syn keyword gmshConditional	If EndIf
syn keyword gmshRepeat		For EndFor
syn keyword gmshFunction	Function Return
"
" Strings
syn region gmshString		start=+"+ end=+"+	oneline
syn region gmshString		start=+'+ end=+'+	oneline



" Any integer
syn match gmshNumber		"-\=\<\d\+\>"
" floating point number, with dot, optional exponent
syn match gmshFloat		"\<\d\+\.\d*\([edED][-+]\=\d\+\)\=\>"
" floating point number, starting with a dot, optional exponent
syn match gmshFloat		"\.\d\+\([edED][-+]\=\d\+\)\=\>"
" floating point number, without dot, with exponent
syn match gmshFloat		"\<\d\+[edED][-+]\=\d\+\>"
"
"syn keyword gmshOperator  = += -= *= /= : ...  /\ 
"syn keyword gmshOperator  && ++ -- == != ~= <= >=
"
" Identifier
syn match gmshIdentifier		"\<[a-zA-Z_][a-zA-Z0-9_]*\>"
"
" Comments
  syn region	gmshCommentL	start="//" skip="\\$" end="$" keepend contains=@gmshCommentGroup,gmshSpaceError
  syn region	gmshComment	matchgroup=gmshCommentStart start="/\*" matchgroup=NONE end="\*/" contains=@gmshCommentGroup,gmshCommentStartError,gmshSpaceError
syntax match	gmshCommentError	display "\*/"
syntax match	gmshCommentStartError display "/\*"me=e-1 contained
"
" Keywords
syn keyword gmshKeyword newreg newp Acos ArcCos Asin ArcSin Atan ArcTan
syn keyword gmshKeyword Atan2 ArcTan2 Attractor Bump BSpline Bounds Ceil
syn keyword gmshKeyword Cosh Cos Characteristic Circle Coherence Complex
syn keyword gmshKeyword Color ColorTable CatmullRom Call Delete Dilate
syn keyword gmshKeyword Duplicata Draw Exp Ellipsis Extrude Elliptic
syn keyword gmshKeyword ELLIPSE  Exit Fabs Floor Fmod 
syn keyword gmshKeyword Hypot In Intersect Knots Length
syn keyword gmshKeyword Line Loop Log Log10 Layers Modulo Meshes Nurbs
syn keyword gmshKeyword Order Physical Pi Plane Point Power Progression
syn keyword gmshKeyword Parametric Printf Recombine Rotate Ruled Rand
syn keyword gmshKeyword Sqrt Sin Sinh Spline Surface Symmetry
syn keyword gmshKeyword Sprintf Transfinite Translate Tanh Tan Trimmed
syn keyword gmshKeyword Using Volume With SS VS TS ST VT TT SL VL TL SP VP TP
syn keyword gmshKeyword System
"
" because of Print.---- options
syn match gmshPrint		"\<Print\>"
" Options
syn match gmshOption2		"\<[a-zA-Z_]*\[\d\]\.[a-zA-Z0-9_]*\>"
syn match gmshOptions		"\<[a-zA-Z_]*\.[a-zA-Z0-9_]*\>"
"
if !exists("did_gmsh_syntax_inits")
  let did_gmsh_syntax_inits = 1
  " The default methods for highlighting.  Can be overridden later
  hi link gmshStatement		Statement
  hi link gmshLabel		Special
  hi link gmshConditional	Conditional
  hi link gmshRepeat		Repeat
  hi link gmshFunction		Repeat
  hi link gmshTodo		Todo
  hi link gmshNumber		Number
  hi link gmshFloat		Float
  hi link gmshLogicalConstant	Constant
  hi link gmshCommentStart	Comment
  hi link gmshComment		Comment
  hi link gmshCommentL		Comment
  hi link gmshType		Type
  hi link gmshImplicit		Special
  hi link gmshPrint		Operator
  hi link gmshOperator		Operator
  hi link gmshKeyword		Operator
  hi link gmshIdentifier	Identifier
  hi link gmshPreCondit		PreCondit
  hi link gmshString		String
  hi link gmshOptions		PreProc
  hi link gmshOption2		PreProc
endif
"
let b:current_syntax = "gmsh"
"
"EOF	vim: ts=8 noet tw=120 sw=8 sts=0
