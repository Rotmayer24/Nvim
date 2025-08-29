-- ==============================
-- Basic settings
-- ==============================
vim.opt.clipboard = "unnamedplus"
vim.cmd("syntax on")
vim.opt.number = true
vim.opt.relativenumber = true

-- Space as Leader
vim.g.mapleader = " "

-- Bind Esc + Space + e to open Nvim Tree
vim.keymap.set("n", "<Space>e", ":NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree" })


-- Disable arrow keys (only use hjkl)
local keys = {"up","down","left","right"}
for _, k in ipairs(keys) do
  vim.keymap.set("n", "<"..k..">", "<nop>")
  vim.keymap.set("i", "<"..k..">", "<nop>")
end

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Interface
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.mouse = "a"
vim.opt.termguicolors = true

-- ==============================
-- Install lazy.nvim
-- ==============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  -- Nvim Tree
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree" })
    end
  },

  -- Which-key for displaying hotkeys
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      wk.setup({})
      wk.register({
        w = { ":w<CR>", "Save file" },
        e = { ":NvimTreeToggle<CR>", "Toggle Nvim Tree" },
        f = { ":Telescope find_files<CR>", "Find files" },
        l = { ":Lazy<CR>", "Lazy" },
      }, { prefix = "<leader>" })
    end
  },

  {
    "blurskye/better-toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<Space>t]],  
        direction = "horizontal",      
        size = 15,                  
        shade_terminals = true,
      })
    end,
  },

  -- Themes
  { "folke/tokyonight.nvim" },
  { "morhetz/gruvbox" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "dracula/vim", name = "dracula" },

  {
    "nyoom-engineering/oxocarbon.nvim", -- example theme with switching ability
    config = function()
-- Completion in command mode (:) and search (/)
local cmp = require("cmp")

-- Для поиска по /
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})

-- Для команд через :
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" } -- автодополнение путей
  }, {
    { name = "cmdline" } -- автодополнение команд Neovim
  })
})
      local themes = { "tokyonight", "onedarkpro", "catppuccin" }
      local current = 1

      local function set_theme(idx)
        current = idx
        vim.cmd("colorscheme " .. themes[current])
      end

      set_theme(current)

      -- Hotkeys
      vim.keymap.set("n", "<leader>O", function() -- next theme
        set_theme(current % #themes + 1)
      end, { desc = "Next Theme" })

    end
  },

   
-- Plugin for tabs
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup{
        options = {
          numbers = "ordinal",  -- tab numbering
          close_command = "bdelete! %d", -- close tab
          right_mouse_command = "bdelete! %d",
          offsets = { { filetype = "NvimTree", text = "Explorer", text_align = "center" } },
          show_buffer_close_icons = true,
          show_close_icon = false,
        }
      }

      -- Hotkeys for switching tabs
      vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", { desc = "Close current buffer" })
      vim.keymap.set("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>")
      vim.keymap.set("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>")
      vim.keymap.set("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>")
      vim.keymap.set("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>")
      vim.keymap.set("n", "L", ":BufferLineCycleNext<CR>", { desc = "Next tab" })
      vim.keymap.set("n", "H", ":BufferLineCyclePrev<CR>", { desc = "Previous tab" })
    end
  },



  -- Dashboard (welcome screen)
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
'    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
'    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
'    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
'    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
'    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
'    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',}

      dashboard.section.buttons.val = {
        dashboard.button("e", "  New File", ":ene <BAR> startinsert<CR>"),
        dashboard.button("w", "  Save File", ":w<CR>"),
        dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
        dashboard.button("l", "  Lazy", ":Lazy<CR>"),
        dashboard.button("c", " Config Nvim", ":cd ~/.config/nvim | NvimTreeToggle <CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      alpha.setup(dashboard.config)
    end
  },

  -- Other plugins
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },



  -- LSP and completion
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", dependencies = {"mason.nvim"}, config = true },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Other plugins
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Themes
  { "folke/tokyonight.nvim" },
  { "morhetz/gruvbox" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "dracula/vim", name = "dracula" },

  -- LSP and completion
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", dependencies = {"mason.nvim"}, config = true },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

