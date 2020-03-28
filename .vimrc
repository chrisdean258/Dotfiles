" CONFIGURATION SETTINGS {{{
"_______________________________________________________________________________________________________

	:syntax on                              " Syntax highlighting
	:set nowrap                             " Dont wrap text to newlines
	:set number                             " Show line numbers
	:set relativenumber                     " show line numbers relative to your current line
	:colorscheme elflord                    " Hells yeah elflord

	:set scrolloff=5                        " Keep cursor 5 lines in
	:set sidescroll=1                       " Move one character at a time off the screen rather than jumping
	:set sidescrolloff=5                    " Keep the cursor 5 characters from the left side of the screen
	:set softtabstop=-1                     " Keep defaults to shiftwidth
	:set shiftwidth=0                       " defaults to tabstop

	:set ttyfast
	:set nocompatible                       " We're not using vi
	:set autoindent                         " automatically indent
	:set smartindent                        " Increase indent in a smart way
	:set showcmd                            " show partial command before you finish typing it
	:set wildmenu                           " show menu of completeion on command line
	:set incsearch hlsearch                 " turn on search highlighting
	:filetype plugin indent on              " indenting by filetype
	:set path+=**                           " Cheap fuzzy find

	:if &filetype !~ "vim"
	:  setlocal nofoldenable                " Turn off folding except in vim files
	:endif
	:setlocal foldtext=MyFold()             " Show foldtext based on my function

	:set splitright                         " Split to the right
	:set splitbelow                         " Split to below

	:set tag=./tags,./TAGS,tags             " Add a bunch of tag files that can be looked at
	:set tags+=./tags;$HOME
	:set tags+=./.tags;$HOME

	" Just ignoring a lot of files you normally dont want to open in vim
	:set wildignore=*.o,*~,*.pyc
	:set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

	:set infercase                           " for insert completion
	:set autoread                            " reads from disk if no modification in buffer
	:set switchbuf=usetab                    " default to jumping to a new tab
	:set hidden                              " hide buffers instead of closing
	:set tabpagemax=1000                     " Vim can handle a lot of tags
	:set pumheight=15                        " Only see 15 options on completion
	:set shortmess+=atI                      " Make more messages short
	:set encoding=utf-8                      " use utf-8 everywhere
	:set fileencoding=utf-8                  " use utf-8 everywhere
	:set termencoding=utf-8                  " use utf-8 everywhere
	:set cinoptions=(8,N-s,l1,t0             " indent 8 for every open paren
	:if getcwd() == expand("~")              " Turn off included file completion for home directory stuff
	:  set complete-=it
	:endif
	:set matchpairs+=<:>                     " adding a matched pair for highlighting and wrapping
	:set ttyfast

	" Create needed folders for backups and undo files
	:if !isdirectory($HOME . "/.vim/backup")
	:  call mkdir($HOME . "/.vim/backup", "p")
	:endif
	:if !isdirectory($HOME . "/.vim/undo")
	:  call mkdir($HOME . "/.vim/undo", "p")
	:endif

	" Set the directory to store backups and undos
	:set backupdir=~/.vim/backup//
	:set undodir=~/.vim/undo//
	
	" Set up undo
	:set undofile
	:set undolevels=1000
	:set undoreload=10000
	:set backup
	:set wildmode=longest,list,full
" }}}

" HIGHLIGHT SETTINGS {{{
"_______________________________________________________________________________________________________

	:function! HighLightSettings()
	" Setting for using Highlight after function
	:highlight LongLine guifg=Red ctermfg=Red
 	:highlight Folded None
	:highlight Folded ctermfg=Black guifg=Black

	" Settings for tabline
	:highlight tablinefill None
	:highlight tablinesel None
	:highlight tabline None
	:highlight tablinesel ctermfg=DarkGrey guifg=DarkGrey
	:highlight tabline ctermfg=black guifg=black

	" Settings for spell
	:highlight spellrare None
	:highlight spellcap None
	:highlight spelllocal None
	:if get(g:, "light_folds", 1)
	:  highlight Folded ctermfg=DarkGrey guifg=DarkGrey
	:  highlight tabline ctermfg=DarkGrey guifg=DarkGrey
	:  highlight tablinesel ctermfg=Grey guifg=Grey
	:endif
	:endfunction
	:call HighLightSettings()

" }}}

" PLUGIN SETTINGS {{{
"_______________________________________________________________________________________________________

	" Function to install syntastic if it isnt already there
	:function! SourceOrInstallSyntastic()
	:  try
	:    execute pathogen#infect()
	:  catch
	:    if executable("git") != 1 || executable("curl") != 1
	:      echom "You need git and curl installed for the Syntastic auto install"
	:      return
	:    endif
	:    silent !mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim &> /dev/null
	:    silent !cd ~/.vim/bundle && git clone --depth=1 https://github.com/vim-syntastic/syntastic.git &> /dev/null
	:    execute pathogen#infect()
	:  endtry
	:endfunction

	" Linting c/c++
	" Some of this stuff has to do with my research like anything to do with eo
	:let g:syntastic_check_on_wq = 0
	:let g:syntastic_cpp_compiler = "g++"
	" :let g:syntastic_cpp_compiler_options = "-std=c++98 -Wall"
	:let g:syntastic_cpp_include_dirs = [ "../../include",  "../include", "include", ".", $HOME."/include"]

	" Linting python
	:if executable("flake8")
	:  let g:syntastic_python_checkers = [ "flake8" ]
	:endif
	:let g:syntastic_tex_checkers = []
	" :let g:syntastic_python_flake8_args=['--ignore=F841,F405,F403,F402,F401']
	" :let g:syntastic_quiet_messages = { "type": "style" }
	" :let g:syntastic_quiet_messages = { 'regex': "space" }
	:let g:syntastic_tex_chktex_args = ["--nowarn", "39"]
	:let g:syntastic_always_populate_loc_list = 1
	:let g:syntastic_loc_list_height= 3

	" Turn off Syntastic Errors
	:cabbrev jk SyntasticReset

" }}}

" UNIVERSAL MAPPINGS {{{
"_______________________________________________________________________________________________________

	"mapleader
	:let mapleader = " "
	:let maplocalleader = '\'

	" move up and down visually rather than linewise
	:nnoremap j gj
	:nnoremap k gk
	:nnoremap gI g^i

	" Use jk instead of escape
	:inoremap <expr> jk CleverEsc()
	:imap Jk jk
	:imap JK jk
	:noremap <space> <nop>
	:imap <C-z> jk<C-z>i

	" insert a single char
	" use the s<F12> mapping to prevent evaluation of the macro until another character is input
	:nnoremap <silent><expr>s SingleInsert("i")
	:nnoremap <silent><expr>S SingleInsert("a")
	:nnoremap <silent>s<F12> <nop>
	:nnoremap <silent>S<F12> <nop>

	" Repeat mappings
	" allow for repeated wrapping
	:nnoremap <silent>. :call RepeatFunc()<CR>.

	" move lines up and down respectively
	:nnoremap <expr>- MoveLineDown()
	:nnoremap <expr>_ MoveLineUp()

	" indent entire file
	:nnoremap <silent><leader>g :call Indent()<CR>

	" edit and reload vimrc
	:nnoremap <silent><leader>ev :vsplit $MYVIMRC<CR>
	:nnoremap <silent><leader>sv :silent source $MYVIMRC<CR>
	:nnoremap <silent><leader>s% :source %<CR>

	" add an empty line right above or below current line
	:nnoremap <leader>o o<esc>
	:nnoremap <leader>O O<esc>

	" clear highlighting from search
	:nnoremap <silent><c-L> :nohlsearch<CR><c-L>
	" Turn on highlighting every time you research or look for the next item
	" Also centers found item on page
	:nnoremap n :set hlsearch<cr>nzz
	:nnoremap N :set hlsearch<cr>Nzz
	:nnoremap / :set hlsearch<cr>/
	:nnoremap ? :set hlsearch<cr>?
	:nnoremap # :set hlsearch<cr>#zz
	:nnoremap * :set hlsearch<cr>*zz

	" mapping for jumping to error
	:nnoremap <silent><A-up>    :lnext<CR>
	:nnoremap <silent><A-down>  :lprev<CR>
	:nnoremap <silent><A-left>  :lfirst<CR>
	:nnoremap <silent><A-right> :llast<CR>

	" Wrapping magic 
	" allows you to target text and wrap it in characters repeatably
	:nnoremap <silent><leader>w :set opfunc=Wrap<CR>g@
	:vnoremap <silent><leader>w :call Wrap("visual")<CR>

	:nnoremap <silent><leader>sw :set opfunc=SwapArgs<CR>g@
	:vnoremap <silent><leader>sw :call SwapArgs("visual")<CR>

	" Resizing split
	:nnoremap <silent><S-right> :vertical resize +5 <CR>
	:nnoremap <silent><S-left>  :vertical resize -5 <CR>
	:nnoremap <silent><S-up>    :resize +5 <CR>
	:nnoremap <silent><S-down>  :resize -5 <CR>

	" Jumping splits 
	:nnoremap <leader>h <c-w>h
	:nnoremap <leader>j <c-w>j
	:nnoremap <leader>k <c-w>k
	:nnoremap <leader>l <c-w>l

	" creating and navigating tabs
	:nnoremap <silent><S-tab>       :tabnext<CR>
	:nnoremap <silent><S-q>         :tabprevious<CR>
	:nnoremap <silent><leader><tab> :tabnew<CR>

	" Pasting from clipboard
	:nnoremap <leader>p "+p
	:nnoremap <leader>P "+P

	" TODO The yanking operations
	:nnoremap Y y$

	" Use control j and k to navigate pop up menu
	:inoremap <expr> <tab>   (pumvisible()?"\<C-p>":CleverTab())
	:inoremap <expr> <S-tab> (pumvisible()?"\<C-n>":"\<c-x>\<c-f>")
			
	" Commenting out lines
	:nnoremap <silent><localleader>\ :call Comment()<CR>
	:vnoremap <silent><localleader>\ :call Comment("visual")<CR>

	" Paste mode
	:nnoremap \p :set paste<CR>
	:inoremap \p <esc>:set paste<CR>i

	" splitting into a file
	:nnoremap <leader>v :vs <cfile><CR>
	:nnoremap <leader>t :tabnew <cfile><CR>

	" Statistics
	:nnoremap <leader><space> g<c-g>

	" Opening files
	:inoremap gqq <esc>gqqA
	:nnoremap VJ Vj
	:nnoremap VJJ Vjj
	:nnoremap VJJJ Vjjj

	:nnoremap <C-p> :vs<CR><C-]>
