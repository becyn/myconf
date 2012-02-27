set nocompatible  " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing

" Now we set some defaults for the editor
set textwidth=0   " Don't wrap words by default
set nobackup    " Don't keep a backup file
set viminfo='50,<1000,s100,\"50 " read/write a .viminfo file, don't store more than
"set viminfo='50,<1000,s100,:0,n~/.vim/viminfo
set history=100   " keep 50 lines of command line history
set ruler   " show the cursor position all the time

" set a cursor alway in the middle.
set scrolloff=999

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" We know xterm-debian is a color terminal
"if &term =~ "xterm-debian" || &term =~ "xterm-xfree86" || &term =~ "xterm-256color"
 set t_Co=256
" set t_Sf= [3%dm
" set t_Sb= [4%dm
"endif

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

syntax on

if &term =~ "xterm-256color"
"  colorscheme desert256
  colorscheme desert256
endif

" Debian uses compressed helpfiles. We must inform vim that the main
" helpfiles is compressed. Other helpfiles are stated in the tags-file.
" set helpfile=$VIMRUNTIME/doc/help.txt.gz
set helpfile=$VIMRUNTIME/doc/help.txt

if has("autocmd")
  " Enabled file type detection
  " Use the default filetype settings. If you also want to load indent files
  " to automatically do language-dependent indenting add 'indent' as well.
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on
  :set cinkeys=0{,0},0),!^F,o,O,e
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off

  " autocmd FileType php :set indentexpr=
  autocmd FileType html :set indentexpr=
  autocmd FileType xhtml :set indentexpr=
endif

" Some Debian-specific things
augroup filetype
  au BufRead reportbug.*    set ft=mail
  au BufRead reportbug-*    set ft=mail
augroup END

" タブ幅の設定
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set modelines=0

"インデントはスマートインデント
set smartindent
"検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
"検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
"検索時に最後まで行ったら最初に戻る
set wrapscan
"検索文字列入力時に順次対象文字列にヒットさせない
set noincsearch
"タブの左側にカーソル表示
"set listchars=tab:\\
set nolist
"入力中のコマンドをステータスに表示する
set showcmd
"括弧入力時の対応する括弧を表示
set showmatch
"検索結果文字列のハイライトを有効にしない
set nohlsearch
"ステータスラインを常に表示
set laststatus=2

function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

"ステータスラインに文字コードと改行文字を表示する
" set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']['.&ft.']'}\ %F%=%l,%c%V%8P
if winwidth(0) >= 120
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
endif

"set statusline=%{GetB()}

" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
" set wildmenu
" コマンドライン補間をシェルっぽく
set wildmode=list,longest,full
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 外部のエディタで編集中のファイルが変更されたら自動で読み直す
set autoread

" 文字コード関連
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
if &encoding !=# 'utf-8'
  set encoding=japan
endif
set fileencoding=japan
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがJISX0213に対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^euc-\%(jp\|jisx0213\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      let &encoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding='utf-8'
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" cvs,svnの時は文字コードをeuc-jpに設定
autocmd FileType cvs :set fileencoding=euc-jp
autocmd FileType svn :set fileencoding=utf-8

" set tags
if has("autochdir")
  set autochdir
  set tags=tags;
else
  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
endif


" tags key map (C-z を C-tに,C-tはGNU/screenとかぶる)
map <C-z> <C-t>

" phpでKでhelpをひく
"autocmd BufNewFile,Bufread *.php,*.php3,*.php4 set keywordprg="help"

" phpならindentファイルは使わない
"autocmd FileType php :filetype indent off

" %マッチでrubyのクラスやメソッドが対応するようにする
" autocmd FileType ruby :source ~/.vim/ftplugin/ruby-matchit.vim

" 辞書ファイルからの単語補間
:set complete+=k

" C-]でtjと同等の効果
nmap <C-]> g<C-]>

" yeでそのカーソル位置にある単語をレジスタに追加
nmap ye :let @"=expand("<cword>")<CR>

"set minibfexp
let g:miniBufExplMapWindowNavVim=1 "hjklで移動
let g:miniBufExplSplitBelow=0  " Put new window above
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1

" CD.vim example:// は適用しない
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

" howm
"set runtimepath+=~/.vim/howm_vim

"im_custom
"if has('im_custom/canna')
" set imoptions=canna
" set noimcmdline
" set iminsert=0
" set imsearch=0
" inoremap :set iminsert=0
" inoremap :set imsearch=0
"" <C-i>でのインサートモードに入ったときは日本語入力On
"  nmap <C-i> :set iminsert=2<CR>i
"" imap <ESC> <ESC>:set iminsert=0<CR>
"endif

" insert mode時にc-jで抜ける
" imap <C-j> <esc>

" Taglist
" nnoremap <silent> <C-,> :Tlist<CR>
"nnoremap <C-q> :Tlist<CR>
"nnoremap <silent> <C-.> :TlistClose<CR>

" savevers.vim(backup)
"set backup
"set patchmode=.clean
"set backupdir=~/.backup_vim
"let savevers_types = "*"
"let savevers_dirs = &backupdir

" command mode 時 tcsh風のキーバインドに
cmap <C-A> <Home>
cmap <C-F> <Right>
cmap <C-B> <Left>
cmap <C-D> <Delete>
cmap <Esc>b <S-Left>
cmap <Esc>f <S-Right>

"表示行単位で行移動する
nmap j gj
nmap k gk
vmap j gj
vmap k gk

"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" closetab C-_でタグをとじる
"let g:closetag_html_style=1
"source ~/.vim/scripts/closetag.vim

",e でそのコマンドを実行
nmap ,e :execute '!' &ft ' %'<CR>
"nmap ,e :execute 'set makeprg=' . expand(&ft) . '\ ' . expand('%')<CR>:make<CR>

" phpdoc
let g:foo_DefineAutoCommands = 1

" MiniBufExplorer で GNU screen likeなキーバインド
let mapleader = " "
"nnoremap <Leader>f :last<CR>
"nnoremap <Leader><C-f> :last<CR>
nmap <Space> :MBEbn<CR>
nmap <F3> :MBEbp<CR>
nmap <F4> :MBEbn<CR>
nnoremap <Leader><Space> :MBEbn<CR>
nnoremap <Leader>n       :MBEbn<CR>
nnoremap <Leader><C-n>   :MBEbn<CR>
nnoremap <Leader>p       :MBEbp<CR>
nnoremap <Leader><C-p>   :MBEbp<CR>
nnoremap <Leader>c       :new<CR>
nnoremap <Leader><C-c>   :new<CR>
nnoremap <Leader>k       :bd<CR>
nnoremap <Leader><C-k>   :bd<CR>
nnoremap <Leader>s       :IncBufSwitch<CR>
nnoremap <Leader><C-s>   :IncBufSwitch<CR>
nnoremap <Leader><Tab>   :wincmd w<CR>
nnoremap <Leader>Q       :only<CR>
nnoremap <Leader>w       :ls<CR>
nnoremap <Leader><C-w>   :ls<CR>
nnoremap <Leader>a       :e #<CR>
nnoremap <Leader><C-a>   :e #<CR>
nnoremap <Leader>"       :BufExp<CR>
nnoremap <Leader>1   :e #1<CR>
nnoremap <Leader>2   :e #2<CR>
nnoremap <Leader>3   :e #3<CR>
nnoremap <Leader>4   :e #4<CR>
nnoremap <Leader>5   :e #5<CR>
nnoremap <Leader>6   :e #6<CR>
nnoremap <Leader>7   :e #7<CR>
nnoremap <Leader>8   :e #8<CR>
nnoremap <Leader>9   :e #9<CR>

nnoremap ,<Space> :MBEbn<CR>
nnoremap ,n       :MBEbn<CR>
nnoremap ,<C-n>   :MBEbn<CR>
"nnoremap ,p       :MBEbp<CR>
"nnoremap ,<C-p>   :MBEbp<CR>
nnoremap ,c       :new<CR>
nnoremap ,<C-c>   :new<CR>
nnoremap ,k       :bd<CR>
nnoremap ,<C-k>   :bd<CR>
nnoremap ,s       :IncBufSwitch<CR>
nnoremap ,<C-s>   :IncBufSwitch<CR>
nnoremap ,<Tab>   :wincmd w<CR>
nnoremap ,Q       :only<CR>
nnoremap ,w       :ls<CR>
nnoremap ,<C-w>   :ls<CR>
nnoremap ,a       :e #<CR>
nnoremap ,<C-a>   :e #<CR>
nnoremap ,"       :BufExp<CR>
nnoremap ,1   :e #1<CR>
nnoremap ,2   :e #2<CR>
nnoremap ,3   :e #3<CR>
nnoremap ,4   :e #4<CR>
nnoremap ,5   :e #5<CR>
nnoremap ,6   :e #6<CR>
nnoremap ,7   :e #7<CR>
nnoremap ,8   :e #8<CR>
nnoremap ,9   :e #9<CR>
" Taglist用
nnoremap <Leader>l       :Tlist<CR>
nnoremap <Leader><C-l>       :Tlist<CR>
nnoremap <Leader>o       :TlistClose<CR>
nnoremap <Leader><C-o>       :TlistClose<CR>

let mapleader = '\'

" buf移動
"nmap <c-n>  :MBEbn<CR>
"nmap <c-p>  :MBEbp<CR>

" いろいろ囲むよ
"fun! Quote(quote)
"  normal mz
"  exe 's/\(\k*\%#\k*\)/' . a:quote . '\1' . a:quote . '/'
"  normal `zl
"endfun
"
"fun! UnQuote()
"  normal mz
""  exe 's/["' . "'" . ']\(\k*\%#\k*\)[' . "'" . '"]/\1/'
"  exe 's/\(["' . "'" . ']\)\(\k*\%#\k*\)\1/\2/'
"  normal `z
"endfun

nnoremap <silent> ,q" :call Quote('"')<CR>
nnoremap <silent> ,q' :call Quote("'")<CR>
nnoremap <silent> ,qd :call UnQuote()<CR>

"" 'quote' a word
"nnoremap ,q' :silent! normal mpea'<esc>bi'<esc>`pl
"" double "quote" a word
"nnoremap ,q" :silent! normal mpea"<esc>bi"<esc>`pl
"nnoremap ,q( :silent! normal mpea)<esc>bi(<esc>`pl
"nnoremap ,q[ :silent! normal mpea]<esc>bi[<esc>`pl
"nnoremap ,q{ :silent! normal mpea}<esc>bi{<esc>`pl
"" remove quotes from a word
"nnoremap ,qd :silent! normal mpeld bhd `ph<CR>


" 現在行をhighlight
" set updatetime=1
" autocmd CursorHold * :match Search /^.*\%#.*$

" code2html
let html_use_css = 1

" ペースト時にautoindentを無効に
set paste

" SeeTab
let g:SeeTabCtermFG="black"
let g:SeeTabCtermBG="red"

" netrw-ftp
let g:netrw_ftp_cmd="netkit-ftp"

" netrw-http
let g:netrw_http_cmd="wget -q -O"

" mru.vim
" MRU は MiniBufExplorer と相性がわるいためつかわない
"let MRU_Max_Entries = 100
"let MRU_Use_Current_Window = 2
"let MRU_Window_Height=15

" YankRing.vim
nmap ,y :YRShow<CR>

" html escape function
:function HtmlEscape()
silent s/&/\&amp;/eg
silent s/</\&lt;/eg
silent s/>/\&gt;/eg
:endfunction

:function HtmlUnEscape()
silent s/&lt;/</eg
silent s/&gt;/>/eg
silent s/&amp;/\&/eg
:endfunction

" 16色
"set t_Co=256
"set t_Sf= ^[3%dm
"set t_Sb= ^[4%dm

" 補完候補の色づけ for vim7
hi Pmenu ctermbg=8
hi PmenuSel ctermbg=12
hi PmenuSbar ctermbg=0

" 検索後、真ん中にフォーカスをあわせる
"nmap n nzz
"nmap N Nzz
"nmap * *zz
"nmap # #zz
"nmap g* g*zz
"nmap g# g#zz


" encoding
nmap ,U :set encoding=utf-8<CR>
nmap ,E :set encoding=euc-jp<CR>
nmap ,S :set encoding=cp932<CR>

" rails
au BufNewFile,BufRead app/**/*.rhtml set fenc=utf-8
au BufNewFile,BufRead app/**/*.rb set fenc=utf-8

" cofs's fsync
au BufNewFile,BufRead /mnt/c/* set nofsync

" vimgrep + quickfix
nmap <unique> g/ :exec ':vimgrep /' . getreg('/') . '/j %\|cwin'<CR>

" FuzzyFinder
nmap <silent> fb :FuzzyFinderBuffer<CR>
nmap <silent> ff :FuzzyFinderFile<CR>
nmap <silent> fv :FuzzyFinderFavFile<CR>
nmap <silent> fm :FuzzyFinderMruFile<CR>
nmap <silent> fc :FuzzyFinderMruCmd<CR>
nmap <silent> fd :FuzzyFinderDir<CR>
nmap <silent> fa :FuzzyFinderAddFavFile<CR>

autocmd BufNewFile,BufRead /mnt/win/* set nofsync

" REQUIRED. This makes vim invoke latex-suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse latex-suite. Set your grep
" program to alway generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

let g:Tex_CompileRule_dvi = 'platex $*'
let g:Tex_ViewRule_dvi = 'xdvi'

set noswapfile

let python_highlight_all = 1

map <silent> sy :call YanktmpYank()<CR> 
map <silent> sp :call YanktmpPaste_p()<CR> 
map <silent> sP :call YanktmpPaste_P()<CR> 

set number
