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
command -v git &>/dev/null || ( (command -v dnf &>/dev/null && sudo dnf -y install git) || (command -v yum &>/dev/null && sudo yum -y install git) || (command -v apt-get &>/dev/null && sudo apt-get install -y git) || (command -v brew &>/dev/null && brew install git) || { echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )

command -v ag &>/dev/null || ( (command -v dnf &>/dev/null && sudo dnf -y install the_silver_searcher) || (command -v yum &>/dev/null && sudo yum -y install the_silver_searcher) || (command -v apt-get &>/dev/null && sudo apt-get install -y silversearcher-ag) || (command -v brew &>/dev/null && brew install the_silver_searcher) || { echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )

command -v ag &>/dev/null || ( (command -v dnf &>/dev/null && sudo dnf -y install the_silver_searcher) || (command -v yum &>/dev/null && sudo yum -y install the_silver_searcher) || (command -v apt-get &>/dev/null && sudo apt-get install -y silversearcher-ag) || (command -v brew &>/dev/null && brew install the_silver_searcher) || { echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )

command -v ctags &>/dev/null || ( (command -v dnf &>/dev/null && sudo dnf -y install ctags) || (command -v yum &>/dev/null && sudo yum -y install ctags) || (command -v apt-get &>/dev/null && sudo apt-get install -y ctags) || (command -v brew &>/dev/null && brew install ctags) || { echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )
## -------------------- PROCESS --------------------
backup_file "$HOME/.vimrc"
mkdir -p "$HOME/.vim/bundle"
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]
then
    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim" || exit 1
fi

mkdir -p $HOME/.vim/.backup
mkdir -p $HOME/.vim/.views

mkdir -p $HOME/.vim/undo
## -------------------- INSTALL --------------------
[ ! -f "$SCRIPT_DIR/.vimrc.bundle" ] && (echo ".vimrc.bundle 不存在" &&  exit 1)
vim -u "$SCRIPT_DIR/.vimrc.bundle" '+set nomore' '+BundleInstall!' '+BundleClean!' '+qall' || (echo "请重试" && exit 1)
## -------------------- ENDING --------------------
backup_file "$HOME/.vim/colors"
ln -s "$HOME/.vim/bundle/vim-colorschemes/colors" "$HOME/.vim/colors" || exit 1

cp -f "$SCRIPT_DIR/.vimrc" "$HOME/"
echo "安装完成"
