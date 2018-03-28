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
	:set softtabstop=0
	:set shiftwidth=8
" }}}

" UNIVERSAL SETTINGS {{{
"_______________________________________________________________________________________________________

	" Some higlight settings
	:highlight LongLine guifg=Red ctermfg=Red
 	:highlight Folded None
	:highlight Folded ctermfg=Black guifg=Black
	:highlight tablinefill None
	:highlight tablinesel None
	:highlight tabline None
	:highlight tablinesel ctermfg=DarkGrey guifg=DarkGrey
	:highlight tabline ctermfg=black guifg=black
	" Unhighlight the next two lines if you cant see your tabline
	" :highlight tabline ctermfg=DarkGrey guifg=DarkGrey
	" :highlight tablinesel ctermfg=Grey guifg=Grey

	:try
	:  execute pathogen#infect()
	:catch
	:  silent !mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim &> /dev/null
	:  silent !cd ~/.vim/bundle && git clone --depth=1 https://github.com/vim-syntastic/syntastic.git &> /dev/null
	:  execute pathogen#infect()
	:endtry

	:set nocompatible
	:set autoindent
	:set smartindent
	:set showcmd
	:set wildmenu
	:set hlsearch incsearch
	:set backspace=eol,indent,start
	:filetype plugin indent on
	:filetype plugin on

	" Allows for recursive finding
	:set path+=**

	:set omnifunc=syntaxcomplete#Complete


	" Comment out this group for auto commenting
	:augroup commenting
	:autocmd!
	:autocmd FileType,BufNewFile,BufRead * :setlocal formatoptions-=cro
	:augroup END
	:set foldtext=MyFold()

	:let g:syntastic_check_on_wq = 0
        :let g:syntastic_cpp_compiler = "g++"
        :let g:syntastic_cpp_compiler_options = "-std=c++1z"

" }}}

" UNVIVERSAL MAPPINGS {{{
"_______________________________________________________________________________________________________

	"mapleader
	:let mapleader = " "
	:let maplocalleader = '\'

	" insert a single char
	:nnoremap s i <esc>r
	:nnoremap S a <esc>r

	" key mapping
	:nnoremap j gj
	:nnoremap k gk

	:inoremap jk <C-R>=CleverEsc()<CR>
	:inoremap Jk <C-R>=CleverEsc()<CR>
	:inoremap JK <C-R>=CleverEsc()<CR>
	:noremap <space> <nop>

	" move lines up and down
	:nnoremap - ddp
	:nnoremap _ ddkP

	" indent file
	:nnoremap <leader>g :call Indent()<CR>

	" edit and reload vimrc
	:nnoremap <leader>ev :vsplit $MYVIMRC<CR>
	:nnoremap <leader>sv :silent source $MYVIMRC<CR>
	:nnoremap <leader>s% :source %<CR>


	" add an empty line right above or below current line
	:nnoremap <leader>o o<esc>
	:nnoremap <leader>O O<esc>


	" clear higlighting from search
	:nnoremap <silent><c-L> :nohlsearch<CR><c-L>

	" mapping for jumping to error
	:nnoremap <A-up> :lnext<CR>
	:nnoremap <A-down> :lprev<CR>

	" Clever Tab
	:inoremap <S-tab> <c-x><c-f>

	" Wrapping
	:nnoremap <silent><leader>w :set opfunc=Wrap<CR>g@
	:vnoremap <silent><leader>w :call Wrap("visual")

	" Resizing split
	:nnoremap <S-right> :vertical resize +5 <CR>
	:nnoremap <S-left> :vertical resize -5 <CR>
	:nnoremap <S-up> :resize +5 <CR>
	:nnoremap <S-down> :resize -5 <CR>

	" Jumping splits and tabs
	:nnoremap <leader>h <c-w>h
	:nnoremap <leader>j <c-w>j
	:nnoremap <leader>k <c-w>k
	:nnoremap <leader>l <c-w>l
	:nnoremap <tab> :tabnext<CR>
	:nnoremap <S-tab> :tabprev<CR>
	:nnoremap <leader><tab> :tabnew<CR>

	" Window Compatibility
	" :inoremap <BS> <Left><Del>

	" Getting rid of pesky popup window
	:nnoremap q: :

