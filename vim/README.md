# Vim 配置

这是一个高度定制化的 Vim 配置，包含了丰富的插件和快捷键设置，适合各种开发场景。

## 流程

```shell
# 步骤1
./build.py

# 步骤2
./install.sh
```

>
> YouCompleteMe编译失败的情况比较复杂，可参考 https://github.com/Valloric/YouCompleteMe 编译安装，或在代码中禁止掉该选项（残暴脸）

## 普通快捷键

| 普通模式 | 作用                       | 普通模式 | 作用                                |
| -------- | -------------------------- | -------- | ----------------------------------- |
| g`"      | 跳转到上次编辑的地方       | ,fc      | 跳转到合并冲突位置（如git版本冲突） |
| ,/       | 取消高亮                   | ,q       | 去掉全部换行符                      |
| ,f1      | 折叠代码（级别1）          | ,f2      | 折叠代码（级别2）                   |
| ,f3      | 折叠代码（级别3）          | ,f4      | 折叠代码（级别4）                   |
| ,f5      | 折叠代码（级别5）          | ,f6      | 折叠代码（级别6）                   |
| ,f7      | 折叠代码（级别7）          | ,f8      | 折叠代码（级别8）                   |
| ,f9      | 折叠代码（级别9）          | gwip     | 去掉全部换行符                      |
| ,ew      | 编辑新文件                 | ,=       | 调整窗口，使它们窗口一样大          |
| ,es      | 编辑新文件（水平分割展示） | ,ev      | 编辑新文件（垂直分割展示）          |
| guiw     | 光标所在单词转换为小写     | gUiw     | 光标所在单词转换为大写              |
| [b       | 上一个buffer               | ]b       | 下一个buffer                        |
| [t       | 上一个tab                  | ]t       | 下一个tab                           |
| ,y       | 将内容复制到寄存器a中      | ,p       | 从寄存器a中黏贴内容                 |
| ,bdo     | 将其他的buffer全部关掉     |          |                                     |

| 命令模式 | 解释              |
| -------- | ----------------- |
| w!!      | 提权,然后保存文件 |

| 可视模式 | 解释         |
| -------- | ------------ |
| .        | 执行重复操作 |

## 插件
### mileszs/ack.vim + ag
##### 任意模式下

| 任意模式 | 解释       |
| -------- | ---------- |
| F4       | 按内容搜索 |

### scrooloose/nerdtree + jistr/vim-nerdtree-tabs
| 任意模式 | 解释       |
| -------- | ---------- |
| F2       | 打开目录树 |



### tpope/vim-surround + tpope/vim-repeat

| 普通模式  | 解释                  | FROM                | TO                            |
| --------- | --------------------- | ------------------- | ----------------------------- |
| csw"      | 添加                  | Hello world!        | "Hello world!"                |
| cs"'      | 替换                  | "Hello world!"      | 'Hello world!'                |
| cs'\<q>   | 替换                  | 'Hello world!'      | <q>Hello world!</q>           |
| cst"      | 替换-标签(t=tag)      | <q>Hello world!</q> | "Hello world!"                |
| ds"       | 删除                  | "Hello world!"      | Hello world!                  |
| ysiw[     | 添加(ys=you surround) | Hello world!        | [Hello] world!                |
| cs[{      | 替换                  | [Hello] world!      | {Hello} world!                |
| yssb      | 添加-整行-空格        | {Hello} world!      | ({Hello} world!)              |
| yssr      | 添加-整行-中括号      | {Hello} world!      | [{Hello} world!]              |
| yss)      | 添加-整行             | {Hello} world!      | ({Hello} world!)              |
| ySS)      | 添加-新行             | {Hello} world!      | (<br/>{ Hello } world!<br />
) |
| veeS"     | 添加-两个词           |                     |                               |
| ys$"      | 添加-当前到行尾       |                     |                               |
| ds{ds)    | 删除-连续删除         | ({Hello} world!)    | Hello world!                  |
| ysiw\<em> | 添加(iw=text-object)  | Hello world!        | \<em>Hello\</em> world!       |

| 可视模式  | 解释                       |
| --------- | -------------------------- |
| S{字符串} | 被选中的行将被{字符串}包裹 |

### ctrlpvim/ctrlp.vim + tacahiroy/ctrlp-funky

| 普通模式 | 解释                                   |
| -------- | -------------------------------------- |
| \<c-p>   | 打开CtrlP                              |
| ,fu      | 打开CtrlP function模式                 |
| ,fU      | 根据光标所在单词打开CtrlP function模式 |

##### CtrlP已经启用时

```
F5      清理缓存
<c-f>   向前切换模式
<c-b>   向后切换模式
<c-d>   根据名称模糊查找目录
<c-r>   根据正则表达式查找目录
<c-j>   在结果列表中向下选择(可用键盘 ⬇ 代替)
<c-j>   在结果列表中向上选择(可用键盘 ⬆ 代替)
<c-v>   根据结果列表中的被选择项,以垂直分割的方式打开文件
<c-x>   根据结果列表中的被选择项,以水平分割的方式打开文件
<c-t>   根据结果列表中的被选择项,以新建TAB的方式打开文件
<c-n>   向下查找搜索历史
<c-p>   向上查找搜索历史
<c-y>   根据名称新建文件并以垂直分割的方式打开
<c-z>   从结果李彪中标记文件,并用<c-o>打开它们
```
### mbbill/undotree
| 普通模式 | 解释       |
| -------- | ---------- |
| F5       | 启动undo树 |

### gcmt/wildfire.vim
| 任意模式 | 解释       |
| -------- | ---------- |
| \<SPACE> | 选择符号对 |

| 可视模式   | 解释 |
| ---------- | ---- |
| \<C-SPACE> |      |

### mhinz/vim-signify
| 普通模式 | 解释             |
| -------- | ---------------- |
| ,gg      | 启用版本控制提示 |

### scrooloose/nerdcommenter
##### 普通模式  & 可视模式

```
,ca         在可选的注释方式之间切换
,cc         注释当前行
,c<space>   切换注释/非注释状态
,cA         在当前行尾添加注释符，并进入Insert模式
,cu         取消注释
,c$         从光标开始到行尾注释
,cs         以更漂亮的方式注释
,cl         注释当前行,分隔符沿着左侧对齐
,cb         注释当前行,分隔符沿着两侧对齐
{n},cc      光标以下n行添加注释
{n},cu      光标以下n行解开注释
{n},cm      光标以下count行添加块注释(2,cm)
```

### godlygeek/tabular
##### 普通模式 & 可视模式

```
,aa         等同于(:Tabularize /),填写要对齐的字符串并按回车生效
```
### majutsushi/tagbar
| 普通模式 | 解释       |
| -------- | ---------- |
| F3       | 打开tagbar |
|          |            |

### SirVer/ultisnips + honza/vim-snippets
| 插入模式 | 解释           |
| -------- | -------------- |
| \<c-j>   | 向前查找语法块 |
| \<c-k>   | 向后查找语法块 |

##### 常用触发点(输入,然后按\<c-j>)

```
date        插入当前日期
datetime    插入当前时间
bbox        插入一个大的注释框

```
### Valloric/YouCompleteMe + rdnetto/YCM-Generator
##### 

| 普通模式 | 解释         |
| -------- | ------------ |
| \<C-F5>  | 编译检查     |
| ,jd      | 跳到单词定义 |
| ,jc      | 跳到单词声明 |
| \<C-O>   | 向后跳转     |
| \<C-I>   | 向前跳转     |

| 命令模式              | 解释                   |
| --------------------- | ---------------------- |
| :CCGenerateConfig^1^  | 生成.ycm_extra_conf.py |
| :YcmGenerateConfig^2^ | 生成.ycm_extra_conf.py |

> 注意, 1与2生成的配置文件一样

##### 备注
在CMakeList.txt 里添加
>set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )

也能达到YCM自动识别编译flag的需求