" }}}

" UNIVERSAL ABBREVIATIONS AND COMMANDS {{{
"_______________________________________________________________________________________________________

	" Vertical splitting is better than horizontal splitting
	:cabbrev help <C-R>=CommandLineStart(":", "vert help", "help")<CR>
	:cabbrev sp <C-R>=CommandLineStart(":", "vs", "sp")<CR>
	:cabbrev sf <C-R>=CommandLineStart(":", "vert sf", "sf")<CR>
	:cabbrev vf <C-R>=CommandLineStart(":", "vert sf", "vf")<CR>
	:cabbrev find <C-R>=CommandLineStart(":", "Find", "find")<CR>

	" Quitting cause Im bad at typing
	:cabbrev W <C-R>=CommandLineStart(":", "w", "W")<CR>
	:cabbrev Q <C-R>=CommandLineStart(":", "q", "Q")<CR>
	:cabbrev Wq <C-R>=CommandLineStart(":", "wq", "Wq")<CR>
	:cabbrev WQ <C-R>=CommandLineStart(":", "wq", "WQ")<CR>

	" Expanding for substitutions
	:cabbrev S <C-R>=CommandLineStart(":", "%s", "S")<CR>
	:cabbrev a <C-R>=CommandLineStart(":", "'a,.s", "a")<CR>
	:cabbrev $$ <C-R>=CommandLineStart(":", ".,$s", "$$")<CR>
	:cabbrev Q! <C-R>=CommandLineStart(":", "q!", "Q!")<CR>
	" :cabbrev term term ++close ++rows=15

	" Force writing
	if !has('win32')
		:cabbrev w!! %!sudo tee > /dev/null %
	endif

	" Making a tags file for jumping
	:command! MakeTags !ctags -Rf .tags --exclude=.session.vim

	" Turn on folding
	:command! Fold :setlocal foldenable | setlocal foldmethod=syntax

	:command! Compile :call Compile()
	:command! Template :call NewFile()
	:command! -nargs=1 -complete=file_in_path Find :call Find("<args>")

" }}}

" AUTOCMD GROUPS  {{{
"_______________________________________________________________________________________________________
 " {{{
