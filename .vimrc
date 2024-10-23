" CONFIGURATION SETTINGS {{{
"_______________________________________________________________________________________________________

	:syntax on                              " Syntax highlighting
	:set nowrap                             " Dont wrap text to newlines
	:set number                             " Show line numbers
	:set relativenumber                     " show line numbers relative to your current line

	:set scrolloff=5                        " Keep cursor 5 lines in
	:set sidescroll=1                       " Move one character at a time off the screen rather than jumping
	:set sidescrolloff=5                    " Keep the cursor 5 characters from the left side of the screen
	:set softtabstop=-1                     " Keep defaults to shiftwidth
	:set shiftwidth=0                       " defaults to tabstop

	:set ttyfast
	:set nocompatible                       " We're not using vi
	:set fo=njq
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
	:set wildignore=*.o,*~,*.pyc,*.log,*.aux,*.nav,*.out,*.snm,*.toc,*.pyc,*.mp3,*.wav,*.bin
	:set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

	:set infercase                           " for insert completion
	:set autoread                            " reads from disk if no modification in buffer
	:set switchbuf=usetab                    " default to jumping to a new tab
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
	:set backspace=indent,eol,start
	:set undofile
	:set undolevels=1000
	:set undoreload=10000
	:set backup
	:set wildmode=longest,list,full
	:set smartcase
	:let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'c', 'python', "copper", "go", "cpp"]
	:set ruler
" }}}