" }}}

" UNIVERSAL ABBREVIATIONS {{{
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

	:command! MakeTags !ctags -R
	:command! Unicode set encoding=utf-8
	
	:cabbrev unicode Unicode

" }}}

" AUTOCMD GROUPS  {{{
"_______________________________________________________________________________________________________

	" C style formatting
	" {{{
	:augroup c_style
	:  autocmd!
	:  autocmd FileType cpp,javascript,java,perl,cs   :nnoremap <silent><buffer><localleader>\ :call CommentBL('\/\/', '')<CR>
	:  autocmd FileType c                             :nnoremap <silent><buffer><localleader>\ :call CommentBL('\/\*', '\*\/')<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <buffer>; mqA<C-R>=AppendSemicolon()<CR><esc>`q
	:  autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <silent><buffer><localleader>s :silent call SplitIf()<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :inoremap <buffer>{} {<CR>}<esc>O
	:  autocmd FileType c,cpp,javascript,java,perl,cs :inoremap <buffer><tab> <C-R>=CleverTab()<CR>
	:  autocmd FileType c,cpp,javascript,java,perl,cs :setlocal cindent
	:  autocmd FileType c,cpp,javascript,java,perl,cs :setlocal nofoldenable
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
	:  autocmd FileType c,cpp  :iabbrev <buffer> cahr char
	:  autocmd FileType cpp    :iabbrev <buffer> enld endl
	:  autocmd FileType c,cpp  :iabbrev <buffer> main <C-R>=MainAbbrev()<CR>
	:  autocmd FileType cpp    :nnoremap <silent><buffer> \ms :call MakeSetter_Cpp()<CR>
	:  autocmd FileType cpp    :nnoremap <silent><buffer> \mg :call MakeGetter_Cpp()<CR>
	:  autocmd FileType cpp    :nnoremap <silent><buffer> \ma :call MakeGetter_Cpp()<CR>:call MakeSetter_Cpp()<CR>
	:  autocmd FileType cpp    :nnoremap <silent><buffer> \mf :call MakeClassFunction_Cpp()<CR>O
	:  autocmd FileType cpp    :nnoremap <silent><buffer> \mc :call MakeConstructor_Cpp()<CR>O
	:  autocmd FileType c      :autocmd CursorMoved,CursorMovedI <buffer> call HighlightAfterColumn(80)
	:  autocmd FileType cpp    :autocmd CursorMoved,CursorMovedI <buffer> call HighlightAfterColumn(80)
	:augroup END
	" }}}

	" JS, HTML
	" {{{
	:augroup web
	:  autocmd!
	:  autocmd FileType html,php :setlocal tabstop=2
	:  autocmd FileType html,php :setlocal softtabstop=0
	:  autocmd FileType html,php :setlocal shiftwidth=2
	:  autocmd FileType html,php :setlocal expandtab
	:  autocmd FileType html,php :setlocal wrap
	:  autocmd FileType html,php :setlocal linebreak
	:  autocmd FileType html,php :setlocal breakindent
	:  autocmd FileType html,php :nnoremap <silent><buffer><localleader>\ :call CommentBL('\<!--', '-->')<CR>
	:  autocmd FileType html,php :inoremap <buffer>> <esc>:call EndTagHTML()<CR>a
	:  autocmd FileType html,php :inoremap <buffer><CR> <esc>:call HTMLCarriageReturn()<CR>i_<esc>==a<BS>
	:  autocmd FileType html,php :inoremap <buffer><tab> <C-R>=CleverTab()<CR>
	:augroup END
	" }}}

	" Python formatting
	" {{{
	:augroup python_
	:  autocmd!
	:  autocmd FileType python,matlab,shell,sh,bash  :nnoremap <silent><buffer><localleader>\ :call CommentBL('#', '')<CR>
	:  autocmd FileType python,matlab,shell,sh,bash  :inoremap <buffer><tab> <C-R>=CleverTab()<CR>
	:  autocmd FileType python  :inoremap <buffer><BS> <C-R>=ExpandedTabBackSpace()<CR>
	:  autocmd FileType python  :setlocal tabstop=4
	:  autocmd FileType python  :setlocal softtabstop=0
	:  autocmd FileType python  :setlocal shiftwidth=4
	:  autocmd FileType python  :setlocal expandtab
	:  autocmd FileType python  :call RemoveTrailingWhitespace_AU()
	:augroup END
	" }}}

	" Vim file
	" {{{
	:augroup vim_
	:  autocmd!
	:  autocmd FileType vim :nnoremap <silent><buffer><localleader>\ :call CommentBL('" ', "")<CR>
	:  autocmd FileType vim :setlocal foldmethod=marker
	:  autocmd FileType vim :inoremap <buffer><tab> <C-R>=CleverTab()<CR>
	:augroup END
	" }}}

	" Markdown
	" {{{
	:augroup Markdown
	:autocmd!
	:autocmd Filetype markdown  :inoremap <buffer><tab> <C-R>=MDTabReplacement()<CR>
	:autocmd Filetype markdown  :nnoremap <buffer>o :execute "normal! " . MDNewlineReplacement("o")<CR>a
	:autocmd Filetype markdown  :inoremap <buffer><CR> <C-R>=MDNewlineReplacement("\r")<CR>
	:autocmd Filetype markdown  :setlocal wrap
	:autocmd Filetype markdown  :setlocal linebreak
	:autocmd Filetype markdown  :setlocal breakindent
	" :autocmd Filetype markdown  :setlocal spell spelllang=en_u
	" :autocmd Filetype markdown  :nnoremap <buffer><localleader>sp mq[s1z=`q
	" :autocmd Filetype markdown  :nnoremap <buffer><localleader>h1 "qyy"qpVr=
	" :autocmd Filetype markdown  :nnoremap <buffer><localleader>h2 "qyy"qpVr-
	:augroup END
	" }}}

	" txt files
	" {{{
	:augroup Text
	:autocmd!
	:autocmd BufRead,BufNewFile *.txt :setlocal wrap
	:autocmd BufRead,BufNewFile *.txt :setlocal encoding=utf-8
	:autocmd BufRead,BufNewFile *.txt :setlocal linebreak
	:autocmd BufRead,BufNewFile *.txt :setlocal breakindent
	:augroup END
	" }}}

	" Assembly
	" {{{
	:augroup Assembly
	:autocmd!
	:autocmd BufRead,BufNewFile *.S :nnoremap <silent><buffer><localleader>\ :call CommentBL('\/\/', '')<CR>
	:augroup END
	" }}}

	" Notes
	" {{{
	:augroup Notes
	:autocmd!
	:autocmd BufRead,BufNewFile *.notes* :nnoremap <buffer><localleader>s :call SpellReplace()<CR>
	:autocmd BufRead,BufNewFile *.notes* :inoremap <buffer><localleader>s <esc>:call SpellReplace()<CR>a
	:autocmd BufRead,BufNewFile *.notes* :iabbrev <buffer>w/ with
	:autocmd BufRead,BufNewFile *.notes* :setlocal spell
	:autocmd BufRead,BufNewFile *.notes* :setlocal spelllang=en
	" :autocmd BufWrite *.notes.md :call NotesMDFormat()
	:autocmd BufRead,BufNewFile *.notes.md :cabbrev md call NotesMDFormat()
	:augroup END
	" }}}

	" Homework
	" {{{
	:augroup hw
	:autocmd!
	:autocmd BufRead,BufNewFile *.hw :nnoremap <buffer><localleader>s :call SpellReplace()<CR>
	:autocmd BufRead,BufNewFile *.hw :inoremap <buffer><localleader>s <esc>:call SpellReplace()<CR>a
	:autocmd BufRead,BufNewFile *.hw :inoremap <buffer><tab> <C-R>=CleverTab()<CR>
	:autocmd BufRead,BufNewFile *.hw :setlocal spell
	:autocmd BufRead,BufNewFile *.hw :setlocal spelllang=en
	:autocmd BufRead,BufNewFile *.hw :setlocal wrap
	:autocmd BufRead,BufNewFile *.hw :setlocal linebreak
	:autocmd BufRead,BufNewFile *.hw :setlocal syntax=
	:augroup END
	" }}}
