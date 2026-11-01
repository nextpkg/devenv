#! /bin/bash
set -e
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

setup_brew() {
    if [[ $(uname) == "Darwin" ]] && ! command -v brew >/dev/null 2>&1; then
        NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    if [[ $(uname) == "Darwin" ]] && ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew 安装失败或未加入 PATH，请手动检查后重试"
        exit 1
    fi
}

backup_file() {
    local file=$1
    if [[ -e "$file" || -L "$file" ]]; then
        local backup
        backup="${file}.bak.$(date +%Y%m%d%H%M%S)"
        while [[ -e "$backup" || -L "$backup" ]]; do
            backup="${file}.bak.$(date +%Y%m%d%H%M%S).$RANDOM"
        done
        if [[ ${2:-move} == copy ]]; then
            cp -pP "$file" "$backup"
        else
            mv -f "$file" "$backup"
        fi
    fi
}

find_compatible_ctags() {
    local candidate version
    for candidate in ctags ctags-exuberant exuberant-ctags universal-ctags /opt/homebrew/bin/ctags /usr/local/bin/ctags /opt/homebrew/opt/universal-ctags/bin/ctags /usr/local/opt/universal-ctags/bin/ctags; do
        if version=$("$candidate" --version 2>/dev/null) &&
            [[ "$version" == *"Universal Ctags"* || "$version" == *"Exuberant Ctags"* ]]; then
            return 0
        fi
    done
    return 1
}

setup_brew

## -------------------- CHECK --------------------
command -v vim &>/dev/null || ( (command -v dnf &>/dev/null && sudo dnf -y install vim-enhanced) || (command -v yum &>/dev/null && sudo yum -y install vim-enhanced) || (command -v apt-get &>/dev/null && sudo apt-get install -y vim) || (command -v brew &>/dev/null && brew install vim) || { echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )

command -v git &>/dev/null || ( (command -v dnf &>/dev/null && sudo dnf -y install git) || (command -v yum &>/dev/null && sudo yum -y install git) || (command -v apt-get &>/dev/null && sudo apt-get install -y git) || (command -v brew &>/dev/null && brew install git) || { echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )

command -v ag &>/dev/null || ( (command -v dnf &>/dev/null && sudo dnf -y install the_silver_searcher) || (command -v yum &>/dev/null && sudo yum -y install the_silver_searcher) || (command -v apt-get &>/dev/null && sudo apt-get install -y silversearcher-ag) || (command -v brew &>/dev/null && brew install the_silver_searcher) || { echo "过程被中断,或者使用了不支持的包管理工具"; exit 1; } )

if ! find_compatible_ctags; then
    if command -v brew >/dev/null 2>&1; then
        brew install universal-ctags
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get install -y universal-ctags
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf -y install ctags
    elif command -v yum >/dev/null 2>&1; then
        sudo yum -y install ctags
    fi
    find_compatible_ctags || { echo "需要 Universal 或 Exuberant Ctags" >&2; exit 1; }
fi
## -------------------- PROCESS --------------------
[ ! -f "$SCRIPT_DIR/.vimrc" ] && (echo ".vimrc 不存在" && exit 1)
mkdir -p "$HOME/.vim/bundle"
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]
then
    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim" || exit 1
fi

mkdir -p "$HOME/.vim/.backup"
mkdir -p "$HOME/.vim/.views"

mkdir -p "$HOME/.vim/undo"
## -------------------- INSTALL --------------------
[ ! -f "$SCRIPT_DIR/.vimrc.bundle" ] && (echo ".vimrc.bundle 不存在" &&  exit 1)
vim -N -n -i NONE -es -u "$SCRIPT_DIR/.vimrc.bundle" -S "$SCRIPT_DIR/install-plugins.vim" || { echo "插件安装失败，保留现有 Vim 配置" >&2; exit 1; }
## -------------------- ENDING --------------------
backup_file "$HOME/.vim/colors"
ln -s "$HOME/.vim/bundle/vim-colorschemes/colors" "$HOME/.vim/colors" || exit 1

[[ ! -d "$HOME/.vimrc" ]] || { echo ".vimrc 不能是目录" >&2; exit 1; }
staged_vimrc=$(mktemp "$HOME/.vimrc.new.XXXXXX")
trap 'rm -f "$staged_vimrc"' EXIT
cp -f "$SCRIPT_DIR/.vimrc" "$staged_vimrc"
backup_file "$HOME/.vimrc" copy
mv -f "$staged_vimrc" "$HOME/.vimrc"
echo "安装完成"