" HIGHLIGHT SETTINGS {{{
"_______________________________________________________________________________________________________

	:function! HighLightSettings()
	" Setting for using Highlight after function
	:  colorscheme elflord
	:  highlight LongLine guifg=Red ctermfg=Red
 	:  highlight Folded None
	" Settings for Todo
	:  highlight Todo None
	:  highlight Todo ctermfg=Yellow guifg=Yellow

	" for some reason these are cleared
	:  highlight htmlitalic cterm=italic
	:  highlight htmlBold cterm=bold
	:  highlight htmlUnderline cterm=underline
	:  highlight htmlBoldUnderline cterm=bold,underline
	:  highlight htmlBoldItalic cterm=bold,italic
	:  highlight htmlUnderlineItalic cterm=underline,italic
	:  highlight htmlBoldUnderlineItalic cterm=bold,underline,italic

	" Settings for tabline
	:  highlight tablinefill None
	:  highlight tablinesel None
	:  highlight tabline None
	:  highlight tabline ctermfg=DarkGrey guifg=DarkGrey
	:  highlight tablinesel ctermfg=Grey guifg=Grey
	" Settings for spell
	:  highlight spellrare None
	:  highlight spellcap None
	:  highlight spelllocal None
	:  highlight! link texOnlyMath texMathOper
	:  highlight Folded ctermfg=DarkGrey guifg=DarkGrey
	:  silent! do ColorScheme elflord
	:endfunction

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
	:inoremap jk <esc>`^
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
	:nnoremap <silent>- :silent! call MoveLineDown()<CR>
	:nnoremap <silent>_ :silent! call MoveLineUp()<CR>

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
	:nnoremap <silent><c-L> :nohlsearch \| syn sync fromstart<CR><c-L>
	" Turn on highlighting every time you research or look for the next item
	" Also centers found item on page
	:nnoremap n :set hlsearch<cr>nzzmh0`h
	:nnoremap N :set hlsearch<cr>Nzzmh0`h
	:nnoremap / :set hlsearch<cr>/
	:nnoremap ? :set hlsearch<cr>?
	:nnoremap # :set hlsearch<cr>#zzmh0`h
	:nnoremap * :set hlsearch<cr>*zzmh0`h

	" Wrapping magic 
	" allows you to target text and wrap it in characters repeatably
	:nnoremap <silent><leader>w :set opfunc=Wrap<CR>g@
	:vnoremap <silent><leader>w :call Wrap(visualmode())<CR>

	:nnoremap <silent><leader>sww VV:call SwapArgs(visualmode())<CR>
	:nnoremap <silent><leader>sw :set opfunc=SwapArgs<CR>g@
	:vnoremap <silent><leader>sw :call SwapArgs(visualmode())<CR>

	:nnoremap <silent><leader>== VV:call MathEval(visualmode())<CR>
	:nnoremap <silent><leader>= :set opfunc=MathEval<CR>g@
	:vnoremap <silent><leader>= :call MathEval(visualmode())<CR>

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
	:inoremap <expr> <tab>   CleverTab()
	:inoremap <S-tab> <c-x><c-f>

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

	:nnoremap <C-p> :vs<CR><C-]>
	:map Q gq
" }}}

" UNIVERSAL ABBREVIATIONS AND COMMANDS {{{
"_______________________________________________________________________________________________________

	" Vertical splitting is better than horizontal splitting
	:cabbrev help <C-R>=CommandLineStart("help", "vert help")<CR>
	:cabbrev sp <C-R>=CommandLineStart("sp", "vs")<CR>
	:cabbrev sf <C-R>=CommandLineStart("sf", "vert sf")<CR>
	:cabbrev vf <C-R>=CommandLineStart("vf", "vert sf")<CR>
	:cabbrev find <C-R>=CommandLineStart("find", "Find")<CR>

	" Quitting cause Im bad at typing
	:cabbrev W <C-R>=CommandLineStart("W", "w")<CR>
	:cabbrev Q <C-R>=CommandLineStart("Q", "q")<CR>
	:cabbrev Wq <C-R>=CommandLineStart("Wq", "wq")<CR>
	:cabbrev WQ <C-R>=CommandLineStart("WQ", "wq")<CR>
	:cabbrev Set <C-R>=CommandLineStart("Set", "set")<CR>
	:cabbrev we <C-R>=CommandLineStart("we", "w\|e")<CR>

	" Expanding for substitutions
	:cabbrev S <C-R>=CommandLineStart("S", "%s")<CR>
	:cabbrev a <C-R>=CommandLineStart("a", "'a,.s")<CR>
	:cabbrev $$ <C-R>=CommandLineStart("$$", ".,$s")<CR>
	:cabbrev Q! <C-R>=CommandLineStart("Q!", "q!")<CR>
	:cabbrev make <C-R>=CommandLineStart("make", "Compile")<CR>
	:abbrev Vecotr Vector
	:abbrev retunr return

	" Force writing
	:cabbrev w!! %!sudo tee > /dev/null %

	" Making a tags file for jumping
	:command! MakeTags !ctags -Rf .tags --exclude=.session.vim

	" Turn on folding
	:command! Fold :setlocal foldenable | setlocal foldmethod=syntax
	:command! Compile :call Compile()
	:command! Template :call NewFile()
	:command! -nargs=+ -complete=file_in_path Find :call Find(<f-args>)
	:command! Compile :call Compile()

" }}}

" AUTOCMD GROUPS  {{{
"_______________________________________________________________________________________________________

	:augroup Universal " {{{
	:autocmd!
	:autocmd BufNewFile *  :autocmd BufWritePost * :call IfScript() " Mark files with shebang as executable
	:autocmd BufEnter *    :set fo=njq
	:autocmd CursorHold *  :if get(g:, "hltimeout", 1) | set nohlsearch | endif " turn off search highlighting after a few seconds of nonuse
	:autocmd InsertLeave * :setlocal nopaste            " Turn off paste when leaving insert mode
	:autocmd BufReadPost * :if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal! g'\"" | endif " Jump to where you were in a file
	:autocmd BufEnter *    :let &commentstring = Trim(substitute(&commentstring, '\s*%s\s*', ' %s ', ''))
	:autocmd SwapExists *  :call SwapExists()
	:autocmd BufNewFile *  :call NewFile()
	:autocmd VimLeave *    :call SaveSess()
	:autocmd VimEnter *    :call HighLightSettings()
	:autocmd VimEnter * nested call RestoreSess()
	:augroup END " }}}

	:if exists("##OptionSet") " {{{
	:augroup Options
	:autocmd!
	:autocmd OptionSet relativenumber :let &number=&relativenumber   " Turn on and off number when we toggle reelative number
	:autocmd OptionSet wrap           :let &linebreak=&wrap          " break on words when were wrapping
	:autocmd OptionSet spell          :setlocal spelllang=en         " set spell language when we turn on spell
	:autocmd OptionSet spell          :syntax spell toplevel
	:autocmd OptionSet spell          :nnoremap <silent><buffer><localleader>s :call SpellReplace()<CR>
	:autocmd OptionSet spell          :inoremap <silent><buffer><localleader>s <esc>:call SpellReplace()<CR>a
	:autocmd OptionSet spell          :inoremap <silent><buffer><localleader>s <esc>:call SpellReplace()<CR>a
	:autocmd OptionSet spell          :setlocal complete+=kspell
	:autocmd OptionSet fo             :set fo=njq
	:augroup END
	:endif " }}}

	:augroup c_style " {{{ 
	:  autocmd!
	:  autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <silent><buffer><localleader>s :call SplitIf()<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <silent><buffer>; :call AppendSemicolon()<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :inoremap <buffer><expr>{} Cbraces()
	:  autocmd FileType c,cpp,javascript,java,perl,cs :setlocal cindent
	:  autocmd FileType c,cpp,javascript,java,perl,cs :autocmd BufRead,BufWrite <buffer> :silent call RemoveTrailingWhitespace()
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
	:augroup END " }}}

	:augroup java " {{{
	:  autocmd!
	:  autocmd FileType java  :silent! SyntasticToggle
	:  autocmd FileType java  :nnoremap <localleader>c :SyntasticCheck<CR>
	:augroup END " }}}

	:augroup web " {{{
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
	:  autocmd FileType css,php :nnoremap <silent><buffer>; :call AppendSemicolon()<CR>
	:  autocmd FileType css :inoremap <buffer>{} {<CR>}<esc>O
	:augroup END " }}}

	:augroup tex " {{{
	:  autocmd BufNewFile *.tex  :setlocal filetype=tex
	:  autocmd BufNew *.tex  :setlocal filetype=tex
	:  autocmd BufRead *.tex :setlocal filetype=tex
	:  autocmd FileType tex :setlocal tabstop=2
	:  autocmd FileType tex :setlocal expandtab
	:  autocmd FileType tex :setlocal wrap
	:  autocmd FileType tex :setlocal linebreak
	:  autocmd FileType tex :setlocal indentexpr=LatexIndent()
	:  autocmd FileType tex :silent! setlocal breakindent
	:  autocmd FileType tex :inoremap <buffer> \pa \pa 
	:  autocmd FileType tex :inoremap <expr><buffer><CR> LatexCarriageReturn()
	:  autocmd FileType tex :inoremap <expr><buffer>{ (strlen(getline('.')) + 1 == col('.')) ? "{}\<left>" : "{"
	:  autocmd FileType tex :inoremap <expr><buffer>} (getline(".")[col(".")-1] == "}") ? "\<right>" : "}"
	:  autocmd FileType tex :nnoremap <buffer> <leader>m mqlBi$<esc>Ea$<esc>`q
	:  autocmd FileType tex :nnoremap <buffer>; :call LatexBackslashBeginning()<CR>
	:  autocmd FileType tex :let g:tex_flavor = 'latex'
	:  autocmd FileType tex :iabbrev eqiv equiv
	:  autocmd FileType tex :inoremap \sum \sum
	:  autocmd FileType tex :inoremap \sec \sec
	:  autocmd FileType tex :inoremap \pau \pau
	:  autocmd FileType tex :inoremap \pi \pi
	:  autocmd Filetype tex :nnoremap <silent><buffer><localleader>rm :set opfunc=LatexTextrm<CR>g@
	:  autocmd Filetype tex :vnoremap <silent><buffer><localleader>rm :call LatexTextrm(visualmode())<CR>
	:  autocmd Filetype tex :nnoremap <silent><buffer><localleader>i :set opfunc=LatexTextit<CR>g@
	:  autocmd Filetype tex :vnoremap <silent><buffer><localleader>i :call LatexTextit(visualmode())<CR>
	:  autocmd Filetype tex :nnoremap <silent><buffer><localleader>b :set opfunc=LatexTextbf<CR>g@
	:  autocmd Filetype tex :vnoremap <silent><buffer><localleader>b :call LatexTextbf(visualmode())<CR>
	:  autocmd Filetype tex :nnoremap <silent><buffer><localleader>c :set opfunc=LatexTextCorrection<CR>g@
	:  autocmd Filetype tex :vnoremap <silent><buffer><localleader>c :call LatexTextCorrection(visualmode())<CR>
	:augroup END " }}}

	:augroup python_ " {{{
	:autocmd!
	:autocmd FileType python  :setlocal tabstop=4
	:autocmd FileType python  :setlocal expandtab
	:autocmd FileType python  :setlocal nosmartindent
	:autocmd FileType python  :setlocal complete-=i
	:autocmd FileType python  :iabbrev inport import
	:autocmd FileType python  :autocmd BufRead,BufWrite <buffer> :silent call RemoveTrailingWhitespace()
	:autocmd FileType python  :iabbrev <buffer> main <C-R>=PythonMainAbbrev()<CR>
	:autocmd FileType python  :let g:pyindent_open_paren = '&sw'
	:autocmd FileType python  :let g:pyindent_nested_paren = '&sw'
	:autocmd FileType python  :let g:pyindent_continue = '0'
	:autocmd FileType python  :autocmd BufEnter <buffer> :if line('$') == 1 | call append(0, "#!/usr/bin/env python3") | endif
	:autocmd FileType python  :autocmd CursorMoved,CursorMovedI <buffer> call HighlightAfterColumn(79)
	:autocmd BufRead .xonshrc,*.xsh :set ft=python
	:autocmd BufRead .xonshrc,*.xsh :silent! SyntasticToggleMode
	:augroup END " }}}

	:augroup vim_ " {{{
	:autocmd!
	:autocmd FileType vim :setlocal foldmethod=marker
	:autocmd FileType vim :setlocal foldenable
	:autocmd FileType vim :setlocal foldtext=MyFold()
	:autocmd BufWritePost .vimrc :source %
	:augroup END " }}}

	:augroup Markdown " {{{
	:autocmd!
	:autocmd Filetype markdown :autocmd InsertLeave <buffer> :call MDCapitals()
	:autocmd Filetype markdown :autocmd InsertLeave <buffer> :call ReIndexOrderedList(line('.'))
	:autocmd Filetype markdown :inoremap <buffer><tab> <c-r>=MDTab(CleverTab())<CR>
	:autocmd Filetype markdown :inoremap <silent><buffer><CR> <c-r>=MDNewline()<CR>
	:autocmd Filetype markdown :nmap <silent><buffer>o A<CR>
	:autocmd Filetype markdown :nmap <silent><buffer>dd dd:call ReIndexOrderedList(line('.'))<CR>
	:autocmd Filetype markdown :inoremap <silent><buffer><localleader>s <esc>:call SpellReplace()<CR><left>a
	:autocmd Filetype markdown :nnoremap <silent><buffer><localleader>s :call SpellReplace()<CR>
	:autocmd Filetype markdown :setlocal complete+=kspell
	:autocmd Filetype markdown :setlocal nospell
	:autocmd Filetype markdown :setlocal nowrap
	:autocmd Filetype markdown :setlocal linebreak
	:autocmd Filetype markdown :setlocal commentstring=<!--\ %s\ -->
	:autocmd Filetype markdown :silent! setlocal breakindent
	:autocmd FileType markdown :setlocal expandtab
	:autocmd FileType markdown :setlocal tabstop=4
	:autocmd FileType markdown :setlocal complete+=k
	:autocmd FileType markdown :setlocal dictionary+=/usr/share/dict/words
	" :autocmd FileType markdown :let g:markdown_fenced_languages = ['html', 'python', 'c', 'vim']
	:augroup END " }}}

	:augroup Text " {{{
	:autocmd!
	:autocmd FileType text :setlocal wrap
	:autocmd FileType text :setlocal linebreak
	:autocmd FileType text :setlocal syntax=
	:autocmd FileType text :silent! setlocal breakindent
	:augroup END " }}}

	:augroup Assembly " {{{
	:autocmd!
	:autocmd FileType assembly,asm :setlocal commentstring=//\ %s
	:autocmd FileType assembly,asm :iunmap <tab>
	:augroup END " }}}

	:augroup rust " {{{
	:  autocmd FileType rust :nnoremap <silent><buffer>; :call AppendSemicolon()<CR>
	:  autocmd FileType rust :inoremap <buffer><expr>{} Cbraces()
	:augroup END " }}}

