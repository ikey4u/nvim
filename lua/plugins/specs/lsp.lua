return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            -- The name is from nvim-lspconfig https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
            --
            -- Note that the name is different from what `:MasonInstall`
            -- requires which is from https://mason-registry.dev/registry/list
            ensure_installed = {
                -- For JSON
                "jsonls",
                -- For typescript and javascript
                "ts_ls",
                "tinymist",
                -- For python
                "ty",
                "ruff",
                -- For Vue
                "vue_ls",
                "vtsls",
                -- Others
                "html",
                "lua_ls",
                "rust_analyzer",
            },
            automatic_installation = true,
            automatic_enable = {
                exclude = {
                    -- Only use mason to install rust analyzer but not start
                    -- it since the rust lsp rustaceanvim will take full control
                    -- over it
                    "rust_analyzer",
                },
            },
        },
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {},
            },
            {
                "neovim/nvim-lspconfig",
                event = { "BufReadPre", "BufNewFile" },
                config = function()
                    -- From nvim 0.11+, `require("lspconfig")` is deprecated in favor of
                    -- `vim.lsp.config(name, cfg)` where
                    --
                    --   - name: The LSP name, a special value `*` can be used to refer all LSPs
                    --   - cfg: See `vim.lsp.Config`
                    --
                    -- To add your additional customized LSP configuration, add it as
                    -- `after/lsp/{name}.lua` (not `after/lsp/{name}.lua` since it may does not work).
                    vim.lsp.config("*", require("std.lsp").get_config())
                end,
            },
        },
    },
    -- Provides `:Lspsage` related commands
    {
        "nvimdev/lspsaga.nvim",
        opts = {},
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            require("luasnip").setup({})
            require("luasnip.loaders.from_lua").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/snippets" },
            })
        end,
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        config = function()
            require("cmp_nvim_lsp").setup({})
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "onsails/lspkind-nvim",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            -- Use `:` to trigger emoji autocomplete in insert mode
            "hrsh7th/cmp-emoji",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- Show the completion in format like `<cmp> <icon> <kind>`
            -- such as `console <icon> Variable`
            local formatting = {
                fields = { "abbr", "menu", "kind" },
                format = require("lspkind").cmp_format({
                    -- show symbol and text annotations
                    mode = "symbol_text",
                    -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    maxwidth = 50,
                    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    ellipsis_char = "...",
                    -- The function below will be called before any actual modifications from lspkind
                    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                    before = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[NVIM_LSP]",
                            luasnip = "[LUA_SNIP]",
                            buffer = "[BUFFER]",
                            path = "[PATH]",
                            nvim_lua = "[NVIM_LUA]",
                            emoji = "[EMOJI]",
                        })[entry.source.name] or string.format("[%s]", entry.source.name)
                        return vim_item
                    end,
                }),
            }
            cmp.setup({
                completion = {
                    autocomplete = {
                        cmp.TriggerEvent.TextChanged,
                        cmp.TriggerEvent.InsertEnter,
                    },
                    keyword_length = 1,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
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
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "path" },
                    { name = "buffer" },
                    { name = "emoji" },
                }),
                formatting = formatting,
                experimental = {
                    ghost_text = true,
                },
            })
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^6",
        lazy = false,
        config = function()
            local lsp_defaults = require("std.lsp").get_config()
            vim.g.rustaceanvim = {
                tools = {
                    inlay_hints = {
                        auto = true,
                        only_current_line = true,
                    },
                },
                -- rust-tools will pass `server` options to lspconfig's `setup` function
                server = {
                    flags = lsp_defaults.flags,
                    capabilities = lsp_defaults.capabilities,
                    on_attach = lsp_defaults.on_attach,
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
                                extraArgs = { "+nightly" },
                            },
                        },
                    },
                },
            }
        end,
    },
}
