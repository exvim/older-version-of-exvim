" Vim syntax file
" Language:	Vim help file
" Maintainer:	Bram Moolenaar (Bram@vim.org)
" Last Change:	2004 May 17

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match helpHeadline		"^[A-Z ]\+[ ]\+\*"me=e-1
syn match helpSectionDelim	"^=\{3,}.*===$"
syn match helpSectionDelim	"^-\{3,}.*--$"
syn region helpExample		matchgroup=helpIgnore start=" >$" start="^>$" end="^[^ \t]"me=e-1 end="^<"
if has("ebcdic")
  syn match helpHyperTextJump	"\\\@<!|[^"*|]\+|"
  syn match helpHyperTextEntry	"\*[^"*|]\+\*\s"he=e-1
  syn match helpHyperTextEntry	"\*[^"*|]\+\*$"
else
  syn match helpHyperTextJump	"\\\@<!|[#-)!+-~]\+|"
  syn match helpHyperTextEntry	"\*[#-)!+-~]\+\*\s"he=e-1
  syn match helpHyperTextEntry	"\*[#-)!+-~]\+\*$"
endif
syn match helpNormal		"|.*====*|"
syn match helpNormal		":|vim:|"	" for :help modeline
syn match helpVim		"Vim version [0-9.a-z]\+"
syn match helpVim		"VIM REFERENCE.*"
syn match helpOption		"'[a-z]\{2,\}'"
syn match helpOption		"'t_..'"
syn match helpHeader		"\s*\zs.\{-}\ze\s\=\~$" nextgroup=helpIgnore
syn match helpIgnore		"." contained
syn keyword helpNote		note Note NOTE note: Note: NOTE: Notes Notes:
syn match helpSpecial		"\<N\>"
syn match helpSpecial		"\<N\.$"me=e-1
syn match helpSpecial		"\<N\.\s"me=e-2
syn match helpSpecial		"(N\>"ms=s+1
syn match helpSpecial		"\[N]"
" avoid highlighting N  N in help.txt
syn match helpSpecial		"N  N"he=s+1
syn match helpSpecial		"Nth"me=e-2
syn match helpSpecial		"N-1"me=e-2
syn match helpSpecial		"{[-a-zA-Z0-9'":%#=[\]<>.,]\+}"
syn match helpSpecial		"{[-a-zA-Z0-9'"*+/:%#=[\]<>.,]\+}"
syn match helpSpecial		"\s\[[-a-z^A-Z0-9_]\{2,}]"ms=s+1
syn match helpSpecial		"<[-a-zA-Z0-9_]\+>"
syn match helpSpecial		"<[SCM]-.>"
syn match helpNormal		"<---*>"
syn match helpSpecial		"\[range]"
syn match helpSpecial		"\[line]"
syn match helpSpecial		"\[count]"
syn match helpSpecial		"\[offset]"
syn match helpSpecial		"\[cmd]"
syn match helpSpecial		"\[num]"
syn match helpSpecial		"\[+num]"
syn match helpSpecial		"\[-num]"
syn match helpSpecial		"\[+cmd]"
syn match helpSpecial		"\[++opt]"
syn match helpSpecial		"\[arg]"
syn match helpSpecial		"\[arguments]"
syn match helpSpecial		"\[ident]"
syn match helpSpecial		"\[addr]"
syn match helpSpecial		"\[group]"
syn match helpSpecial		"CTRL-."
syn match helpSpecial		"CTRL-Break"
syn match helpSpecial		"CTRL-PageUp"
syn match helpSpecial		"CTRL-PageDown"
syn match helpSpecial		"CTRL-Insert"
syn match helpSpecial		"CTRL-Del"
syn match helpSpecial		"CTRL-{char}"
syn region helpNotVi		start="{Vi[: ]" start="{not" start="{only" end="}" contains=helpLeadBlank,helpHyperTextJump
syn match helpLeadBlank		"^\s\+" contained

