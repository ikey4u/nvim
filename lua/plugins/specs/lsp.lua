-- Update lsp binary using lsp `name` and update it to the lsp's lspconfig `opts`
-- if found.
--
-- Assume the lsp `name` is `lua_ls`, then this function will try to search
-- lsp binary from environment `LUA_LS_EXE`, and then `lua_ls`command, the first
-- wins.
--
local function lsp_config_with_cmd(opts, name)
	local cmd

	local env_exe = vim.env[name:upper():gsub("%.", "_") .. "_EXE"]
	if env_exe and env_exe ~= "" then
		local p = vim.fn.exepath(env_exe)
		if p and p ~= "" then
			cmd = p
		end
	end
	if cmd then
		opts.cmd = { cmd }
		return opts
	end

	cmd = vim.fn.exepath(name)
	if cmd and cmd ~= "" then
		opts.cmd = { cmd }
		return opts
	end

	return opts
end

local function default_lsp_config()
	return {
		flags = { debounce_text_changes = 150 },
		capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
		on_attach = function(_client, bufnr)
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
			local bufopts = { noremap = true, silent = true, buffer = bufnr }

			vim.keymap.set("n", "<space>ge", vim.diagnostic.open_float, bufopts)
			vim.keymap.set("n", "<space>gD", vim.lsp.buf.declaration, bufopts)
			vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, bufopts)
			vim.keymap.set("n", "<space>gy", "<cmd>split |lua vim.lsp.buf.definition()<CR>", bufopts)
			vim.keymap.set("n", "<space>gx", "<cmd>vsplit |lua vim.lsp.buf.definition()<CR>", bufopts)
			vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, bufopts)
			vim.keymap.set("n", "<space>gh", ":Lspsaga peek_definition<CR>", bufopts)
			vim.keymap.set("n", "<space>gt", vim.lsp.buf.type_definition, bufopts)
			vim.keymap.set("n", "<space>gn", vim.lsp.buf.rename, bufopts)
			vim.keymap.set("n", "<space>gc", vim.lsp.buf.code_action, bufopts)
			vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, bufopts)
			vim.keymap.set("n", "<space>FF", vim.lsp.buf.format, bufopts)
			vim.keymap.set("n", "<space>gwa", vim.lsp.buf.add_workspace_folder, bufopts)
			vim.keymap.set("n", "<space>gwr", vim.lsp.buf.remove_workspace_folder, bufopts)
			vim.keymap.set("n", "<space>gwl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, bufopts)
		end,
	}
end

local function lua_ls_config()
	return lsp_config_with_cmd({
		single_file_support = true,
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
				},
			},
		},
	}, "lua_ls")
end

local function ts_ls_config()
	local vue_language_server_path = vim.fn.stdpath("data")
		.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
	local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
	local vue_plugin = {
		name = "@vue/typescript-plugin",
		location = vue_language_server_path,
		languages = { "vue" },
	}

	return {
		init_options = {
			plugins = {
				vue_plugin,
			},
		},
		filetypes = tsserver_filetypes,
	}
end

return {
	{ "mason-org/mason.nvim", opts = {} },
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"vue_ls",
				"ts_ls",
				"tinymist",
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
			{ "mason-org/mason.nvim", opts = {} },
		},
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvimdev/lspsaga.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		config = function()
			local mlsp = require("mason-lspconfig")
			local installed_servers = mlsp.get_installed_servers()
			for _, server_name in ipairs(installed_servers) do
				local c = default_lsp_config()
				if server_name == "lua_ls" then
					c = vim.tbl_deep_extend("force", c, lua_ls_config())
				end
				if server_name == "ts_ls" then
					-- TODO: this will cause the documentation of typescript
					-- disappear :(, disabled for now
					-- c = vim.tbl_deep_extend("force", c, ts_ls_config())
				end
				vim.lsp.config(server_name, c)
			end
		end,
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
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
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
				}, {
					{ name = "buffer" },
				}),
				-- Show the completion in format like `<cmp> <icon> <kind>`
				-- such as `console <icon> Variable`
				formatting = {
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
							return vim_item
						end,
					}),
				},
			})
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
		config = function()
			local lsp_defaults = default_lsp_config()
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
