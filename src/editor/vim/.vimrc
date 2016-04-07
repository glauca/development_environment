" ====================================================================================================
" Filename: .vimrc
" Author: glauca
" Date: 2014-01-07
" ====================================================================================================

":%s/\s\+$//    删除多余空格
":%s/find/replace/g    替换

" ====================================================================================================支持utf-8
filetype on                                                                                           "检查文档类型
set ffs=unix,dos,mac                                                                                  "文件格式
set fileencoding=gb18030                                                                              "默认文件编码为utf-8
set fileencodings=utf-8,gb18030,utf-16,big5                                                           "支持打开的文件编码
set fencs=utf-8,gbk,ucs-bom,gb18030,gb2312,cp936

"所有文件的编辑encoding都将是utf8, 而且可以自动识别其他encoding的文件
"如果文件本身是gbk将被打开成utf8文件编辑,但是保存还是会用gbk,如果要修改成utf8用:set fenc=utf8
set encoding=utf-8
set nobomb
set ambiwidth=double                                                                                  "对 不明宽度 字符的处理方式；Vim 6.1.455 后引入
" ====================================================================================================支持utf-8

" ====================================================================================================状态栏
" 修改状态栏为: Ln: 行, Col: 列 | 语言 | 文件编码(编辑编码) | Tab: 大小 | 文件格式
set laststatus=2
set statusline=%<%{'Ln:\ '}%l,%{'\ Col:\ '}%c%V\ \|\ %Y\ \|\ %{&fenc}\ (%{&enc}\)\ \|\ %{'Tab:\ '.&sw}\ \|\ %{&ff}%=%8P
" ====================================================================================================状态栏

" ====================================================================================================
"  VIM 的一些常用配置
" ====================================================================================================
set shortmess=atI                                                                                     "去掉欢迎界面
set vb t_vb=                                                                                          "关闭响铃

set guifont=Courier\ New:h10                                                                          "字体
"http://vimcolorschemetest.googlecode.com/svn/colors/darkburn.vim
colorscheme darkburn                                                                                  "主题 /usr/share/vim/vim70/colors
set t_Co=256
set nu!                                                                                               "行号
set mouse=a                                                                                           "xterm支持鼠标

set history=1000
syntax enable                                                                                         "语法检测
syntax on                                                                                             "开启语法高亮
set incsearch                                                                                         "增量查找
set hlsearch                                                                                          "高亮查找提醒
set showmatch                                                                                         "显示对应括号
set ruler                                                                                             "显示标尺
set autoindent                                                                                        "自动索引
set cindent                                                                                           "cindent 缩进
set smartindent                                                                                       "智能自动缩进
filetype indent on                                                                                    "Enable filetype detection and use of indent plugins
set ai!                                                                                               "开启自动缩进
set nowrapscan                                                                                        "是否绕回搜索 

"Tab为空格
:%retab!
set list                                                                                              "显示tab和行尾空格
set lcs=tab:\-\ ,nbsp:%,trail:`                                                                       "tab - 空格`
highlight LeaderTab guifg=#666666
match LeaderTab /^\t/
set tabstop=4
set expandtab                                                                                         "自动把tab转化为空格
set shiftwidth=4

" ====================================================================================================自动补全
filetype plugin on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType php set omnifunc=phpcomplete#CompletePHP



"备份到/root/vimBack
"set backup
"set writebackup
"set backupdir=/root/vimBackup

"Ctags
"ctrl+] ctrl+t
"ctags -R
"set tags=/root/tags
