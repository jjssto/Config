setlocal filetype = python

setlocal textwidth=0
setlocal expandtab
setlocal tabstop=8
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

setlocal modeline



"let g:deoplete#enable_at_startup = 1
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

"inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"


" option for jedi auto completion
let g:jedi#popup_on_dot`= 1

" use jedi autocompletion, 
let g:jedi#completions_enabled = 1

let g:jedi#use_tabs_not_buffers = 1
let g:jedi#smart_auto_mappings = 1

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "down"

"let g:neomake_python_enabled_makers = ['pylint']

"call neomake#configure#automake('nrwi', 500)