" }}}

" FUNCTIONS {{{
"_______________________________________________________________________________________________________

	" Generation
	" {{{
		:function! MakeGetter_Cpp()
		" {{{
		:  normal! mq
		:  let list = split(getline('.'))
		:  let type = list[0]
		:  let varlist = split(list[1],';')
		:  let var = varlist[0]
		:  execute "normal! ?\\v(class|struct)\<CR>"
		:  let list = split(getline('.'))
		:  let clst = list[0]
		:  let class = list[1]
		:  if clst ==# 'class'
		:    execute "normal!/public\<CR>"
		:  else
		:    execute "normal!/{\<CR>"
		:  endif
		:  normal! o
		:  execute "normal! i".type." get_".var."();"
		:  execute "normal! =="
		:  execute "normal!/};\<CR>o"
		:  execute "normal! o".type." ".class."::get_".var."()"
		:  execute "normal! o{"
		:  execute "normal! oreturn ".var.";"
		:  execute "normal! o}"
		:  normal! `q
		:endfunction
		" }}}

		:function! MakeSetter_Cpp()
		" {{{
		:  normal! mq
		:  let list = split(getline('.'))
		:  let type = list[0]
		:  let varList = split(list[1],';')
		:  let var = varList[0]
		:  execute "normal! ?\\v(class|struct)\<CR>"
		:  let list = split(getline('.'))
		:  let clst = list[0]
		:  let class = list[1]
		:  if clst ==# 'class'
		:    execute "normal!/public\<CR>"
		:  else
		:    execute "normal!/{\<CR>"
		:  endif
		:  normal! o
		:  execute "normal! ivoid set_".var."(".type.");"
		:  execute "normal! =="
		:  execute "normal!/};\<CR>o"
		:  execute "normal! ovoid ".class."::set_".var."(".type." ".var."_)"
		:  execute "normal! o{"
		:  execute "normal! o".var." = ".var."_;"
		:  execute "normal! o}"
		:  normal! `q
		:endfunction
		" }}}

		:function! MakeClassFunction_old_Cpp()
		"  {{{
		:  let line = substitute(getline('.'), ";", "", "")
		:  execute "normal! ?\\v(class|struct)\<CR>"
		:  let class = substitute(split(getline('.'))[1], " {", "" , "")
		:  let linesplit = split(line)
		:  let linesplit[1] = class."::".linesplit[1]
		:  let line = join(linesplit)
		:  execute "normal! /};\<CR>"
		:  normal! o
		:  execute "normal! o".line
		:  execute "normal! o{"
		:  execute "normal! o}"
		:endfunction
		" }}}

		:function! MakeClassFunction_Cpp()
		"  {{{
		:  let funcline = substitute(getline('.'), ";", "", "")
		:  execute "normal! ?\\v(class|struct)\<CR>"
		:  let classname = substitute(split(getline('.'))[1], " {", "" , "")
		:  let splitLine = split(funcline, '(')
		:  let splitSignature = split(splitLine[0], " ")
		:  let splitSignature[-1] = classname . "::" . splitSignature[-1]
		:  let splitLine[0] = join(splitSignature, ' ')
		:  let line = substitute(join(splitLine, '('), "\t*","","")
		:  execute "normal! /};\<CR>"
		:  normal! o
		:  execute "normal! o".line
		:  execute "normal! o{"
		:  execute "normal! o}"
		:endfunction
		" }}}

		:function! MakeConstructor_Cpp()
		" {{{
		:  execute "normal! ?\\v(class|struct)\<CR>"
		:  let list = split(getline('.'))
		:  let clst = list[0]
		:  let class = list[1]
		:  if clst ==# 'class'
		:    execute "normal!/public\<CR>"
		:  else
		:    execute "normal!/{\<CR>"
		:  endif
		:  execute "normal! o".class."();"
		:  execute "normal!/};\<CR>o"
		:  execute "normal! o".class."::".class."()"
		:  execute "normal! o{"
		:  execute "normal! o}"
		:endfunction
		" }}}

		:function! EndTagHTML()
		" {{{
		:  let line = getline('.')
		:  let line = line[0:col('.')-1]
		:  echom line
		:  let unclosed = [ "area", "base", "br", "col", "command", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr" ]
		:  if line =~ '^\s*<.*'
		:    try
		:      let tag = substitute(split(split(line, "<")[-1], " ")[0], ">", "", "g")
		:      for item in unclosed
		:        if item == tolower(tag)
		:          normal! a>
		:          return
		:        endif
		:      endfor
		:      execute 'normal! a></'.tag.">"
		:      normal! %h
		:      return
		:    catch
		:      normal! a>
		:      return
		:    endtry
		:  else
		:    normal! a>
		:    return
		:  endif
		:endfunction
		" }}}

		:function! HTMLCarriageReturn()
		" {{{
		:  let line = getline('.')
		:  let cursorcol = col('.')
		:  let leftside = line[0:cursorcol-1]
		:  let rightside = line[cursorcol:]
		:  if leftside =~ '<.*>$' && rightside =~ '^</.*>'
		:    execute "normal! a\<CR>"
		:    normal! O
		:    normal! ==
		:  else
		:    execute "normal! a\<CR>"
		:  endif
		:endfunction
		" }}}

		:function! NotesToMD()
		" {{{
		:  silent %s/^\w/#### &/ge
		:  silent %s/\t/  /ge
		:  silent %s/^\(  *\)/&- /ge
		:  silent %s/^\(  *\)- \(\d\)\./\1\2./ge
		:  silent %s/^  //ge
		:endfunction
		" }}}

		function! MDNewlineReplacement(in)
		"  {{{
		:  let allowable_starts = [ '>', '\*', '-', '+', '|' ]
		:  let line = getline('.')
		:  for starting in allowable_starts
		:    if line =~ '^\s*' . starting . ' '
		:      if line =~ '^\s*' . starting .' $'
		:        return "\<esc>^C"
		:      endif
		:      if a:in == "o"
		:        return "\<esc>yyp^f lC"
		:      else
		:        return "_\<left>\<CR>\<esc>^x\<up>yf \<down>P^f a"
		:      endif
		:    endif
		:  endfor
		:  if line =~ '^\s*\d\d*\. '
		:    if line =~ '^\s*\d\d*\. $'
		:      return "\<esc>^C"
		:    endif
		:    if a:in == "o"
		:      return "\<esc>yyp^\<C-A>f lC"
		:    else
		:      return "_\<left>\<CR>\<esc>^x\<up>yf \<down>P^\<C-A>f a"
		:    endif
		:  endif
		:  return a:in
		endfunction
		" }}}
		
		function! MDTabReplacement()
		"  {{{
		:  let allowable_starts = [ '>', '\*', '-', '+', '|' ]
		:  let linenum = line('.')
		:  if linenum == 1
		:    return CleverTab()
		:  endif
		:
		:  let lineabove = getline(linenum-1)
		:  let line = getline('.')
		:  let indention = indent(linenum-1)
		:
		:  let lineabove = lineabove[indention:]
		:  let indent = stridx(lineabove, ' ') + 1
		:
		:  echom 
		:  if indent == 0
		:    let indent = 2
		:  endif
		:
		:  for starting in allowable_starts
		:    if line =~ '^\s*' . starting .' $'
		:      return "\<esc>^C".repeat(" ", indent)
		:    endif
		:  endfor
		:
		:  if line =~ '^\s*\d*\. $'
		:    return "\<esc>^C".repeat(" ", indent)
		:  endif
		:
		:  return CleverTab()
		endfunction
		" }}}

		function! NotesMDFormat()
		" {{{
		" The \{-} is the non greedy version of *
		" Honestly there should be a *? but that who am I to judge
		:  normal! mq
		:  normal! H
		:  normal! mm

		:  %s/__\(.\{-}\)__/<u>\1<\/u>/ge

		:  %s/_\(.\{-}\)_\^\(.\{-}\)\^/<sup>\2<\/sup><sub style='position: relative; left: -.5em;'>\1<\/sub> /ge
		:  %s/\^\(.\{-}\)\^_\(.\{-}\)_/<sup>\1<\/sup><sub style='position: relative; left: -.5em;'>\2<\/sub> /ge

		:  %s/_\(.\{-}\)_/<sub>\1<\/sub>/ge
		:  %s/\^\(.\{-}\)\^/<sup>\1<\/sup>/ge

		:  nohlsearch
		:  normal! `m
		:  normal! zt
		:  normal! `q
		:endfunction
		" }}}

		function! MakeRect(arglist)
		" {{{
		:  normal! mq
		:  normal! H
		:  normal! mm
		
		:  normal! `>
		:  let col1 = col('.')
		:  let row1 = line('.')
		:  normal! `<
		:  let col2 = col('.')
		:  let row2 = line('.')

		:  let highcol = col1 > col2 ? col1 : col2
		:  let highrow = row1 > row2 ? row1 : row2
		:  let lowcol  = col1 < col2 ? col1 : col2
		:  let lowrow  = row1 < row2 ? row1 : row2

		:  let line = getline(lowrow)
		" May need to subtract one from lowcol in next line
		:  let line = line[:lowcol] . repeat(a:arglist[0], highcol-lowcol)
		:  setline(lowrow, line)


		:  normal! `m
		:  normal! zt
		:  normal! `q
		:endfunction
		" }}}

		function! MakeEllipse()
		" {{{
		:  normal! mq
		:  normal! H
		:  normal! mm

		:  normal! `m
		:  normal! zt
		:  normal! `q
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
		:  let tablen = &l:shiftwidth
		:  let lines = v:foldend - v:foldstart - 1
		:  let line = getline(v:foldstart)
		:  let endline = getline(v:foldend)
		:  return substitute(line[0:index(line,'{')], "\t", repeat(" ", tablen), "g").' '. lines .' lines '. endline
		:endfunction
		" }}}

		:function! HighlightAfterColumn(col)
		" {{{
		:  exe 'match LongLine /\%'.line('.').'l\%>'.(a:col).'v./'
		:endfunction
		" }}}

		:function! AppendSemicolon()
		" {{{
		:  if getline('.') =~ ';\s*$'
		:    return "\<bs>"
		:  endif
		:  return ';'
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
		:  normal! mq
		:  normal! H
		:  normal! mm
		:  normal! `q
		:  execute "normal! 0f(%l"
		:  if !(getline('.') =~ ".*(.*)\s*.*;$")
		:    return
		:    echom "No split found"
		:    normal! `m
		:    normal! zt
		:    normal! `q
		:    return
		:  else
		:    execute "normal! i\<CR>{\<CR>\<esc>$a\<CR>}"
		:  endif
		:  normal! `m
		:  normal! zt
		:  normal! `q
		:  normal! 2j^
		:endfunction
		" }}}

	" }}}

	" Universally used function
	" {{{
		:function! CommentBL(start, end) range
		" {{{
		:  normal! mq
		:  normal! H
		:  normal! mm
		:  normal! `q
		:  execute "silent ".a:firstline.",".a:lastline.'s/\v^(\s*)(.)/\1'.a:start.'\2/e'
		:  execute "silent ".a:firstline.",".a:lastline.'s/\v^(\s*)'.a:start.a:start.'/\1/e'
		:  execute "silent ".a:firstline.",".a:lastline.'s/$/'. a:end
		:  execute "silent ".a:firstline.",".a:lastline.'s/'. a:end . a:end . '$//e'
		:  normal! `m
		:  normal! zt
		:  normal! `q
		:  nohlsearch
		:endfunction
		" }}}

		:function! CleverTab()
		" {{{
		:   let str =  strpart( getline('.'), 0, col('.')-1 )
		:   if str =~ '^\s*$' || str =~ '\s$'
		:      return "\<Tab>"
		:   else
		:      return "\<C-P>"
		:   endif
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

		:function! Wrap(type)
		" {{{
		:  let sel_save = &selection
		:  let &selection = "inclusive"
		:  let input  = nr2char(getchar())
		:  let forward = {"<" : ">", "[" : "]", " {" : " }", "(" : ")",}
		:  let backward = {">" : "<", "]" : "[", " }" : " {", ")" : "(",}
		:  if has_key(forward, input)
		:    let begin = input
		:    let ending = forward[input]
		:  elseif has_key(backward, input)
		:    let ending = input
		:    let begin = backward[input]
		:   else
		:    let ending = input
		:    let begin = input
		:  endif
		:  if a:type ==# "line"
		:    echom "help"
		:    let deref = "\'"
		:    let jump = "$"
		:  else
		:    let deref = "`"
		:    let jump = ""
		:  endif
		:  if a:type !=# "visual"
		:    silent exe "normal! ".deref."[v".deref."]".jump."d"
		:    let @@ = begin.@@.ending
		:    if col('.') == strlen(getline('.'))
		:      normal! p
		:    else
		:      normal! P
		:    endif
		:    let &selection = sel_save
		:  else
		:    execute "normal! `<i".begin."\<esc>`>a".ending
		:  endif
		:endfunction
		" }}}

		:function! RemoveTrailingWhitespace_AU()
		" {{{
		:  autocmd BufRead,BufWrite * :silent call RemoveTrailingWhitespace()
		:endfunction
		" }}}

		:function! RemoveTrailingWhitespace()
		" {{{
		:  let line = line('.')
		:  let ll = line-1
		:  let end = line('$')
		:  normal! mq
		:  normal! H
		:  normal! mm
		:  if line != 1
		:    try
		:      silent execute "1,".ll.'s/\s*$//g'
		:    catch
		:    endtry
		:  endif
		:  if line != end
		:    try
		:      silent execute line+1.',$s/\s*$//g'
		:    catch
		:    endtry
		:  endif
		:  nohlsearch
		:  normal! `m
		:  normal! zt
		:  normal! `q
		:endfunction
		" }}}

		:function! FormatCommas_AU()
		" {{{
		" :  autocmd BufRead,BufWrite * :silent call FormatCommas()
		:endfunction
		" }}}

		:function! FormatCommas()
		" {{{
		:  normal! mq
		:  normal! H
		:  normal! mm
		:  %s/ *, */,/g
		:  %s/,/, /g
		:  nohlsearch
		:  normal! `m
		:  normal! zt
		:  normal! `q
		:endfunction
		" }}}

		:function! MyFold()
		" {{{
		:  let tablen = &l:shiftwidth
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
		:  normal! mq
		:  normal! H
		:  normal! mm
		:  normal! gg=G
		:  normal! `m
		:  normal! zt
		:  normal! `q
		:endfunction
		" }}}

		:function! SpellReplace()
		" {{{
		:  normal! mq
		:  normal! H
		:  normal! mm
		:  normal! [s1z=
		:  normal! `m
		:  normal! zt
		:  normal! `q
		:endfunction
		" }}}

		:function! ExpandedTabBackSpace()
		" {{{
		:  let tablen = &l:shiftwidth
		:  let line = getline('.')
		:  let column = col('.')
		:  let line = line[0:column-2]
		:  if line =~ '^\s*$' && column > tablen
		:    return repeat("\b", tablen)
		:  endif
		:  return "\b"
		:endfunction
		"}}}

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
	:  echo tmuxSession
	:  call getchar()
	:  let split = '\; split-window -v -p 40 \;'
	:  mksession session.vim
	:  set noswapfile
	:  silent execute '!' . tmuxSession . split
	:  silent execute '!rm session.vim'
	" :  q!
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
	:function Update_Vimrc()
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
	:call Update_Vimrc()
	:command! Update call Update_Vimrc()
" }}}


" If you cannot see anything but this message uncomment the next line
" :highlight Folded ctermfg=DarkGrey guifg=DarkGrey
