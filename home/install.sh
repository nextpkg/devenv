#!/bin/bash
set -e

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
none='\e[0m'

USER=${USER:-$(id -u -n)}
BREW=false
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

backup_file() {
  local file=$1
  if [[ -e "$file" || -L "$file" ]]; then
    local backup
    backup="${file}.bak.$(date +%Y%m%d%H%M%S)"
    while [[ -e "$backup" || -L "$backup" ]]; do
      backup="${file}.bak.$(date +%Y%m%d%H%M%S).$RANDOM"
    done
    mv -f "$file" "$backup"
  fi
}

require_tmux_version() {
  local major minor
  read -r major minor < <(tmux -V | sed -E 's/^tmux ([0-9]+)\.([0-9]+).*/\1 \2/')
  if [[ -z "$major" || -z "$minor" ]] || (( major < 2 || (major == 2 && minor < 9) )); then
    echo "tmux 版本过低，需要 tmux >= 2.9；请升级系统或通过 Homebrew/Linuxbrew 安装新版 tmux"
    exit 1
  fi
}

setup_brew() {
  if [[ $(uname) == "Darwin" && ${USER} != "root" ]] && ! command -v brew >/dev/null 2>&1; then
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

setup_brew

# Tool
CMD="yum"
if [[ $(command -v apt-get) ]]; then
  CMD="apt-get"
elif [[ $(command -v dnf) ]]; then
  CMD="dnf"
elif [[ $(command -v yum) ]]; then
  CMD="yum"
elif [[ $(command -v brew) ]]; then
  CMD="brew"
  BREW=true
else
  echo -e "${red}该脚本${none} 不支持你的系统.${yellow}请确认代码${none}，仅支持 Ubuntu 20+ / Debian 11+ / Fedora 34+ / CentOS Stream 9+ / macOS 12+ 系统"
  exit 1
fi

# Dependence
case $CMD in
'dnf')
   sudo dnf install -y git zsh curl tmux
   ;;
'yum')
   sudo yum install -y git zsh curl tmux
   ;;
'apt-get')
   sudo apt-get install -y git zsh curl tmux
   ;;
'brew')
   brew install git zsh curl tmux
   ;;
esac

require_tmux_version

# Config
install_config() {
  local source=$1
  local target=$2

  [[ -e "$source" ]] || return 0
  if [[ -f "$target" ]] && cmp -s "$source" "$target"; then
    return
  fi

  backup_file "$target"
  cp -f "$source" "$target"
}

install_config "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
install_config "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Install Oh-My-Zsh
setup_zsh() {
  ZSH=${ZSH:-$HOME/.oh-my-zsh}
  export ZSH

  if [[ ! -f "$ZSH/oh-my-zsh.sh" ]]; then
    if [[ -e "$ZSH" ]]; then
      echo "Oh My Zsh 目录已存在但安装不完整：$ZSH"
      echo "请移走该目录后重试"
      exit 1
    fi
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended
  fi

  ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH/custom}
  mkdir -p "$ZSH_CUSTOM"
  cp "$SCRIPT_DIR"/*.zsh "$ZSH_CUSTOM"
}

# Switch Shell
setup_shell() {
  # Test for the right location of the "shells" file
  if [ -f /etc/shells ]; then
    shells_file=/etc/shells
  elif [ -f /usr/share/defaults/etc/shells ]; then # Solus OS
    shells_file=/usr/share/defaults/etc/shells
  else
    echo "could not find /etc/shells file. Change your default shell manually."
    return
  fi

  # Get the path to the right zsh binary
  if ! zsh=$(command -v zsh) || [[ ! -x "$zsh" ]]; then
    if ! zsh=$(grep '^/.*/zsh$' "$shells_file" | tail -n 1) || [[ ! -x "$zsh" ]]; then
      echo "no zsh binary found or not present in '$shells_file'"
      echo "change your default shell manually."
      return
    fi
  fi

  # We're going to change the default shell, so back up the current one
  if [ -n "$SHELL" ]; then
    echo "$SHELL" > "$HOME/.shell.pre-oh-my-zsh"
  else
    grep "^$USER:" /etc/passwd | awk -F: '{print $7}' > "$HOME/.shell.pre-oh-my-zsh"
  fi

  echo "Changing your shell to $zsh..."

  # Change shell
  if ! grep -qxF "$zsh" "$shells_file"; then
    echo "$zsh" | sudo tee -a "$shells_file" >/dev/null
  fi
  if [[ "$SHELL" == "$zsh" ]]; then
    echo "Shell is already '$zsh'."
  elif { [[ "$USER" == "root" ]] && chsh -s "$zsh"; } || { [[ "$USER" != "root" ]] && sudo chsh -s "$zsh" "$USER"; }; then
    export SHELL="$zsh"
    echo -e "${green}Shell successfully changed to '$zsh'.${none}"
  else
    echo "chsh command unsuccessful. Change your default shell manually."
  fi

  echo
}

# Init ZSH
setup_zshrc() {
  local zshrc="$HOME/.zshrc"

  if [[ ! -f "$zshrc" ]] ||
    ! grep -Eq '^[[:space:]]*(source|\.)[[:space:]].*oh-my-zsh\.sh' "$zshrc" ||
    ! grep -Eq '^[[:space:]]*ZSH_THEME=' "$zshrc" ||
    ! grep -Eq '^[[:space:]]*plugins=' "$zshrc"; then
    backup_file "$zshrc"
    sed "s|^export ZSH=.*$|export ZSH=\"$ZSH\"|" "$ZSH/templates/zshrc.zsh-template" > "$zshrc"
  fi

  HOME="$HOME" ZSH="$ZSH" zsh -c 'source "$HOME/.zshrc"
    omz plugin enable z docker kubectl
    omz theme set suvash'

  if [[ $(uname) == "Linux" && ${BREW} == true ]] && ! grep -Fq '/home/linuxbrew/.linuxbrew/bin/brew shellenv' "$HOME/.zshrc"; then
    printf '%s\n' "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> "$HOME/.zshrc"
  fi
}

# Setup ZSH
setup_zsh
setup_shell
setup_zshrc

echo -e "${green}Initial my home successfully.${none}"
if [[ -t 0 && -t 1 ]]; then
  zsh
fi
