if vim.g.os ~= "Windows" then
    -- 编译时尝试的编译器顺序, 可以使用 CC 环境变量指定编译器, 也要求安装 treesiter: cargo install tree-sitter-cli
    require('nvim-treesitter.install').compilers = {
        vim.fn.getenv('CC'), "clang","zig", "gcc",
    }

    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        "html", "css", "cpp", "bash", "vim", "lua", "go", "rust", "cmake",
        "json", "make", "kotlin", "python", "toml", "json5", "c", "svelte",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        -- 暂时禁用 treesitter 的 html 高亮, https://github.com/nvim-treesitter/nvim-treesitter/issues/1788
        disable = { "html" },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
        }
      },
      -- 禁用缩进, treesitter 的缩进支持比较差
      indent = {
        enable = false,
      }
    }
end

-- The default install root directory `install_root_dir ` of mason is determined by
-- `stdpath("data")/mason` where `stdpath("data")` can be checked manually using command
-- `:echo stdpath("data")`.
require("mason").setup()
-- We use mason-lspconfig to automatically install LSP servers which can then be configured using
-- neovim lspconfig
require("mason-lspconfig").setup({
    -- Server name used in mason is different from what is used in the standard lspconfig, the
    -- mapping could be found here
    --
    --     https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
    --
    -- The installed LSP servers could be found under `install_root_dir/mason`.
    ensure_installed = {
        'tsserver',
        'cssls',
        'html',
        'bashls',
        'kotlin_language_server',
        'jdtls',
        'marksman',
        'rust_analyzer',
        'svelte',
    },
    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
})

local lsp_defaults = {
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', '<space>gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', '<space>gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<space>gy', '<cmd>split |lua vim.lsp.buf.definition()<CR>', bufopts)
        vim.keymap.set('n', '<space>gx', '<cmd>vsplit |lua vim.lsp.buf.definition()<CR>', bufopts)
        vim.keymap.set('n', '<space>gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', '<space>gh', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>gn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>gc', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', '<space>gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>gf', vim.lsp.buf.formatting, bufopts)
        vim.keymap.set('n', '<space>gwa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>gwr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>gwl',
            function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts
        )
    end,
}

-- A classic nvim lsp server configuration looks like
--
--     require('${BUILTIN_LSP_NAME}').setup({
--
--     })
--
--  - How do you get `${BUILTIN_LSP_NAME}`?
--
--      Use `:h lspconfig-all`.
--
--  - What does the `setup()` accept?
--
--      Use `:h lspconfig-setup`. For example, `start_client` function has a
--      parameter `{cmd} list[string]`, it means that `setup()` accepts a
--      parameter `cmd` which is a list of string. As a result, you can
--      configure your lsp such as
--
--          require('${BUILTIN_LSP_NAME}').setup({
--              cmd = { '/path/to/your_lsp_binary' }
--          })
--
--      `setup` calls the underlying `vim.lsp.start_client` function with some
--      parameters overrided. For other parameters not listed in
--      `:h lspconfig-setup`, see `:h vim.lsp.start_client` for details.
--
local lsp = require('lspconfig')
lsp.util.default_config = vim.tbl_deep_extend(
    'force',
    lsp.util.default_config,
    lsp_defaults
)

local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        -- if your windows is too small, the documentation windows may overlap
        -- your completion windows, a simple and dirty workaround can be found
        -- here: https://www.youtube.com/watch?v=ivmraDlBGDg
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
    }, {
        { name = 'buffer' },
    }),
    formatting = {
        format = require('lspkind').cmp_format({
            -- show only symbol annotations
            mode = 'symbol',
            -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            maxwidth = 50,
            -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            ellipsis_char = '...',
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function (entry, vim_item)
                return vim_item
            end
        })
    },
})

-- lsp.bash
lsp.bashls.setup({
})

-- lsp.kotlin
--
-- For android development, you may export the java bundled with Android Studio into PATH,
-- or else neovim will use the system java which could not work with kotlin.
if vim.env.ANDROID_JDK_DIR ~= nil then
    lsp.kotlin_language_server.setup({
        cmd_env = {
            PATH = vim.env.ANDROID_JDK_DIR .. "/bin:" .. vim.env.PATH,
            JAVA_HOME = vim.env.ANDROID_JDK_DIR,
        },
    })
end

-- lsp.vimscript
lsp.vimls.setup({
})

-- lsp.lua
lsp.lua_ls.setup({
    single_file_support = true,
})

-- lsp.java
lsp.jdtls.setup({
})

-- lsp.golang
lsp.gopls.setup({
})

