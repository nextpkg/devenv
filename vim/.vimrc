set nocompatible

let mapleader = ','
"let maplocalleader = '_'

set encoding=utf-8
"set fileencodings=utf-8,gb2312,gbk,gb18030
set fileencodings=utf-8
set termencoding=utf-8
"scriptencoding utf-8
set term=screen

syntax enable
"" Syntax highlighting
syntax on

"" Automatically enable mouse usage
"set mouse=a
"" Hide the mouse cursor while typing
"set mousehide

"" Assume a background
set background=light

"" change file directory to current directory
set autochdir
"" Automatically write a file when leaving a modified buffer
"set autowrite
"" reload when file changed outside
set autoread
"" Abbreviated the messages
set shortmess+=aoOtT
"" Allow for cursor beyond last character
set virtualedit=onemore
"" Store a ton of history (default is 20)
set history=1000
"" Spell checking on
"set spell
"" Allow buffer switching without saving
set hidden
"" '.' is an end of word designator
set iskeyword-=.
"" '#' is an end of word designator
set iskeyword-=#
"" '-' is an end of word designator
set iskeyword-=-

"" set it to the first line when editing a git commit message
"au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

"" Only show 15 tabs
"set tabpagemax=15
"" Display the current mode
set showmode
"" Highlight current line
set cursorline
"set cursorcolumn
"" SignColumn should match background(sigh is in the left-hand side of the window like breakpoint in IDE)
highlight clear SignColumn
"" Current line number row will have same background color in relative mode
highlight clear LineNr
"" Remove highlight color from current line number
"highlight clear CursorLineNr

"" Show partial commands in status line and Selected characters/lines in visual mode
set showcmd

set laststatus=2

"" (bs) allows backspacing beyond starting point of insert mode, indents and line breaks
set backspace=indent,eol,start
"" No extra spaces between rows
set linespace=0
"" Line numbers on
"set number
"set relativenumber
"" Windows can be 0 line high
set winminheight=0
"" Puts new vsplit windows to the right of the current
set splitright
"" Puts new split windows to the bottom of the current
set splitbelow
"" (ws) allows search to wrap to top of document when the bottom has been hit
set wrapscan
"" (ic) ignores case in search patterns
set ignorecase
"" (scs) don't ignore case when the search pattern has uppercase
set smartcase
"" (is) highlights what you are searching for as you type
set incsearch
"" (hls) highlights all instances of the last searched string
set hlsearch
nmap <silent> <leader>/ :set invhlsearch<CR>
"" Show list instead of just completing
set wildmenu
"" Command <Tab> completion, list matches, then longest common part, then all.
set wildmode=list:longest,full
"" wrap long lines
set wrap
"" (lbr) wrap long lines at a space instead of in the middle of a word
set linebreak
"" Backspace and cursor keys wrap too
set whichwrap=b,s,h,l,<,>,[,]
""Lines to scroll when cursor leaves screen
set scrolljump=5
""Minimum lines to keep above and below cursor
set scrolloff=3

"" Auto fold code
set nofoldenable
set foldmethod=indent
"" Code folding options
nmap <leader>f1 :set foldlevel=0<CR>
nmap <leader>f2 :set foldlevel=1<CR>
nmap <leader>f3 :set foldlevel=2<CR>
nmap <leader>f4 :set foldlevel=3<CR>
nmap <leader>f5 :set foldlevel=4<CR>
nmap <leader>f6 :set foldlevel=5<CR>
nmap <leader>f7 :set foldlevel=6<CR>
nmap <leader>f8 :set foldlevel=7<CR>
nmap <leader>f9 :set foldlevel=8<CR>
nmap <leader>f0 :set foldlevel=9<CR>

"" Highlight problematic whitespace
"set list
"set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
"" In Visual Block Mode, cursor can be positioned where there is no actual character
set ve=block
"" Show matching brackets/parenthesis
set showmatch

"" Prevents inserting two spaces after punctuation on a join (J)
set nojoinspaces
"" (ts) width (in spaces) that a <tab> is displayed as
set tabstop=4
"" (sw) width (in spaces) used in each step of autoindent (as well as << and >>)
set shiftwidth=4
"" (sts)when use backspace,it will delete 4 spaces at the same time
set softtabstop=4
"" (et) expand tabs to spaces (use :retab to redo entire file)
set expandtab
"" (ai)Indent at the same level of the previous line
"set autoindent
"" enable the smartindenting (si) feature for the following files
"set smartindent
"" close autoindent when pasting
"set pastetoggle=<F12>

autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
"" Workaround broken color highlighting in Haskell
autocmd FileType haskell,rust setlocal nospell
"" Match, to be used with %
autocmd FileType xhtml,html,htm,php,xml setlocal matchpairs+=<:>
"" enable the intelligent cindent (cin) feature for the following files
autocmd FileType c,h setlocal cindent
"" preceding line best in a plugin but here for now.
autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2

""sudo
cmap w!! w !sudo tee % >/dev/null
" Adjust viewports to the same size
map <Leader>= <C-w>=
"" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
"" Allow using the repeat operator with a visual selection (!)
vnoremap . :normal .<CR>

"" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

"" Rename the command , convert :W to :w(:W can't write)
"" bang is !
"" -nargs=* Any number of arguments are allowed,separated by white space
"" <args> + ...  The command arguments
command! -bang -nargs=* -complete=file E e<bang> <args>
command! -bang -nargs=* -complete=file W w<bang> <args>
command! -bang -nargs=* -complete=file Wq wq<bang> <args>
command! -bang -nargs=* -complete=file WQ wq<bang> <args>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Q q<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>

"" %  current file name
"" :h head (last path component removed)
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :edit %%
map <leader>es :split %%
map <leader>ev :vsplit %%
map <leader>et :tabedit %%

"" Easier formatting
nnoremap <silent> <leader>q gwip
nnoremap <silent> [b :bp<CR>
nnoremap <silent> ]b :bn<CR>
nnoremap <silent> [t :tabp<CR>
nnoremap <silent> ]t :tabn<CR>
nnoremap <Leader>y "ay
nnoremap <Leader>p "ap

" delete others buffer
function! BufCloseOthers()
    let l:currentBufNum   = bufnr("%")
    let l:alternateBufNum = bufnr("#")
    for i in range(1,bufnr("$"))
        if buflisted(i)
            if i!=l:currentBufNum
                execute("bdelete ".i)
            endif
        endif
    endfor
endfunction
map <silent> <leader>bdo :call BufCloseOthers()<CR>

" Restore cursor to file position in previous editing session
function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

"" ------------------- PLUGIN_START -------------------
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'sheerun/vim-polyglot'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'jiangmiao/auto-pairs'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'bling/vim-airline'
Plugin 'mbbill/undotree'
Plugin 'mhinz/vim-signify'
Plugin 'gcmt/wildfire.vim'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdcommenter'
Plugin 'godlygeek/tabular'
Plugin 'majutsushi/tagbar'
call vundle#end()
filetype plugin indent on

"" Enable 256 colors to stop the CSApprox warning and make xterm vim shine
set t_Co=256
"" Load a colorscheme
"let g:molokai_original=1
"let g:rehash256 = 1
color gruvbox
"color solarized

set backup
set backupdir=$HOME/.vim/.backup
set viewdir=$HOME/.vim/.views

let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
map <F4> :Ack -i

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

"let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
"augroup nerdtree_group
    "autocmd!
    "" open a NERDTree automatically when vim starts up if no files were specified
    "autocmd StdinReadPre * let s:std_in=1
    "autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    "" close vim if the only window left open is a NERDTree
    "autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"augroup END

let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
""scan for dotfiles and dotdirs,does not apply when a command defined with g:ctrlp_user_command is being used
let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore = {'dir':  '\v[\/]\.(git|hg|svn)$','file': '\v\.(exe|so|dll|pyc|swp)$'}
"" Use a version control listing command when inside a repository, this is faster when scanning large projects listing command lists untracked files (slower)
let g:ctrlp_user_command = {
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
    \ 'fallback': s:ctrlp_fallback
\ }

"" CtrlP extensions
let g:ctrlp_extensions = ['funky']

""funky
nnoremap <Leader>fu :CtrlPFunky<Cr>

"" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

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

set undodir=$HOME/.vim/undo
set undofile
"" Maximum number of changes that can be undone
set undolevels=1000
"" Maximum number lines to save for undo on a buffer reload
set undoreload=10000

nnoremap <silent> <F5> :UndotreeToggle<CR>
"" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1

nnoremap <silent> <leader>gg :SignifyToggle<CR>
let g:signify_vcs_list = [ 'git', 'svn' ]

map <SPACE> <Plug>(wildfire-fuel)
vmap <C-SPACE> <Plug>(wildfire-water)
let g:wildfire_objects = {  "*" : ["i'", 'i"', "i)", "i]", "i}","ip"], "html,xml" : ["at"],}

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

nmap <leader>aa :Tabularize /
vmap <leader>aa :Tabularize /

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
