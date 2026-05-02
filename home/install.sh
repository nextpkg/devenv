#!/bin/bash
set -e

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'
_red() { echo -e ${red}$*${none};  }
_green() { echo -e ${green}$*${none};  }
_yellow() { echo -e ${yellow}$*${none};  }
_magenta() { echo -e ${magenta}$*${none};  }
_cyan() { echo -e ${cyan}$*${none};  }

USER=${USER:-$(id -u -n)}
BREW=false
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

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

require_tmux_version() {
  local major minor
  read -r major minor < <(tmux -V | sed -E 's/^tmux ([0-9]+)\.([0-9]+).*/\1 \2/')
  if [[ -z "$major" || -z "$minor" ]] || (( major < 2 || (major == 2 && minor < 9) )); then
    echo "tmux 版本过低，需要 tmux >= 2.9；请升级系统或通过 Homebrew/Linuxbrew 安装新版 tmux"
    exit 1
  fi
}

setup_brew() {
  if [[ $(uname) == "Darwin" && ${USER} != "root" && ! $(command -v brew) ]]; then
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
  echo -e "${red}该脚本${none} 不支持你的系统.${yellow}请确认代码${none}，仅支持 ubuntu 16+ / debian 8+ / centos 7+ / macos 12+ 系统"
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
[[ -e "$SCRIPT_DIR/.gitconfig" ]] && backup_file "$HOME/.gitconfig" && cp -f "$SCRIPT_DIR/.gitconfig" "$HOME/"
[[ -e "$SCRIPT_DIR/.tmux.conf" ]] && backup_file "$HOME/.tmux.conf" && cp -f "$SCRIPT_DIR/.tmux.conf" "$HOME/"

# Install Oh-My-Zsh
setup_zsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended
  ZSH=${ZSH:-$HOME/.oh-my-zsh}
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
  if ! zsh=$(command -v zsh) || ! grep -qxF "$zsh" "$shells_file"; then
    if ! zsh=$(grep '^/.*/zsh$' "$shells_file" | tail -n 1) || [ ! -f "$zsh" ]; then
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
  if { [[ "$USER" == "root" ]] && chsh -s "$zsh"; } || { [[ "$USER" != "root" ]] && sudo chsh -s "$zsh" "$USER"; }; then
    export SHELL="$zsh"
    echo -e "${green}Shell successfully changed to '$zsh'.${none}"
  else
    echo "chsh command unsuccessful. Change your default shell manually."
  fi

  echo
}

# Init ZSH
setup_zshrc() {
  zsh -c "source $HOME/.zshrc && 
  omz plugin enable z docker kubectl && 
  omz theme set suvash"

  if [[ $(uname) == "Linux" && ${BREW} == true ]] && ! grep -Fq '/home/linuxbrew/.linuxbrew/bin/brew shellenv' "$HOME/.zshrc"; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
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