" }}}

" FUNCTIONS {{{
"_______________________________________________________________________________________________________

	" Helpers {{{
		:function! Trim(str, ...) " {{{
		:  return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
		:  let chars = get(a:000, 1, " ")
		:  let mode = get(a:000, 2, 0)
		:  let rtn = a:str
		:  if mode == 1 || mode == 0
		:    let rtn = substitute(a:str, '^['.chars.']*', "", "")
		:  endif
		:  if mode == 2 || mode == 0
		:    let rtn = substitute(a:str, '['.chars.']*$', "", "")
		:  endif
		:  return rtn
		:endfunction " }}}

		:function! LineFromCursor() " {{{
		:  return getline('.')[col('.')-1:]
		:endfunction " }}}

		:function! LineUntilCursor() " {{{
		:  return getline('.')[:col('.')-1]
		:endfunction " }}}

		:function! LineAfterCursor() " {{{
		:  return LineFromCursor()[1:]
		:endfunction " }}}

		:function! LineBeforeCursor() " {{{
		:  if strlen(getline('.')) == col('.') - 1
		:    return LineUntilCursor()
		:  endif
		:  return LineUntilCursor()[:-2]
		:endfunction " }}}

		:function! TextFromCursor() " {{{
		:  return Trim(LineFromCursor())
		:endfunction " }}}

		:function! TextAfterCursor() " {{{
		:  return Trim(LineAfterCursor())
		:endfunction " }}}

		:function! TextUntilCursor() " {{{
		:  return Trim(LineUntilCursor())
		:endfunction " }}}

		:function! TextBeforeCursor() " {{{
		:  return Trim(LineBeforeCursor())
		:endfunction " }}}

		:function! MotionHelp(type, func) " {{{
		:  let l:window = winsaveview()
		:  let [l:start_marker, l:end_marker] = (a:type == "v" || a:type == "V" || a:type == "\<C-V>") ? ["'<", "'>"] : ["'[", "']"]
		:  let [l:startl, l:startc] = getpos(l:start_marker)[1:2]
		:  let [l:endl, l:endc] = getpos(l:end_marker)[1:2]
		:  if a:type == "line" || a:type == "V"
		:    call map(range(l:startl, l:endl), { i, l -> MotionHelpInt(l, 1, 0, a:func) })
		:  elseif a:type == "char" || a:type == "v"
		:    call MotionHelpInt(l:startl, l:startc, l:endc, a:func)
		:  elseif a:type == "block" || a:type == "\<C-V>"
		:    call map(range(l:startl, l:endl), { i, l -> MotionHelpInt(l, l:startc, l:endc, a:func) })
		:  endif
		:  call winrestview(l:window)
		:endfunction " }}}

		:function! MotionHelpInt(line, startcol, endcol, func) " {{{
		:  let l:line = getline(a:line)
		:  let l:start = a:startcol <= 1 ? "" : (l:line[:(a:startcol-2)])
		:  let l:end = a:endcol == 0 ? "" : (l:line[(a:endcol):])
		:  let l:value = l:line[(a:startcol-1):(a:endcol-1)]
		:  call setline(a:line, a:func(l:start, l:value, l:end))
		:endfunction " }}}

		:function! MotionWrap(type, begin, ending) " {{{
		:  call MotionHelp(a:type, { a, b, c -> a . a:begin . b . a:ending . c })
		:endfunction " }}}

		:function! Input(arg) " {{{
		:  call inputsave()
		:  let l:input = input(a:arg)
		:  call inputrestore()
		:  return l:input
		:endfunction " }}}

		:function! PrevIndentLine(start) " {{{
		:  let idt = indent(a:start)
		:  let i = a:start - 1
		:  while indent(i) >= idt && getline('.') =~ '\S'
		:    let i -= 1
		:  endwhile
		:  return i
		:endfunction " }}}
		
		function! RetainPosition(fun) " {{{
			let win = winsaveview()
			let rv = a:fun()
			call winrestview(win)
			return rv
		endfunction "}}}

	" }}}
	
	" HTML {{{
		:let s:unclosed = [ "area", "base", "br", "col", "command", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr", "canvas" ]
		:function! GetEndTagHTML() " {{{
		:  let l:line = TextUntilCursor()
		:  if l:line !~ '<\w\+[^>]*>$'
		:    return ""
		:  endif
		:  let l:tag = split(split(split(l:line, "<")[-1], ">")[0], " ")[0]
		:  if l:tag =~ '^' . join(s:unclosed, '$\|^') . '$'
		:    return ""
		:  endif
		:  return "</".l:tag.">"
		:endfunction " }}}

		:function! EndTagHTML() " {{{
		:  if LineAfterCursor() == ""
		:    call setline(".", getline('.') . GetEndTagHTML())
		:  endif
		:endfunction " }}}

		:function! HTMLCarriageReturn() " {{{
		:  let l:leftside = TextBeforeCursor()
		:  let l:rightside = TextFromCursor()
		:  if l:leftside =~ '<.*>\s*$' && l:rightside =~ '^\s*</.*>'
		:    return "\<CR>\<esc>O"
		:  endif
		:  return "\<CR>"
		:endfunction " }}}

	" }}}

	" Markdown {{{
		let s:markdown_is_list = '^\s*\([>*\-+]\|\d\+[.)]\)\( \[.\]\?\s\)\?\(.*\)'

		:function! MDNewline() "  {{{
		:  let l:line = getline('.')
		:  let l:left = LineBeforeCursor()
		" If left is unindented list specifier remove it leaving the rest of the content
		:  if l:left =~ '^\([>*\-+]\|\d\+[.)]\)\( \[.\]\?\s\)\?\s*$'
		:    let newline = substitute(l:line, s:markdown_is_list, '\3', '')
		:    call setline('.', newline)
		:    call cursor(line('.'), 1)
		:    return ""
		" If between the starter and line and can unindent then unindent
		:  elseif l:left =~ '^\s*\([>*\-+]\|\d\+[.)]\)\( \[.\]\)\?\s*$'
		:    let l:diff = indent('.') - indent(PrevIndentLine(line('.')))
		:    let column = col('.')
		:    call setline('.', getline('.')[l:diff:])
		:    call ReIndexOrderedList(line('.'))
		:    call cursor('.', column - diff)
		:    return ""
		" Somewhere in the middle of the line
		:  elseif l:left =~ '^\s*$'
		:    return "\r"
		:  elseif strlen(l:left) < strlen(l:line)
		:    return "\r"
		:  endif
		" If target line starts with starter and were at the end then insert starter on next line
		:  let idt = indent('.')
		:  let lineno = line('.')
		:  if l:line !~ '^\s*\([>*\-+]\|\d\+[.)]\)\s' && idt != 0
		:    let lineno = PrevIndentLine(lineno)
		:    let l:line = getline(lineno)
		:  endif
		:  if l:line =~ '^\s*\([>*\-+]\|\d\+[.)]\)\s'
		:    let l:nextline = getline(line('.')+1)
		"    If nextline already has a starter and is more indented use its indentation and starter
		:    if indent(line('.') + 1) > indent(lineno) && l:nextline =~ '^\s*\([>*\-+]\|\d\+[.)]\)\s'
		:      let l:line = l:nextline
		:    endif
		:    call append('.', substitute(l:line, '^\(\s*.\{-}\( \[.\]\)\?\)\s.*', '\1', '') . ' ')
		:    call ReIndexOrderedList(line('.')  + 1)
		:    return "\<down>\<right>"
		:  endif
		:  return "\r"
		:endfunction " }}}

		:function! MDTab(default) " {{{
		:  let lineno = line('.')
		:  if &filetype == "rmd" || lineno == 1
		:    return a:default
		:  endif
		:  let allowable_starts = [ '>', '\*', '-', '+', '|' , '\d\+\.', '\d\+)']
		:  let ext = []
		:  for start in allowable_starts
		:    call add(ext, start . ' \[.\]')
		:  endfor
		:  call extend(allowable_starts, ext)
		:  let target = line('.') - 1
		:  let idt = indent('.')
		:  while indent(target) > idt
		:    let target -= 1
		:  endwhile
		:  let repeat = stridx(Trim(getline(target)), " ") + 1
		:  let line = TextBeforeCursor()
		:  if line =~ '^\s*\(' . join(allowable_starts, '\|') . '\)\s*$'
		:    call setline('.', repeat(" ", repeat) . getline('.'))
		:    call ReIndexOrderedList(lineno)
		:    call ReIndexOrderedList(lineno - 1)
		:    return repeat("\<right>", repeat)
		:  endif
		:  return a:default
		:endfunction " }}}

		:function! MDCapitals() " {{{
		:  let l:window = winsaveview()
		:  silent s/^\(\s*- \)\(\w\+[^\/]\(\s\|$\)\)/\1\u\2/e
		:  call winrestview(l:window)
		:  nohlsearch
		:endfunction " }}}

		:function! InIndentTree(linenum, valid_starts, natural_indent) " {{{
		:  let idt = indent(a:linenum)
		:  return idt > a:natural_indent || (idt == a:natural_indent && getline(a:linenum) =~ a:valid_starts)
		:endfunction " }}}

		:function! LineNosOrderedList(start) " {{{
		:  let valid_starts = '^\s*\d\+[\.)]\( \[.\]\)\?'
		:  if getline(a:start) !~ valid_starts
		:    return []
		:  endif
		:  let linenum = a:start
		:  let natural_indent = indent(linenum)
		:  let reindex_lines = [linenum]
		:  let linenum -= 1
		:  while InIndentTree(linenum, valid_starts, natural_indent)
		:    if indent(linenum) == natural_indent
		:      call add(reindex_lines, linenum)
		:    endif
		:    let linenum -= 1
		:  endwhile
		:  let linenum = a:start + 1
		:  while InIndentTree(linenum, valid_starts, natural_indent)
		:    if indent(linenum) == natural_indent
		:      call add(reindex_lines, linenum)
		:    endif
		:    let linenum += 1
		:  endwhile
		:  call sort(reindex_lines, {i1, i2 -> i1 - i2})
		:  return reindex_lines
		:endfunction " }}}

		:function! ReIndexOrderedList(start) " {{{
		:  let window = winsaveview()
		:  let reindex_lines = LineNosOrderedList(a:start)
		:  let i = 0
		:  for lineno in reindex_lines
		:    call setline(lineno, substitute(getline(lineno), '\d\d*', string(i + 1), ''))
		:    let i += 1
		:  endfor
		:  call winrestview(window)
		:endfunction " }}}
	" }}}

	" Latex {{{
		:function! LatexCarriageReturn() " {{{
		:  let l:line = getline('.')
		:  if l:line =~ '^\s*\\begin{enumerate}$' || l:line =~ '^\s*\\begin{itemize}$'
		:    let l:line = substitute(getline('.'), "begin", "end", "")
		:    return "\<esc>A\<CR>\\item\<CR>" . l:line . "\<esc>==O"
		:  elseif l:line =~ '^\s*\\begin{.*}\[.*\]$'
		:    let l:line = substitute(getline('.'), "begin", "end", "")
		:    let l:line = substitute(l:line, '\[.*\]', "", "")
		:    return "\<esc>A\<CR>" . l:line . "\<esc>==O"
		:  endif
		:  return "\<CR>"
		:endfunction " }}}

		:function! LatexBackslashBeginning() " {{{
		:  let l:window = winsaveview()
		:  normal! B
		:  if getline('.')[col('.')-1] != '\'
		:    normal! i\
		:  endif
		:  call winrestview(l:window)
		:endfunction " }}}
		
		:function! LatexIndent() " {{{
		:  let l:lineno = line('.')
		:  if l:lineno == 1
		:    return 0
		:  endif
		:  let l:unindented = [ '\\section', '\\subsection', '\\Title', '\\Subtitle', '\\Subsubtitle' , '\\bibliography']
		:  let l:inc_off = ['\\begin', '{', '[', '\\FOR', '\\IF', '\\WHILE', '\\If', '\\For', '\\While', '\\Procedure', '\\Else', '\\minipage']
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
		:endfunction " }}}

		:function! LatexTextrm(type) range " {{{
		:  call MotionWrap(a:type, '\textrm{', '}')
		:endfunction " }}}

		:function! LatexTextit(type) range " {{{
		:  call MotionWrap(a:type, '\textit{', '}')
		:endfunction " }}}

		:function! LatexTextbf(type) range " {{{
		:  call MotionWrap(a:type, '\textbf{', '}')
		:endfunction " }}}
	" }}}

	" C Style Function {{{
		:function! Cbraces() " {{{
		:  if len(split(LineBeforeCursor(), '"', 1)) % 2 == 0
		:    return "{}"
		:  endif
		:  return "{\<CR>}\<esc>O"
		:endfunction " }}}

		:function! HighlightAfterColumn(col) " {{{
		:  let s:exclude_patterns = [ '[^=]*<<[^=]*', '\/\/', '\/\*', '\*\/', '^\s*#', 'print', 'cout', 'cerr' ]
		:  for m in get(b:, "matches", [])
		:    silent! call matchdelete(m)
		:  endfor
		:  let b:matches = []
		:  if get(g:, "hllonglines", 1) && getline('.') !~ join(s:exclude_patterns, '\|')
		:    call add(b:matches, matchadd('LongLine', '\%'.line('.').'l\%>'.(a:col).'v.'))
		:  endif
		:endfunction " }}}

		:function! AppendSemicolon() " {{{
		:  let l:text = Trim(getline('.'))
		:  if l:text =~ ';$'
		:    if l:text =~ '^if' || l:text =~ '^for' || l:text =~ '^while'
		:      call setline('.', getline('.')[:-2])
		:    endif
		:  else
		:    call setline('.', getline('.') . ';')
		:  endif
		:endfunction " }}}

		:function! CMainAbbrev() " {{{
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
		:endfunction " }}}

		:function! SplitIf() " {{{
		:  let l:window = winsaveview()
		:  let l:match0   = SplitIf_Match(0)
		:  let l:match01  = SplitIf_Match(0, 1)
		:  let l:match_10 = SplitIf_Match(-1, 0)
		:  if l:match0 == 2
		:    execute "normal! 0f(%l"
		:  elseif l:match0 == 1
		:    execute "normal! 0feel"
		:  elseif l:match01 == 2
		:    execute "normal! J"
		:  elseif l:match_10 == 2
		:    execute "normal! kJ"
		:  elseif l:match01 == 1
		:    execute "normal! J0feel"
		:  elseif l:match_10 == 1
		:    execute "normal! kJ0feel"
		:  endif
		:  if l:match_10 || l:match0 || l:match01
		:    call SplitIf_Internal()
		:  endif
		:  call winrestview(l:window)
		:endfunction " }}}

		:function! SplitIf_Internal() " {{{
		:  if get(g:, "inline_braces")
		:    execute "normal! i{\<CR>\<esc>o}"
		:    call winrestview(l:window)
		:    normal! j^
		:  else
		:    execute "normal! i\<CR>{\<CR>\<esc>o}"
		:    normal! 2j^
		:  endif
		:endfunction " }}}

		:function! SplitIf_Match(...) " {{{
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
		:endfunction " }}}
	" }}}

	" Python {{{
		:function! PythonMainAbbrev() " {{{
		:  if getline('.') =~ '^$'
		:      let l:rtn  = "import sys\n\n\ndef usage():\nprint(\"Usage: " . expand("%") . "\", file=sys.stderr)\n"
		:      let l:rtn .= "sys.exit(1)\n\n\n\b"
		:      return l:rtn . "def main(argv):\npass\n\n\nif __name__ == \"__main__\":\nsys.exit(main(sys.argv))"
		:  endif
		:  return 'main'
		:endfunction " }}}
	" }}}

	" Universally used function {{{

		:function! CleverTab() " {{{
		:  if pumvisible()
		:    return "\<C-P>"
		:  endif
		:  let l:str = LineBeforeCursor()
		:  let l:words = split(l:str, " ")
		:  let l:last_word = len(l:words) > 0 ? l:words[-1] : ""
		:  if l:str =~ '^\s*$'
		:    return "\<Tab>"
		:  elseif l:str =~ '\s$'
		:    return "\<Tab>"
		:  elseif l:last_word =~ "\/" && len(glob(l:last_word . "*")) > 0 
		:    return "\<C-X>\<C-F>"
		:  elseif l:last_word =~ "^\/" && len(glob(l:last_word[1:] . "*")) > 0 
		:    " TODO flesh this out
		:    return "\<C-P>"
		:  endif
		:  return "\<C-P>"
		:endfunction " }}}

		:function! CommandLineStart(default, arg) " {{{
		:  return (getcmdtype() == ":" && getcmdline() == "") ? a:arg : a:default
		:endfunction " }}}

		:function! Comment(...) range " {{{
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
		:endfunction " }}}

		:function! Compile() " {{{
		:  call system("compile ".expand("%"))
		:endfunction " }}}

		:function! FileAge(filename) " {{{
		:  return system("date +%s") - system("date +%s -r ".a:filename)
		:endfunction " }}}
		
		:function! Find(name, ...) " {{{
		:  let [l:path, l:name] = get(a:, 1) ? [a:name, a:1] : ['.', a:name]
		:  let l:fn = systemlist('find '.l:path.' -type f -name "*'.l:name.'*"')
		:  if len(l:fn) != 0
		:    execute ":e ".l:fn[0]
		:  endif
		:endfunction " }}}
		
		:function! HJKL() " {{{
		:  noremap <Up> <NOP>
		:  noremap <Down> <NOP>
		:  noremap <Left> <NOP>
		:  noremap <Right> <NOP>
		:  inoremap <ESC> <NOP>
		:endfunction " }}}

		:function! IfScript() " {{{
		:  if getline(1) =~ '^#!/' && exists("*setfperm")
		:    let perm = getfperm(expand("%"))
		:    let perm = perm[:1] . "x" . perm[3:]
		:    call setfperm(expand("%"), perm)
		:  endif
		:endfunction " }}}

		:function! Indent() " {{{
		:  let l:window = winsaveview()
		:  normal! gg=G
		:  call winrestview(l:window)
		:endfunction " }}}

		:function! MathEval(type) range "{{{
		:  call MotionHelp(a:type, {a, b, c -> a . MathEvalSafe(b) . c})
		:endfunction " }}}

		:function! MathEvalSafe(str) " {{{
		:  try
		:    return string(eval(a:str))
		:  catch
		:  endtry
		:  return a:str
		:endfunction " }}}

		:function! MoveLineUp() " {{{
		:  silent move .-2
		:endfunction " }}}

		:function! MoveLineDown() " {{{
		:  silent move .+1
		:endfunction " }}}
		
		:function! MyFold() " {{{
		:  let l:tablen = &tabstop
		:  let line = getline(v:foldstart)
		:  let lines_count = v:foldend - v:foldstart + 1
		:  setlocal fillchars=fold:\ "
		:  let foldline = substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g')
		:  let foldline = (strlen(foldline) > 0 ? ': ' : "") . foldline 
		:  return (repeat(" ", indent(v:foldstart)). '+--- ' . lines_count . ' lines' . foldline . ' ---+')[winsaveview()["leftcol"]:]
		:endfunction " }}}

		:function! NewFile() " {{{
		:  let l:fn = &filetype
		:  if filereadable($HOME . "/.vim/templates/" . l:fn)
		:    execute "%!cat " . $HOME . "/.vim/templates/" . l:fn
		:  endif
		:endfunction " }}}

		:function! RemoveTrailingWhitespace() " {{{
		:  let l:window = winsaveview()
		:  let l:line = getline('.')
		:  %s/\s\+$//ge
		:  call winrestview(l:window)
		:  call setline('.', l:line)
		:  call winrestview(l:window)
		:  nohlsearch
		:endfunction " }}}

		:function! RepeatFunc() " {{{
		:  let s:repeat = get(s:, 'repeatstack', "")
		:  let s:repeatstack = ""
		:endfunction " }}}

		:function! RestoreSess() "{{{
		:  if system("stat -c '%U' .") != $USER
		:    return
		:  elseif expand("%") != ""
		:    return
		:  elseif get(g:, "manage_sessions" ) && filereadable(getcwd() . '/.session.vim') && argc() == 0
		:    execute 'so ' . getcwd() . '/.session.vim'
		:  elseif get(g:, "manage_session" ) && filereadable($HOME . '/session/.session.vim') && argc() == 0
		:    execute 'so ' . $HOME . '/session/.session.vim'
		:  endif
		:endfunction " }}}
		
		:function! SaveSess() "{{{
		:  if system("stat -c '%U' .") != $USER || getcwd() == $HOME
		:    return
		:  endif
		:  if get(g:, "manage_sessions")
		:    execute 'mksession! ' . getcwd() . '/.session.vim'
		:  elseif get(g:, "manage_session")
		:    call mkdir($HOME.'/.vim/session')
		:    execute 'mksession! ' . $HOME . '/session/.session.vim'
		:  endif
		:endfunction " }}}

		:function! SingleInsert(how) " {{{
		:  return a:how . nr2char(getchar()) . "\<esc>`^"
		:endfunction " }}}
		
		:function! SpellReplace() " {{{
		:  let l:window = winsaveview()
		:  normal! [s1z=
		:  call winrestview(l:window)
		:endfunction " }}}

		:function! SwapArgs(type) range " {{{
		:  call MotionHelp(a:type, function("SwapArgsInt"))
		:endfunction " }}}

		:function! SwapArgsInt(start, value, end) "{{{
		:  if a:value =~ ","
		:    let l:v = join(reverse(map(split(a:value, ","), {i, v -> Trim(v)})), ", ")
		:  else
		:    let l:v = join(reverse(map(split(a:value), {i, v -> Trim(v)})))
		:  endif
		:  return a:start . l:v . a:end
		:endfunction " }}}

		:function! SwapExists() " {{{
		"  open swapfiles readonly by default
		:  if getftime(expand("%")) > getftime(v:swapname)
		"    delete swap file if it is older than our file
		:    let v:swapchoice = "d"
		:    echohl WarningMsg | echom "Deleting Swapfile" | echohl None
		:  endif
		:endfunction " }}}

		:function! System(arg) " {{{
		:  if has('win32')
		:    throw "Calls to system() not supported on windows"
		:  endif
		:  let l:return = system(a:arg)
		:  if v:shell_error != 0
		:    throw "Error: system(". a:arg . ") returned ".v:shell_error
		:  endif
		:  return l:return
		:endfunction " }}}

		:function! Wrap(type) range " {{{
		:  let l:window = winsaveview()
		:  let l:sel_save = &selection
		:  let &selection = "inclusive"
		:  let s:wrapinput = get(s:, 'repeat', "") != "wrap" ? nr2char(getchar()) : get(s:, 'wrapinput', "")
		:  let [s:repeatstack, s:repeat] = ["wrap", ""]
		:  let [l:begin, l:ending] = WrapHelp(s:wrapinput)
		:  call MotionWrap(a:type, l:begin, l:ending)
		:endfunction " }}}

		:function! WrapHelp(arg) " {{{
		:  execute "let l:last  = {".substitute(&matchpairs, '\(.\):\(.\)', '"\1":"\2"', "g")."}"
		:  execute "let l:first = {".substitute(&matchpairs, '\(.\):\(.\)', '"\2":"\1"', "g")."}"
		:  let l:begin = get(l:first, a:arg, a:arg)
		:  let l:end = get(l:last, a:arg, a:arg)
		:  if l:begin ==? "t"
		:    let l:input = Input("tag: ")
		:    let l:begin = '<' . l:input . '>'
		:    let l:end = '</' . split(l:input)[0] . '>'
		:  elseif l:begin ==? "s"
		:    let [l:begin, l:end] = repeat([Input("string: ")], 2)
		:  elseif l:begin ==? "r"
		:    let l:begin = Input("string: ")
		:    let l:end = join(reverse(split(l:input, '.\zs')), '')
		:  endif
		:  return [l:begin, l:end]
		:endfunction " }}}
	" }}}

" }}}

" AUTO UPDATE SCRIPT {{{
"_______________________________________________________________________________________________________
	:function! Update_Vimrc(...) " {{{
	:  let l:url = 'https://raw.githubusercontent.com/chrisdean258/Dotfiles/master/.vimrc'
	:  if FileAge("~/.vimrc") < (24 * 60 * 60) && !get(a:, 1)
	:    return
	:  endif
	:  echom "Updating"
	:  try
	:    call System("wget -O ~/.vimrc.temp " . l:url)
	:    if System("cat ~/.vimrc.temp") =~ '\S'
	:      call System("mv ~/.vimrc.temp ~/.vimrc")
	:    endif
	:    redraw!
	:  catch
	:    echom v:exception. ". Contact Chris if you think this was not caused by lack of internet"
	:  endtry
	:endfunction " }}}

	:command! Update call Update_Vimrc(1)
" }}}

" FEATURE ADDITION {{{
"_______________________________________________________________________________________________________

	:if filereadable($HOME . "/.vimrc.local")
	:  source ~/.vimrc.local
	:endif

	:if get(g:, "use_syntastic", 1) && !has('win32')
	:  try
	:    execute pathogen#infect()
	:  catch
	:  endtry
	:endif

	:if get(g:,"auto_update", 1) && !has('win32')
	:  if has("autocmd") && &filetype !~ "vim" && expand("%") !~ "\.vimrc$"
	:  augroup vim_update
	:    autocmd VimEnter * :call Update_Vimrc()
	:  augroup END
	:  endif
	:endif
" }}}
