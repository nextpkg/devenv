# Home 目录配置

这个目录包含了用户主目录下的各种配置文件，包括 Shell 环境、工具配置等。

## 流程

```shell
./install
```
安装的最好方式是打开install.sh,然后一行一行复制黏贴执行（避免来不及的备份）

## 快捷键
##### autojump

| 命令       | 解释                                                       |
| ---------- | ---------------------------------------------------------- |
| j foo      | 跳转到 foo 目录                                            |
| jc bar     | 跳转到 bar 的子目录                                        |
| jo music   | 用资源管理器打开 music 目录（前提是操作系统要有图形界面）  |
| jco images | 用资源管理器打开 images 子目录(前提是操作系统要有图形界面) |

##### bash

| 命令        | 解释                                       |
| ----------- | ------------------------------------------ |
| ctags-c     | 为当前目录生成 c的ctags                    |
| ctags-c++   | 为当前目录生成 c++的ctags                  |
| ctags-php   | 为当前目录生成 php的ctags                  |
| tmns        | 新起一个 tmux session                      |
| tmnw        | 新起一个 tmux windows                      |
| tmas        | attached 到 tmux                           |
| tmkw        | kill 一个 tmux                             |
| tmsw        | 选择 一个 tmux                             |
| dt          | 根据预设窗口打开 tmux                      |
| cscope-find | 从当前目录找到匹配的文件生成cscope原始文件 |
| cscope-make | 根据cscope原始文件生成cscope数据库         |

##### tmux

| 命令            | 解释                                                    |
| --------------- | ------------------------------------------------------- |
| ctrl-a + ?      | 查看当前配置的快捷键                                    |
| ctrl-a + R      | 重载 .tmux.conf                                         |
| ctrl-a + a      | 回到行首(代替shell的ctrl-a)                             |
| ctrl-a + [      | 进入复制模式,按 SPACE 键开始复制,按 RETURN 退出复制模式 |
| ctrl-a + ]      | 黏贴                                                    |
| ctrl-a + x      | 关掉当前 pane                                           |
| ctrl-a + z      | 最大化当前 pane                                         |
| ctrl-a + 数字n  | 选择第 n 个windows                                      |
| ctrl-a + ,      | 重命名当前 window                                       |
| ctrl-c + c      | 创建一个新的 window                                     |
| ctrl-c + &      | 关闭当前 window                                         |
| ctrl-c + $      | 重命名当前 session                                      |
| ctrl-c + (      | 选择上一个 session                                      |
| ctrl-c + )      | 选择下一个 session                                      |
| ctrl-c + D      | 选择一个 session                                        |
| ctrl-a +        | 在当前 pane 右边产生一个新的 pane                       |
| ctrl-a + -      | 在当前 pane 下边产生一个新的 pane                       |
| ctrl + ←        | 切换到当前 pane 左边的pane                              |
| ctrl + →        | 切换到当前 pane 左边的pane                              |
| ctrl + ↑        | 切换到当前 pane 上边的pane                              |
| ctrl + ↓        | 切换到当前 pane 下边的pane                              |
| ctrl-a + ctrl-← | 向左扩大当前 pane 的区域                                |
| ctrl-a + ctrl-→ | 向右扩大当前 pane 的区域                                |
