-- NOTE: This requires neovim >= 0.12, you can use bob to download nightly.
--

-- Options
vim.g.netrw_browsex_viewer = "xdg-open"
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.winborder = "rounded"
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.termguicolors = true


-- Plugins
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",          version = "main" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/ThePrimeagen/harpoon",                     version = "harpoon2" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
})

require("mason").setup({
	ensure_installed = {
		"bash-language-server",
		"docker-language-server",
		"hyprls",
		"jq",
		"lua-language-server",
		"markdown-toc",
		"markdownlint-cli2",
		"marksman",
		"prettier",
		"shellcheck",
		"tinymist",
	}
})
require("mini.pick").setup()
require("oil").setup({
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, bufnr)
			local m = name:match("^%.git$")
			if m ~= nil then
				return true
			else
				return false
			end
		end
	}
})
require("conform").setup({
	formatters = {
		["markdown-toc"] = {
			condition = function(_, ctx)
				for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
					if line:find("<!%-%- toc %-%->") then
						return true
					end
				end
			end,
		},
		["markdownlint-cli2"] = {
			condition = function(_, ctx)
				local diag = vim.tbl_filter(function(d)
					return d.source == "markdownlint"
				end, vim.diagnostic.get(ctx.buf))
				return #diag > 0
			end,
		},
		formatters_by_ft = {
			["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
			["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
			lua = { "stulua" },
			swift = { "swiftformat" },
		},
	}
})

require("harpoon").setup({ settings = { save_on_toggle = true, sync_on_ui_close = true } })

-- Set color scheme
vim.cmd([[colorscheme catppuccin-mocha]])
vim.cmd(":hi statusline guibg=NONE")
vim.cmd [[set completeopt+=menuone,noselect,popup]]

-- LSP
--
vim.lsp.enable({
	"lua_ls", "tinymist", "marksman", "bashls", "hyprls", "docker-language-server",
})

vim.lsp.config('bashls', {
	filetypes = { "bash", "sh", "zsh" },
	cmd = { 'bash-language-server', 'start' },
})

vim.lsp.config('docker-language-server', {
	cmd = { 'docker-language-server', 'start', '--stdio' },
	filetypes = { 'dockerfile', 'yaml.docker-compose' },
	get_language_id = function(_, ftype)
		if ftype == 'yaml.docker-compose' or ftype:lower():find('ya?ml') then
			return 'dockercompose'
		else
			return ftype
		end
	end,
	root_markers = {
		'Dockerfile',
		'docker-compose.yaml',
		'docker-compose.yml',
		'compose.yaml',
		'compose.yml',
		'docker-bake.json',
		'docker-bake.hcl',
		'docker-bake.override.json',
		'docker-bake.override.hcl',
	},
})

-- Fix warnings for 'vim' global keyword.
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = {
					vim.api.nvim_get_runtime_file("", true),
				},
			},
		},
	},
})

-- Keymaps
local map = vim.keymap.set
local harpoon = require("harpoon")

map('i', 'jk', '<ESC>')

map('n', '<leader>a', function() harpoon:list():add() end, { desc = "[A]dd file to harpoon" })
map('n', '<leader>bb', ':bprevious', { desc = "[B]uffer [b]ack" })
map('n', '<leader>bn', ':bnext', { desc = "[B]uffer [n]ext" })
map('n', '<leader>cf', vim.lsp.buf.format, { desc = "[F]ormat" })
map('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open harpoon menu" })
map('n', '<leader>e', ':Oil<CR>', { desc = "[E]xplore files" })
map('n', '<leader>ff', ':Pick files<CR>', { desc = "[F]ind file" })
map('n', '<leader>fh', ':Pick help<CR>', { desc = "[H]elp search" })
map('n', '<leader>hb', function() harpoon:list():prev() end, { desc = "[H]arpoon [b]ack" })
map('n', '<leader>hn', function() harpoon:list():next() end, { desc = "[H]arpoon [n]ext" })
map('n', '<leader>o', ':update<CR> :source<CR>', { desc = "Source current file" })

-- Tmux / pane navigation
map('n', "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>")
map('n', "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>")
map('n', "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>")
map('n', "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>")

-- Move line(s) up or down.
map('n', "J", ":move .+1<CR>==", { desc = "Move line down" })
map('n', "K", ":move .-2<CR>==", { desc = "Move line up" })
map("v", "K", ":move '<-2<CR>gv=gv", { desc = "Move selected block up.", silent = true, noremap = true })
map("v", "J", ":move '>+1<CR>gv=gv", { desc = "Move selected block up.", silent = true, noremap = true })

-- Harpoon extensions
harpoon:extend({
	UI_CREATE = function(cx)
		vim.keymap.set("n", "<C-v>", function()
			harpoon.ui:select_menu_item({ vsplit = true })
		end, { buffer = cx.buffer, desc = "Open in [V]ertical split" })
	end,
})

-- Auto commands.
local defaultopts = { clear = true }

-- Force zsh files to use bash syntax highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup('my.zsh', defaultopts),
	pattern = "*",
	callback = function(args)
		local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ""
		if first_line:match("^#!.*zsh") then
			vim.cmd.setlocal("filetype=bash")
		end
	end,
})

-- Markdown
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.md",
	group = vim.api.nvim_create_augroup('my.markdown', defaultopts),
	callback = function(_)
		-- HACK: Set filetype to markdown for '.md' files.
		-- Not sure why it doesn't detect these as markdown files, but this fixes the issue.
		vim.cmd.setlocal("filetype=markdown")
		vim.cmd.setlocal("textwidth=120")
		vim.cmd.setlocal("spell spelllang=en_us")
	end,
})

-- Neomutt
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "neomutt*",
	group = vim.api.nvim_create_augroup('my.neomutt', defaultopts),
	callback = function(_)
		vim.cmd.setlocal("filetype=markdown")
		vim.cmd.setlocal("textwidth=120")
		vim.cmd.setlocal("spell spelllang=en_us")
	end,
})

-- GoPass
vim.api.nvim_exec2(
	[[
  autocmd BufNewFile,BufRead /private/**/gopass** setlocal noswapfile nobackup noundofile shada=""
  ]],
	{}
)

-- Stolen from: https://github.com/SylvanFranklin/.config/blob/main/nvim/init.lua
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
	pattern = { "*.hl", "hypr*.conf" },
	callback = function(event)
		vim.lsp.start {
			name = "hyprlang",
			cmd = { "hyprls" },
			root_dir = vim.fn.getcwd(),
		}
	end
})

-- Highlight when yanking.
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text.",
	group = vim.api.nvim_create_augroup("my.highlight-yank", defaultopts),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Add '-' to be part of words.
vim.api.nvim_create_autocmd("BufEnter", {
	desc = "Add '-' to be part of word.",
	group = vim.api.nvim_create_augroup('my.iskeyword', defaultopts),
	pattern = "*",
	callback = function()
		vim.cmd.setlocal("iskeyword+=-")
	end
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Format on write.",
	group = vim.api.nvim_create_augroup('my.format-on-write', defaultopts),
	pattern = "*",
	callback = function()
		vim.lsp.buf.format()
	end
})
