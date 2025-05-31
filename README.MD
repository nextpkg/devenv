# 开发环境配置

一个完整的开发环境配置项目，包含了 Vim 编辑器和 Shell 环境的优化配置，提供丰富的快捷键和插件支持，帮助开发者快速搭建高效的开发环境。

## 项目结构

```
devenv/
├── home/           # Shell 环境配置
│   ├── .bashrc     # Bash 配置文件
│   ├── .gitconfig  # Git 配置
│   ├── .tmux.conf  # Tmux 配置
│   ├── alias.zsh   # Zsh 别名配置
│   ├── config.zsh  # Zsh 配置
│   └── install.sh  # Shell 环境安装脚本
└── vim/            # Vim 编辑器配置
    ├── .vimrc      # Vim 主配置文件
    ├── .vimrc.bundle # Vim 插件配置
    ├── build.py    # 构建脚本
    └── install.sh  # Vim 安装脚本
```

## 安装说明

### 系统要求

支持以下操作系统：
- Ubuntu 16+
- Debian 8+
- CentOS 7+
- macOS 12+

### Shell 环境安装

```bash
cd home
./install.sh
```

**推荐安装方式**：打开 `install.sh` 文件，逐行复制粘贴执行（避免来不及备份）

### Vim 环境安装

```bash
cd vim
# 步骤1：构建依赖
./build.py

# 步骤2：安装配置
./install.sh
```