-- ==============================
-- Plugins via lazy.nvim
-- ==============================

  -- Basic plugins
  { "nvim-tree/nvim-tree.lua" },                           
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
{
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        python = { "black", "isort" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        sql = { "sql_formatter" },
      },
    })
  end,
},
  -- Themes
  { "folke/tokyonight.nvim" },
  { "morhetz/gruvbox" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "dracula/vim", name = "dracula" },
 { "olimorris/onedarkpro.nvim", name=onedarkpro},

  -- LSP and completion
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", dependencies = {"mason.nvim"}, config = true },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  {"stevearc/dressing.nvim"},
  {"rcarriga/nvim-notify"},
  {"folke/trouble.nvim"},
  {"numToStr/Comment.nvim"},
  {"rafamadriz/friendly-snippets"},
  {"folke/twilight.nvim"},
  {"MunifTanjim/nui.nvim"},
  {"folke/noice.nvim"},
  {"sindrets/diffview.nvim"},
  {"stevearc/oil.nvim"},
  {"folke/flash.nvim"},
  {"echasnovski/mini.nvim"},
  {"iamcco/markdown-preview.nvim"},
  {"chrisgrieser/nvim-kickstart-python"},
  {"kiyoon/python-import.nvim"},
  {"RaafatTurki/hex.nvim"},
})

-- ==============================
-- Default theme setup
-- ==============================
vim.g.tokyonight_style = "storm"
vim.cmd([[colorscheme tokyonight]])

-- ==============================
-- Theme switching function
-- ==============================
local themes = {
  ["tokyonight"] = function() vim.cmd([[colorscheme tokyonight]]) end,
  ["gruvbox"] = function() vim.cmd([[colorscheme gruvbox]]) end,
  ["catppuccin"] = function() vim.cmd([[colorscheme catppuccin]]) end,
  ["onedarkpro"] = function() vim.cmd([[colorscheme dracula]]) end,

}

-- Hotkeys for switching themes
--vim.keymap.set("n", "<leader>1", themes.tokyonight, { desc = "Tokyonight" }) 
--vim.keymap.set("n", "<leader>2", themes.catppuccin, { desc = "Catppuccin" })
--vim.keymap.set("n", "<leader>3", themes.onedarkpro, { desc = "Onedarkpro" })

-- ==============================
-- LSP setup for Python
-- ==============================
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = {"pyright"} })
require("lspconfig").pyright.setup({})

-- ==============================
-- Completion setup
-- ==============================
local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    { name = "luasnip" },
  }),
})
-- ==============================
-- Load plugins from lua/plugins/
-- ==============================
--local plugin_files = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugins/*.lua", false, true)
--for _, file in ipairs(plugin_files) do
  --local name = file:match("lua/plugins/(.+)%.lua$")
  --if name then
    --require("plugins." .. name)
  --end
--end

vim.keymap.set("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>")
vim.keymap.set("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>")
vim.keymap.set("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>")
vim.keymap.set("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>")
vim.keymap.set("n", "<leader>L", ":bnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>H", ":bprevious<CR>", { desc = "Previous tab" })

-- ==============================
-- Tokyonight Theme
-- ==============================

vim.g.tokyonight_style = "night"  -- options: storm, night, day
vim.cmd[[colorscheme tokyonight]]

-- ==============================
-- Completion setup (nvim-cmp)
-- ==============================
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<CR>"]  = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
  }),
})

-- Completion in search ("/" и "?")
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})

-- Completion in command-line (":")
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" }
  }, {
    { name = "cmdline" }
  })
})


require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",       -- Python (Flask тоже, т.к. это питоновский фреймворк)
    "html",          -- HTML
    "cssls",         -- CSS
    "jsonls",        -- JSON
    "sqlls",         -- SQL (SQLite тоже работает)
    "eslint",        -- для JS/TS, если вдруг понадобится
  }
})


local lspconfig = require("lspconfig")

lspconfig.pyright.setup({})
lspconfig.html.setup({})
lspconfig.cssls.setup({})
lspconfig.jsonls.setup({})
lspconfig.sqlls.setup({})


require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "python", "html", "css", "javascript", "json", "sql"
  },
  highlight = { enable = true },
  indent = { enable = true },
})

