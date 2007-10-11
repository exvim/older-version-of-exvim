syn region	exCppOut	start="^\s*\(%:\|#\)\s*if\s\+ff1\+\>" end=".\@=\|$" contains=exCppOut2
syn region	exCppOut2	contained start="ff1"  end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=exCppSkip
syn region	exCppSkip	contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=exCppSkip

hi def link exCppSkip    exCppOut
hi def link exCppOut2    exCppOut
hi exCppOut	 term=none cterm=none ctermfg=DarkGray gui=none guifg=DarkGray
