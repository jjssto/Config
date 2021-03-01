" Neovim configurations
"
" This file may be shared in accordance with the GPLv3




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Various settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" not compatible to vi
set nocompatible

" Pathogen
execute pathogen#infect()

syntax enable

" Ensure unicode support
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("multi_byte")
	if &termencoding == ""
		let &termencoding = &encoding
	endif
	set encoding=utf-8
	setglobal fileencoding=utf-8
	"setglobal bomb
	 set fileencodings=ucs-bom,utf-8,latin1
endif

" Setting some options
"
set textwidth=0
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set smartindent
set spelllang=de_CH
set nospell
set fo=ctrqn2jo
set spc=

set hidden

" syntax highlighting and color theme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

colorscheme solarized8

if has("syntax")
  syntax on
endif

if has("autocmd")
  filetype plugin indent on
  set omnifunc=syntaxcomplete#Complete
endif

" adapt syntax highligting for dark background
set background=dark



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Things happening if buffer changes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Loading plugins and indentation rules according to file type and use
" the templetes provided
function! GetSkeleton(templet)
	let l:dir="~/.config/nvim/templates/"
	let l:path=l:dir . a:templet
	exec '0r ' . l:path
	"let l:date_ = system('date -I')
	let l:date  = substitute(system('date -I'), '\n\+$', '', '')
	exec '%s/<+TODAY+>/' . l:date .'\ /g'
endfun

" If buffer modified, update any 'Last modified: ' in the first 20 lines.
" 'Last modified: ' can have up to 10 characters before (they are retained).
" Restores cursor and window position using save_cursor variable.
function! LastModified()
  if &modified
    let save_cursor = getpos(".")
    let n = min([20, line("$")])
    keepjumps exe '1,' . n . 's#^\(.\{,10}Last modified: \).*#\1' .
          \ strftime('%a %b %d, %Y  %I:%M%p') . '#e'
    call histdel('search', -1)
    call setpos('.', save_cursor)
  endif
endfun


