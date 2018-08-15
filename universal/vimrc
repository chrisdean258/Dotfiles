" NORMAL CONFIGURATION SETTINGS {{{
"_______________________________________________________________________________________________________

	:syntax on
	:set nowrap
	:set number
	:set relativenumber
	:colorscheme elflord

	" Set line buffer at top and bottom of screen
	:set scrolloff=5
	:set sidescroll=1
	:set sidescrolloff=5

	" If you want 4 width tabs changes tabstop ad shiftwidth to 4
	:set tabstop=8
	:set softtabstop=-1
	:set shiftwidth=0
" }}}

" UNIVERSAL SETTINGS {{{
"_______________________________________________________________________________________________________

	:set nocompatible
	:set autoindent
	:set smartindent
	:set showcmd
	:set wildmenu
	:set incsearch hlsearch
	:set backspace=eol,indent,start
	:set lazyredraw
	:filetype plugin indent on
	:filetype plugin on

	" Allows for recursive finding
	:set path+=**

	:set omnifunc=syntaxcomplete#Complete
	:set laststatus=1

	" Comment out this group for auto commenting
	:setlocal nofoldenable
	:setlocal foldtext=MyFold()

	:set splitright
	:set splitbelow

	:set tag=./tags,./TAGS,tags,TAGSs,../tags,../../tags
	:set tags+=./tags;$HOME
	:set tags+=./.tags;$HOME

	:set wildignore=*.o,*~,*.pyc
	:if has("win16") || has("win32")
	:  set wildignore+=.git\*,.hg\*,.svn\*
	:else
	:  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
	:endif

	:set ttyfast
	:set infercase
	:set complete-=i
	:set autoread
	:set switchbuf=usetab
	:set hidden
	:set tabpagemax=1000

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

	:let g:syntastic_check_on_wq = 0
        :let g:syntastic_cpp_compiler = "g++"
        :let g:syntastic_cpp_compiler_options = "-std=c++98 -Wall -Wextra"
	:let g:syntastic_cpp_include_dirs = [ "../../include", "../../include/utils/" , "../../eo/include", "../../eo/gengraph/include" ]

	:let g:syntastic_python_checkers = [ 'python' ]
	:let g:syntastic_always_populate_loc_list = 1
	" :let g:syntastic_auto_loc_list = 1
	:let g:syntastic_loc_list_height= 3
	:let g:syntastic_quiet_messages = { "type": "style" }


" }}}

" UNIVERSAL MAPPINGS {{{
"_______________________________________________________________________________________________________

	"mapleader
	:let mapleader = " "
	:let maplocalleader = '\'

	" insert a single char
	" :nnoremap s i <esc>r
	" :nnoremap S a <esc>r
	:nnoremap <silent><expr>s SingleInsert("i")
	:nnoremap <silent><expr>S SingleInsert("a")
	:nnoremap <silent>s<F12> <nop>
	:nnoremap <silent>S<F12> <nop>

	" Repeat mappings
	:nnoremap <silent>. .:let g:repeat = "wrap"<CR>
	:let g:repeat = ""
	:let g:repeatstack = ""

	" key mapping
	:nnoremap j gj
	:nnoremap k gk

	:inoremap <expr> jk CleverEsc()
	:imap Jk jk
	:imap JK jk
	:noremap <space> <nop>

	" move lines up and down
	:nnoremap - ddp
	:nnoremap _ ddkP

	" indent file
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


	" Clever Tab
	:inoremap <S-tab> <c-x><c-f>

	" Wrapping
	:nnoremap <silent><leader>w :set opfunc=Wrap<CR>g@
	:vnoremap <silent><leader>w :call Wrap("visual")<CR>

	" Resizing split
	:nnoremap <silent><S-right> :vertical resize +5 <CR>
	:nnoremap <silent><S-left>  :vertical resize -5 <CR>
	:nnoremap <silent><S-up>    :resize +5 <CR>
	:nnoremap <silent><S-down>  :resize -5 <CR>

	" Jumping splits and tabs
	:nnoremap <leader>h <c-w>h
	:nnoremap <leader>j <c-w>j
	:nnoremap <leader>k <c-w>k
	:nnoremap <leader>l <c-w>l
	:nnoremap <silent><tab>         :tabnext<CR>
	:nnoremap <silent><S-tab>       :tabprev<CR>
	:nnoremap <silent><leader><tab> :tabnew<CR>

	" Window Compatibility
	" :inoremap <BS> <Left><Del>

	" Getting rid of pesky popup window
	:nnoremap q: :

	" Pasting from clipboard
	:nnoremap <leader>p "+p
	:nnoremap <leader>P "+P

	" TODO The yanking operations
	:nnoremap Y y$

	" VisualBlock
	:nnoremap <C-c> <C-v>

