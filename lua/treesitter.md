# treesitter 插件

## 基本介绍

[treesitter](https://github.com/tree-sitter/tree-sitter) 是一个通用的增量解析生成器工具 (a parser generator tool and an incremental parsing
library), 所以这是个什么东西?

首先 parser 是说它是一个词法分析器, 即能够分析当前编辑器中的代码, 将其转换为抽象语法树 (AST) 表示.
其次, incremental 是指当修改代码时, 它只会修改 AST 中对应的部分, 而不是全部重建 AST.

`nvim-treesitter` 就是基于 treesitter 而来的一个编辑器插件, 能够高效准确的支持代码高亮,
代码缩进等功能, 在 `settings/plugins/others.vim` 中加入如下配置进行安装

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

## 配置

具体配置可以参考 `lua/treesitter.lua` 文件, 常用的 treesitter 的配置选项如下所示

- `ensure_installed`

    要安装的语言解析器, 在这里写入你常用的语言, 然后启动 neovim 后, 会自动进行安装.

- `highlight`

    代码高亮模块配置.

- `indent`

    代码缩进模块配置, 选中代码块后使用 `=` 按键来执行代码格式化.

- `incremental_selection`

    增量选择.

## 安装与卸载插件

TreeSitter 提供的命令为 `:TSxxx`, 要卸载插件可以使用 `:TSUninstall`, 安装插件可以使用 `:TSInstall`.