" jump back to last position when opening a file
if has("autocmd")

	" Execute, when a new file is createt, and when it is opend
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" options for various filetypes
	autocmd BufNewFile,BufRead *.Rnw  set filetype=tex  syntax=rnoweb tw=80 fo-=t
	autocmd BufNewFile,BufRead *.Rscript  set filetype=r tw=80 fo-=t
	autocmd BufNewFile,BufRead *.image  set filetype=r tw=80 fo-=t
	autocmd BufNewFile,BufRead *.lmd  set filetype=markdown.pandoc tw=55 spell

	autocmd BufNewFile,BufRead *.md  set  tw=72 spell
	autocmd BufNewFile,BufRead *.txt  set  tw=72
	autocmd BufNewFile,BufRead *.adoc  set  tw=72 spell

	autocmd BufNewFile,BufRead *.sh  set tw=80 fo-=t
	autocmd BufNewFile,BufRead *.py  set tw=80 fo-=t
	autocmd BufNewFile,BufRead *.cpp  set tw=80 fo-=t
	autocmd BufNewFile,BufRead *.c  set tw=80 fo-=t
	autocmd BufNewFile,BufRead *.h  set tw=80 fo-=t
	autocmd BufNewFile,BufRead *.java  set tw=80 fo-=t
	autocmd BufNewFile,BufRead *.R  set tw=80 fo-=t

	" Execute, when a new file is created
	"""""""""""""""""""""""""""""""""""""""
	" Use skeleton files in ~/.config/nvim/templates/
	augroup templates
		autocmd BufNewFile *.sh call GetSkeleton("skeleton.sh")
    	autocmd BufNewFile *.py call GetSkeleton("skeleton.py")
    	autocmd BufNewFile *.lmd call GetSkeleton("skeleton_l.md")
    	autocmd BufNewFile *.md call GetSkeleton("skeleton.md")
    	autocmd BufNewFile *.adoc call GetSkeleton("skeleton.adoc")
	augroup END


	" Execute, when a file is opened
	"""""""""""""""""""""""""""""""""""""""
	" return cursor to the location it was when the file was closed
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


	" Execute, before a file is saved
	""""""""""""""""""""""""""""""""""""""
	"In html files put '%s/\(<!-- DATE -->\).\{-\}\d\d:\d\d:\d\d/\1' to insert a time stamp
	autocmd BufWritePre *.html exe "norm mz"|exe '%s/\(<!-- DATE -->\).\{-\}\d\d:\d\d:\d\d/\1'.strftime("%b %d, %Y %X")."/e"|norm `z

	" Update time stamp 'Last modified:'
	autocmd BufWritePre * call LastModified()

endif



" Various settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)

" let mapleader = "\\"
let mapleader = "'"
let maplocalleader = "]"

set number
set relativenumber

" Fixes weird character problem in some devel versions neovim underline
" tmux sesssion. This might go away in future.
set guicursor=



" Remove white background of status line at bottom of nvim viewport
" (default is 2)
set laststatus=1


" hide files in file browser
let g:netrw_list_hide= '\(^\|\s\s\)\zs\.\S\+'





" Settings for Latx-Suite and Rnw
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" settings for vim-latex
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:tex_pdfviewer='okular'
let g:Tex_DefaultTargetFormat='pdf'

let R_pdfviewer = "Okular"
let R_csv_app = 'tmux new-window scim --txtdelim="\t"'
" Ensures usage of your own ~/.tmux.conf file
let R_notmuxconf = 1

" Shows function arguments in a separate viewport during omni completion with Ctrl-x Ctrl-o:w
let R_show_args = 1

let R_in_buffer = 1 "0
let R_applescript = -1
let R_tmux_close = 0









""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keyboard shortcuts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" execute make
nnoremap <leader>mm :make<CR>

"" comand to switch of line numbering
map <F2> :set number<CR>

map <F3> :set number relativenumber<CR>

map <F4> :set nonumber norelativenumber<CR>

" "" comand to switch on fixed textwidth
" map <leader>0 :set textwidth=0<CR>
" map <leader>50 :set textwidth=50<CR>
" map <leader>60 :set textwidth=60<CR>
" map <leader>70 :set textwidth=70<CR>
" map <leader>72 :set textwidth=72<CR>
" map <leader>73 :set textwidth=73<CR>
" map <leader>74 :set textwidth=74<CR>
" map <leader>75 :set textwidth=75<CR>
" map <leader>76 :set textwidth=76<CR>
" map <leader>77 :set textwidth=77<CR>
" map <leader>78 :set textwidth=78<CR>
" map <leader>79 :set textwidth=79<CR>
" map <leader>80 :set textwidth=80<CR>

" Shortcut to execute the macro stored in register q
nnoremap <F9> @q


" Use Ctrl-Space to do omnicompletion
inoremap <C-Space> <C-x><C-o>

" Download mail using getmail
nnoremap <leader>m :!get_mail<CR>


" Terminal mode: get into normal mode by pressing <Esc>
tnoremap <Esc> <C-\><C-n>

" Reload the config file

nnoremap <leader>R :source ~/.config/nvim/init.vim<CR>

" Placeholder as in vim-latex
""""""""""""""""""""""""""""""

" Pressing Control-j jumps to the next match.
inoremap <c-j> <Esc>/<++><CR><Esc>cf>
inoremap <c-k> <Esc>?<++><CR><Esc>cf>





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lines & Formatting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"
" Shortcuts to create lines and stuff to structure text files and
" comments
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Lines
"
" Adds the same symbol n times and puts you on the next line (in normal
" mode)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Hashes (#)
inoremap <leader>,, <Home><C-R>=f_init#addLine("#")<C-M><CR>
nmap <leader>,, o<leader>,,

" Stars (*)
inoremap <leader>,. <Home><Space><Space><C-R>=f_init#addLine("*")<C-M><CR>
nmap <leader>,. o<leader>,.

inoremap <leader>.. <Home>/*<Space><C-R>=f_init#addLine("*")<C-M><CR>
nmap <leader>.. o<leader>..

" Double quotes (")
inoremap <leader>., <Home><C-R>=f_init#addLine("\"")<C-M><CR>
nmap <leader>., o<leader>.,

" Single quotes (')
inoremap <leader>,, <Home><C-R>=f_init#addLine("\'")<C-M><CR>
nmap <leader>,, o<leader>,,

" Semicolon (;)
inoremap <leader>;; <Home><C-R>=f_init#addLine(";")<C-M><CR>

" Colon (:)
inoremap <leader>:: <Home><C-R>=f_init#addLine(":")<C-M><CR>

" Slashes (/)
inoremap <leader>// <Home><C-R>=f_init#addLine("/")<C-M><CR>
nmap <leader>,, o<leader>//


nmap <leader>// o<leader>//


" Bullet points & arrows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap <leader>= <Space>-><Space>
nnoremap <leader>= o<Space>-><Space>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings for plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" " Nvim-R
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " start R with F2 key
" map <F2> <Plug>RStart
" imap <F2> <Plug>RStart
" vmap <F2> <Plug>RStart
" 
" " R version:
" " let vimrplugin_r_path = "/opt/R/3.1.2-release/bin/R"
" 
" " Send selection or line to R with space bar, respectively.
" vmap <Space> <Plug>RDSendSelection
" nmap <Space> <Plug>RDSendLine
" 
" " Shortcut for R's assignment operator: 0 turns it off; 1 assigns underscore; 2 assigns two underscores
" let R_assign = 2
" 
" 
" 
"  " Settings for vimcmdline
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" " vimcmdline mappings
" let cmdline_map_start          = '<LocalLeader>s'
" let cmdline_map_send           = '<Space>'
" let cmdline_map_send_and_stay  = '<LocalLeader><Space>'
" let cmdline_map_source_fun     = '<LocalLeader>f'
" let cmdline_map_send_paragraph = '<LocalLeader>p'
" let cmdline_map_send_block     = '<LocalLeader>b'
" let cmdline_map_quit           = '<LocalLeader>q'
" 
" " vimcmdline options
" let cmdline_vsplit      = 1      " Split the window vertically
" let cmdline_esc_term    = 1      " Remap <Esc> to :stopinsert in Neovim's terminal
" let cmdline_in_buffer   = 1      " Start the interpreter in a Neovim's terminal
" let cmdline_term_height = 15     " Initial height of interpreter window or pane
" let cmdline_term_width  = 80     " Initial width of interpreter window or pane
" let cmdline_tmp_dir     = '/tmp' " Temporary directory to save files
" let cmdline_outhl       = 1      " Syntax highlight the output
" let cmdline_auto_scroll = 1      " Keep the cursor at the end of terminal (nvim)<Paste>
" 
" let cmdline_app           = {}
" let cmdline_app['ruby']   = 'pry'
" let cmdline_app['sh']     = 'bash'
" let cmdline_app['python'] = 'python3'
" 
" if has('gui_running') || &termguicolors
"     let cmdline_color_input    = '#9e9e9e'
" 	let cmdline_color_normal   = '#00afff'
" 	let cmdline_color_number   = '#00ffff'
" 	let cmdline_color_integer  = '#00ffff'
" 	let cmdline_color_float    = '#00ffff'
" 	let cmdline_color_complex  = '#00ffff'
" 	let cmdline_color_negnum   = '#d7afff'
" 	let cmdline_color_negfloat = '#d7afff'
" 	let cmdline_color_date     = '#00d7af'
" 	let cmdline_color_true     = '#5fd787'
" 	let cmdline_color_false    = '#ff5f5f'
" 	let cmdline_color_inf      = '#00afff'
" 	let cmdline_color_constant = '#5fafff'
" 	let cmdline_color_string   = '#5fd7af'
" 	let cmdline_color_stderr   = '#0087ff'
" 	let cmdline_color_error    = '#ff0000'
" 	let cmdline_color_warn     = '#c0ffff'
" 	let cmdline_color_index    = '#d7d787'
" elseif &t_Co == 256
" 	let cmdline_color_input    = 247
" 	let cmdline_color_normal   =  39
" 	let cmdline_color_number   =  51
" 	let cmdline_color_integer  =  51
" 	let cmdline_color_float    =  51
" 	let cmdline_color_complex  =  51
" 	let cmdline_color_negnum   = 183
" 	let cmdline_color_negfloat = 183
" 	let cmdline_color_date     =  43
" 	let cmdline_color_true     =  78
" 	let cmdline_color_false    = 203
" 	let cmdline_color_inf      =  39
" 	let cmdline_color_constant =  75
" 	let cmdline_color_string   =  79
" 	let cmdline_color_stderr   =  33
" 	let cmdline_color_error    =  15
" 	let cmdline_color_warn     =   1
" 	let cmdline_color_index    = 186
" endif
" 
" let cmdline_color_error = 'ctermfg=1 ctermbg=15 guifg=#c00000 guibg=#ffffff gui=underline term=underline'
" let cmdline_follow_colorscheme = 1
" let cmdline_tmux_conf = "~/vimcmdline_tmux.conf"
" 
" 
" 
" " Ncm2
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" " suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" " found' messages
" set shortmess+=c
" 
" " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
" inoremap <c-c> <ESC>
" 
" " When the <Enter> key is pressed while the popup menu is visible, it only
" " hides the menu. Use this mapping to close the menu and also start a new
" " line.
" inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" 
" " Use <TAB> to select the popup menu:
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" 
" " wrap existing omnifunc
" " Note that omnifunc does not run in background and may probably block the
" " editor. If you don't want to be blocked by omnifunc too often, you could
" " add 180ms delay before the omni wrapper:
" "  'on_complete': ['ncm2#on_complete#delay', 180,
" "               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
" au User Ncm2Plugin call ncm2#register_source({
"         \ 'name' : 'css',
"         \ 'priority': 9,
"         \ 'subscope_enable': 1,
"         \ 'scope': ['css','scss'],
"         \ 'mark': 'css',
"         \ 'word_pattern': '[\w\-]+',
"         \ 'complete_pattern': ':\s*',
"         \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
"         \ })
" 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting for Pandoc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists(":PP")
	command PP call f_init#My_Pandoc_Fun("")
endif

if !exists(":PPN")
	command PPN call f_init#My_Pandoc_Fun("-N")
endif

noremap <leader>nn :execute('!zathura '.expand('%:r').'.pdf &' )<CR>

" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " NotMuch
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:notmuch_folders = [
" 		\ [ 'inbox', 'tag:inbox' ],
" 		\ [ 'to_do: heute', 'tag:heute' ],
" 		\ [ 'to_do: später', 'tag:heute or tag:woche or tag:monat or tag:info' ],
" 		\ [ 'termine', 'tag:termin' ],
" 		\ [ 'erledigt', 'tag:erledigt' ],
" 		\ [ 'admin', 'tag:registrationen and tag:bestellung and tag:finanzen' ],
" 		\ [ 'system', 'tag:system' ],
" 		\ [ 'mailinglists', 'tag:lists' ],
" 		\ [ 'unread', 'tag:unread' ],
" 		\ [ 'Papierkorb', 'tag:deleted' ],
" 		\ [ 'Spam', 'tag:spam' ],
" 		\ [ 'watch', 'tag:watch' ],
" 		\ [ 'sent', 'tag:sent' ],
" 		\ ]
" 
" let g:notmuch_custom_search_maps = {
" 		\ '1':		'search_tag("+heute")',
" 		\ '2':		'search_tag("+woche")',
" 		\ '3':		'search_tag("+monat")',
" 		\ '4':		'search_tag("+info")',
" 		\ '5':		'search_tag("+termin")',
" 		\ '!':		'search_tag("-heute")',
" 		\ '@':		'search_tag("-woche")',
" 		\ '#':		'search_tag("-monat")',
" 		\ '$':		'search_tag("-info")',
" 		\ '%':		'search_tag("-termin")',
" 		\ '^':		'search_tag("-erledigt")',
" 		\ }
" let g:notmuch_custom_show_maps = {
" 		\ '1':		'show_tag("+heute")',
" 		\ '2':		'show_tag("+woche")',
" 		\ '3':		'show_tag("+monat")',
" 		\ '4':		'show_tag("+info")',
" 		\ '5':		'show_tag("+termin")',
" 		\ '!':		'show_tag("-heute")',
" 		\ '@':		'show_tag("-woche")',
" 		\ '#':		'show_tag("-monat")',
" 		\ '$':		'show_tag("-info")',
" 		\ '%':		'show_tag("-termin")',
" 		\ '^':		'show_tag("-erledigt")',
" 		\ }
" 
" let g:notmuch_date_format = '%d.%m.%y'
" let g:notmuch_sendmail = '/usr/bin/msmtp'
" let g:notmuch_reader = 'mutt -f %s'
" 
" 
" 
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Setting for vim-table
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" " Make all tables Vim-Panoc compatible (ft specific rule in
" " /bundle/ftplugin)
" let g:table_mode_corner_corner='+'
" let g:table_mode_corner='+'
" let g:table_mode_header_fillchar='='
" 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Inserting dots 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

unmap! 005
unmap! 015
unmap! 025
unmap! 035
unmap! 045
unmap! 055

unmap! 001
unmap! 010
unmap! 000   
unmap! 099
      

nnoremap 001 a○<ESC>
nnoremap 011 a●<ESC>

nnoremap 002 a○○<ESC>
nnoremap 012 a●○<ESC>
nnoremap 022 a●●<ESC>

nnoremap 003 a○○○<ESC>
nnoremap 013 a●○○<ESC>
nnoremap 023 a●●○<ESC>
nnoremap 033 a●●●<ESC>

nnoremap 004 a○○○○<ESC>
nnoremap 014 a●○○○<ESC>
nnoremap 024 a●●○○<ESC>
nnoremap 034 a●●●○<ESC>
nnoremap 044 a●●●●<ESC>

nnoremap 005 a○○○○○<ESC>
nnoremap 015 a●○○○○<ESC>
nnoremap 025 a●●○○○<ESC>
nnoremap 035 a●●●○○<ESC>
nnoremap 045 a●●●●○<ESC>
nnoremap 055 a●●●●●<ESC>


nnoremap 000 r○<ESC>l
nnoremap 099 r●<ESC>l


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting for external programms
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