-- lsp.clangd
--[[

- 项目根目录

    clangd 的项目根目录使用 .vimroot 文件来标记

- clangd 可执行程序

    需要编译 llvm 14 及其以上版本, 如果是 mac 不要使用自带的 clangd. 编译安装后,
    导出其安装目录为 LLVM_HOME, 该安装目录结构如下

        ${LLVM_HOME}
        ├── bin
        ├── include
        ├── lib
        ├── libexec
        └── share

- clangd 配置文件

    在 .vimroot 所在目录下面新建一个 .clangd 文件, 该文件格式为 YAML, 参考选项参见 https://clangd.llvm.org/config#diagnostics,
    比如如下配置表示屏蔽 clangd 所有警告

        Diagnostics:
            Suppress: '*'

- 生成 compile_commands.json

    cmpile_commands.json 文件的生成依赖于 cmake, 基本命令如下

        mkdir build && cd build
        cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1  ..

    将生成的文件放到 .vimroot 同目录的 build 目录下即可.

--]]
local clangd = nil
if vim.env.LLVM_HOME ~= nil then
    clangd = vim.env.LLVM_HOME .. "/bin/clangd"
    lsp.clangd.setup {
        cmd = {
            clangd,
            "--background-index",
            "--compile-commands-dir=build",
            "--clang-tidy",
            "--clang-tidy-checks=performance-*,bugprone-*",
            "--completion-style=detailed",
            "--all-scopes-completion",
            "--header-insertion=iwyu",
            "-j=8",
        },
        root_dir = lsp.util.root_pattern('.vimroot', '.git'),
    }
end

-- lsp.rust
--
-- Rust analzyer plugin (depends on rust-tools plugin), to custmized
-- configuration see https://github.com/simrat39/rust-tools.nvim#configuration
--
-- Note that you can use the following command to install rust-analyzer into
-- `${HOME}/.cargo/bin/`:
--
--     rustup component add rust-analyzer
--
require('rust-tools').setup({
    tools = {
        inlay_hints = {
            auto = true,
            only_current_line = true,
        },
    },
    -- rust-tools will pass `server` options to lspconfig's `setup` function
    server = {
        -- If we use rust-analyzer provided by mason plugin, sometimes you will
        -- have errors like this https://github.com/rust-lang/rust-analyzer/issues/16688
        --
        --     proc-macro server's api version (3) is newer than rust-analyzer's (2)
        --
        -- As a result, we use rust-analyzer provided by the following command:
        --
        --     rustup component add rust-analyzer
        --
        cmd = { vim.env.HOME .. "/.cargo/bin/rust-analyzer" },
        -- see https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
        settings = {
            ["rust-analyzer"] = {
                -- Do not warn me some codes are inactive
                diagnostics = {
                    enable = true,
                    disabled = { "inactive-code" },
                    enableExperimental = true,
                },
                -- Sometimes you may write cross-platform codes using `[#cfg(...)]` macro such as
                --
                --     #[cfg(target_os = "android")]
                --     #[allow(non_snake_case)]
                --     pub mod android {
                --         // ...
                --     }
                --
                -- rust_analyzer will not analyze the code in your mod `android`, to solve the
                -- problem you must declare the following checkOnSave option, but it is not enough.
                -- You must also create a file named config.toml under directory `<project>/.cargo`
                -- with content liking the followings
                --
                --    [build]
                --    target = "aarch64-linux-android"
                --
                -- Now you can continue your happy rust coding!
                --
                checkOnSave = {
                    enable = true,
                    allTargets = true,
                    command = "clippy",
                },
                -- make sure you have rust nightly installed:
                --
                --     rustup toolchain install nightly
                --
                rustfmt = {
                    extraArgs = { "+nightly", },
                },
            },
        },
    },
})

-- lsp.python
-- install python lsp: pip3 install -U jedi-language-server
lsp.jedi_language_server.setup({
})

-- lsp.javascript
-- 1. install: curl -fsSL https://deno.land/install.sh | sh
-- 2. add ${HOME}/.deno/bin to your PATH environment
lsp.denols.setup({
})

-- lsp.cmake
-- install lsp: pip3 install cmake-language-server
lsp.cmake.setup({
    root_dir = lsp.util.root_pattern('.vimroot'),
})

lsp.marksman.setup({
})

lsp.tsserver.setup({
})

lsp.cssls.setup({
})

lsp.html.setup({
})

-- https://github.com/sveltejs/language-tools/tree/master/packages/language-server
lsp.svelte.setup({
    settings = {
      svelte = {
          plugin = {
              typescript = {
                enable = true,
                diagnostics = {
                    enable = false,
                }
              }
          }
      },
    },
})