" Highlight group items in their own color.
syn match helpComment		"\t[* ]Comment\t\+[a-z].*"
syn match helpConstant		"\t[* ]Constant\t\+[a-z].*"
syn match helpString		"\t[* ]String\t\+[a-z].*"
syn match helpCharacter		"\t[* ]Character\t\+[a-z].*"
syn match helpNumber		"\t[* ]Number\t\+[a-z].*"
syn match helpBoolean		"\t[* ]Boolean\t\+[a-z].*"
syn match helpFloat		"\t[* ]Float\t\+[a-z].*"
syn match helpIdentifier	"\t[* ]Identifier\t\+[a-z].*"
syn match helpFunction		"\t[* ]Function\t\+[a-z].*"
syn match helpStatement		"\t[* ]Statement\t\+[a-z].*"
syn match helpConditional	"\t[* ]Conditional\t\+[a-z].*"
syn match helpRepeat		"\t[* ]Repeat\t\+[a-z].*"
syn match helpLabel		"\t[* ]Label\t\+[a-z].*"
syn match helpOperator		"\t[* ]Operator\t\+["a-z].*"
syn match helpKeyword		"\t[* ]Keyword\t\+[a-z].*"
syn match helpException		"\t[* ]Exception\t\+[a-z].*"
syn match helpPreProc		"\t[* ]PreProc\t\+[a-z].*"
syn match helpInclude		"\t[* ]Include\t\+[a-z].*"
syn match helpDefine		"\t[* ]Define\t\+[a-z].*"
syn match helpMacro		"\t[* ]Macro\t\+[a-z].*"
syn match helpPreCondit		"\t[* ]PreCondit\t\+[a-z].*"
syn match helpType		"\t[* ]Type\t\+[a-z].*"
syn match helpStorageClass	"\t[* ]StorageClass\t\+[a-z].*"
syn match helpStructure		"\t[* ]Structure\t\+[a-z].*"
syn match helpTypedef		"\t[* ]Typedef\t\+[Aa-z].*"
syn match helpSpecial		"\t[* ]Special\t\+[a-z].*"
syn match helpSpecialChar	"\t[* ]SpecialChar\t\+[a-z].*"
syn match helpTag		"\t[* ]Tag\t\+[a-z].*"
syn match helpDelimiter		"\t[* ]Delimiter\t\+[a-z].*"
syn match helpSpecialComment	"\t[* ]SpecialComment\t\+[a-z].*"
syn match helpDebug		"\t[* ]Debug\t\+[a-z].*"
syn match helpUnderlined	"\t[* ]Underlined\t\+[a-z].*"
syn match helpError		"\t[* ]Error\t\+[a-z].*"
syn match helpTodo		"\t[* ]Todo\t\+[a-z].*"


" Additionally load a language-specific syntax file "help_ab.vim".
let i = match(expand("%"), '\.\a\ax$')
if i > 0
  exe "runtime syntax/help_" . strpart(expand("%"), i + 1, 2) . ".vim"
endif

syn sync minlines=40


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_help_syntax_inits")
  if version < 508
    let did_help_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink helpExampleStart	helpIgnore
  HiLink helpIgnore		Ignore
  HiLink helpHyperTextJump	Subtitle
  HiLink helpHyperTextEntry	String
  HiLink helpHeadline		Statement
  HiLink helpHeader		PreProc
  HiLink helpSectionDelim	PreProc
  HiLink helpVim		Identifier
  HiLink helpExample		Comment
  HiLink helpOption		Type
  HiLink helpNotVi		Special
  HiLink helpSpecial		Special
  HiLink helpNote		Todo
  HiLink Subtitle		Identifier

  HiLink helpComment		Comment
  HiLink helpConstant		Constant
  HiLink helpString		String
  HiLink helpCharacter		Character
  HiLink helpNumber		Number
  HiLink helpBoolean		Boolean
  HiLink helpFloat		Float
  HiLink helpIdentifier		Identifier
  HiLink helpFunction		Function
  HiLink helpStatement		Statement
  HiLink helpConditional	Conditional
  HiLink helpRepeat		Repeat
  HiLink helpLabel		Label
  HiLink helpOperator		Operator
  HiLink helpKeyword		Keyword
  HiLink helpException		Exception
  HiLink helpPreProc		PreProc
  HiLink helpInclude		Include
  HiLink helpDefine		Define
  HiLink helpMacro		Macro
  HiLink helpPreCondit		PreCondit
  HiLink helpType		Type
  HiLink helpStorageClass	StorageClass
  HiLink helpStructure		Structure
  HiLink helpTypedef		Typedef
  HiLink helpSpecialChar	SpecialChar
  HiLink helpTag		Tag
  HiLink helpDelimiter		Delimiter
  HiLink helpSpecialComment	SpecialComment
  HiLink helpDebug		Debug
  HiLink helpUnderlined		Underlined
  HiLink helpError		Error
  HiLink helpTodo		Todo

  delcommand HiLink
endif

let b:current_syntax = "help"

" vim: ts=8 sw=2

