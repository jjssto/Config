""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions used in the config file init.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This script may be shared in accordance with the GPLv3
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! f_init#addLine(symbol)

	if ( &textwidth is 0 )
		"return "\<Esc>o\<Esc>72i".a:symbol."\<Esc>o\<Esc>"
		let l:len=72
	else
		let l:len=&textwidth
		"return "\<Esc>o\<Esc>".&textwidth."i".a:symbol."\<Esc>o\<Esc>"
		"return <Esc>."o".<Esc>.&textwidth."i".a:symbol.<Esc>."o".<Esc>
	endif


	let l:string = a:symbol

	let l:i = 1 
	while l:i < l:len
	
		let l:string = l:string.a:symbol
		let l:i = l:i+1
	endwhile

	return l:string		
	
endfunction


function! f_init#My_Pandoc_Fun(options)

	let l:argument = ' -o '.expand('%:r').'.pdf '.a:options
	execute '!pandoc '.@%.' --from=markdown --to=latex --pdf-engine=xelatex '.l:argument
endfun


