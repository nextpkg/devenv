#! /usr/bin/env python3
import os


class VimPlugin:
    """
    plugin : 插件列表
    check  : 安装插件前需要执行的shell命令
    command: 安装插件时需要执行的shell命令
    ending : 安装插件后需要执行的shell命令
    setting: 插件设置
    """
    setting = []

    def __init__(self):
        self.setting += [{
            "plugin": ["VundleVim/Vundle.vim"],
            "check": """
command -v git &>/dev/null || \
( (command -v dnf &>/dev/null && sudo dnf -y install git) || \
(command -v yum &>/dev/null && sudo yum -y install git) || \
(command -v apt-get &>/dev/null && sudo apt-get install -y git) || \
(command -v brew &>/dev/null && brew install git) || \
{ echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )
""",
            "command": """
mkdir -p "$HOME/.vim/bundle"
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]
then
    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim" || exit 1
fi
""",
            "ending": "",
            "setting": ""
        }]

    # 皮肤
    def _colorschemes(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["flazz/vim-colorschemes"],
                "check": "",
                "command": "",
                "ending": """
backup_file "$HOME/.vim/colors"
ln -s "$HOME/.vim/bundle/vim-colorschemes/colors" "$HOME/.vim/colors" || exit 1
""",
                "setting": """
"" Enable 256 colors to stop the CSApprox warning and make xterm vim shine
set t_Co=256
"" Load a colorscheme
"let g:molokai_original=1
"let g:rehash256 = 1
color gruvbox
"color solarized
""",
            }]

    # 多语言语法高亮
    def _polygolt(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["sheerun/vim-polyglot"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": "",
            }]

    # 备份
    def _go_back(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": [],
                "check": "",
                "command": """
mkdir -p $HOME/.vim/.backup
mkdir -p $HOME/.vim/.views
""",
                "ending": "",
                "setting": """
set backup
set backupdir=$HOME/.vim/.backup
set viewdir=$HOME/.vim/.views
"""
            }]

    # 搜索文本内容
    def _ack(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["mileszs/ack.vim"],
                "check": """
command -v ag &>/dev/null || \
( (command -v dnf &>/dev/null && sudo dnf -y install the_silver_searcher) || \
(command -v yum &>/dev/null && sudo yum -y install the_silver_searcher) || \
(command -v apt-get &>/dev/null && sudo apt-get install -y silversearcher-ag) || \
(command -v brew &>/dev/null && brew install the_silver_searcher) || \
{ echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )
""",
                "command": "",
                "ending": "",
                "setting": """
let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
map <F4> :Ack -i
""",
            }]

    # 目录树
    def _nerdtree(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": [
                    "scrooloose/nerdtree",
                    "jistr/vim-nerdtree-tabs"
                ],
                "check": "",
                "command": "",
                "ending": "",
                "setting": """
map <silent> <F2> :NERDTreeMirrorToggle<CR>
let g:nerdtree_tabs_autofind=1

let NERDTreeShowBookmarks=1
" Auto change the root directory
let NERDTreeChDirMode=2
" show hidden files
let NERDTreeShowHidden=1
let NERDTreeWinPos="right"
let NERDTreeMinimalUI=1
"let g:NERDTreeWinSize = 23
""delete the file auto delete the buffer
let NERDTreeAutoDeleteBuffer=1

"let NERDTreeIgnore=['\\.py[cd]$', '\\~$', '\\.swo$', '\\.swp$', '^\\.git$', '^\\.hg$', '^\\.svn$', '\\.bzr$']
"augroup nerdtree_group
    "autocmd!
    "" open a NERDTree automatically when vim starts up if no files were specified
    "autocmd StdinReadPre * let s:std_in=1
    "autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    "" close vim if the only window left open is a NERDTree
    "autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"augroup END
""",
            }]

    def _surround(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["tpope/vim-surround"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": "",
            }]

    def _repeat(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["tpope/vim-repeat"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": "",
            }]

    # 括号自动配对
    def _auto_pairs(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["jiangmiao/auto-pairs"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": "",
            }]

    def _ctrlp(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": [
                    "ctrlpvim/ctrlp.vim",
                    "tacahiroy/ctrlp-funky"
                ],
                "check": """
command -v ag &>/dev/null || \
( (command -v dnf &>/dev/null && sudo dnf -y install the_silver_searcher) || \
(command -v yum &>/dev/null && sudo yum -y install the_silver_searcher) || \
(command -v apt-get &>/dev/null && sudo apt-get install -y silversearcher-ag) || \
(command -v brew &>/dev/null && brew install the_silver_searcher) || \
{ echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )
""",
                "command": "",
                "ending": "",
                "setting": """
let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
""scan for dotfiles and dotdirs,does not apply when a command defined with g:ctrlp_user_command is being used
let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore = {'dir':  '\\v[\\/]\\.(git|hg|svn)$','file': '\\v\\.(exe|so|dll|pyc|swp)$'}
"" Use a version control listing command when inside a repository, this is faster when scanning large projects listing command lists untracked files (slower)
let g:ctrlp_user_command = {
    \\ 'types': {
        \\ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
        \\ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \\ },
    \\ 'fallback': s:ctrlp_fallback
\\ }

"" CtrlP extensions
let g:ctrlp_extensions = ['funky']

""funky
nnoremap <Leader>fu :CtrlPFunky<Cr>

"" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
""",
            }]

    def _airline(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["bling/vim-airline"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": """
"" enable/disable bufferline integration
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
"" configure whether buffer numbers should be shown
let g:airline#extensions#tabline#buffer_nr_show = 1
"" configure collapsing parent directories in buffer name
let g:airline#extensions#tabline#fnamecollapse = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'
"" the separator used on the left side
let g:airline_left_sep='|'
"" the separator used on the right side
let g:airline_right_sep='|'
let g:airline_middle_sep='|'
""",
            }]
        else:
            self.setting += [{
                "plugin": [],
                "check": "",
                "command": "",
                "ending": "",
                "setting": """
"" Broken down into easily includeable segments Filename
set statusline=%<%f\
"" Options
set statusline+=%w%h%m%r
"if isdirectory(expand("~/.vim/bundle/vim-fugitive/")) == 0
"" Git Hotness
"set statusline+=%{fugitive#statusline()}
"endif
"" Filetype
set statusline+=\\ [%{&ff}/%Y]
"" Current dir
set statusline+=\\ [%{getcwd()}]
"" Right aligned file nav info
set statusline+=%=%-14.(%l,%c%V%)\\ %p%%

"" Show the ruler
set ruler
"" A ruler on steroids
set rulerformat=%30(%=\\:b%n%y%m%r%w\\ %l,%c%V\\ %P%)
""",
            }]

    # 撤销记录
    def _undotree(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["mbbill/undotree"],
                "check": "",
                "command": """
mkdir -p $HOME/.vim/undo
""",
                "ending": "",
                "setting": """
set undodir=$HOME/.vim/undo
set undofile
"" Maximum number of changes that can be undone
set undolevels=1000
"" Maximum number lines to save for undo on a buffer reload
set undoreload=10000

nnoremap <silent> <F5> :UndotreeToggle<CR>
"" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1
""",
            }]

    def _signify(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["mhinz/vim-signify"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": """
nnoremap <silent> <leader>gg :SignifyToggle<CR>
let g:signify_vcs_list = [ 'git', 'svn' ]
""",
            }]

    def _wildfire(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["gcmt/wildfire.vim"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": """
map <SPACE> <Plug>(wildfire-fuel)
vmap <C-SPACE> <Plug>(wildfire-water)
let g:wildfire_objects = {  "*" : ["i'", 'i"', "i)", "i]", "i}","ip"], "html,xml" : ["at"],}
""",
            }]

    # 语法错误提示
    def _syntastic(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["scrooloose/syntastic"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": """
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
""Enable this option to tell syntastic to always stick any detected errors into the |location-list|
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_cpp_compiler = executable('clang++') ? 'clang++' : 'g++'
let g:syntastic_cpp_compiler_options = '-std=c++11'
""Use this option to specify the height of the location lists that syntastic opens.
"let g:syntastic_loc_list_height = 5
""",
            }]

    def _fugitive(self, use=False):
        if use == True:
            self.setting += [{
                "plugin": ["tpope/vim-fugitive"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": """
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
" Mnemonic _interactive
nnoremap <silent> <leader>gi :Git add -p %<CR>
""",
            }]

    def _easymotion(self, use=False):
        if use == True:
            self.setting += [{
                "plugin": ["Lokaltog/vim-easymotion"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": """
map <Leader>m <Plug>(easymotion-prefix)
"" Disable default mappings
let g:EasyMotion_do_mapping = 0
"" This setting makes EasyMotion work similarly to Vim's smartcase option for global searches
let g:EasyMotion_smartcase=1
"" Set this option to 0 to force the cursor to stay in the same column If you want to use both movements as separate mappings
let g:EasyMotion_startofline=0
map <leader>ms <Plug>(easymotion-s2)
map <Leader>mj <Plug>(easymotion-j)
map <Leader>mk <Plug>(easymotion-k)
""",
            }]

    # 添加/解开 注释
    def _nerdcommenter(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["scrooloose/nerdcommenter"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": "",
            }]

    # .c文件和.h文件之间的切换
    def _a(self, use=False):
        if use == True:
            self.setting += [{
                "plugin": ["vim-scripts/a.vim"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": "",
            }]

    # 文本对齐
    def _tabular(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["godlygeek/tabular"],
                "check": "",
                "command": "",
                "ending": "",
                "setting": """
nmap <leader>aa :Tabularize /
vmap <leader>aa :Tabularize /
""",
            }]

    def _tagbar(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["majutsushi/tagbar"],
                "check": """
command -v ctags &>/dev/null || \
( (command -v dnf &>/dev/null && sudo dnf -y install ctags) || \
(command -v yum &>/dev/null && sudo yum -y install ctags) || \
(command -v apt-get &>/dev/null && sudo apt-get install -y ctags) || \
(command -v brew &>/dev/null && brew install ctags) || \
{ echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )
""",
                "command": "",
                "ending": "",
                "setting": """
"" Width of the Tagbar window in characters.
nmap <silent> <F3> :TagbarToggle<CR>
let g:tagbar_width = 30
"" Set this option to open it on the left instead
let g:tagbar_left = 1
"" auto open Tagbar only for specific filetypes
"autocmd FileType c,cpp,h nested :TagbarOpen
autocmd BufWinEnter * if &previewwindow | setlocal nonumber | endif
let g:tagbar_previewwin_pos = "rightbelow"  "The position of the preview window
let g:tagbar_autopreview = 1
""hide help infomation
let g:tagbar_compact=1
""",
            }]

    # 代码片段补全
    def _snip(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": [
                    "SirVer/ultisnips",
                    "honza/vim-snippets"
                ],
                "check": "",
                "command": """
mkdir -p $HOME/.vim/UltiSnips
""",
                "ending": "",
                "setting": """
"" remap Ultisnips for compatibility for YCM
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
""",
            }]

    def _ctags(self, use=False):
        if use == True:
            self.setting += [{
                "plugin": [],
                "check": """
command -v ctags &>/dev/null || \
(( command -v dnf &>/dev/null && sudo dnf -y install ctags) || \
(command -v yum &>/dev/null && sudo yum -y install ctags) || \
(command -v apt-get &>/dev/null && sudo apt-get install -y ctags) || \
(command -v brew &>/dev/null && brew install ctags) || \
{ echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )
""",
                "command": """
mkdir -p $HOME/.vim/tags
echo "这个功能需要系统头文件的ctags支持,如需使用,请先生存ctags 保存到 $HOME/.vim/tags/systags"
""",
                "ending": "",
                "setting": """
set tags=./tags;
autocmd FileType c set tags+=~/.vim/tags/systags
"" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
""",
            }]

    def _cscope(self, use=False):
        if use == True:
            self.setting += [{
                "plugin": [],
                "check": """
command -v cscope &>/dev/null || \
(( command -v dnf &>/dev/null && sudo dnf -y install cscope) || \
(command -v yum &>/dev/null && sudo yum -y install cscope) || \
(command -v apt-get &>/dev/null && sudo apt-get install -y cscope) || \
(command -v brew &>/dev/null && brew install cscope) || \
{ echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )
""",
                "command": """
mkdir -p /tmp/cscope
""",
                "ending": "",
                "setting": """
set cscopetag
"" check cscope for definition of a symbol before checking ctags:set to 1 if you want the reverse search order.
set csto=1
""add the database pointed to by environment variable
if $CSCOPE_DB !=""
    cs add $CSCOPE_DB
endif

"" add any cscope database in current directory
if filereadable("cscope.out")
    cs add cscope.out
endif

"" show msg when any other cscope db added
set cscopeverbose

nmap <leader>sa :cs add cscope.out<CR>
nmap <leader>ss :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>sg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>sc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>st :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>se :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>si :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <leader>sd :cs find d <C-R>=expand("<cword>")<CR><CR>

set cscopequickfix=s-,g-,c-,d-,t-,e-,f-,i-
""",
            }]

    # 这种用法很久没用了,新版本中这个函数未经测试
    def _omnicomplete(self, use=False):
        if use == True:
            self.setting += [{
                "plugin": [],
                "check": """
vim --version | grep +autocmd >/dev/null || (echo "vim不支持 autocmd" && exit 1)
vim --version | grep +omnifunc >/dev/null || (echo "vim不支持 omnifunc" && exit 1)
""",
                "command": "",
                "ending": "",
                "setting": """
autocmd Filetype * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

"" Some convenient mappings
"inoremap   <expr>  <Esc>       pumvisible() ? "\\<C-e>" : "\\<Esc>"
inoremap    <expr>  <CR>        pumvisible() ? "\\<C-y>" : "\\<CR>"
inoremap    <expr>  <Down>      pumvisible() ? "\\<C-n>" : "\\<Down>"
inoremap    <expr>  <Up>        pumvisible() ? "\\<C-p>" : "\\<Up>"
inoremap    <expr>  <C-d>       pumvisible() ? "\\<PageDown>\\<C-p>\\<C-n>" : "\\<C-d>"
inoremap    <expr>  <C-u>       pumvisible() ? "\\<PageUp>\\<C-p>\\<C-n>" : "\\<C-u>"

"" Automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"set completeopt=menu,preview,longest
set completeopt=menu,longest

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
""",
            }]

    # 语法补全
    def _ycm(self, use=True):
        if use == True:
            self.setting += [{
                "plugin": ["Valloric/YouCompleteMe", "rdnetto/YCM-Generator"],
                "check": """
vim --version | grep +python >/dev/null || (echo "YCM要求 VIM必须要有python支持" && exit 1)
( command -v yum &>/dev/null && (sudo yum -y install automake gcc gcc-c++ kernel-devel cmake python-devel clang clang-devel) ) || \
( command -v dnf &>/dev/null && (sudo dnf -y install automake gcc gcc-c++ kernel-devel cmake python-devel clang clang-devel) ) || \
(command -v apt-get &>/dev/null && (sudo apt-get install build-essential cmake python-dev python3-dev clang libclang-dev)) || \
(command -v brew &>/dev/null && (brew install cmake)) || \
(echo "过程被中断,或者使用了不支持的包管理工具" && exit 1)
""",
                "command": "",
                "ending": """
[ ! -d $HOME/.vim/bundle/YouCompleteMe ] && echo "Bundle安装未完整,请重新执行install.sh" && exit 1
cd $HOME/.vim/bundle/YouCompleteMe
echo "校验并拉取YCM项目"
git submodule update --init --recursive || exit 1
./install.py --clang-completer || exit 1
cd - >/dev/null
""",
                "setting": """
"" force YCM to immediately recompile your file and display any new diagnostics it encounters.
nnoremap <C-F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>jc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
let g:ycm_global_ycm_extra_conf = '$HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
""",
            }]

    def run(self):
        # 当前文件绝对路径
        this_dir = os.path.split(os.path.realpath(__file__))[0]

        # 安装需要的模块
        self._colorschemes()
        self._polygolt()
        self._go_back()
        self._ack()
        self._nerdtree()
        self._surround()
        self._repeat()
        self._auto_pairs()
        self._ctrlp()
        self._airline()
        self._undotree()
        self._signify()
        self._wildfire()
        self._syntastic()
        self._fugitive()
        self._easymotion()
        self._nerdcommenter()
        self._a()
        self._tabular()
        self._tagbar()
        #self._snip()
        #self._ctags()
        #self._cscope()
        #self._omnicomplete()
        #self._ycm()

        plugin = ""
        setting = ""
        command = ""
        check = ""
        ending = ""
        for key in self.setting:
            if key['plugin'] != []:
                for value in key['plugin']:
                    plugin += "Plugin '" + value.strip() + "'\n"
            if key['check'] != "":
                check += key['check'].strip() + "\n\n"
            if key['command'] != "":
                command += key['command'].strip() + "\n\n"
            if key['setting'] != "":
                setting += key['setting'].strip() + "\n\n"
            if key['ending'] != "":
                ending += key['ending'].strip() + "\n\n"

        # 读取vim 基础配置
        base_object = open(this_dir + "/base.txt", encoding='utf-8')
        base = base_object.read()
        base_object.close()

        bundle = """
set nocompatible
filetype off
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
""" + plugin.strip() + """
call vundle#end()
filetype plugin indent on
"""

        vimrc = base.strip() + """

"" ------------------- PLUGIN_START -------------------
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
""" + plugin.strip() + """
call vundle#end()
filetype plugin indent on

""" + setting.strip()

        install = """
#! /bin/bash
set -e
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

setup_brew() {
    if [[ $(uname) == "Darwin" && ! $(command -v brew) ]]; then
        NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    if [[ $(uname) == "Darwin" && ! $(command -v brew) ]]; then
        echo "Homebrew 安装失败或未加入 PATH，请手动检查后重试"
        exit 1
    fi
}

backup_file() {
    local file=$1
    if [[ -e "$file" || -L "$file" ]]; then
        local backup="${file}.bak.$(date +%Y%m%d%H%M%S)"
        while [[ -e "$backup" || -L "$backup" ]]; do
            backup="${file}.bak.$(date +%Y%m%d%H%M%S).$RANDOM"
        done
        mv -f "$file" "$backup"
    fi
}

setup_brew

## -------------------- CHECK --------------------
""" + check.strip() + """
## -------------------- PROCESS --------------------
backup_file "$HOME/.vimrc"
""" + command.strip() + """
## -------------------- INSTALL --------------------
[ ! -f "$SCRIPT_DIR/.vimrc.bundle" ] && (echo ".vimrc.bundle 不存在" &&  exit 1)
vim -u "$SCRIPT_DIR/.vimrc.bundle" '+set nomore' '+BundleInstall!' '+BundleClean!' '+qall' || (echo "请重试" && exit 1)
## -------------------- ENDING --------------------
""" + ending.strip() + """

cp -f "$SCRIPT_DIR/.vimrc" "$HOME/"
echo "安装完成"
"""

        bundle_write_object = open(this_dir + "/.vimrc.bundle", "w", encoding="utf-8")
        bundle_write_object.write(bundle.strip() + "\n")
        bundle_write_object.close()

        vimrc_write_object = open(this_dir + "/.vimrc", "w", encoding="utf-8")
        vimrc_write_object.write(vimrc.strip() + "\n")
        vimrc_write_object.close()

        install_write_object = open(this_dir + "/install.sh", "w", encoding="utf-8")
        install_write_object.write(install.strip() + "\n")
        install_write_object.close()
        os.chmod(this_dir + "/install.sh", 0o755)


vimer = VimPlugin()
vimer.run()