:if has("autocmd")
" }}}

	" Universal
	" {{{
	:augroup Universal
	:autocmd!
	:autocmd BufNewFile *  :autocmd BufWritePost * :call IfScript() " Mark files with shebang as executable
	:autocmd BufRead *     :setlocal formatoptions-=cro " turn off autocommenting
	:autocmd BufNewFile *  :setlocal formatoptions-=cro " turn off autocommenting
	:autocmd BufRead *     :call CorrectFile()
	:autocmd BufNewFile *  :call CorrectFile()
	:autocmd VimEnter *    :setlocal formatoptions-=cro " turn off autocommenting
	:autocmd CursorHold *  :if get(g:, "hltimeout", 1) | set nohlsearch | endif " turn off search highlighting after a few seconds of nonuse
	:autocmd InsertLeave * :setlocal nopaste            " Turn off paste when leaving insert mode
	:autocmd BufReadPost * :if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal! g'\"" | endif " Jump to where you were in a file
	:autocmd VimEnter *    :let &commentstring = Strip(substitute(&commentstring, '\s*%s\s*', ' %s ', ''))
	:autocmd SwapExists *  :call SwapExists()
	:autocmd BufNewFile *  :call NewFile()
	:autocmd VimLeave *    :call SaveSess()
	:autocmd VimEnter * nested call RestoreSess()
	:autocmd VimEnter *    :call HighLightSettings()
	:augroup END
	" }}}

	" Option Autocmds
	" {{{
	:if exists("##OptionSet")
	:augroup Options
	:autocmd!
	:autocmd OptionSet relativenumber :let &number=&relativenumber   " Turn on and off number when we toggle reelative number
	:autocmd OptionSet wrap           :let &linebreak=&wrap          " break on words when were wrapping
	:autocmd OptionSet spell          :setlocal spelllang=en         " set spell language when we turn on spell
	:autocmd OptionSet spell          :syntax spell toplevel
	:autocmd OptionSet spell          :nnoremap <silent><buffer><localleader>s :call SpellReplace()<CR>
	:autocmd OptionSet spell          :inoremap <silent><buffer><localleader>s <esc>:call SpellReplace()<CR>a
	:augroup END
	:endif
	" }}}

	" C style formatting
	" {{{ 
	:augroup c_style
	:  autocmd!
	:  autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <silent><buffer><localleader>s :call SplitIf()<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <silent><buffer>; :call AppendSemicolon()<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :inoremap <buffer>{} {<CR>}<esc>O
	:  autocmd FileType c,cpp,javascript,java,perl,cs :setlocal cindent
	:  autocmd FileType c,cpp,javascript,java,perl,cs :iabbrev <buffer>csign <c-r>=Csign()<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :call RemoveTrailingWhitespace_AU()
	:  autocmd FileType c,cpp,javascript,java,perl,cs :command! Format :call CFormat()
	:  autocmd FileType c,cpp,javascript,java,perl,cs :call CFold()
	:augroup END
	" }}}

	" C/cpp specific
	" {{{
	:augroup c_cpp
	:  autocmd!
	:  autocmd FileType c,cpp  :setlocal complete+=t
	:  autocmd FileType c,cpp  :iabbrev <buffer> #i #include
	:  autocmd FileType c,cpp  :iabbrev <buffer> #I #include
	:  autocmd FileType c,cpp  :iabbrev <buffer> #d #define
	:  autocmd FileType c,cpp  :iabbrev <buffer> #D #define
	:  autocmd FileType c,cpp  :iabbrev <buffer> cahr char
	:  autocmd FileType c,cpp  :iabbrev <buffer> main <C-R>=CMainAbbrev()<CR>
	:  autocmd FileType cpp    :iabbrev <buffer> enld endl
	:  autocmd FileType cpp    :iabbrev <buffer> nstd using namespace std;<CR>
	:  autocmd FileType cpp    :autocmd CursorMoved,CursorMovedI <buffer> call HighlightAfterColumn(100)
	:  autocmd FileType cpp    :setlocal syntax=cpp
	:  autocmd FileType c      :autocmd CursorMoved,CursorMovedI <buffer> call HighlightAfterColumn(80)
	:  autocmd FileType c      :setlocal commentstring=/*\ %s\ */
	:augroup END
	" }}}

	" Java
	" {{{
	:augroup java
	:  autocmd!
	:  autocmd FileType java  :SyntasticToggle
	:  autocmd FileType java  :nnoremap <localleader>c :SyntasticCheck<CR>
	:augroup END
	" }}}

	" Web
	" {{{
	:augroup web
	:  autocmd!
	:  autocmd FileType html,php,htmldjango :setlocal tabstop=2
	:  autocmd FileType html,php,htmldjango :setlocal expandtab
	:  autocmd FileType html,php,htmldjango :setlocal wrap
	:  autocmd FileType html,php,htmldjango :setlocal linebreak
	:  if exists("+breakindent")
	:    autocmd FileType html,php,htmldjango :setlocal breakindent
	:  endif
	:  autocmd FileType html,php,htmldjango :inoremap <silent><buffer>> ><esc>:call EndTagHTML()<CR>a
	:  autocmd FileType html,php,htmldjango :inoremap <expr><buffer><CR> HTMLCarriageReturn()
	:let g:html_indent_script1 = "inc"
	:let g:html_indent_style1 = "inc"
	:let g:html_indent_inctags = "address,article,aside,audio,blockquote,canvas,dd,div,dl,fieldset,figcaption,figure,footer,form,h1,h2,h3,h4,h5,h6,header,hgroup,hr,main,nav,noscript,ol,output,p,pre,section,table,tfoot,ul,video"
	:  autocmd FileType html,php,htmldjango :command! Preview call HTMLPreview()
	:  autocmd FileType css,php :nnoremap <silent><buffer>; :call AppendSemicolon()<CR>
	:  autocmd FileType css :inoremap <buffer>{} {<CR>}<esc>O
	:augroup END
	" }}}

	" Tex
	" {{{
	:augroup web
	:  autocmd BufNew *.tex  :setlocal filetype=tex
	:  autocmd BufRead *.tex :setlocal filetype=tex
	:  autocmd FileType tex :setlocal tabstop=2
	:  autocmd FileType tex :setlocal expandtab
	:  autocmd FileType tex :setlocal wrap
	:  autocmd FileType tex :setlocal linebreak
	:  autocmd FileType tex :setlocal indentexpr=LatexIndent()
	:  if exists("+breakindent")
	:    autocmd FileType tex :setlocal breakindent
	:  endif
	:  autocmd FileType tex :inoremap <buffer> \pa \pa 
	:  autocmd FileType tex :inoremap <expr><buffer><CR> LatexCarriageReturn()
	:  autocmd FileType tex :inoremap <expr><buffer>{ (strlen(getline('.')) + 1 == col('.')) ? "{}\<left>" : "{"
	:  autocmd FileType tex :inoremap <expr><buffer>} (getline(".")[col(".")-1] == "}") ? "\<right>" : "}"
	:  autocmd FileType tex :nnoremap <buffer> <leader>m mqlBi$<esc>Ea$<esc>`q
	:  autocmd FileType tex :nnoremap <buffer>; :call LatexBackslashBeginning()<CR>
	:  autocmd FileType tex :command! Preview call LatexPreview()
	:  autocmd FileType tex :let g:tex_flavor = 'latex'
	:  autocmd FileType tex :iabbrev eqiv equiv
	:  autocmd FileType tex :inoremap \sum \sum
	:  autocmd FileType tex :inoremap \sec \sec
	:  autocmd FileType tex :inoremap \pau \pau
	:augroup END
	" }}}

	" Python formatting
	" {{{
	:augroup python_
	:autocmd!
	:autocmd FileType python  :setlocal tabstop=4
	:autocmd FileType python  :setlocal expandtab
	:autocmd FileType python  :setlocal nosmartindent
	:autocmd FileType python  :setlocal complete-=i
	:autocmd FileType python  :iabbrev inport import
	:autocmd FileType python  :call RemoveTrailingWhitespace_AU()
	:autocmd FileType python  :iabbrev <buffer> main <C-R>=PythonMainAbbrev()<CR>
	:autocmd FileType python  :let g:pyindent_open_paren = '&sw'
	:autocmd FileType python  :let g:pyindent_nested_paren = '&sw'
	:autocmd FileType python  :let g:pyindent_continue = '0'
	:autocmd FileType python  :autocmd BufEnter <buffer> :if getline(1) !~ '^#' | call append(0, "#!/usr/bin/env python3") | endif
	:autocmd FileType python  :autocmd CursorMoved,CursorMovedI <buffer> call HighlightAfterColumn(79)
	:autocmd FileType python  :autocmd BufWrite <buffer> :call PythonBlankLineFix()
	:augroup END
	" }}}

	" Vim file
	" {{{
	:augroup vim_
	:autocmd!
	:autocmd FileType vim :setlocal foldmethod=marker
	:autocmd FileType vim :setlocal foldenable
	:autocmd FileType vim :setlocal foldtext=MyFold()
	:autocmd BufWritePost .vimrc :source %
	:augroup END
	" }}}

	" Markdown
	" {{{
	:augroup Markdown
	:autocmd!
	:autocmd Filetype markdown :autocmd InsertLeave <buffer> :call MDCapitals()
	:autocmd FileType markdown :autocmd InsertLeave <buffer> :call CheckMD()
	:autocmd Filetype markdown :inoremap <buffer><tab> <c-r>=MDTab(CleverTab())<CR>
	:autocmd Filetype markdown :inoremap <silent><buffer><CR> <c-r>=MDNewline("\r")<CR>
	:autocmd Filetype markdown :nmap <silent><buffer>o A<CR>
	:autocmd Filetype markdown :inoremap <silent><buffer><localleader>s <esc>:call SpellReplace()<CR>a
	:autocmd Filetype markdown :nnoremap <silent><buffer><localleader>s :call SpellReplace()<CR>
	:autocmd FileType markdown :setlocal spelllang=en
	:autocmd Filetype markdown :setlocal nospell
	:autocmd Filetype markdown :setlocal wrap
	:autocmd Filetype markdown :setlocal linebreak
	:autocmd Filetype markdown :setlocal commentstring=<!--\ %s\ -->
	:if exists("+breakindent")
	:  autocmd Filetype markdown :setlocal breakindent
	:endif
	:autocmd Filetype markdown :cabbrev markdown call NotesMDFormat()
	:autocmd FileType markdown :command! Preview call MDPreview()
	:autocmd FileType markdown :call CheckMD()
	:autocmd FileType markdown :setlocal expandtab
	:autocmd FileType markdown :setlocal tabstop=4
	:augroup END
	" }}}

	" txt files
	" {{{
	:augroup Text
	:autocmd!
	:autocmd FileType text :setlocal spell
	:autocmd FileType text :setlocal wrap
	:autocmd FileType text :setlocal linebreak
	:autocmd FileType text :setlocal syntax=
	:if exists("+breakindent")
	:  autocmd FileType text :setlocal breakindent
	:endif
	:augroup END
	" }}}

	" Assembly
	" {{{
	:augroup Assembly
	:autocmd!
	:  autocmd FileType assembly,asm :setlocal commentstring=//\ %s
	:  autocmd FileType assembly,asm :iunmap <tab>
	:augroup END
	" }}}

	" Yacc
	" {{{
	:augroup yacc
	:  autocmd VimEnter *.y :doautocmd Filetype c | doautocmd Filetype yacc
	:augroup END
	" }}}

	" LD
	" {{{
	:augroup ld
	:  autocmd FileType ld :inoremap <buffer>{} {<CR>}<esc>O
	:augroup END
	" }}}

	" Enclave Description Language
	" {{{
	:augroup EDL
	:  autocmd BufRead,BufNewFile *.edl :doautocmd Filetype c
	:augroup END
	" }}}


" {{{
:endif
" }}}
" }}}

" FUNCTIONS {{{
"_______________________________________________________________________________________________________

	" Helpers
	" {{{
		:function! Indentation()
		" {{{
		:  return &expandtab ? repeat(" ", &tabstop) : "\t"
		:endfunction
		" }}}

		:function! LeftStrip(str)
		" {{{
		:  return substitute(a:str, '^\s*\(.\{-}\s*\)$', '\1', '')
		:endfunction
		" }}}

		:function! RightStrip(str)
		" {{{
		:  return substitute(a:str, '^\(\s*.\{-}\)\s*$', '\1', '')
		:endfunction
		" }}}

		:function! Strip(str)
		" {{{
		:  return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
		:endfunction
		" }}}

		:function! Text(line)
		" {{{
		:  return Strip(getline(a:line))
		:endfunction
		" }}}

		:function! LineFromCursor()
		" {{{
		:  return getline('.')[col('.')-1:]
		:endfunction
		" }}}

		:function! LineUntilCursor()
		" {{{
		:  return getline('.')[:col('.')-1]
		:endfunction
		" }}}

		:function! LineAfterCursor()
		" {{{
		:  return LineFromCursor()[1:]
		:endfunction
		" }}}

		:function! LineBeforeCursor()
		" {{{
		:  return LineUntilCursor()[:-2]
		:endfunction
		" }}}

		:function! TextFromCursor()
		" {{{
		:  return Strip(LineFromCursor())
		:endfunction
		" }}}

		:function! TextAfterCursor()
		" {{{
		:  return Strip(LineAfterCursor())
		:endfunction
		" }}}

		:function! TextUntilCursor()
		" {{{
		:  return Strip(LineUntilCursor())
		:endfunction
		" }}}

		:function! TextBeforeCursor()
		" {{{
		:  return Strip(LineBeforeCursor())
		:endfunction
		" }}}
	" }}}
	
	" HTML
	" {{{
		:let s:unclosed = [ "area", "base", "br", "col", "command", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr", "canvas" ]
		:function! GetEndTagHTML()
		" {{{
		:  let l:line = TextUntilCursor()
		:  if l:line !~ '<\w\+[^>]*>$'
		:    return ""
		:  endif
		:  let l:tag = split(split(split(l:line, "<")[-1], ">")[0], " ")[0]
		:  if l:tag =~ '^' . join(s:unclosed, '$\|^') . '$'
		:    return ""
		:  endif
		:  return "</".l:tag.">"
		:endfunction
		" }}}

		:function! EndTagHTML()
		" {{{
		:  if LineAfterCursor() == ""
		:    let l:window = winsaveview()
		:    execute "normal! a".GetEndTagHTML()
		:    call winrestview(l:window)
		:  endif
		:endfunction
		" }}}

		:function! MatchHTMLTagPre()
		" {{{
		:  let l:linebefore = TextBeforeCursor()
		:  let l:lineafter = TextFromCursor()
		:  if (l:linebefore =~ '</[^>]*$' && l:lineafter =~ '^[^<]*>')
		   || (l:linebefore =~ '<[^>]*$' && l:lineafter =~ '^/[^<]*>')
		   || (l:lineafter =~ '^</[^<]*>')
		:    let l:window = winsaveview()
		:    normal! vat
		:    normal! `<
		:    let s:match_tag = winsaveview()
		:    call winrestview(l:window)
		:  elseif (l:linebefore =~ '<[^>]*$' && l:lineafter =~ '^[^<]*>')
		   || (l:lineafter =~ '^<[^<]*>')
		:    let l:window = winsaveview()
		:    normal! vat
		:    let s:match_tag = winsaveview()
		:    call winrestview(l:window)
		:  else
		:    let s:match = {}
		:  endif
		:endfunction
		" }}}

		:function! MatchHTMLTagPost()
		" {{{
		:  let s:match = get(s:, "match", {})
		:  if len(s:match) > 0
		:  endif
		:endfunction
		" }}}

		:function! HTMLCarriageReturn()
		" {{{
		:  let l:leftside = TextBeforeCursor()
		:  let l:rightside = TextFromCursor()
		:  if l:leftside =~ '<.*>\s*$' && l:rightside =~ '^\s*</.*>'
		:    return "\<CR>\<esc>O"
		:  endif
		:  return "\<CR>"
		:endfunction
		" }}}

		:function! HTMLPreview()
		" {{{
		:  let l:refresh = '<meta http-equiv="refresh" content="1">'
		:  execute ':g/'.l:refresh.'/d'
		:  execute ':g/<head>/normal! o'.l:refresh
		:  write
		:  silent !xdg-open % >/dev/null 2>/dev/null &
		:endfunction
		" }}}
	" }}}

	" Markdown
	" {{{
		:function! MDNewline(in)
		"  {{{
		:  let l:allowable_starts = [ '>', '\*', '-', '+', ]
		:  let l:line = getline('.')
		:  let l:left = LineBeforeCursor()
		:  let l:start = substitute(l:line, '^\(\s*.\{-}\)\s.*', '\1', '')
		:  if l:line =~ '^'.join(l:allowable_starts, '\s*$\|^').'\s*$'
		:    call setline('.', '')
		:    return ""
		:  elseif l:left =~ '^\s*'.join(l:allowable_starts, '\s*$\|^\s*').'\s*$'
		:    return MDUnindent()
		:  elseif l:line =~ '^\s*'.join(l:allowable_starts, '\s\|^\s*').'\s'
		:    call append('.', l:start . ' ')
		:    return "\<down>\<right>"
		:  elseif l:line =~ '^\d\+[\.)]\s*$'
		:    call setline('.', '')
		:    return ""
		:  elseif l:left =~ '^\s*\d\+[\.)]\s*$'
		:    return MDUnindent()
		:  elseif l:line =~ '^\d\+[\.)]'
		:    let l:char = substitute(l:line, '^\d\+\([\.)] \).*', '\1', '')
		:    call append('.', l:line + 1 . l:char)
		:    return "\<down>\<right>"
		:  endif
		:  return a:in
		:endfunction
		" }}}

		:function! MDUnindent()
		"  {{{
		:  let l:indent = indent('.')
		:  let l:other = line('.') - 1
		:  while indent(l:other) >= l:indent && l:other > 1
		:    let l:other -= 1
		:  endwhile
		:  let l:diff = l:indent - indent(l:other)
		:  call cursor('.', col('.')-l:diff)
		:  call setline('.', getline('.')[l:diff:])
		:  return ""
		:endfunction
		" }}}

		:function! MDTab(default)
		"  {{{
		:  let l:allowable_starts = [ '>', '\*', '-', '+', '|' , '\d\+.', '\d\+)' ]
		:  let l:linenum = line('.') - 1
		:  if l:linenum == 1
		:    return a:default
		:  endif
		:  let lineabove = Text(l:linenum)
		:  let line = TextBeforeCursor()
		:  for starting in allowable_starts
		:    if line =~ '^\s*' . starting .'\s*$'
		:      let l:repeat = &tabstop
		:      if &filetype != "rmd"
		:        let l:repeat =  stridx(l:lineabove, " ") + 1
		:      endif
		:      call setline('.', repeat(" ", l:repeat) . getline('.'))
		:      return repeat("\<right>", l:repeat)
		:    endif
		:  endfor
		:  return a:default
		:endfunction
		" }}}

		:function! NotesMDFormat()
		" {{{
		" The \{-} is the non greedy version of *
		" Honestly there should be a *? but that who am I to judge
		:  let l:window = winsaveview()
		:  %s/__\(.\{-}\)__/<u>\1<\/u>/ge
		:  %s/_\(.\{-}\)_\^\(.\{-}\)\^/<sup>\2<\/sup><sub style='position: relative; left: -.5em;'>\1<\/sub> /ge
		:  %s/\^\(.\{-}\)\^_\(.\{-}\)_/<sup>\1<\/sup><sub style='position: relative; left: -.5em;'>\2<\/sub> /ge
		:  %s/_\(.\{-}\)_/<sub>\1<\/sub>/ge
		:  %s/\^\(.\{-}\)\^/<sup>\1<\/sup>/ge
		:  call winrestview(l:window)
		:  nohlsearch
		:endfunction
		" }}}

		:function! MDPreview()
		" {{{
		:  autocmd! BufWritePost <buffer> call Compile()
		:  write
		:  let l:filename = substitute(expand("%"), "\.md$", ".pdf", "")
		:  call System('xdg-open '. l:filename. ' >/dev/null 2>/dev/null &')
		:endfunction
		" }}}

		:function! MDCapitals()
		" {{{
		:  let l:window = winsaveview()
		:  silent %s/^\(\s*- \)\(.\)/\1\U\2/e
		:  call winrestview(l:window)
		:  nohlsearch
		:endfunction
		" }}}

		:function! CheckMD()
		" {{{
		:  if toupper(expand("%")) =~ "README"
		:    return
		:  endif
		:  let l:text = join(getline('.', '$'))
		:  if l:text =~ '\$'
		:    set ft=rmd
		:  endif
		:endfunction
		" }}}
	" }}}

	" Latex
	" {{{
		:function! LatexPreview()
		" {{{
		:  autocmd! BufWritePost <buffer> call Compile()
		:  write
		:  let l:filename = substitute(expand("%"), "\.tex$", ".pdf", "")
		:  call System('xdg-open '. l:filename. ' >/dev/null 2>/dev/null &')
		:endfunction
		" }}}

		:function! LatexCarriageReturn()
		" {{{
		:  let l:line = getline('.')
		:  if l:line =~ '^\s*\\begin{.*}$'
		:    let l:line = substitute(getline('.'), "begin", "end", "")
		:    return "\<esc>A\<CR>" . l:line . "\<esc>==O"
		:  elseif l:line =~ '^\s*\\FOR'
		:    return "\<esc>A\<CR>" . '\ENDFOR ' . "\<esc>==O\\STATE "
		:  elseif l:line =~ '^\s*\\IF'
		:    return "\<esc>A\<CR>" . '\ENDIF ' . "\<esc>==O\\STATE "
		:  elseif l:line =~ '^\s*\\STATE'
		:    return "\<esc>A\<CR>" . '\STATE ' . "\<esc>==A"
		:  elseif l:line =~ '^\s*\\WHILE'
		:    return "\<esc>A\<CR>" . '\ENDWHILE ' . "\<esc>==O\\State "
		:  elseif l:line =~ '^\s*\\While'
		:    return "\<esc>A\<CR>" . '\EndWhile ' . "\<esc>==O\\State "
		:  elseif l:line =~ '^\s*\\For'
		:    return "\<esc>A\<CR>" . '\EndFor ' . "\<esc>==O\\State "
		:  elseif l:line =~ '^\s*\\Procedure'
		:    return "\<esc>A\<CR>" . '\EndProcedure ' . "\<esc>==O\\State "
		:  elseif l:line =~ '^\s*\\If'
		:    return "\<esc>A\<CR>" . '\EndIf ' . "\<esc>==O\\State "
		:  elseif l:line =~ '^\s*\\State'
		:    return "\<esc>A\<CR>" . '\State ' . "\<esc>==A"
		:  elseif l:line =~ '^\s*\\Note'
		:    return "\<esc>A\<CR>" . '\Note ' . "\<esc>==A"
		:  endif
		:  return "\<CR>"
		:endfunction
		" }}}

		:function! LatexBackslashBeginning()
		" {{{
		:  let l:window = winsaveview()
		:  let l:word = split(LineUntilCursor())[-1]
		:  if l:word[0] != '\'
		:    if LineAfterCursor() == ""
		:      normal! Bi\
		:    else
		:      normal! lBi\
		:    endif
		:  endif
		:  call winrestview(l:window)
		:endfunction
		" }}}
		
		:function! LatexIndent()
		" {{{
		:  let l:lineno = line('.')
		:  if l:lineno == 1
		:    return 0
		:  endif
		:  let l:unindented = [ '\\section', '\\subsection', '\\Title', '\\Subtitle', '\\Subsubtitle' ]
		:  let l:inc_off = ['\\begin', '{', '[', '\\FOR', '\\IF', '\\WHILE', '\\If', '\\For', '\\While', '\\Procedure', '\\Else']
		:  let l:dec_off = ['\\end', '}', '\\\=]', '\\END', '\\End', '\\Else']
		:  let l:otherno = l:lineno - 1
		:  while getline(l:otherno) =~ "^\s*$" && l:otherno > 0
		:    let l:otherno -= 1
		:  endwhile
		:  let l:line = getline('.')
                :  let l:other = getline(l:otherno)
		:  if l:other =~ '\s*%'
                :     return indent(l:otherno)
		:  endif
		" Special cases for \item tags
		:  let l:offset  = l:other =~ '^\s*\\item' && l:other !~ '\\end{\(enumerate\|itemize\)}'
		:  let l:offset -= l:line =~ '^\s*\\item' && l:other !~ '\\begin{\(enumerate\|itemize\)}'
		:  let l:offset -= l:line =~ '\\end{\(enumerate\|itemize\)}'
		:  call extend(l:inc_off, l:unindented)
		:  call extend(l:dec_off, l:unindented)
		:  let l:offset += l:other =~ ('^\s*' . join(l:dec_off, '\|^\s*'))
		:  let l:offset -= l:line =~ ('^\s*' . join(l:dec_off, '\|^\s*'))
		:  let l:offset += len(split(l:other, join(l:inc_off, '\|'), 1)) - 1
		:  let l:offset -= len(split(l:other, join(l:dec_off, '\|'), 1)) - 1
		:  return indent(l:otherno) + l:offset * shiftwidth()
		:endfunction
		" }}}
	" }}}

	" C Style Function
	" {{{
		:function! Csign()
		" {{{
		:  if &l:formatoptions =~ "cro"
		:    let rtn = "/**\rChris Dean\r".strftime("%m/%d/%y")."\r".split(expand('%:p'), '/')[-2]."\r".@%." \r\r\<bs>*/"
		:  else
		:    let rtn = "/**\r\<bs>* Chris Dean\r* ".strftime("%m/%d/%y")."\r* ".split(expand('%:p'), '/')[-2]."\r* ".@%." \r* \r*/"
		:  endif
		:  return rtn
		:endfunction
		" }}}

		:function! CFold()
		" {{{
		:  ownsyntax c
		:  setlocal foldtext=CFoldText()
		:  setlocal fillchars=fold:\ "
		:  highlight Folded guifg=DarkGreen ctermfg=DarkGreen
		:endfunction
		" }}}

		:function! CFoldText()
		" {{{
		:  let l:tablen = &l:shiftwidth
		:  let l:lines = v:foldend - v:foldstart - 1
		:  let l:line = getline(v:foldstart)
		:  let l:endline = getline(v:foldend)
		:  let l:line = substitute(getline(v:foldstart), '^\s*\(.\{-}\){\s*$', '\1', '')
		:  return (repeat(" ", indent(v:foldstart)).l:line.'{ '.l:lines. ' line'.(l:lines!=1?"s":"").' }')[winsaveview()['leftcol']:]
		:endfunction
		" }}}

		:function! HighlightAfterColumn(col)
		" {{{
		:  let s:exclude_patterns = [ '[^=]*<<[^=]*', '\/\/', '\/\*', '\*\/', '^\s*#', 'print', 'cout', 'cerr' ]
		:  for m in get(b:, "matches", [])
		:    try
		:      silent call matchdelete(m)
		:    catch
		:    endtry
		:  endfor
		:  let b:matches = []
		:  if get(g:, "hllonglines", 1) && getline('.') !~ join(s:exclude_patterns, '\|')
		:    call add(b:matches, matchadd('LongLine', '\%'.line('.').'l\%>'.(a:col).'v.'))
		:  endif
		:endfunction
		" }}}

		:function! AppendSemicolon()
		" {{{
		:  let l:window = winsaveview()
		:  let l:text = Text('.')
		:  if l:text =~ ';$'
		:    if l:text =~ '^if\s*(.*)\s*;$' || l:text =~ '^for\s*(.*)\s*;$' 
		:      execute "normal! A\b"
		:    endif
		:  else
		:    execute "normal! A;"
		:  endif
		:  call winrestview(l:window)
		:endfunction
		" }}}

		:function! CMainAbbrev()
		" {{{
		:  if getline('.') =~ '^$'
		:    call getchar()
		:    if get(g:, 'inline_braces')
		:      return "int main(int argc, char ** argv){\<CR>}\<up>\<esc>o"
		:    else
		:      return "int main(int argc, char ** argv)\<CR>{\<CR>}\<up>\<esc>o"
		:    endif
		:  else
		:    return 'main'
		:  endif
		:endfunction
		" }}}

		:function! SplitIf()
		" {{{
		:  let l:window = winsaveview()
		:  let l:match0   = SplitIf_Match(0)
		:  let l:match01  = SplitIf_Match(0, 1)
		:  let l:match_10 = SplitIf_Match(-1, 0)
		:  if l:match0 == 2
		:    execute "normal! 0f(%l"
		:  elseif l:match01 == 2
		:    execute "normal! J"
		:  elseif l:match_10 == 2
		:    execute "normal! kJ"
		:  elseif l:match0 == 1
		:    execute "normal! 0feel"
		:  elseif l:match01 == 1
		:    execute "normal! j0feel"
		:  elseif l:match_10 == 1
		:    execute "normal! kJ0feel"
		:  endif
		:  if l:match_10 || l:match0 || l:match01
		:    call SplitIf_Internal()
		:  endif
		:  call winrestview(l:window)
		:endfunction
		" }}}

		:function! SplitIf_Internal()
		" {{{
		:  if get(g:, "inline_braces")
		:    execute "normal! i{\<CR>\<esc>o}"
		:    call winrestview(l:window)
		:    normal! j^
		:  else
		:    execute "normal! i\<CR>{\<CR>\<esc>o}"
		:    normal! 2j^
		:  endif
		:endfunction
		" }}}

		:function! SplitIf_Match(...)
		" {{{
		:  let l:regex = '^\s*\(if\|for\|while\)\s*(.*)\+[^)].*;\s*$'
		:  let l:elseregex = '^\s*else\s.\+;'
		:  let l:line = ""
		:  let l:base = line('.')
		:  for value in a:000
		:    let l:linenum = l:base + value
		:    if l:linenum < 1 || l:linenum > line('$')
		:      return 0
		:    endif
		:    let l:line .= getline(l:linenum)
		:  endfor
		:  if l:line =~ l:regex
		:    return 2
		:  endif
		:  return l:line =~ l:elseregex
		:endfunction
		" }}}

		:function! CFormat()
		" {{{
		:  let l:window = winsaveview()
		:  %s/\s*,\s*/, /g
		:  call Indent()
		:  call winrestview(l:window)
		:endfunction
		" }}}
	" }}}

	" Python
	" {{{
		:function! PythonMainAbbrev()
		" {{{
		:  if getline('.') =~ '^$'
		:      let l:rtn  = "import sys\n\n\ndef usage():\nprint(\"Usage: " . expand("%") . "\", file=sys.stderr)\n"
		:      let l:rtn .= "sys.exit(1)\n\n\n\b"
		:      return l:rtn . "def main():\npass\n\n\nif __name__ == \"__main__\":\nmain()"
		:  else
		:    return 'main'
		:  endif
		:endfunction
		" }}}

		:function! PythonBlankLineFix()
		" {{{
		:  let l:window = winsaveview()
		:  if !get(g:, "python_blank_line_fix")
		:    return
		:  endif
		:  %s/\(\n\n\n\)\n\+/\1/e
		:  while getline('$') == ''
		:    $d
		:  endwhile
		":  silent %s/\n\+\(\n\n\ndef\)/\1/e
		":  silent %s/\([^\n]\)\(\n\ndef\)/\1\r\2/e
		":  silent %s/\([^\n]\)\(\ndef\)/\1\r\r\2/e
		:  call winrestview(l:window)
		:endfunction
		" }}}
	" }}}

	" Universally used function
	" {{{
		:function! Comment(...) range
		" {{{
		:  let l:window = winsaveview()
		:  if get(a:, 1, "") ==# 'visual'
		:    '<,'>call Comment()
		:    call winrestview(l:window)
		:    return
		:  endif
		:  let l:temp = split(&commentstring, "%s")
		:  let l:start = escape(get(l:temp, 0, ""), '\*/!"')
		:  let l:end = escape(get(l:temp, 1, ""), '\*/!"')
		:  let l:startshort = substitute(l:start, ' $', '', '')
		:  let l:endshort = substitute(l:end, '^ ', '', '')
		:  if l:end ==# ""
		:    execute "silent ".a:firstline.",".a:lastline.'s:^\(\s*\)\(.\):\1'.l:start.'\2:e'
		:    execute "silent ".a:firstline.",".a:lastline.'s:^\(\s*\)'.l:start.l:startshort.' \{,1}:\1:e'
		:  else
		:    execute "silent ".a:firstline.'s:^\(\s*\)\(.\):\1'.l:start.'\2:e'
		:    execute "silent ".a:firstline.'s:^\(\s*\)'.l:start.l:startshort.' \{,1}:\1:e'
		:    execute "silent ".a:lastline.'s:$:'.l:end
		:    execute "silent ".a:lastline.'s: \{,1}'. l:endshort . l:end . '$::e'
		:  endif
		:  call winrestview(l:window)
		:  nohlsearch
		:endfunction
		" }}}

		:function! CleverTab()
		" {{{
		:  if pumvisible()
		:    return "\<C-P>"
		:  endif
		:  let l:str =  strpart( getline('.'), 0, col('.')-1 )
		:  let l:words = split(l:str, " ")
		:  let l:last_word = len(l:words) > 0 ? l:words[-1] : ""
		:  if l:str =~ '^\s*$' || l:str =~ '\s$'
		:    return "\<Tab>"
		:  elseif l:last_word =~ "\/" && len(glob(l:last_word . "*")) > 0 
		:    return "\<C-X>\<C-F>"
		:  elseif l:last_word =~ "^\/" && len(glob(l:last_word[1:] . "*")) > 0 
		:    " TODO flesh this out
		:    return "\<C-P>"
		:  endif
		:  return "\<C-P>"
		:endfunction
		" }}}

		:function! CleverEsc()
		" {{{
		:  return "\<esc>`^"
		:endfunction
		" }}}

		:function! Wrap(type) range
		" {{{
		:  let l:window = winsaveview()
		:  let l:sel_save = &selection
		:  let &selection = "inclusive"
		:  let s:wrapinput = get(s:, 'repeat', "") != "wrap" ? nr2char(getchar()) : get(s:, 'wrapinput', "")
		:  let s:repeatstack = "wrap"
		:  let s:repeat = ""
		:  let l:firstlast = WrapHelp(s:wrapinput)
		:  let l:begin  = l:firstlast[0]
		:  let l:ending = l:firstlast[1]
		:  if a:type ==# "line"
		:    silent execute "normal! `[V`]$V"
		:  elseif a:type ==# "char"
		:    silent execute "normal! `[v`]v"
		:  elseif a:type ==# "block"
		:    silent execute "normal! `[\<C-V>`]\<C-V>"
		:  endif
		:  silent execute "normal! `>a".l:ending."\<esc>`<i".l:begin
		:  let &selection = l:sel_save
		:  call winrestview(l:window)
		:endfunction
		" }}}

		:function! WrapHelp(arg)
		" {{{
		:  execute "let l:last  = {".substitute(&matchpairs, '\(.\):\(.\)', '"\1":"\2"', "g")."}"
		:  execute "let l:first = {".substitute(&matchpairs, '\(.\):\(.\)', '"\2":"\1"', "g")."}"
		:  let l:begin = get(l:first, a:arg, a:arg)
		:  let l:end = get(l:last,  a:arg, a:arg)
		:  if l:begin ==? "t"
		:    call inputsave()
		:    let l:input = input("tag: ")
		;    call inputrestore()
		:    if l:input != ""
		:      let l:begin = '<' . l:input . '>'
		:      let l:end = '</' . split(l:input)[0] . '>'
		:    endif
		:  endif
		:  if l:begin ==? "s"
		:    call inputsave()
		:    let l:input = input("string: ")
		;    call inputrestore()
		:    if l:input != ""
		:      let l:begin = l:input
		:      let l:end = l:input
		:    endif
		:  endif
		:  if l:begin ==? "r"
		:    call inputsave()
		:    let l:input = input("string: ")
		;    call inputrestore()
		:    if l:input != ""
		:      let l:begin = l:input
		:      let l:end = join(reverse(split(l:input, '.\zs')), '')
		:    endif
		:  endif
		:  return [l:begin, l:end]
		:endfunction
		" }}}

		:function! RemoveTrailingWhitespace_AU()
		" {{{
		:  autocmd BufRead,BufWrite <buffer> :silent call RemoveTrailingWhitespace()
		:endfunction
		" }}}

		:function! RemoveTrailingWhitespace()
		" {{{
		:  let l:window = winsaveview()
		:  let l:line = getline('.')
		:  %s/\s\+$//ge
		:  call winrestview(l:window)
		:  call setline('.', l:line)
		:  call winrestview(l:window)
		:  nohlsearch
		:endfunction
		" }}}

		:function! MyFold()
		" {{{
		:  let l:tablen = &tabstop
		:  let line = getline(v:foldstart)
		:  let lines_count = v:foldend - v:foldstart + 1
		:  setlocal fillchars=fold:\ "
		:  let foldline = substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g')
		:  let foldline = (strlen(foldline) > 0 ? ': ' : "") . foldline 
		:  return (repeat(" ", indent(v:foldstart)). '+--- ' . lines_count . ' lines' . foldline . ' ---+')[winsaveview()["leftcol"]:]
		:endfunction
		" }}}

		:function! Indent()
		" {{{
		:  let l:window = winsaveview()
		:  normal! gg=G
		:  call winrestview(l:window)
		:endfunction
		" }}}

		:function! SpellReplace()
		" {{{
		:  let l:window = winsaveview()
		:  normal! [s1z=
		:  call winrestview(l:window)
		:endfunction
		" }}}

		:function! SingleInsert(how)
		" {{{
		:  return a:how . GetChar() . CleverEsc()
		:endfunction
		" }}}
		
		:function! GetChar()
		" {{{
		:  while getchar(1) == 0
		:  endwhile
		:  return nr2char(getchar())
		:endfunction
		" }}}

		:function! IfScript()
		" {{{
		:  if getline(1) =~ '^#!/' && exists("*setfperm")
		:    let perm = getfperm(expand("%"))
		:    let perm = perm[:1] . "x" . perm[3:]
		:    call setfperm(expand("%"), perm)
		:  endif
		:endfunction
		" }}}

		:function! RepeatFunc()
		" {{{
		:  let s:repeat = get(s:, 'repeatstack', "")
		:  let s:repeatstack = ""
		:endfunction
		" }}}

		:function! HJKL()
		" {{{
		:  noremap <Up> <NOP>
		:  noremap <Down> <NOP>
		:  noremap <Left> <NOP>
		:  noremap <Right> <NOP>
		:  inoremap <ESC> <NOP>
		:endfunction
		" }}}

		:function! SwapExists()
		" {{{
		"  open swapfiles readonly by default
		:  if getftime(expand("%")) > getftime(v:swapname)
		"    delete swap file if it is older than our file
		:    let v:swapchoice = "d"
		:    echohl WarningMsg | echom "Deleting Swapfile" | echohl None
		:  else
		" :    let v:swapchoice = "o"
		" :    echohl WarningMsg | echom "Detected Swapfile. Opening Read only" | echohl None
		:  endif
		:endfunction
		" }}}

		:function! NewFile()
		" {{{
		:  let l:fn = &filetype
		:  if filereadable($HOME . "/.vim/templates/" . l:fn)
		:    execute "%!cat " . $HOME . "/.vim/templates/" . l:fn
		:  endif
		:endfunction
		" }}}

		:function! SwapArgs(type) range
		" {{{
		:  let l:window = winsaveview()
		:  let l:sel_save = &selection
		:  let &selection = "inclusive"
		:  if a:type ==# "line"
		:    silent execute "normal! `[V`]$V"
		:  elseif a:type ==# "char"
		:    silent execute "normal! `[v`]v"
		:  elseif a:type ==# "block"
		:    silent execute "normal! `[\<C-V>`]\<C-V>"
		:  endif
		:  exec 'normal! gv"ay'
		:  let l:args = reverse(split(@a, ","))
		:  if len(l:args) > 1
		:    call map(l:args, 'Strip(v:val)')
		:    let @a = join(l:args, ", ")
		:    exec 'normal! gv"ap'
		:  else
		:    let @a = join(reverse(split(@a)), " ")
		:    exec 'normal! gv"ap'
		:  endif
		:  let &selection = l:sel_save
		:  call winrestview(l:window)
		:endfunction
		" }}}

		:function! MoveLineUp()
		" {{{
		:  if line('.') == 1
		:    return ''
		:  elseif line('.') == line('$')
		:    return '"add"aP'
		:  endif
		:  return '"addk"aP'
		:endfunction
		" }}}

		:function! MoveLineDown()
		" {{{
		:  if line('.') == 1
		:    return '"add"ap'
		:  elseif line('.') == line('$')
		:    return ''
		:  endif
		:  return '"add"ap'
		:endfunction
		" }}}
		
		:function! System(arg)
		" {{{
		:  if has('win32')
		:    throw "Calls to system() not supported on windows"
		:  endif
		:  let l:return = system(a:arg)
		:  if v:shell_error != 0
		:    throw "Error: system(". a:arg . ") returned ".v:shell_error
		:  endif
		:  return l:return
		:endfunction
		" }}}

		:function! CommandLineStart(type, arg, default)
		" {{{
		:  return (getcmdtype() == a:type && getcmdline() == "") ? a:arg : a:default
		:endfunction
		" }}}

		:function! Compile()
		" {{{
		:  try
		:    call System("compile ".expand("%"))
		:  catch
		:    echom v:exception
		:  endtry
		:endfunction
		" }}}

		:function! Open(file)
		"{{{
		:  try 
		:    if executable("open")
		:      let l:type = System("file $(realpath ".a:file.")")
		:      if l:type !~ 'text\|empty'
		:        call System("open ".a:file)
		:        return
		:      endif
		:    endif
		:  catch
		:  endtry
		:  normal! gf
		:endfunction
		" }}}

		:function! SaveSess()
		"{{{
		:  if getcwd() == $HOME
		:    return
		:  endif
		:  if get(g:, "manage_sessions")
		:    execute 'mksession! ' . getcwd() . '/.session.vim'
		:  elseif get(g:, "manage_session")
		:    call mkdir($HOME.'/.vim/session')
		:    execute 'mksession! ' . $HOME . '/session/.session.vim'
		:  endif
		:endfunction
		" }}}

		let g:restored = 0
		:function! RestoreSess()
		"{{{
		:  if expand("%") != ""
		:    return
		:  elseif get(g:, "manage_sessions" ) && filereadable(getcwd() . '/.session.vim') && argc() == 0
		:    execute 'so ' . getcwd() . '/.session.vim'
		:    let g:restored = 1
		:  elseif get(g:, "manage_session" ) && filereadable($HOME . '/session/.session.vim') && argc() == 0
		:    execute 'so ' . $HOME . '/session/.session.vim'
		:    let g:restored = 1
		:  endif
		:endfunction
		" }}}
		
		:function! CorrectFile()
		"{{{
		:  let l:file = expand("%")
		:  if &ft == "" && stridx(l:file, ".") == -1
		:    let l:glob = glob(l:file . ".*", 0, 1)
		:    if len(l:glob) == 1
		:     execute "e! ". l:glob[0]
		:    endif
		:  endif
		:endfunction
		" }}}

		:function! Find(name)
		"{{{
		:  let l:fns = split(System("find -type f -name '" . a:name . "'"), "\n")
		:  if len(l:fns) > 0
		:    execute ":e " . l:fns[0]
		:  endif
		:endfunction
		" }}}


	" }}}

" }}}

" AUTO UPDATE SCRIPT {{{
"_______________________________________________________________________________________________________
	:function! Update_Vimrc(...)
	" {{{
	:  let l:url = 'https://raw.githubusercontent.com/chrisdean258/Dotfiles/master/.vimrc'
	:  try
	:    let l:output = system("diff <(date +%j) ~/.vim/update")
	:    if !get(a:, 1)
	:      if l:output == "" || system("date +%H") < "04"
	:        redraw!
	:        return
	:      endif
	:    endif
	:    echom "Updating"
	:    call System("date +%j > ~/.vim/update")
	:    call System("wget -O ~/.vimrc.temp " . l:url)
	:    if System("cat  ~/.vimrc.temp") =~ '\S'
	:      call System("cat ~/.vimrc.temp > ~/.vimrc")
	:      call System("rm ~/.vimrc.temp")
	:    endif
	:    redraw!
	:  catch
	:    echom v:exception. ". Contact Chris if you think this was not caused by lack of internet"
	:  endtry
	:endfunction
	" }}}

	:command! Update call Update_Vimrc(1)
" }}}

" FEATURE ADDITION {{{
"_______________________________________________________________________________________________________

	:if filereadable(expand("~") . "/.vimrc.local")
	:  source ~/.vimrc.local
	:endif

	:if exists("g:imawimp")
	:  if !g:imawimp
	:    call HJKL()
	:  endif
	:else
	:  if !has('win32')
	:    let s:response = confirm("I'm about to turn off the arrow keys. Use h,j,k,l for left, up, right, down respectively", "y\nn", "y")
	:    if s:response < 2
	:      call HJKL()
	:      call System("echo :let g:imawimp = 0 >> ~/.vimrc.local")
	:    else
	:      call System("echo :let g:imawimp = 1 >> ~/.vimrc.local")
	:    endif
	:  endif
	:endif
	
	:if get(g:, "format_text", 0)
	:  autocmd FileType text :setlocal textwidth=80
	:endif

	:if get(g:, "light_folds", 1)
	:  highlight Folded ctermfg=DarkGrey guifg=DarkGrey
	:  highlight tabline ctermfg=DarkGrey guifg=DarkGrey
	:  highlight tablinesel ctermfg=Grey guifg=Grey
	:endif
	
	:if get(g:, "use_syntastic", 1) && !has('win32')
	:  call SourceOrInstallSyntastic()
	:endif

	:if get(g:,"auto_update", 1) && !has('win32')
	:  if has("autocmd") && &filetype !~ "vim" && expand("%") !~ "\.vimrc$"
	:  augroup vim_update
	:    autocmd VimEnter * :call Update_Vimrc()
	:  augroup END
	:  endif
	:endif


" }}}