"*****************************************************************************
"** Name:      help.vim - extend standard syntax highlighting for help      **
"**                                                                         **
"** Type:      syntax file                                                  **
"**                                                                         **
"** Author:    Christian Habermann                                          **
"**            christian (at) habermann-net (point) de                      **
"**                                                                         **
"** Copyright: (c) 2002-2004 by Christian Habermann                         **
"**                                                                         **
"** License:   GNU General Public License 2 (GPL 2) or later                **
"**                                                                         **
"**            This program is free software; you can redistribute it       **
"**            and/or modify it under the terms of the GNU General Public   **
"**            License as published by the Free Software Foundation; either **
"**            version 2 of the License, or (at your option) any later      **
"**            version.                                                     **
"**                                                                         **
"**            This program is distributed in the hope that it will be      **
"**            useful, but WITHOUT ANY WARRANTY; without even the implied   **
"**            warrenty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      **
"**            PURPOSE.                                                     **
"**            See the GNU General Public License for more details.         **
"**                                                                         **
"** Version:   1.0.1                                                        **
"**            tested under Linux and Win32, VIM and GVIM 6.2               **
"**                                                                         **
"** History:   0.1.0  12. Dec. 2002 - 21. Feb. 2003                         **
"**              initial version, not released                              **
"**            1.0.0   6. Apr. 2003                                         **
"**              no changes, first release                                  **
"**            1.0.1   3. Mar. 2004                                         **
"**              marker changed from 0xa7 to $ in order to avoid problems   **
"**              with fonts that use codes > 0x7f as multibyte characters   **
"**              (e.g. Chinese, Korean, Japanese... fonts)                  **
"**                                                                         **
"**                                                                         **
"*****************************************************************************
"** Description:                                                            **
"**   This syntax file extends the standard syntax highlighting for help    **
"**   files. This is needed in order to view the C-reference manual         **
"**   of the project CRefVim correctly.                                     **
"**   This syntax file is only active for the help file named               **
"**   "crefvim.txt". For other help files no extention on syntax            **
"**   highlighting is applied.                                              **
"**                                                                         **
"**   For futher information see crefvimdoc.txt or do :help crefvimdoc      **
"**                                                                         **
"**   Happy viming...                                                       **
"*****************************************************************************


" extend syntax-highlighting for "crefvim.txt" only (not case-sensitive)

if tolower(expand("%:t"))=="crefvim.txt"
    syn match helpCRVSubStatement  "statement[0-9Ns]*"   contained
    syn match helpCRVSubCondition  "condition[0-9]*"     contained
    syn match helpCRVSubExpression "expression[0-9]*"    contained
    syn match helpCRVSubExpr       "expr[0-9N]"          contained
    syn match helpCRVSubType       "type-name"           contained
    syn match helpCRVSubIdent      "identifier"          contained
    syn match helpCRVSubIdentList  "identifier-list"     contained
    syn match helpCRVSubOperand    "operand[0-9]*"       contained
    syn match helpCRVSubConstExpr  "constant-expression[1-9Ns]*" contained
    syn match helpCRVSubClassSpec  "storage-class-specifier"  contained
    syn match helpCRVSubTypeSpec   "type-specifier"      contained
    syn match helpCRVSubEnumList   "enumerator-list"     contained
    syn match helpCRVSubDecl       "declarator"          contained
    syn match helpCRVSubRetType    "return-type"         contained
    syn match helpCRVSubFuncName   "function-name"       contained
    syn match helpCRVSubParamList  "parameter-list"      contained
    syn match helpCRVSubReplList   "replacement-list"    contained
    syn match helpCRVSubNewLine    "newline"             contained
    syn match helpCRVSubMessage    "message"             contained
    syn match helpCRVSubFilename   "filename"            contained
    syn match helpCRVSubDigitSeq   "digit-sequence"      contained
    syn match helpCRVSubMacroNames "macro-name[s]*"      contained
    syn match helpCRVSubDirective  "directive"           contained


    syn match helpCRVignore     "\$[a-zA-Z0-9\\\*/\._=()\-+%<>&\^|!~\?:,\[\];{}#\'\" ]\+\$" contains=helpCRVstate
    syn match helpCRVstate      "[a-zA-Z0-9\\\*/\._=()\-+%<>&\^|!~\?:,\[\];{}#\'\" ]\+"   contained contains=helpCRVSub.*


    hi helpCRVitalic  term=italic cterm=italic gui=italic
    
    hi def link  helpCRVstate          Comment
    hi def link  helpCRVSubStatement   helpCRVitalic
    hi def link  helpCRVSubCondition   helpCRVitalic
    hi def link  helpCRVSubExpression  helpCRVitalic
    hi def link  helpCRVSubExpr        helpCRVitalic
    hi def link  helpCRVSubOperand     helpCRVitalic
    hi def link  helpCRVSubType        helpCRVitalic
    hi def link  helpCRVSubIdent       helpCRVitalic
    hi def link  helpCRVSubIdentList   helpCRVitalic
    hi def link  helpCRVSubConstExpr   helpCRVitalic
    hi def link  helpCRVSubClassSpec   helpCRVitalic
    hi def link  helpCRVSubTypeSpec    helpCRVitalic
    hi def link  helpCRVSubEnumList    helpCRVitalic
    hi def link  helpCRVSubDecl        helpCRVitalic
    hi def link  helpCRVSubRetType     helpCRVitalic
    hi def link  helpCRVSubFuncName    helpCRVitalic
    hi def link  helpCRVSubParamList   helpCRVitalic
    hi def link  helpCRVSubReplList    helpCRVitalic
    hi def link  helpCRVSubNewLine     helpCRVitalic
    hi def link  helpCRVSubMessage     helpCRVitalic
    hi def link  helpCRVSubFilename    helpCRVitalic
    hi def link  helpCRVSubDigitSeq    helpCRVitalic
    hi def link  helpCRVSubMacroNames  helpCRVitalic
    hi def link  helpCRVSubDirective   helpCRVitalic
    hi def link  helpCRVignore         Ignore
endif

" vim: ts=8 sw=2
