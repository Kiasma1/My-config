if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Plugin: UI
Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Plugin: themes
Plug 'morhetz/gruvbox'
Plug 'twerth/ir_black'
Plug 'tomasr/molokai'
Plug 'chriskempson/base16-vim'
Plug 'nanotech/jellybeans.vim'

" Plugin: Editing
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/vim-easy-align'
Plug 'preservim/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'gcmt/wildfire.vim'
Plug 'tpope/vim-surround'
Plug 'Shougo/echodoc.vim'
Plug 'dkarter/bullets.vim'
" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-indent'
" Plug 'kana/vim-textobj-syntax'
" Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java', 'go'] }
" Plug 'sgur/vim-textobj-parameter'

" Plugin: Completion & Syntastic & snippets
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" go
Plug 'fatih/vim-go', { 'for':'go' }
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

" Plugin: tags
Plug 'universal-ctags/ctags'
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/tagbar'

" Plugin: Finder & Motions
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle' }
Plug 'easymotion/vim-easymotion'

" Plugin: Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

Plug 'skywind3000/asyncrun.vim'

call plug#end()

" Base-key map {{{

    let mapleader = "\<Space>"
    inoremap <Esc> <nop>
    inoremap jj <Esc>
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l
    nnoremap [b :bp<CR>
    nnoremap ]b :bn<CR>
    map tt :NERDTreeToggle<CR>
    " configure file
    map <silent> <leader>fc :e $MYVIMRC<CR>
    autocmd! bufwritepost .vimrc source $MYVIMRC

" }}}

" base-settings {{{

    set hidden
    set nobackup
    set nowritebackup
    let &t_SI.="\e[5 q"
    let &t_SR.="\e[4 q"
    let &t_EI.="\e[1 q"
    set tags=./.tags;,.tags
    set updatetime=100
    set cursorline "突出当前行
    set number relativenumber "显示行号
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
    syntax enable
    colorscheme base16-default-dark
    let base16colorspace=256
    " set background=dark
    set t_Co=256
    " let g:gruvbox_contrast_dark="hard"
    let g:rehash256=1
    "" 设置编码
    set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
    set encoding=utf-8
    "" 缩进
    set smartindent
    set tabstop=4
    set shiftwidth=4
    set expandtab
    set softtabstop=4
    set helplang=cn

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
    autocmd FileType go nmap <silent> <F9> :AsyncRun :!go run % <cr>
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

" tagbar {{{

    nmap <F1> :TagbarToggle<CR>
    let g:tagbar_width=30
    let g:tagbar_sort=0
    let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
          \ 'p:package',
          \ 'i:imports:1',
          \ 'c:constants',
          \ 'v:variables',
          \ 't:types',
          \ 'n:interfaces',
          \ 'w:fields',
          \ 'e:embedded',
          \ 'm:methods',
          \ 'r:constructor',
          \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
          \ 't' : 'ctype',
          \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
          \ 'ctype' : 't',
          \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ 
      \ }

" }}}

" vim-easy-align {{{

    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)"

" }}}

" LeaderF {{{

    let g:Lf_ShortcutF               = '<leader>fp'
    let g:Lf_ShortcutB               = '<leader>fb'
    let g:Lf_DefaultMode             = 'NameOnly'
    let g:Lf_HideHelp                = 1
    let g:Lf_UseCache                = 0
    let g:Lf_IgnoreCurrentBufferName = 1
    let g:Lf_ShowHidden              = 1
    let g:Lf_ShowDevIcons            = 0
    let g:Lf_UseVersionControlTool   = 0
    let g:Lf_WindowPosition          = 'popup'
    let g:Lf_PreviewInPopup          = 1
    let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
    let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
    let g:Lf_WorkingDirectoryMode = 'Ac'
    let g:Lf_WindowHeight = 0.30
    let g:Lf_ShowRelativePath = 0
    let g:Lf_StlColorscheme = 'powerline'
    let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}
    nmap <silent> <leader>f<s-b>: LeaderfBufferAll<CR>
    nmap <silent> <leader>fl    : LeaderfLine<CR>
    nmap <silent> <leader>f<s-l>: LeaderfLineAll<CR>
    nmap <silent> <leader>ff    : LeaderfFunction<CR>
    nmap <silent> <leader>f<s-f>: LeaderfFunctionAll<CR>
    nmap <silent> <leader>fr    : LeaderfMru<CR>
    nmap <silent> <leader>fg    : LeaderfRgInteractive<CR>
    nmap <silent> <leader>ft    : LeaderfTag<CR>

