if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'universal-ctags/ctags'
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/tagbar'

Plug 'morhetz/gruvbox'

Plug 'skywind3000/asyncrun.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go', { 'for':'go' }

" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-indent'
" Plug 'kana/vim-textobj-syntax'
" Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java', 'go'] }
" Plug 'sgur/vim-textobj-parameter'

Plug 'Shougo/echodoc.vim'

Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle' }

Plug 'jiangmiao/auto-pairs'

Plug 'gcmt/wildfire.vim'
Plug 'tpope/vim-surround'

Plug 'mhinz/vim-signify'

call plug#end()

" Key map {{{
  let mapleader = "\<Space>"
  imap jj <Esc>
  
" imap ( ()<Esc>i
" imap [ []<Esc>i
" imap { {}<Esc>i

  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l

  map <leader>t :NERDTreeToggle<CR>
" }}}

" 基本设置 {{{
  set updatetime=100
  set cursorline "突出当前行
  set number "显示行号
  set termguicolors " 24bit颜色
  set colorcolumn=80 " 每行最长长度提示
  set noswapfile  "不创建swp文件
  set ignorecase  "忽略大小写
  set smartcase   "如果同时打开了ignorecase，那么对于只有一个大写字母的搜索词，将大小写敏感
  set linebreak   "只用遇到制定的符号（空格、连词号等标点符号），才发生折行，不会再单词内部折行
" set list        "显示不可见字符
  set fileformat=unix "文件格式
  set maxmempattern=2000000 "规定了vim做字符串匹配时使用的最大内存
  "" 主题
  colorscheme gruvbox
  set background=dark
  "" 设置编码
  set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
  set encoding=utf-8
  "" 缩进
  set smartindent
  set tabstop=4
  set shiftwidth=4
  set expandtab
  set softtabstop=4
" }}}

" vim-gutentags {{{
  " gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
  let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
  
  " 所生成的数据文件的名称
  let g:gutentags_ctags_tagfile = '.tags'
  
  " 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
  let s:vim_tags = expand('~/.cache/tags')
  let g:gutentags_cache_dir = s:vim_tags
  
  " 配置 ctags 的参数
  let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
  let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
  let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
  
  " 检测 ~/.cache/tags 不存在就新建
  if !isdirectory(s:vim_tags)
     silent! call mkdir(s:vim_tags, 'p')
     endif
" }}}

" asyncrun.vim {{{
  " 重新定义项目标志
  let g:asyncrun_rootmarks = ['.svn', '.git', '.root', '_darcs', 'build.xml'] 
  " 自动打开 quickfix window ，高度为 6
  let g:asyncrun_open = 6
  " 任务结束时候响铃提醒
  let g:asyncrun_bell = 1
  " 设置 F10 打开/关闭 Quickfix 窗口
  nmap <F10> :call asyncrun#quickfix_toggle(6)<cr>
  
  " 设置 F9 单文件：编译
  autocmd FileType cpp nmap <silent> <F9> :AsyncRun g++ -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
  autocmd FileType c nmap <silent> <F9> :AsyncRun gcc -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>

  " 设置 F8 项目：运行
  autocmd FileType cpp,c nmap <silent> <F8> :AsyncRun -cwd=<root> -raw make run <cr>
  " 设置 F7 项目：编译
  autocmd FileType cpp,c nmap <silent> <F7> :AsyncRun -cwd=<root> make <cr>
  " 设置 F6 项目：测试
  autocmd FileType cpp,c nmap <silent> <F6> :AsyncRun -cwd=<root> -raw make test <cr>
  " 设置 F5 单文件：运行
  autocmd FileType cpp,c nmap <silent> <F5> :AsyncRun -raw -cwd=$(VIM_FILEDIR) "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
  " 设置 F4 使用cmake生成Makefile
  autocmd FileType cpp,c nmap <silent> <F4> :AsyncRun -cwd=<root> cmake . <cr>

" }}}
"
" YCM {{{
  let g:ycm_confirm_extra_conf = 1
  let g:ycm_add_preview_to_completeopt = 0
  let g:ycm_show_diagnostics_ui = 0
  let g:ycm_server_log_level = 'info'
  let g:ycm_min_num_identifier_candidate_chars = 2
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_complete_in_strings=1
  let g:ycm_key_invoke_completion = '<c-z>'
  set completeopt=menu,menuone
  
  noremap <c-z> <NOP>
  
  let g:ycm_semantic_triggers =  {
             \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
             \ 'cs,lua,javascript': ['re!\w{2}'],
             \ }
" }}}
" 
" ale {{{
  let g:ale_linters = {
  \   'c++': ['gcc'],
  \   'c': ['gcc'],
  \   'go': ['gofmt', 'golint'],
  \}
  let g:ale_linters_explicit = 1
  let g:ale_completion_delay = 500
  let g:ale_echo_delay = 20
  let g:ale_lint_delay = 500
  let g:ale_echo_msg_format = '[%linter%] %code: %%s'
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1
  let g:airline#extensions#ale#enabled = 1
  
  let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
  let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
  let g:ale_c_cppcheck_options = ''
  let g:ale_cpp_cppcheck_options = ''
" }}}
"
" tagbar {{{
  nmap <F1> :TagbarToggle<CR>
" }}}
"
" LeaderF {{{
  let g:Lf_ShortcutF = '<c-p>'
  let g:Lf_ShortcutB = '<leader>b'
  noremap <c-n> :LeaderfMru<cr>
  noremap <leader>p :LeaderfFunction!<cr>
  noremap <leader>n :LeaderfBuffer<cr>
  noremap <leader>m :LeaderfTag<cr>
  let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
  
  let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
  let g:Lf_WorkingDirectoryMode = 'Ac'
  let g:Lf_WindowHeight = 0.30
  let g:Lf_CacheDirectory = expand('~/.vim/cache')
  let g:Lf_ShowRelativePath = 0
  let g:Lf_HideHelp = 1
  let g:Lf_StlColorscheme = 'powerline'
  let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}
" }}}
"
" Vim-GO{{{
  syntax enable
  filetype plugin on
  let g:go_disable_autoinstall = 0
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
" }}}
