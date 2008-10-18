" ======================================================================================
" File         : exSearchComplete.vim
" Author       : Wu Jie 
" Last Change  : 10/18/2008 | 18:32:07 PM | Saturday,October
" Description  : This script catches the <Tab> character when using the '/' search 
"                command.  Pressing Tab will expand the current partial word to the 
"                next matching word starting with the partial word.
"                If you want to match a tab, use the '\t' pattern.
" ======================================================================================

" check if plugin loaded
if exists('loaded_exsearchcomplete') || &cp
    finish
endif
let loaded_exsearchcomplete = 1

"/////////////////////////////////////////////////////////////////////////////
" Key mappings
"/////////////////////////////////////////////////////////////////////////////

noremap / :call g:ex_SearchCompleteStart()<CR>/


"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////


" ------------------------------------------------------------------ 
" Desc: Set mappings for search complete
" ------------------------------------------------------------------ 

function! g:ex_SearchCompleteStart() " <<<
	cnoremap <Tab> <C-R>=<sid>ex_SearchComplete()<CR>
	cnoremap <silent> <CR> <CR>:call g:ex_SearchCompleteStop()<CR>
	cnoremap <silent> <Esc> <C-C>:call g:ex_SearchCompleteStop()<CR>
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Tab completion in / search
" ------------------------------------------------------------------ 

function! s:ex_SearchComplete() " <<<
	let old_cmdline = getcmdline()
	let pos = getcmdpos()

	let search_end_col = col( "." )
	let search_start_col = search_end_col - strlen(old_cmdline)
    silent exec "normal b"
	let word_start_col = col( "." )

    let cur_word = expand('<cword>')
    let new_cmdline = strpart( cur_word, search_start_col-word_start_col )

    " TODO: make multi-TAB workable

	return substitute(old_cmdline, ".", "\<c-h>", "g") . new_cmdline
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Remove search complete mappings
" ------------------------------------------------------------------ 

function! g:ex_SearchCompleteStop() " <<<
	cunmap <Tab>
	cunmap <CR>
	cunmap <Esc>
endfunction " >>>

