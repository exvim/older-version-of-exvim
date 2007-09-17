" Lexicon of contractions and other special items.
" For use with SpellChecker.vim.
" Author: Ajit J. Thakkar
" Last Change: 2003 Jan. 08

syn case match
" Contractions
syn match GoodWord "\<I\>"
if !exists("b:formal")
  syn match GoodWord "\<I'\(m\|ve\|d\|ll\)\>"
endif
" Initials
syn match GoodWord "\<\u\."
" Abbreviations
syn match GoodWord "\<\(et\_s\+al\|etc\|cf\|Ph\.D\|B\.Sc\|M\.Sc\|Dr\|Mrs\=\|Ms\|Jr\|e\.g\|i\.e\|pp\|Mon\|Tue\|Thu\|Fri\|Jan\|Feb\|Apr\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\)\."

syn case ignore
" Contractions
syn match GoodWord "\<\(can\|don\|haven\|he\|it\|she\|they\|we\|who\|won\|you\)\>"
if exists("b:formal")
  syn match BadWord "\<\(o\|m\|ve\|d\|ll\|re\|t\)\>"
  syn match BadWord "\<\(aren\|couldn\|didn\|doesn\|isn\|wasn\|wouldn\|ain\|hadn\|hasn\|mustn\|needn\|shan\|shouldn\|weren\)\>"
else
  syn match GoodWord "\<\(ma'am\|o'clock\)\>"
  syn match GoodWord "\<\(they\|we\|you\)'[vr]e\>"
  syn match GoodWord "\<\(he\|it\|she\|they\|we\|who\|you\)'\(ll\|d\)\>"
  syn match GoodWord "\<\(aren\|can\|couldn\|didn\|doesn\|don\|haven\|isn\|wasn\|won\|wouldn\|ain\|hadn\|hasn\|mustn\|needn\|shan\|shouldn\|weren\)'t\>"
endif
" Reserved vim syntax
syn match GoodWord "\<\(contains\|contained\|display\|extend\|fold\|skip\|transparent\)\>"
" Numbered lists
syn match GoodWord "\<\(i\{1,3}\|iv\|vi\{0,3}\|i\=x\))"
syn match GoodWord "\<\(b\|c\|d\|e\|f\|g\))"
" Prefixes and suffixes
syn match GoodWord "\<\(ex\|non\)-"
syn match GoodWord "'s\>"
" Abbreviations
syn match GoodWord "\<eqn\=s\=\."
syn match GoodWord "\<refs\=\."
if &ft == "tex"
  syn match GoodWord "\<\(st\|nd\|rd\|th\)\>"
endif
" URLs
syn match GoodWord "\<\(ht\|f\)tp://\S\+"
syn match GoodWord "\<\k\+@\S\+"
syn match GoodWord "\<mailto:"

" vim: set nowrap noma:
