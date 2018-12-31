"
" Vim8用サンプル vimrc
"
if has('win32')                   " Windows 32bit または 64bit ?
  set encoding=cp932              " cp932 が嫌なら utf-8 にしてください
else
  set encoding=utf-8
endif
scriptencoding utf-8              " This file's encoding

" 推奨設定の読み込み (:h default.vim)
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

"===============================================================================
" 設定の追加はこの行以降でおこなうこと！
" 分からないオプション名は先頭に ' を付けてhelpしましょう。例:
" :h 'helplang

packadd! vimdoc-ja                " 日本語help の読み込み
set helplang=ja,en                " help言語の設定

set scrolloff=0
set laststatus=2                  " 常にステータス行を表示する
set cmdheight=2                   " hit-enter回数を減らすのが目的
if !has('gui_running')            " gvimではない？ (== 端末)
  set mouse=                      " マウス無効 (macOS時は不便かも？)
  set ttimeoutlen=0               " モード変更時の表示更新を最速化
  if $COLORTERM == "truecolor"    " True Color対応端末？
    set termguicolors
  endif
endif
set nofixendofline                " Windowsのエディタの人達に嫌われない設定
set ambiwidth=double              " ○, △, □等の文字幅をASCII文字の倍にする
set directory-=.                  " swapファイルはローカル作成がトラブル少なめ
set formatoptions+=mM             " 日本語の途中でも折り返す
let &grepprg="grep -rnIH --exclude=.git --exclude-dir=.hg --exclude-dir=.svn --exclude=tags"
let loaded_matchparen = 1         " カーソルが括弧上にあっても括弧ペアをハイライトさせない

" :grep 等でquickfixウィンドウを開く (:lgrep 等でlocationlistウィンドウを開く)
"augroup qf_win
"  autocmd!
"  autocmd QuickfixCmdPost [^l]* copen
"  autocmd QuickfixCmdPost l* lopen
"augroup END

" マウスの中央ボタンクリックによるクリップボードペースト動作を抑制する
noremap <MiddleMouse> <Nop>
noremap! <MiddleMouse> <Nop>
noremap <2-MiddleMouse> <Nop>
noremap! <2-MiddleMouse> <Nop>
noremap <3-MiddleMouse> <Nop>
noremap! <3-MiddleMouse> <Nop>
noremap <4-MiddleMouse> <Nop>
noremap! <4-MiddleMouse> <Nop>

"-------------------------------------------------------------------------------
" ステータスライン設定
let &statusline = "%<%f %m%r%h%w[%{&ff}][%{(&fenc!=''?&fenc:&enc).(&bomb?':bom':'')}] "
if has('iconv')
  let &statusline .= "0x%{FencB()}"

  function! FencB()
    let c = matchstr(getline('.'), '.', col('.') - 1)
    if c != ''
      let c = iconv(c, &enc, &fenc)
      return s:Byte2hex(s:Str2byte(c))
    else
      return '0'
    endif
  endfunction
  function! s:Str2byte(str)
    return map(range(len(a:str)), 'char2nr(a:str[v:val])')
  endfunction
  function! s:Byte2hex(bytes)
    return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
  endfunction
else
  let &statusline .= "0x%B"
endif
let &statusline .= "%=%l,%c%V %P"

"-------------------------------------------------------------------------------
" ファイルエンコーディング検出設定
let &fileencoding = &encoding
if has('iconv')
  if &encoding ==# 'utf-8'
    let &fileencodings = 'iso-2022-jp,euc-jp,cp932,' . &fileencodings
  else
    let &fileencodings .= ',iso-2022-jp,utf-8,ucs-2le,ucs-2,euc-jp'
  endif
endif
" 日本語を含まないファイルのエンコーディングは encoding と同じにする
if has('autocmd')
  function! AU_ReSetting_Fenc()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding = &encoding
    endif
  endfunction
  augroup resetting_fenc
    autocmd!
    autocmd BufReadPost * call AU_ReSetting_Fenc()
  augroup END
endif

"-------------------------------------------------------------------------------
" カラースキームの設定
colorscheme torte

try
  silent hi CursorIM
catch /E411/
  " CursorIM (IME ON中のカーソル色)が定義されていなければ、紫に設定
  hi CursorIM ctermfg=16 ctermbg=127 guifg=#000000 guibg=#af00af
endtry

" vim:set et ts=2 sw=0:

" シンタックスハイライトをON
syntax enable

" 大文字を含まない文字列での検索では大文字小文字を区別しない
set ignorecase
set smartcase
" インクリメンタルサーチを有効にする
set incsearch
" 検索でマッチしたワードをハイライト
set hlsearch
" 行番号を表示する
set number
" タブと行の折り返しを可視化する
set list listchars=tab:>\ ,extends:<
" 常にタブをスペースに展開する
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
" 自動インデントをONにする
set smartindent
set autoindent
" Insertモード中に<BS>で直前の文字を消せるように
set backspace=indent,eol,start
set nowrapscan
" マッチする括弧を強調表示
set showmatch matchtime=1
set matchpairs+=<:>
" 新しいウィンドウを開く際に現在のウィンドウの位置が変わらないようにする
set splitright
set splitbelow
" 常にコマンドを表示
set showcmd
" \+pでPasteモードと切り替え
set pastetoggle=<leader>p

set wildmenu
set wildmode=longest,full
set wildignore=.git,.hg,.svn
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore+=*.DS_Store

let format_allow_over_tw = 1
set whichwrap=b,s,h,l,<,>,[,]
set hidden
set visualbell
" バックアップファイルを作成しない
set nobackup

" Key Mappings
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k
inoremap <silent> jj <ESC>
inoremap <silent> っj <ESC>
" ウィンドウの移動をCtrlキーと方向指定でできるようにする
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Esc2回で検索のハイライトを消す
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

nnoremap <Space>. :<C-u>OpenVimrcTab<Cr>
function! OpenVimrcTab() " {{{
    tabnew
    cd ~
    edit ~/.vimrc
endfunction
"}}}
command! -nargs=0 OpenVimrcTab call OpenVimrcTab()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" dein.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vimをインストールしていない場合はインストールする
if !isdirectory(s:dein_repo_dir)
    echo "install dein.vim..."
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start dein.vim Settings.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    call dein#load_toml(s:dein_dir . '/dein.toml',{'lazy':0})
    call dein#load_toml(s:dein_dir . '/dein_lazy.toml',{'lazy':1})
    if !has('nvim')
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
    endif
    call dein#end()
    call dein#save_state()
endif

" If you want to install not installed plugins on startup.
if dein#check_install()
    call dein#install()
endif

filetype plugin indent on
syntax enable
