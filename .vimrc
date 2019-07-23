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
	:set tabstop=8                          " Tabs should be 8 wide. Dont even argue you are wrong
	:set softtabstop=-1                     " Keep defaults to shiftwidth
	:set shiftwidth=0                       " defaults to tabstop

	:set nocompatible                       " We're not using vi
	:set autoindent                         " automatically indent
	:set smartindent                        " Increase indent in a smart way
	:set showcmd                            " show partial command before you finish typing it
	:set wildmenu                           " show menu of completeion on command line
	:set incsearch hlsearch                 " turn on search highlighting
	:set backspace=eol,indent,start         " backspace across eol and farther than you started
	:filetype plugin indent on              " indenting by filetype
	:set path+=**                           " Cheap fuzzy find

	:set omnifunc=syntaxcomplete#Complete   " Not 100% on this because I dont use omnicomplete
	:set laststatus=1                       " Show statusline only if we have more than 1 window upen

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
	:set textwidth=0                         " Dont insert random newlines for us
	:set pumheight=15                        " Only see 15 options on completion
	:set shortmess+=atI                      " Make more messages short
	:set ttyfast                             " Increase buffer before redraw
	:set encoding=utf-8                      " use utf-8 everywhere
	:set fileencoding=utf-8                  " use utf-8 everywhere
	:set termencoding=utf-8                  " use utf-8 everywhere
	:set cinoptions=(8,N-s,l1                " indent 8 for every open paren
	:setlocal complete-=t                    " Turn off completion using tag files for all except c/c++ projects
	:if getcwd() == expand("~")               " Turn off included file completion for home directory stuff
	:  set complete-=i
	:endif
	:set matchpairs+=<:>                     " adding a matched pair for highlighting and wrapping

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

	" Unhighlight the next two lines if you cant see your tabline
	" :highlight tabline ctermfg=DarkGrey guifg=DarkGrey
	" :highlight tablinesel ctermfg=Grey guifg=Grey

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

	:call SourceOrInstallSyntastic()


	" Linting c/c++
	" Some of this stuff has to do with my research like anything to do with eo
	:let g:syntastic_check_on_wq = 0
        :let g:syntastic_cpp_compiler = "g++"
        :let g:syntastic_cpp_compiler_options = "-std=c++98 -Wall"
	:let g:syntastic_cpp_include_dirs = [ "../../include",  "../include", "include", ".", $HOME."/include"]

	" Linting python
	:if executable("flake8")
	:  let g:syntastic_python_checkers = [ "flake8" ]
	:endif
	:let g:syntastic_python_flake8_args=['--ignore=F841,F405,F403,F402,F401']
	:let g:syntastic_always_populate_loc_list = 1
	:let g:syntastic_loc_list_height= 3
	:let g:syntastic_quiet_messages = { "type": "style" }

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
	:nnoremap <silent><leader>f :call Format()<CR>

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
	:nnoremap <leader><space> <c-w><c-w>

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

" }}}

" UNIVERSAL ABBREVIATIONS AND COMMANDS {{{
"_______________________________________________________________________________________________________

	" Vertical splitting is better than horizontal splitting
	:cabbrev help <C-R>=CommandLineStart(":", "vert help", "help")<CR>
	:cabbrev sp <C-R>=CommandLineStart(":", "vs", "sp")<CR>

	" Quitting cause Im bad at typing
	:cabbrev W <C-R>=CommandLineStart(":", "w", "W")<CR>
	:cabbrev Q <C-R>=CommandLineStart(":", "q", "Q")<CR>
	:cabbrev Wq <C-R>=CommandLineStart(":", "wq", "Wq")<CR>
	:cabbrev WQ <C-R>=CommandLineStart(":", "wq", "WQ")<CR>

	" Expanding for substitutions
	:cabbrev S <C-R>=CommandLineStart(":", "%s", "S")<CR>
	:cabbrev a <C-R>=CommandLineStart(":", "'a,.s", "a")<CR>
	:cabbrev $$ <C-R>=CommandLineStart(":", ".,$s", "$$")<CR>
	" :cabbrev term term ++close ++rows=15

	" Force writing
	:cabbrev w!! %!sudo tee > /dev/null %

	" Making a tags file for jumping
	:command! MakeTags !ctags -Rf .tags

	" Turn on folding
	:command! Fold :setlocal foldenable | setlocal foldmethod=syntax

	" Turn on hard mode
	:command! HardMode :call HardMode()

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
	:autocmd CursorHold *  :if get(g:, "hltimeout", 1) | set nohlsearch | endif " turn off search highlighting after a few seconds of nonuse
	:autocmd InsertLeave * :setlocal nopaste            " Turn off paste when leaving insert mode
	:autocmd BufReadPost * :if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal! g'\"" | endif " Jump to where you were in a file
	:autocmd VimEnter *    :if getcwd() ==# $HOME | set complete-=t | endif
	:autocmd VimEnter *    :if &commentstring == '/*%s*/' | setlocal commentstring=/*\ %s\ */ | endif
	:autocmd VimEnter *    :if &commentstring == '#%s' | setlocal commentstring=#\ %s | endif
	:autocmd SwapExists *  :call SwapExists()
	:autocmd WinEnter *    :call WinEnter()
	:autocmd WinLeave *    :call WinLeave()
	" :autocmd WinCreate *      :call WinNew()
	:autocmd BufEnter *    :call BufEnter()
	:autocmd BufLeave *    :call BufLeave()
	:autocmd BufNewFile *.tex :set filetype=tex
	:autocmd BufNewFile *  :call NewFile()
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
	:autocmd OptionSet spell          :setlocal spelllang=en         " set spell language when we turn on spell
	:autocmd OptionSet spell          :nnoremap <silent><buffer><localleader>s :call SpellReplace()<CR>
	:autocmd OptionSet spell          :inoremap <silent><buffer><localleader>s <esc>:call SpellReplace()<CR>a
	:augroup END
	:endif
	" }}}

	" C style formatting
	" {{{ 
	:augroup c_style
	:  autocmd!
	:  autocmd FileType c,cpp,javascript,java,perl,cs :setlocal commentstring=//%s
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
	:  autocmd FileType c      :autocmd CursorMoved,CursorMovedI <buffer> call HighlightAfterColumn(80)
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
	:  autocmd FileType html,php :setlocal tabstop=2
	:  autocmd FileType html,php :setlocal expandtab
	:  autocmd FileType html,php :setlocal wrap
	:  autocmd FileType html,php :setlocal linebreak
	:  if exists("+breakindent")
	:    autocmd FileType html,php :setlocal breakindent
	:  endif
	:  autocmd FileType html,php :inoremap <silent><buffer>> ><esc>:call EndTagHTML()<CR>a
	:  autocmd FileType html,php :inoremap <expr><buffer><CR> HTMLCarriageReturn()
	:let g:html_indent_script1 = "inc"
	:let g:html_indent_style1 = "inc"
	:let g:html_indent_inctags = "address,article,aside,audio,blockquote,canvas,dd,div,dl,fieldset,figcaption,figure,footer,form,h1,h2,h3,h4,h5,h6,header,hgroup,hr,main,nav,noscript,ol,output,p,pre,section,table,tfoot,ul,video"
	:  autocmd FileType html,php :command! Preview call HTMLPreview()
	:  autocmd FileType css,php :nnoremap <silent><buffer>; :call AppendSemicolon()<CR>
	:  autocmd FileType css :inoremap <buffer>{} {<CR>}<esc>O
	:augroup END
	" }}}

	" Tex
	" {{{
	:augroup web
	:  autocmd FileType tex :setlocal tabstop=2
	:  autocmd FileType tex :setlocal expandtab
	:  autocmd FileType tex :setlocal wrap
	:  autocmd FileType tex :setlocal linebreak
	:  autocmd FileType tex :setlocal commentstring=%\ %s
	:  if exists("+breakindent")
	:    autocmd FileType tex :setlocal breakindent
	:  endif
	:  autocmd FileType tex :inoremap <expr><buffer><CR> LatexCarriageReturn()
	:  autocmd FileType tex :inoremap <buffer>{} {}<left>
	:  autocmd FileType tex :nnoremap <buffer>; :call LatexBackslashBeginning()<CR>
	" :  autocmd FileType tex :nnoremap <buffer>; mqviwv`<i\<esc>`ql
	:  autocmd FileType tex :command! Preview call LatexPreview()
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
	:augroup END
	" }}}

	" Vim file
	" {{{
	:augroup vim_
	:autocmd!
	:autocmd FileType vim :setlocal foldmethod=marker
	:autocmd FileType vim :setlocal commentstring=\"\ %s
	:autocmd FileType vim :setlocal foldenable
	:autocmd FileType vim :setlocal foldtext=MyFold()
	:autocmd BufWritePost .vimrc :source %
	:augroup END
	" }}}

	" Markdown
	" {{{
	:augroup Markdown
	:autocmd!
	:autocmd Filetype markdown :inoremap <buffer><tab> <c-r>=MDTab(CleverTab())<CR>
	:autocmd Filetype markdown :inoremap <expr><silent><buffer><CR> MDNewline("\r")
	:autocmd Filetype markdown :inoremap <silent><buffer><localleader>s <esc>:call SpellReplace()<CR>a
	:autocmd Filetype markdown :nnoremap <expr><silent><buffer>o MDNewline("o")
	:autocmd Filetype markdown :nnoremap <silent><buffer><localleader>s :call SpellReplace()<CR>
	:autocmd FileType markdown :highlight link markdownError NONE
	:autocmd Filetype markdown :setlocal wrap
	:autocmd Filetype markdown :setlocal linebreak
	:if exists("+breakindent")
	:  autocmd Filetype markdown :setlocal breakindent
	:endif
	:autocmd Filetype markdown :cabbrev markdown call NotesMDFormat()
	:autocmd FileType markdown :command! Preview call MDPreview()
	:augroup END
	" }}}

	" txt files
	" {{{
	:augroup Text
	:autocmd!
	:autocmd FileType text :setlocal wrap
	:autocmd FileType text :setlocal encoding=utf-8
	:autocmd FileType text :nnoremap <silent><buffer><localleader>s :call SpellReplace()<CR>
	:autocmd FileType text :inoremap <silent><buffer><localleader>s <esc>:call SpellReplace()<CR>a
	:autocmd FileType text :setlocal wrap
	:autocmd FileType text :setlocal linebreak
	:if exists("+breakindent")
	:  autocmd FileType text :setlocal breakindent
	:endif
	:autocmd FileType text :setlocal syntax=
	:augroup END
	" }}}

	" Assembly
	" {{{
	:augroup Assembly
	:autocmd!
	:  autocmd FileType assembly :setlocal commentstring=//%s
	:  autocmd FileType assembly :iunmap <tab>
	:  autocmd FileType asm :setlocal commentstring=//%s
	:  autocmd FileType asm :iunmap <tab>
	:augroup END
	" }}}

	" Make
	" {{{
	:augroup make_
	:  autocmd FileType make :inoremap <expr><buffer><tab> CleverTab()
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
		:  for tag_ in s:unclosed
		:    if tag_ ==? l:tag
		:      return ""
		:    endif
		:  endfor
		:  return "</".l:tag.">"
		:endfunction
		" }}}

		:function! EndTagHTML()
		" {{{
		:  let l:window = winsaveview()
		:  execute "normal! a".GetEndTagHTML()
		:  call winrestview(l:window)
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
		:  let l:line = Text('.')
		:  for starting in l:allowable_starts
		:    if l:line =~ '^' . starting . '\s*$'
		:      return "\<esc>^C"
		:    elseif l:line =~ '^' . starting . ' '
		:      return a:in.l:line[:stridx(l:line, " ")]
		:    endif
		:  endfor
		:  if l:line =~ '^\d\+.\s*$' || l:line =~ '^\d\+)\s*'
		:    return "\<esc>^C"
		:  elseif l:line =~ '^\d\+. '
		:    return a:in.(l:line + 1).'. '
		:  elseif l:line =~ '^\d\+) '
		:    return a:in.(l:line + 1).') '
		:  endif
		:  return a:in
		:endfunction
		" }}}

		:function! MDTab(default)
		"  {{{
		:  let l:allowable_starts = [ '>', '\*', '-', '+', '|' , '\d\+.', '\d\+)' ]
		:  let l:linenum = line('.') - 1
		:  if linenum == 1
		:    return a:default
		:  endif
		:  let lineabove = Text(linenum)
		:  let line = TextBeforeCursor()
		:  for starting in allowable_starts
		:    if line =~ '^\s*' . starting .'\s*$'
		:      let l:window = winsaveview()
		:      let l:repeat =  stridx(l:lineabove, " ") + 1
		:      call setline('.', repeat(" ", l:repeat) . getline('.'))
		:      call winrestview(l:window)
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
		:  if executable("grip")
		:    write
		:    call system('grip ' . expand('%') . ' > /dev/null 2>/dev/null &')
		:    call system('xdg-open http://localhost:6419 > /dev/null 2>/dev/null &')
		:    autocmd VimLeave * :call system("pkill grip")
		:  endif
		:endfunction
		" }}}

	" }}}

	" Latex
	" {{{
		:function! LatexPreview()
		" {{{
		:  if executable("latex2pdf")
		:    autocmd! BufWritePost <buffer> call system("cat /dev/null | latex2pdf " . expand("%"))
		:    write
		:  endif
		:  let l:filename = substitute(expand("%"), "\.tex$", ".pdf", "")
		:  call system('xdg-open '. l:filename. ' >/dev/null 2>/dev/null &')
		:endfunction
		" }}}

		:function! LatexCarriageReturn()
		" {{{
		:  if getline('.') =~ '^\s*\\begin{.*}$'
		:    let l:line = substitute(getline('.'), "begin", "end", "")
		:    return "\<CR>" . l:line . "\<esc>==O"
		:  endif
		:  return "\<CR>"
		:endfunction
		" }}}

		:function! LatexBackslashBeginning()
		" {{{
		:  let l:window = winsaveview()
		:  let l:word = split(LineBeforeCursor())[-1]
		:  if l:word[0] == '\'
		:    normal! Bx
		:  else
		:    normal! Bi\
		:  endif
		:  call winrestview(l:window)
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
		:  for match in getmatches()
		:    if match["group"] ==? "LongLine"
		:      call matchdelete(match["id"])
		:    endif
		:  endfor
		:  let s:longlinematches = []
		:  if get(g:, "hllonglines", 1) && getline('.') !~ 'printf' && getline('.') !~ '[^=]*<<[^=]*' && getline('.') !~ '\/\/' && getline('.') !~ '\/\*' && getline('.') !~ '\*\/'
		:    call matchadd('LongLine', '\%'.line('.').'l\%>'.(a:col).'v.')
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
		:    if get(g:, 'inline_braces')
		:      return "int main(int argc, char ** argv){\<CR>}\<up>" . repeat("\<right>", 50)
		:    else
		:      return "int main(int argc, char ** argv)\<CR>{\<CR>}\<up>"
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
		:  let l:matchm10 = SplitIf_Match(0, -1)
		:  if l:match0 == 2
		:    execute "normal! 0feel"
		:    call SplitIf_Internal()
		:  elseif l:match01 == 2
		:    execute "normal! j0feel"
		:  elseif l:matchm10 == 2
		:    execute "normal! kj0feel"
		:  elseif l:match0
		:    execute "normal! 0f(%l"
		:  elseif l:match01
		:    execute "normal! j"
		:  elseif l:matchm10
		:    execute "normal! kj"
		:  endif
		:  if l:matchm10 || l:match0 || l:match10
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
		:  let l:regex = '^\s*.\+(.*)\+[^)].*'
		:  let l:elseregex = '^\s*else\s.\+'
		:  let l:line = ""
		:  let l:base = line('.')
		:  for value in a:000
		:    let l:linenum = l:base + value
		:    if value < 1 || value > line('$')
		:      return 0
		:    endif
		:    let l:line .= getline(l:linenum)
		:  endfor
		:  if l:line =~ l:elseregex
		:    return 2
		:  endif
		:  return l:line =~ l:regex
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
		:      return "def main():\npass\n\nif __name__ == \"__main__\":\nmain()"
		:  else
		:    return 'main'
		:  endif
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
		:    execute "silent ".a:firstline.",".a:lastline.'s:^\(\s*\):\1'.l:start.':e'
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
		:    let l:input = input("tag: ")
		;    call inputrestore()
		:    if l:input != ""
		:      let l:begin = l:input
		:      let l:end = l:input
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

		:function! Format()
		" {{{
		:  let l:window = winsaveview()
		:  let l:save = &textwidth
		:  let l:tw = &textwidth ? &textwidth : 80
		:  let &textwidth = l:tw
		:  execute ':g/.\{' . l:tw . ',\}/normal! gqq'
		:  normal! gg=G
		:  let &textwidth = l:save
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
		"}}}

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

		:function! HardMode()
		" {{{
		:  noremap <Up> <NOP>
		:  noremap <Down> <NOP>
		:  noremap <Left> <NOP>
		:  noremap <Right> <NOP>
		:  noremap h <NOP>
		:  noremap j <NOP>
		:  noremap k <NOP>
		:  noremap l <NOP>
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

		:function! Scanf(input, format)
		" {{{
		" Escape a bunch of characters
		:  l:input = escape(a:input, '/\[].*')
		:  l:input = substitute(l:input, "%s", '\([^\S]*\)', "g")
		:  l:input = substitute(l:input, "%d", '\(-{0,1}\d\+\)', "g")
		:endfunction
		" }}}

		:function! WinEnter()
		" {{{
		:endfunction
		" }}}

		:function! WinLeave()
		" {{{
		:endfunction
		" }}}

		:function! WinNew()
		" {{{
		:endfunction
		" }}}
		 
		:function! BufLeave()
		" {{{
		:endfunction
		" }}}
		
		:function! BufEnter()
		" {{{
		: 
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
		
		:function! CloseMatches()
                " {{{
                :  let l:pairs = split(&matchpairs, ",")
                :  for pair in l:pairs
                :    if maparg(l:begin.l:end, "i") == "" && maparg(l:end, "i") == ""
                :      let l:temp = split(pair, ":") 
                :      let l:begin = l:temp[0]
                :      let l:end = l:temp[1]
                :      exec "inoremap " . l:begin . l:end . " " . l:begin . l:end . "<left>"
                :      exec "inoremap <expr> " . l:end . ' (getline(".")[col(".")-1] == "' . l:end . '" ? "\<right>" : "' . l:end . '")' 
                :    endif
		:  endfor
                :endfunction
                " }}}

		:function! System(arg)
		" {{{
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

	" }}}

" }}}

" VIMRC SOURCING {{{
"_______________________________________________________________________________________________________
	
	:function! UpwardVimrcSource()
	:  let l:dir = getcwd()
	:  while l:dir =~ "\/" && l:dir != $HOME
	:    if filereadable(l:dir . "/.vimrc")
	:      execute "source " . l:dir . "/.vimrc"
	:    endif
	:    let l:dir = fnamemodify(l:dir, ":p:h:h")
	:  endwhile
	:endfunction

" }}}

" DEV {{{
"_______________________________________________________________________________________________________

:if get(g:, "dev")

		:function! WinEnter()
		" {{{
		:  if !get(g:, 'buffcmds', 1)
		:    return
		:  endif
		:  exec (&columns / 20).'wincmd >'
		:  exec (&lines / 20).'wincmd +'
		:  if get(b:, 'relativenumber', &relativenumber)
		:    setlocal relativenumber
		:  endif
		:endfunction
		" }}}

		:function! WinLeave()
		" {{{
		:  if !get(g:, 'buffcmds', 1)
		:    return
		:  endif
		:  exec (&columns / 20).'wincmd <'
		:  exec (&lines / 20).'wincmd -'
		:  if bufname("%") =~ "^!"
		:    exec 'resize '.(winline() / 10 + 10)
		:    echo "hi"
		:  endif
		:  let b:relativenumber = &relativenumber
		:  setlocal norelativenumber
		:endfunction
		" }}}

		:function! WinNew()
		" {{{
		:  if bufname("%") =~ "^!"
		:    exec 'resize '.(winline() / 10 + 10)
		:  endif
		:endfunction
		" }}}

		:function! BufLeave()
		" {{{
		: 
		:endfunction
		" }}}

		:function! BufEnter()
		" {{{
		:  if exists("*getwininfo") && len(getwininfo()) == 1 && bufname("%") =~ '^!'
		:    q!
		:  endif
		:endfunction
		" }}}

		:function! BackGroundPython()
		" {{{
		:  let g:python_proc_directory = get(g:, python_proc_directory)
		:  if g:python_proc_directory == 0
		:    let l:python = "python3 -i"
		:    if getline(1) =~ "python$"
		:      let l:python = "python -i"
		:    endif
		:    let g:python_proc_directory = system("mktemp -d vim-python.XXXXXXXXXX")
		:    let g:python_input_pipe = g:python_proc_directory . '/input'
		:    let g:python_output_pipe = g:python_proc_directory . '/output'
		:    call system("mknod p ".g:python_input_pipe)
		:    call system("mknod p ".g:python_output_pipe)
		:    autocmd VimLeave * :call system("rm -rf ".g:python_proc_directory)
		:  endif
		:endfunction
		" }}}
:endif

" }}}

" AUTO UPDATE SCRIPT {{{
"_______________________________________________________________________________________________________
	:function! Update_Vimrc(...)
	" {{{
	:  let l:url = 'https://raw.githubusercontent.com/chrisdean258/Dotfiles/master/.vimrc'
	:  try
	:    let l:output = system("diff <(date +%j) ~/.vim/update")
	:    if l:output == "" && !get(a:, 1)
	:      redraw!
	:      return
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

	:if has("autocmd") && &filetype !~ "vim" && expand("%") !~ "\.vimrc$"
	:augroup vim_update
	:  autocmd VimEnter * :call Update_Vimrc()
	:augroup END
	:endif

	:command! Update call Update_Vimrc(1)

	:if filereadable(expand("~") . "/.vimrc.local")
	:  source ~/.vimrc.local
	:endif

" }}}

" FEATURE ADDITION {{{
"_______________________________________________________________________________________________________

	:if exists("g:imawimp")
	:  if !g:imawimp
	:    call HJKL()
	:  endif
	:else
	:  let s:response = confirm("I'm about to turn off the arrow keys. Use h,j,k,l for left, up, right, down respectively", "y\nn", "y")
	:  if s:response < 2
	:    call HJKL()
	:    call system("echo :let g:imawimp = 0 >> ~/.vimrc.local")
	:  else
	:    call system("echo :let g:imawimp = 1 >> ~/.vimrc.local")
	:  endif
	:endif
	
	:if get(g:,"hardmode")
	:  call HardMode()
	:endif

	:if get(g:, "source2home")
	:  call UpwardVimrcSource()
	:endif

	:if get(g:, "format_text")
	:  autocmd FileType text :setlocal textwidth=80
	:endif

	:if get(g:, "dark_folds") != 1
	:  highlight Folded ctermfg=DarkGrey guifg=DarkGrey
	:  highlight tabline ctermfg=DarkGrey guifg=DarkGrey
	:  highlight tablinesel ctermfg=Grey guifg=Grey
	:endif
	
	:if get(g:, "close_matches")
        :  call CloseMatches()
        :endif

" }}}
