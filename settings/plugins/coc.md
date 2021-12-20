# coc 插件

## 安装

使用 nvm 安装 nodejs

        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        nvm install node

安装完成之后在 plug 中添加插件如下并安装.

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

通过 `g:coc_global_extensions` 配置要自动安装的 coc 扩展, 比如

    let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-pyright', 'coc-go', 'coc-css', 'coc-html', 'coc-sh', 'coc-snippets']

也可以使用如下命令安装 coc 扩展

    :CocInstall <extension name>

coc 的配置文件为 `${HOME}/.config/nvim/coc-settings.json`, 如果有额外的配置, 可以写到该文件中,
coc 提供 `:CocConfig` 命令可以直接打开该文件.

## Rust 补全

安装 rust-analyzer 以及 rust-src

    cargo install --git https://github.com/rust-analyzer/rust-analyzer.git rust-analyzer
    RUST_DIST_SERVER= rustup component add rust-src

然后配置 coc-settings.json, 加入如下选项

    "rust-analyzer.server.path": "~/.cargo/bin/rust-analyzer",

## C 家族补全

 需要手动下载 clangd 并加入到环境变量中 (https://github.com/clangd/coc-clangd),
 然后在 neovim 中执行

    :CocInstall coc-clangd

clangd 由于无法识别当前项目的头文件, 因此需要使用 ccls 来弥补, ccls 的安装和配置如下

- 下载 LLVM

    下载地址为 https://releases.llvm.org/download.html, 将其解压并存放到 $HOME/.usr/llvm 中.

- 编译 ccls

    编译并安装

        git clone --depth=1 --recursive https://github.com/MaskRay/ccls
        cd ccls
        cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$HOME/.usr/llvm -DCMAKE_INSTALL_PREFIX=$HOME/.usr
        cmake --build Release --target install

    其中  CMAKE_PREFIX_PATH 指定了 LLVM 的安装地址, CMAKE_INSTALL_PREFIX 指定了安装目录, 将会安装到 $HOME/.usr/bin/ccls 处.

- 配置 ccls

    在项目根目录新建 .ccls 文件, 并写入如下内容

        clang++
        %h
        %cpp -std=c++11
        %objective-c
        %objective-cpp
        -I.
        ... // [1]

    [1] 处是包含系统头文件, 这个 clang 自己是没带的, 在 mac 下可以通过 gcc 获取输出

        gcc -v -x c++ /dev/null -fsyntax-only

    比如我的输出为如下

        /usr/local/include
        /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1
        /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.3/include
        /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include
        /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include
        /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks

    然后在 [1] 处使用 -I 将其包含进去即可.
