#!/bin/bash

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

# 如果是Linux系统，请自行将以下这一行命令放在.bashrc，.zshrc中
if [ ${USER} != "root" ]; then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 确定系统的依赖包安装工具
CMD="yum"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
  if [[ $(command -v apt-get) ]]; then
    CMD="apt-get"
  fi
elif [[ $(command -v brew) ]]; then
  CMD="brew"
else
  echo -e "${red}该脚本${none} 不支持你的系统.${yellow}请确认代码${none}，仅支持 ubuntu 16+ / debian 8+ / centos 7+ / macos 12+ 系统"
  exit 1
fi

# 安装推荐的工具
case $CMD in
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

# 使用推荐的配置
[[ -e .gitconfig ]] || cp -f .gitconfig $HOME/
[[ -e .tmux.conf ]] || cp -f .tmux.conf $HOME/

# 安装Oh-My-Zsh
setup_zsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended
  mkdir -p $ZSH/custom
  cp *.zsh $ZSH/custom
}

# 切换shell
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
  if ! zsh=$(command -v zsh) || ! grep -qx "$zsh" "$shells_file"; then 
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
  sudo sh -c "grep -wqE ^${zsh}$ ${shells_file} || echo ${zsh} >> ${shells_file}"

  # Check if the shell change was successful
  if [ $? -ne 0 ]; then
    echo "chsh command unsuccessful. Change your default shell manually."
  else
    export SHELL="$zsh"
    echo -e "${green}Shell successfully changed to '$zsh'.${none}"
  fi

  echo
}

# 初始化ZSH
setup_zshrc() {
  zsh -c "source $HOME/.zshrc && 
  omz plugin enable z docker kubectl && 
  omz theme set suvash"
}

setup_zsh
setup_shell
setup_zshrc

echo -e "${green}Initial my home successfully.${none}"
zsh
