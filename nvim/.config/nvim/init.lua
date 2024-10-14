-- Set to true if you have a Nerd Font installed
-- TODO Remove
vim.g.have_nerd_font = true

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Visual help
vim.opt.colorcolumn = "80"
vim.opt.cursorline = false -- Highlight the current line (TODO)
vim.opt.showmatch = true

-- Wrapping
vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5

-- Indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.breakindent = true

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.magic = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.matchpairs:append("<:>")

-- Save undo history
vim.opt.undofile = true

-- Status bar
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.ruler = true
vim.opt.statusline = "%{FugitiveStatusline()} %<%f %h%m%r%=%-14.(%l,%c%V%) %P"

vim.opt.guicursor = ""
vim.opt.termguicolors = true
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
-- TODO cleanup
-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- [[ keymap - remap ]]
-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>rn", ":set relativenumber!<CR>", {
	silent = true,
})

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- FZF
vim.keymap.set("n", "<C-P>", ":Files<CR>")
vim.keymap.set("n", "<leader>p", ":Buffers<CR>")
vim.keymap.set("n", "<leader>m", ":Marks<CR>")

-- Custom Grep
vim.keymap.set("n", "<leader>f", ":Crg<Space>")
vim.keymap.set("n", "<leader>F", ":Crg <C-R><C-W><CR>") -- Grep word under cursor
vim.keymap.set("n", "<leader>fd", ":Crgfd<Space>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Trigger test
vim.keymap.set("n", "<leader>t", ":TestNearest<CR>")
vim.keymap.set("n", "<leader>T", ":TestFile<CR>")

-- Replace base64 content with decoded content
vim.keymap.set("v", "<leader>64", [[c<c-r>=system('base64 --decode', @")<cr><esc>]], {})

-- Monzo specific
vim.keymap.set(
	"n",
	"gh",
	":let pp=getpos('.')<CR>:let res=split(system('handlertool '.shellescape(expand('%:p').':'.line('.').':'.col('.'))), ':')<CR>:e <C-R>=res[0]<CR><CR>:call setpos('.',[pp[0],res[1],res[2],0])<CR>",
	{ silent = true }
)

-- [[ Autocommands ]]

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "import Golang on save",
	group = vim.api.nvim_create_augroup("go-import-on-save", { clear = true }),
	pattern = { "*.go" },
	callback = function()
		Goimp(1000)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "set colorcolumn for Golang",
	group = vim.api.nvim_create_augroup("go-filetype", { clear = true }),
	pattern = "go",
	callback = function()
		vim.opt.colorcolumn = "120"
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	desc = "removes trailing spaces",
	group = vim.api.nvim_create_augroup("remove-whitespace-on-save", { clear = true }),
	pattern = "*",
	command = [[keepp %s/\s\+$//e]],
})

-- vim.api.nvim_create_autocmd({ "WinNew" }, {
	-- desc = "limit the number of split window to 2",
	-- group = vim.api.nvim_create_augroup("window-limit-two", { clear = true }),
	-- pattern = "*",
	-- callback = function ()
		-- local wins = vim.api.nvim_list_wins()
		-- print(vim.inspect(wins))
		-- -- print(#wins)
		-- -- if #wins > 2 then
			-- -- vim.cmd("q")
		-- -- end
	-- end
-- })


-- [[ Custom search with Ripgrep ]]
-- This is a custom search command that uses `ripgrep` to search for a pattern
if vim.fn.executable("rg") == 1 then
	vim.o.grepprg = "rg -H --no-heading --vimgrep"

	-- Search with default ripgrep options
	vim.api.nvim_create_user_command("Crg", function(opts)
		vim.cmd("grep! " .. table.concat(opts.fargs, " ") .. "|botright cw|redraw!")
	end, { nargs = "*" })

	-- Search within the current file's directory
	vim.api.nvim_create_user_command("Crgfd", function(opts)
		local current_file_path = CurrentRelativeFilePath()

		local pattern = current_file_path:match("^([^/]+)")
		-- Default to the original rg command if we can't find a pattern
		if pattern == nil then
			vim.cmd({ cmd = "Crg", args = { unpack(opts.fargs) } })
		end

		vim.cmd({ cmd = "Crg", args = { "-g", "'" .. pattern .. "/**/*'", unpack(opts.fargs) } })
	end, { nargs = "*" })
end

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
-- Use `opts = {}` to force a plugin to be loaded. This is equivalent to:
--    require('xxx').setup({})
require("lazy").setup({
	-- Utils
	"vim-scripts/scratch.vim", -- Create scratch buffers
	"tpope/vim-surround", -- Surround text with quotes, brackets, etc.
	"tpope/vim-vinegar", -- Enhances netrw
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	-- Git integration
	{ "tpope/vim-fugitive", dependencies = { "tpope/vim-rhubarb" } },

	-- Test helper
	{
		"vim-test/vim-test",
		config = function()
			vim.g["test#neovim#start_normal"] = 1
			vim.g["test#strategy"] = "neovim_sticky"
			vim.cmd("let test#neovim#term_position = 'vert botright 30'")
		end,
	},

	-- Commenting
	{
		"preservim/nerdcommenter",
		config = function()
			vim.g.NERDSpaceDelims = 1
		end,
	},

	-- Color
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"dzfrias/noir.nvim",
		priority = 999,
		config = function()
			-- vim.cmd("colorscheme gruvbox")
		end,
	},

	-- TODO evaluate
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- TODO revisit
	-- { -- Useful plugin to show you pending keybinds.
	-- "folke/which-key.nvim",
	-- event = "VimEnter", -- Sets the loading event to 'VimEnter'
	-- config = function() -- This is the function that runs, AFTER loading
	-- require("which-key").setup()

	-- -- Document existing key chains
	-- require("which-key").register({
	-- ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
	-- ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
	-- ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
	-- ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
	-- ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
	-- })
	-- end,
	-- },

	-- fzf
	-- {
		-- "junegunn/fzf",
		-- dir = "~/.fzf",
		-- build = "./install --all" ,
		-- dependencies = { "junegunn/fzf.vim" },
		-- config = function()
			-- vim.g.fzf_layout = { ["down"] = "40%" }
			-- vim.g.fzf_history_dir = "~/.local/share/fzf-history-nvim"
		-- end,
	-- },
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf" },
		config = function()
			vim.g.fzf_layout = { ["down"] = "40%" }
			vim.g.fzf_history_dir = "~/.local/share/fzf-history-nvim"
		end,
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
					map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
					map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
					map("<space>D", vim.lsp.buf.type_definition, "Type [D]efinition")
					-- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
					-- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
					map("<space>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<space>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
					-- map('<space>f', vim.lsp.buf.formatting, 'Format buffer')

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					-- TODO revisit
					-- local client = vim.lsp.get_client_by_id(event.data.client_id)
					-- if client and client.server_capabilities.documentHighlightProvider then
					-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					-- buffer = event.buf,
					-- callback = vim.lsp.buf.document_highlight,
					-- })

					-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					-- buffer = event.buf,
					-- callback = vim.lsp.buf.clear_references,
					-- })
					-- end
				end,
			})

			-- Don't show inline diagnostics and while typing
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					update_in_insert = false,
					virtual_text = false,
				})

			local util = require("lspconfig/util")
			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			local servers = {
				-- LSP Golang settings
				gopls = {
					on_init = function(client)
						local path = client.workspace_folders[1].name

						if string.find(path, "monzo/wearedev") then
							client.config.settings.gopls["local"] = "github.com/monzo/wearedev"
						end

						client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
						return true
					end,
					cmd = { "gopls", "-remote=auto" },
					filetypes = { "go", "gomod" },

					-- Ignore typical project roots which cause gopls to ingest large monorepos.
					--root_dir = util.root_pattern("go.work", "go.mod", ".git"),
					-- root_dir = util.root_pattern("main.go", "README.md", "LICENSE"),

					settings = {
						gopls = {
							-- Don't try to find the go.mod file, otherwise we ingest large monorepos
							-- expandWorkspaceToModule = false,
							-- memoryMode = "DegradeClosed",
							directoryFilters = {
								"-vendor",
								"-manifests",
							},
							codelenses = {
								generate = true,
								gc_details = true,
								test = true,
								tidy = true,
							},
						},
					},
				},
				-- LSP Python settings
				-- Type checking is performed with pip install pylsp-mypy
				pylsp = {
					root_dir = util.root_pattern("pyproject.toml", "requirements.txt", ".git"),
					plugins = {
						-- use ruff with https://github.com/python-lsp/python-lsp-ruff
						ruff = {
							enabled = true,
							formatEnabled = true,
							format = { "I" },
						},
					},
				},

				-- LSP TypeScript settings
				ts_ls = {},

				-- LSP Lua (with NeoVim) settings
				lua_ls = {
					on_init = function(client)
						local path = client.workspace_folders[1].name
						if
							not vim.loop.fs_stat(path .. "/.luarc.json")
							and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
						then
							client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
								Lua = {
									runtime = {
										-- Tell the language server which version of Lua you're using
										-- (most likely LuaJIT in the case of Neovim)
										version = "LuaJIT",
									},
									-- Make the server aware of Neovim runtime files
									workspace = {
										checkThirdParty = false,
										-- library = {
										-- vim.env.VIMRUNTIME
										-- -- "${3rd}/luv/library"
										-- -- "${3rd}/busted/library",
										-- },
										-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
										library = vim.api.nvim_get_runtime_file("", true),
									},
								},
							})

							client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
						end
						return true
					end,
				},

				-- LSP YAML settings
				yamlls = {},

				-- LSP Bash shell
				bashls = {},
			}

			-- Without Mason
			-- Iterate over the servers table and setup each server
			-- for server_name, server in pairs(servers) do
			-- -- This handles overriding only values explicitly passed
			-- -- by the server configuration above. Useful when disabling
			-- -- certain features of an LSP (for example, turning off formatting for tsserver)
			-- server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			-- require("lspconfig")[server_name].setup(server)
			-- end

			-- With Mason
			-- Ensure the servers and tools above are installed
			--  To check the current status of installed tools and/or manually install
			--  other tools, you can run
			--    :Mason
			--
			--  You can press `g?` for help in this menu.
			require("mason").setup()

			require("mason-lspconfig").setup({
				ensure_installed = {
					-- "gopls", Installed without Mason to use specific version
					"bashls",
					"lua_ls",
					"pylsp",
					"ts_ls",
					"yamlls",
				},
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>a",
				function()
					require("conform").format({ async = true, lsp_fallback = "always" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		config = function()
			local cfm = require("conform")
			cfm.setup({
				notify_on_error = true,
				-- format_on_save = function(bufnr)
				-- -- Disable "format_on_save lsp_fallback" for languages that don't
				-- -- have a well standardized coding style. You can add additional
				-- -- languages here or re-enable it for the disabled ones.
				-- local disable_filetypes = { c = true, cpp = true }
				-- return {
				-- timeout_ms = 500,
				-- lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				-- }
				-- end,
				formatters_by_ft = {
					lua = { "stylua" },
					bash = { "shfmt" },
					sh = { "shfmt" },
					graphql = { "prettier" },
					-- Conform can also run multiple formatters sequentially
					-- python = { "isort", "black" },
					--
					-- You can use a sub-list to tell conform to run *until* a formatter
					-- is found.
					-- javascript = { { "prettierd", "prettier" } },
				},
			})

			-- Format on save only for given filetypes
			vim.api.nvim_create_autocmd("BufWritePre", {
				desc = "format on save",
				group = vim.api.nvim_create_augroup("format-on-save", { clear = true }),
				pattern = { "*.go", "*.py", "*.graphql" },
				callback = function(args)
					-- Equivalent to vim.lsp.buf.format({ async = false })
					cfm.format({ bufnr = args.buf, lsp_fallback = "always" })
				end,
			})
		end,
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	},

	{ -- Github Copilot
		"github/copilot.vim",
		config = function()
			vim.g.copilot_no_tab_map = true

			vim.keymap.set("i", "<C-J>", [[copilot#Accept("\<CR>")]], {
				expr = true,
				replace_keycodes = false,
			})
		end,
	},

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			-- require("mini.surround").setup()

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "bash", "c", "html", "lua", "luadoc", "markdown", "vim", "vimdoc", "go", "python" },
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},
	require 'kickstart.plugins.debug',
	-- require 'kickstart.plugins.indent_line',
	-- require 'kickstart.plugins.lint',

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	--    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
	-- { import = 'custom.plugins' },
}, {
	ui = {},
})

-- [[ Helper Functions ]]
function Goimp(waitms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }

	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, waitms)
	for client_id, res in pairs(result or {}) do
		local client = vim.lsp.get_client_by_id(client_id)
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
			end
		end
	end
end

function CurrentRelativeFilePath()
	local current_directory = vim.fn.getcwd()
	local current_bufnr = vim.fn.bufnr("%")

	-- Get the path of the current buffered file
	local current_file_path = vim.api.nvim_buf_get_name(current_bufnr)

	-- Remove current directory from the path
	current_file_path = string.gsub(current_file_path, current_directory .. "/", "")
	return current_file_path
end

function CopyRelativePath()
	local relative_path = CurrentRelativeFilePath()

	-- Copy the relative path to the system clipboard
	vim.fn.setreg("+", relative_path)
	vim.fn.setreg("*", relative_path)

	print("Copied relative path to system clipboard: " .. relative_path)
end