" }}}

" Vim-go{{{

    syntax enable
    filetype plugin on
    let g:go_disable_autoinstall = 0
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1

" }}}

"" YCM {{{
  "let g:ycm_add_preview_to_completeopt = 0
  "let g:ycm_show_diagnostics_ui = 0
  "let g:ycm_server_log_level = 'info'
  "let g:ycm_min_num_identifier_candidate_chars = 2
  "let g:ycm_collect_identifiers_from_comments_and_strings = 1
  "let g:ycm_complete_in_strings=1
  "let g:ycm_key_invoke_completion = '<c-z>'
  "set completeopt=menu,menuone

  "noremap <c-z> <NOP>

  "let g:ycm_semantic_triggers =  {
             "\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
             "\ 'cs,lua,javascript': ['re!\w{2}'],
             "\ }
"" }}}

" UltiSnips {{{

    "let g:UltiSnipsExpandTrigger="<c-e>"
    "let g:UltiSnipsJumpForwardTrigger="<c-e>"
    "let g:UltiSnipsJumpBackwardTrigger="<c-n>"
    "let g:UltiSnipsEditSplit="vertical"

" }}}

" airline {{{

    let g:airline#extensions#tabline#enabled = 1
    let g:airline_powerline_fonts = 1

" }}}

" easymotion {{{

    let g:EasyMotion_smartcase=1
    map <leader><leader>h <Plug>(easymotion-linebackward)
    map <leader><leader>j <Plug>(easymotion-j)
    map <leader><leader>k <Plug>(easymotion-k)
    map <leader><leader>l <Plug>(easymotion-lineforward)
    map <leader><leader>. <Plug>(easymotion-repeat)

" }}}
"
"
" coc.nvim {{{
    let g:coc_global_extensions = [
                \ 'coc-go',
                \ 'coc-vimlsp',
                \ 'coc-json',
                \ 'coc-translator']

    set shortmess+=c

    if has("patch-8.1.1564")
        set signcolumn=number
    else
        set signcolumn=yes
    endif

    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1] =~# '\s'
    endfunction

    inoremap <silent><expr> <c-o> coc#refresh()

     " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
     " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    nmap <silent> [e <Plug>(coc-diagnostic-prev)
    nmap <silent> ]e <Plug>(coc-diagnostic-next)

    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)

    " Remap for format selected region
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    
    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
        else
            execute '!' . &keywordprg . " " . expand('<cword>')
        endif
    endfunction

    " Create mappings for function text object, requires document symbols feature of languageserver.
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    nmap <Leader>t <Plug>(coc-translator-p)
    vmap <Leader>t <Plug>(coc-translator-pv)

    "" Using CocList
    "" Show all diagnostics
    "nnoremap <silent> <space>la  :<C-u>CocList diagnostics<cr>
    "" Manage extensions
    "nnoremap <silent> <space>le  :<C-u>CocList extensions<cr>
    "" Show commands
    "nnoremap <silent> <space>lc  :<C-u>CocList commands<cr>
    "" Find symbol of current document
    "nnoremap <silent> <space>lo  :<C-u>CocList outline<cr>
    "" Search workspace symbols
    "nnoremap <silent> <space>ls  :<C-u>CocList -I symbols<cr>
    "" Do default action for next item.
    "nnoremap <silent> <space>j  :<C-u>CocNext<CR>
    "" Do default action for previous item.
    "nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
    "" Resume latest coc list
    "nnoremap <silent> <space>lp  :<C-u>CocListResume<CR>

" }}}

" vim-startify {{{

    let g:startify_lists = [{'type':'files', 'header':['    MRU']}]

" }}}