> **注意**：YouCompleteMe 编译失败的情况比较复杂，可参考 [YouCompleteMe 官方文档](https://github.com/Valloric/YouCompleteMe) 编译安装，或在代码中禁用该选项。

## 功能特性

### Shell 环境
- **Tmux** 终端复用器配置
- **Autojump** 智能目录跳转
- **Zsh/Bash** 优化配置
- **Git** 配置优化
- 丰富的命令别名

### Vim 编辑器
- **代码补全**：YouCompleteMe 智能补全
- **文件管理**：NERDTree 文件树
- **模糊搜索**：CtrlP 文件搜索
- **代码导航**：Tagbar 标签栏
- **版本控制**：Git 集成
- **代码片段**：UltiSnips 代码片段
- **语法高亮**：多语言支持

## 快捷键说明

### Autojump 快捷键

| 命令       | 功能                                                       |
| ---------- | ---------------------------------------------------------- |
| `j foo`    | 跳转到 foo 目录                                            |
| `jc bar`   | 跳转到 bar 的子目录                                        |
| `jo music` | 用资源管理器打开 music 目录（需要图形界面）                |
| `jco images` | 用资源管理器打开 images 子目录（需要图形界面）           |

### Bash/Zsh 快捷命令

| 命令        | 功能                                       |
| ----------- | ------------------------------------------ |
| `ctags-c`   | 为当前目录生成 C 的 ctags                  |
| `ctags-c++` | 为当前目录生成 C++ 的 ctags                |
| `ctags-php` | 为当前目录生成 PHP 的 ctags                |
| `tmns`      | 新建一个 tmux session                      |
| `tmnw`      | 新建一个 tmux window                       |
| `tmas`      | 连接到 tmux session                        |
| `tmkw`      | 关闭一个 tmux window                       |
| `tmsw`      | 选择一个 tmux session                      |
| `dt`        | 根据预设窗口打开 tmux                      |
| `cscope-find` | 从当前目录找到匹配的文件生成 cscope 原始文件 |
| `cscope-make` | 根据 cscope 原始文件生成 cscope 数据库     |

### Tmux 快捷键

| 快捷键           | 功能                                                    |
| --------------- | ------------------------------------------------------- |
| `Ctrl-a + ?`    | 查看当前配置的快捷键                                    |
| `Ctrl-a + R`    | 重载 .tmux.conf                                         |
| `Ctrl-a + a`    | 回到行首（代替 shell 的 Ctrl-a）                       |
| `Ctrl-a + [`    | 进入复制模式，按 SPACE 开始复制，按 RETURN 退出         |
| `Ctrl-a + ]`    | 粘贴                                                    |
| `Ctrl-a + x`    | 关闭当前 pane                                           |
| `Ctrl-a + z`    | 最大化当前 pane                                         |
| `Ctrl-a + 数字` | 选择第 n 个 window                                      |
| `Ctrl-a + ,`    | 重命名当前 window                                       |
| `Ctrl-a + c`    | 创建一个新的 window                                     |
| `Ctrl-a + &`    | 关闭当前 window                                         |
| `Ctrl-a + $`    | 重命名当前 session                                      |
| `Ctrl-a + (`    | 选择上一个 session                                      |
| `Ctrl-a + )`    | 选择下一个 session                                      |
| `Shift + 方向键` | 在 pane 之间跳转                                        |
| `Ctrl + 左右键`  | 在 window 之间切换                                      |

### Vim 普通模式快捷键

| 快捷键   | 功能                       | 快捷键   | 功能                                |
| -------- | -------------------------- | -------- | ----------------------------------- |
| `g'"`    | 跳转到上次编辑的地方       | `,fc`    | 跳转到合并冲突位置（如 git 版本冲突） |
| `,/`     | 取消高亮                   | `,q`     | 去掉全部换行符                      |
| `,f1-f9` | 折叠代码（级别 1-9）       | `gwip`   | 去掉全部换行符                      |
| `,ew`    | 编辑新文件                 | `,=`     | 调整窗口，使它们大小一样            |
| `,es`    | 编辑新文件（水平分割）     | `,ev`    | 编辑新文件（垂直分割）              |
| `guiw`   | 光标所在单词转换为小写     | `gUiw`   | 光标所在单词转换为大写              |
| `[b`     | 上一个 buffer              | `]b`     | 下一个 buffer                       |
| `[t`     | 上一个 tab                 | `]t`     | 下一个 tab                          |
| `,y`     | 将内容复制到寄存器 a 中    | `,p`     | 从寄存器 a 中粘贴内容               |
| `,bdo`   | 将其他的 buffer 全部关掉   |          |                                     |

### Vim 插件快捷键

#### NERDTree 文件树
| 快捷键 | 功能       |
| ------ | ---------- |
| `F2`   | 打开目录树 |

#### CtrlP 文件搜索
| 快捷键   | 功能                                   |
| -------- | -------------------------------------- |
| `Ctrl-p` | 打开 CtrlP                             |
| `,fu`    | 打开 CtrlP function 模式               |
| `,fU`    | 根据光标所在单词打开 CtrlP function 模式 |

**CtrlP 启用时的快捷键：**
- `F5`：清理缓存
- `Ctrl-f/b`：切换模式
- `Ctrl-j/k`：在结果列表中选择
- `Ctrl-v`：垂直分割打开文件
- `Ctrl-x`：水平分割打开文件
- `Ctrl-t`：新建 TAB 打开文件

#### Surround 文本包围
| 快捷键     | 功能                  | 示例                                    |
| --------- | --------------------- | --------------------------------------- |
| `csw"`    | 添加引号              | Hello world! → "Hello world!"          |
| `cs"'`    | 替换引号              | "Hello world!" → 'Hello world!'        |
| `ds"`     | 删除引号              | "Hello world!" → Hello world!          |
| `ysiw[`   | 添加方括号            | Hello world! → [Hello] world!          |
| `yssb`    | 添加整行括号          | {Hello} world! → ({Hello} world!)      |

#### 代码注释 (NERDCommenter)
| 快捷键      | 功能                     |
| ----------- | ------------------------ |
| `,cc`       | 注释当前行               |
| `,c<space>` | 切换注释/非注释状态      |
| `,cu`       | 取消注释                 |
| `,cA`       | 在行尾添加注释并进入插入模式 |

#### YouCompleteMe 代码补全
| 快捷键    | 功能         |
| --------- | ------------ |
| `Ctrl-F5` | 编译检查     |
| `,jd`     | 跳到定义     |
| `,jc`     | 跳到声明     |
| `Ctrl-O`  | 向后跳转     |
| `Ctrl-I`  | 向前跳转     |

#### 其他插件
| 快捷键    | 功能           | 插件          |
| --------- | -------------- | ------------- |
| `F3`      | 打开 tagbar    | Tagbar        |
| `F4`      | 按内容搜索     | Ack + ag      |
| `F5`      | 启动 undo 树   | UndoTree      |
| `Space`   | 选择符号对     | Wildfire      |
| `,gg`     | 启用版本控制提示 | vim-signify   |
| `,aa`     | 对齐文本       | Tabular       |

### Vim 命令模式
| 命令                  | 功能                   |
| --------------------- | ---------------------- |
| `:w!!`                | 提权保存文件           |
| `:CCGenerateConfig`   | 生成 .ycm_extra_conf.py |
| `:YcmGenerateConfig`  | 生成 .ycm_extra_conf.py |

## 常见问题

### YouCompleteMe 编译失败
1. 参考 [YouCompleteMe 官方文档](https://github.com/Valloric/YouCompleteMe)
2. 在 CMakeList.txt 中添加：`set(CMAKE_EXPORT_COMPILE_COMMANDS 1)`
3. 或在配置中禁用该插件

### 权限问题
如果遇到权限问题，建议逐行执行安装脚本而不是直接运行。

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。

## 许可证

本项目采用 MIT 许可证，详见 LICENSE 文件。