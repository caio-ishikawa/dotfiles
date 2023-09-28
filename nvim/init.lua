-- GENERAL CONFIG --
local map = vim.api.nvim_set_keymap 
local defaults = { noremap = true, silent = true } 
map("i", "jk", "<Esc>", defaults)
vim.cmd("colorscheme catppuccin-mocha")
vim.cmd("set relativenumber")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("autocmd BufNewFile,BufRead *.h setfiletype c")
vim.cmd("set background=dark")
vim.keymap.set("n", "OD", require("oil").open, { desc = "Open parent directory" })

-- LSP CONFIG --
local lsp = require('lsp-zero').preset({})

vim.diagnostic.config({
	virtual_text = false
})

vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'rust_analyzer',
  'ocamllsp',
})

lsp.setup()

-- LSP LINES CONFIG --
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})

-- TREESITTER CONFIG --
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- LUALINE CONFIG --
require('lualine').setup {
    options = {
        theme = "catppuccin"
        -- ... the rest of your lualine config
    }
}

-- TELESCOPE CONFIG --
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'FF', builtin.find_files, {})
vim.keymap.set('n', 'FG', builtin.live_grep, {})

-- OIL CONFIG --
require("oil").setup()
return require('packer').startup(function(use)
	-- ONLY USING THIS BECAUSE TREE-SITTER WON'T WORK WITH SVELTE --
	use 'evanleck/vim-svelte'
	use 'pangloss/vim-javascript'
	use 'othree/html5.vim'
	-- PLEASE DON'T FORGET TO FIND A SOLUTION TO THIS --
	
    use 'wbthomason/packer.nvim'
	use {'nyoom-engineering/oxocarbon.nvim'}
	use { "catppuccin/nvim", as = "catppuccin" }
    use 'nvim-tree/nvim-web-devicons'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
   	}
    use {'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
	use "lukas-reineke/indent-blankline.nvim"
	use {
      	'stevearc/oil.nvim',
      	config = function() require('oil').setup() end
    }

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}	

	use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
		-- LSP Support
		{'neovim/nvim-lspconfig'},             -- Required
		{'williamboman/mason.nvim'},           -- Optional
		{'williamboman/mason-lspconfig.nvim'}, -- Optional

		-- Autocompletion
		{'hrsh7th/nvim-cmp'},     -- Required
		{'hrsh7th/cmp-nvim-lsp'}, -- Required
		{'L3MON4D3/LuaSnip'},     -- Required
	  }
	}
end)