" }}}

" UNIVERSAL ABBREVIATIONS AND COMMANDS {{{
"_______________________________________________________________________________________________________

	:cabbrev help vert help
	:cabbrev sp vs
	:cabbrev help vert help

	" Quitting cause Im bad at typing
	:cabbrev W w
	:cabbrev Q q
	:cabbrev Wq wq
	:cabbrev WQ wq
	:cabbrev jk SyntasticReset
	:cabbrev unicode Unicode
	:cabbrev S %s
	:cabbrev a 'a,.s
	:cabbrev $$ .,$s
	:cabbrev w!! %!sudo tee > /dev/null %

	:command! MakeTags !ctags -Rf .tags
	:command! Unicode set encoding=utf-8
	:command! Net :call ProcessNetwork()
	:command! Fold :setlocal foldenable | setlocal foldmethod=syntax

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
	:autocmd BufNewFile * :autocmd BufWritePost * :call IfScript()
	:autocmd BufRead *    :setlocal formatoptions-=cro
	:autocmd cursorhold * :set nohlsearch
	:autocmd BufEnter * :if &filetype !~ "help" | setlocal nu rnu
	:autocmd BufLeave * :setlocal nornu
	:autocmd InsertLeave * set nopaste
	:augroup END
	" }}}

	" Option Autocmds
	" {{{
	:if exists("##OptionSet")
	:augroup Options
	:autocmd!
	:autocmd OptionSet relativenumber :let &number=&relativenumber
	:autocmd OptionSet wrap           :let &linebreak=&wrap
	:autocmd OptionSet paste          :let &relativenumber=!&paste
	:autocmd OptionSet spell          :setlocal spelllang=en
	:augroup END
	:endif
	" }}}

	" C style formatting
	" {{{ 
	:augroup c_style
	:  autocmd!
	:  autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <silent><buffer><localleader>\ :call CommentBL('\/\/')<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <silent><buffer><localleader>s :silent call SplitIf()<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <silent><buffer>; :call AppendSemicolon()<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :inoremap <buffer>{} {<CR>}<esc>O
	:  autocmd FileType c,cpp,javascript,java,perl,cs :inoremap <expr><buffer><tab> CleverTab()
	:  autocmd FileType c,cpp,javascript,java,perl,cs :setlocal cindent
	:  autocmd FileType c,cpp,javascript,java,perl,cs :iabbrev <buffer>csign <c-r>=Csign()<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :call RemoveTrailingWhitespace_AU()
	:augroup END
	" }}}

	" C/cpp specific
	" {{{
	:augroup c_cpp
	:  autocmd!
	:  autocmd FileType cpp    :iabbrev <buffer> nstd using namespace std;<CR>
	:  autocmd FileType c,cpp  :iabbrev <buffer> #i #include
	:  autocmd FileType c,cpp  :iabbrev <buffer> #I #include
	:  autocmd FileType c,cpp  :iabbrev <buffer> cahr char
	:  autocmd FileType cpp    :iabbrev <buffer> enld endl
	:  autocmd FileType c,cpp  :iabbrev <buffer> main <C-R>=MainAbbrev()<CR>
	:  autocmd FileType c      :autocmd CursorMoved,CursorMovedI <buffer> call HighlightAfterColumn(80)
	:  autocmd FileType cpp    :autocmd CursorMoved,CursorMovedI <buffer> call HighlightAfterColumn(100)
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
	:  autocmd FileType html,php :setlocal matchpairs+=<:>
	:  if exists("+breakindent")
	:    autocmd FileType html,php :setlocal breakindent
	:  endif
	:  autocmd FileType html,php :nnoremap <silent><buffer><localleader>\ :call CommentBL('\<!--', '-->')<CR>
	:  autocmd FileType html,php :inoremap <silent><buffer>> ><esc>:call EndTagHTML()<CR>a
	:  autocmd FileType html,php :inoremap <expr><buffer><CR> HTMLCarriageReturn()
	:  autocmd FileType html,php :inoremap <expr><buffer><tab> CleverTab()
	:augroup END
	" }}}

	" Python formatting
	" {{{
	:augroup python_
	:autocmd!
	:autocmd FileType python,matlab,shell,sh,bash  :nnoremap <silent><buffer><localleader>\ :call CommentBL('#')<CR>
	:autocmd FileType python,matlab,shell,sh,bash  :inoremap <expr><buffer><tab> CleverTab()
	:autocmd FileType python  :setlocal tabstop=4
	:autocmd FileType python  :setlocal expandtab
	:autocmd FileType python  :call RemoveTrailingWhitespace_AU()
	:augroup END
	" }}}

	" Vim file
	" {{{
	:augroup vim_
	:autocmd!
	:autocmd FileType vim :nnoremap <silent><buffer><localleader>\ :call CommentBL('" ')<CR>
	:autocmd FileType vim :setlocal foldmethod=marker
	:autocmd FileType vim :setlocal foldenable
	:autocmd FileType vim :setlocal foldtext=MyFold()
	:autocmd FileType vim :inoremap <expr><buffer><tab> CleverTab()
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
	:autocmd FileType markdown :nnoremap <silent><buffer><localleader>\ :call CommentBL('- ')<CR>
	:autocmd Filetype markdown :setlocal wrap
	:autocmd Filetype markdown :setlocal linebreak
	:if exists("+breakindent")
	:  autocmd Filetype markdown :setlocal breakindent
	:endif
	:autocmd Filetype markdown :cabbrev markdown call NotesMDFormat()
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
	:autocmd FileType text :inoremap <expr><buffer><tab> CleverTab()
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
	:autocmd BufRead,BufNewFile *.S :nnoremap <silent><buffer><localleader>\ :call CommentBL('\/\/')<CR>
	:augroup END
	" }}}

	" Make
	:augroup c_style
	:  autocmd FileType make :inoremap <expr><buffer><tab> CleverTab()
	:  autocmd FileType make :nnoremap <silent><buffer><localleader>\ :call CommentBL('#')<CR>
	:augroup END

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

	" HTML/Markdown
	" {{{
		:function! GetEndTagHTML()
		" {{{
		:  let l:unclosed = [ "area", "base", "br", "col", "command", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr" ]
		:  let l:line = TextUntilCursor()
		:  if l:line !~ '<\w\+[^>]*>$'
		:    return ""
		:  endif
		:  let l:tag = split(split(split(l:line, "<")[-1], ">")[0], " ")[0]
		:  for tag_ in l:unclosed
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

		:function! HTMLCarriageReturn()
		" {{{
		:  let l:leftside = TextBeforeCursor()
		:  let l:rightside = TextFromCursor()
		:  if l:leftside =~ '<.*>\s*$' && l:rightside =~ '^\s*</.*>'
		:    return "\<CR>\<esc>O".Indentation()
		:  endif
		:  return "\<CR>"
		:endfunction
		" }}}

		function! MDNewline(in)
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
		endfunction
		" }}}

		function! MDTab(default)
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
		endfunction
		" }}}

		function! NotesMDFormat()
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
		:  return substitute(l:line[0:index(l:line,'{')], "\t", repeat(" ", l:tablen), "g").' '. l:lines .' lines '. l:endline
		:endfunction
		" }}}

		:function! HighlightAfterColumn(col)
		" {{{
		:  if getline('.') !~ 'printf' && getline('.') !~ '[^=]*<<[^=]*'
		:    exe 'match LongLine /\%'.line('.').'l\%>'.(a:col).'v./'
		:  else
		:    exe 'match LongLine /\%'.line('.').'l\%>'.(500).'v./'
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

		:function! MainAbbrev()
		" {{{
		:  if getline('.') =~ '^$'
		:    return "int main(int argc, char ** argv)\<CR>{\<CR>}\<up>"
		:  else
		:    return 'main'
		:  endif
		:endfunction
		" }}}

		:function! SplitIf()
		" {{{
		:  let l:window = winsaveview()
		:  let l:split = 0
		:  execute "normal! 0f(%"
		:  if getline('.') =~ ".*(.*)..*"
		:    execute "normal! a\<CR>{\<CR>\<esc>o}"
		:    let l:split = 1
		:  endif
		:  call winrestview(l:window)
		:  if l:split
		:    normal! 2j^
		:  endif
		:endfunction
		" }}}

	" }}}

	" Universally used function
	" {{{
		:function! CommentBL(start,...) range
		" {{{
		:  let a:end = get(a:, 1, "")
		:  let l:window = winsaveview()
		:  execute "silent ".a:firstline.",".a:lastline.'s/\v^(\s*)(.)/\1'.a:start.'\2/e'
		:  execute "silent ".a:firstline.",".a:lastline.'s/\v^(\s*)'.a:start.a:start.'/\1/e'
		:  execute "silent ".a:firstline.",".a:lastline.'s/$/'. a:end
		:  execute "silent ".a:firstline.",".a:lastline.'s/'. a:end . a:end . '$//e'
		:  call winrestview(l:window)
		:  nohlsearch
		:endfunction
		" }}}

		:function! Comment() range
		" {{{
		:  let l:window = winsaveview()
		:  let l:row = line(a:firstline)
		:  let l:comments = split(&commentstring, "%s")
		:  let l:begin = l:comments[0]
		:  let l:end = len(l:comments) > 2 ? l:comments[1] : ""
		:  while l:row <= line(a:lastline)
		:    let l:line = getline(l:row)
		:    let l:row += 1
		:  endwhile
		:  call winrestview(l:window)
		:  nohlsearch
		:endfunction
		" }}}

		:function! CleverTab()
		" {{{
		:  let l:str =  strpart( getline('.'), 0, col('.')-1 )
		:  let l:words = split(l:str, " ")
		:  let l:last_word = len(l:words) > 0 ? l:words[-1] : ""
		:  if l:str =~ '^\s*$' || l:str =~ '\s$'
		:    return "\<Tab>"
		:  elseif l:last_word =~ "\/"
		:    return "\<C-X>\<C-F>"
		:  else
		:    return "\<C-P>"
		:  endif
		:endfunction
		" }}}

		:function! CleverEsc()
		" {{{
		:  if col('.') == 1
		:    return "\<esc>"
		:  else
		:    return "\<esc>l"
		:  endif
		:endfunction
		" }}}

		:function! Wrap(type) range
		" {{{
		:  let l:window = winsaveview()
		:  let l:sel_save = &selection
		:  let &selection = "inclusive"
		:  if g:repeat != "wrap"
		:    let l:input = nr2char(getchar())
		:  else
		:    let l:input = g:wrapinput
		:  endif
		:  let g:repeat = "wrap"
		:  let g:wrapinput = l:input
		:  let l:ending = l:input
		:  let l:begin = l:input
		:  let l:first = {"<" : "<", "[" : "[", "{" : "{", "(" : "(", ">" : "<", "]" : "[", "}" : "{", ")" : "(",}
		:  let l:last  = {"<" : ">", "[" : "]", "{" : "}", "(" : ")", ">" : ">", "]" : "]", "}" : "}", ")" : ")",}
		:  if has_key(l:first, input)
		:    let l:begin  = l:first[l:input]
		:    let l:ending = l:last[l:input]
		:  endif
		:  if a:type ==# "line"
		:    silent execute "normal! '[V`]$V"
		:    silent execute "normal! `<i".l:begin."\<esc>`>la".l:ending
		:  elseif a:type ==# "char"
		:    silent execute "normal! `[v`]lv"
		:    silent execute "normal! `<i".l:begin."\<esc>`>a".l:ending
		:  elseif a:type ==# "block"
		:    silent execute "normal! `[\<C-V>`]\<C-V>"
		:    silent execute "normal! `<i".l:begin."\<esc>`>a".l:ending
		:  elseif a:type ==# "visual"
		:    silent execute "normal! `<i".l:begin."\<esc>`>a".l:ending
		:  endif
		:  let &selection = l:sel_save
		:  call winrestview(l:window)
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
		:  let tablen = &l:tabstop
		:  let line = getline(v:foldstart)
		:  let lines_count = v:foldend - v:foldstart + 1
		:  let i = 0
		:  while line[i] == "\t"
		:    let i += 1
		:  endwhile
		:  setlocal fillchars=fold:\ "
		:  let foldline = substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g')
		:  if strlen(foldline) == 0
		:    let foldline = ' '
		:  else
		:    let foldline = ' ' . foldline . ' '
		:  endif
		:  return repeat(" ", tablen*i). '+--- ' . lines_count . ' lines:' . foldline . '---+'
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
		:  if getline(1) =~ '^#!/'
		:    let perm = getfperm(expand("%"))
		:    let perm = perm[:1] . "x" . perm[3:]
		:    call setfperm(expand("%"), perm)
		:  endif
		:endfunction
		" }}}
	" }}}

	" Process Network
	" {{{
	:function! ProcessNetwork()
	:  w! temp
	:  g/^N/:let a = join(split(getline('.'))[6:]) | execute ':%s/'.a.'/'.join(split(getline('.'))[1:3]).'/g'
	:  g/^N/:call setline('.',join(split(getline('.'))[0:5]))
	:endfunction
	" }}}
" }}}

" TMUX Terminal Split {{{
"_______________________________________________________________________________________________________

	:cabbrev t T
	:command! T call Terminal()

	:function! Terminal()
	" {{{
	:  let aucmd = ' ''autocmd VimLeave :!tmux kill-session -t vim '' '
	:  let tmuxSession = 'tmux new-session -s "vim" "vim -S session.vim -c '.aucmd .'"'
	:  let split_ = '\; split-window -v -p 40 \;'
	:  mksession session.vim
	:  set noswapfile
	:  silent execute '!' . tmuxSession . split_
	:  silent execute '!rm session.vim'
	:  q!
	:endfunction
	" }}}

	:function! TestSuspend()
	" {{{
	: silent execute '!sleep 3 && echo hi &'
	:endfunction
	" }}}

" }}}

" AUTO UPDATE SCRIPT {{{
"_______________________________________________________________________________________________________
	:function! Update_Vimrc()
	" {{{
	:let update_script= "sh $HOME/.vim/auto_update/fetch_vimrc.sh auto"
	:  silent execute "! " . update_script . " &> /dev/null"
	:  if v:shell_error != 0
	:    silent !mkdir -p $HOME/.vim/auto_update
	:    silent !wget https://raw.githubusercontent.com/chrisdean258/vimrc/master/fetch_vimrc.sh -O $HOME/.vim/auto_update/fetch_vimrc.sh &>/dev/null
	:    silent execute "! " . update_script . " &>/dev/null"
	:  endif
	:endfunction
	" }}}
	" :call Update_Vimrc()
	:command! Update call Update_Vimrc()
" }}}

" If you cannot see anything but this message uncomment the next line
" :highlight Folded ctermfg=DarkGrey guifg=DarkGrey
