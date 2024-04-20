require("Serenity")
print("Welcome back Syl :D")

-- disables netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- lazy.nvim installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install lazy.nvim plugins here
local plugins = {
    'neovim/nvim-lspconfig',
    'nvim-tree/nvim-web-devicons',
    'lewis6991/gitsigns.nvim',
    'nvim-lua/plenary.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
    'petertriho/cmp-git',
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    {
        "luckasRanarison/tailwind-tools.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            document_color = {
                enabled = true, -- can be toggled by commands
                kind = "background", -- "inline" | "foreground" | "background"
                inline_symbol = "󰝤 ", -- only used in inline mode
                debounce = 200, -- in milliseconds, only applied in insert mode
            },
            conceal = {
                enabled = false, -- can be toggled by commands
                min_length = nil, -- only conceal classes exceeding the provided length
                symbol = "󱏿", -- only a single character is allowed
                highlight = { -- extmark highlight options, see :h 'highlight'
                    fg = "#38BDF8",
                },
            },
            custom_filetypes = {} -- see the extension section to learn how it works
        } -- your configuration
    },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
    {
        "nvim-tree/nvim-tree.lua",
	    version = "*",
	    lazy = false,
	    dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    'feline-nvim/feline.nvim',
    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
    },
    'm4xshen/autoclose.nvim',
    'NvChad/nvim-colorizer.lua',
}

-- lazy.nvim options
local opts = {}

-- DO NOT TOUCH: lazy.nvim initialization
require("lazy").setup(plugins, opts)

-- tree-sitter settings

-- Theme settings
vim.cmd.colorscheme "catppuccin-mocha"

-- Catppuccin Integrations
require("catppuccin").setup({
    integrations = {
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
    }
})

-- gitsigns settings
require('gitsigns').setup()

-- Autocompletion settings
local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    },
    {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })
  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- auto closing braces
require("autoclose").setup()


-- LSP settings
local navic = require("nvim-navic")

-- lua
require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  on_attach = function(client, bufnr)
      navic.attach(client, bufnr)
  end,
  settings = {
    Lua = {}
  },
  capabilities = capabilities
}

-- TypeScript
require("typescript-tools").setup {
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end,
    settings = {
        jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
        },
    },
    capabilities = capabilities
}

-- Tailwind CSS
require'lspconfig'.tailwindcss.setup{}

-- Telescope settings
local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  }
}

-- feline bar settings
local mocha = require("catppuccin.palettes").get_palette "mocha"
local clrs = require("catppuccin.palettes").get_palette()
local ctp_feline = require('catppuccin.groups.integrations.feline')
local U = require "catppuccin.utils.colors"

ctp_feline.setup({
    assets = {
        left_separator = "",
        right_separator = "",
        mode_icon = "",
        dir = "󰉖",
        file = "󰈙",
        lsp = {
            server = "󰅡",
            error = "",
            warning = "",
            info = "",
            hint = "",
        },
        git = {
            branch = "",
            added = "",
            changed = "",
            removed = "",
        },
    },
    sett = {
        text = U.vary_color({ mocha = mocha.base }, clrs.surface0),
        bkg = U.vary_color({ mocha = mocha.crust }, clrs.surface0),
        diffs = clrs.mauve,
        extras = clrs.overlay1,
        curr_file = clrs.maroon,
        curr_dir = clrs.flamingo,
        show_modified = true -- show if the file has been modified
    },
    mode_colors = {
        ["n"] = { "NORMAL", clrs.lavender },
        ["no"] = { "N-PENDING", clrs.lavender },
        ["i"] = { "INSERT", clrs.green },
        ["ic"] = { "INSERT", clrs.green },
        ["t"] = { "TERMINAL", clrs.green },
        ["v"] = { "VISUAL", clrs.flamingo },
        ["V"] = { "V-LINE", clrs.flamingo },
        ["�"] = { "V-BLOCK", clrs.flamingo },
        ["R"] = { "REPLACE", clrs.maroon },
        ["Rv"] = { "V-REPLACE", clrs.maroon },
        ["s"] = { "SELECT", clrs.maroon },
        ["S"] = { "S-LINE", clrs.maroon },
        ["�"] = { "S-BLOCK", clrs.maroon },
        ["c"] = { "COMMAND", clrs.peach },
        ["cv"] = { "COMMAND", clrs.peach },
        ["ce"] = { "COMMAND", clrs.peach },
        ["r"] = { "PROMPT", clrs.teal },
        ["rm"] = { "MORE", clrs.teal },
        ["r?"] = { "CONFIRM", clrs.mauve },
        ["!"] = { "SHELL", clrs.green },
        ["nt"] = { "NVIMTREE", clrs.peach },
    },
    view = {
        lsp = {
            progress = true, -- if true the status bar will display an lsp progress indicator
            name = false, -- if true the status bar will display the lsp servers name, otherwise it will display the text "Lsp"
            exclude_lsp_names = {}, -- lsp server names that should not be displayed when name is set to true
            separator = "|", -- the separator used when there are multiple lsp servers
        },
    }
})

require('feline').setup({
    components = ctp_feline.get(),
})

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        package.loaded["feline"] = nil
        package.loaded["catppuccin.groups.integrations.feline"] = nil
        require("feline").setup {
            components = require("catppuccin.groups.integrations.feline").get(),
        }
    end,
})


-- colorizer settings
require'colorizer'.setup()

-- nvim editor options
-- use vim.g.{variable} = something to replicate the behaviour of let {variable} = something
-- use vim.opt.{variable} = something to replicate the behaviour of set {variable} = something
-- when using vim.opt, if the flag is a boolean, you must explicitly set it to true or false.

-- show line numbers in a file
vim.opt.number = true

-- show tabline at the top
vim.opt.showtabline = 2

-- 4 tab spacing
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- sets termguicolors
vim.opt.termguicolors = true
