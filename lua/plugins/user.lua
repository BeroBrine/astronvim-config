---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    opts = {
      handlers = {
        rust_analyzer = false,
      },
    },
  },

	{
		"voxelprismatic/rabbit.nvim",

		-- Important! The master branch is the previous version
		branch = "rewrite",

		-- Important! Rabbit should launch on startup to track buffers properly
		lazy = false,

		---@type Rabbit.Config
		opts = {},
		config = true,
	},

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- Your transparency configuration
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      highlights = {
        init = { -- applies to all colorschemes
          Normal = { bg = "none" },
          NormalNC = { bg = "none" },
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          SignColumn = { bg = "none" },
          FoldColumn = { bg = "none" },
          WinBar = { bg = "none" },
          WinBarNC = { bg = "none" },
          WinSeparator = { bg = "none" },
          StatusLine = { bg = "none" },
          StatusLineNC = { bg = "none" },
          TabLine = { bg = "none" },
          TabLineFill = { bg = "none" },
          TabLineSel = { bg = "none" },
          NeoTreeNormal = { bg = "none" },
          NeoTreeNormalNC = { bg = "none" },
          NeoTreeEndOfBuffer = { bg = "none" },
          NeoTreeWinSeparator = { bg = "none" },
          NeoTreeSignColumn = { bg = "none" },
          NeoTreeStatusLine = { bg = "none" },
          NeoTreeStatusLineNC = { bg = "none" },
          NeoTreeTabLineSel = { bg = "none" },
          NeoTreePane = { bg = "none" },
          Pmenu = { bg = "none" },
          TelescopeNormal = { bg = "none" },
          TelescopeBorder = { bg = "none" },
          SnacksPicker = { bg = "none" },
          SnacksPickerBorder = { bg = "none" },
          SnacksPickerPreview = { bg = "none" },
          SnacksPickerPreviewBorder = { bg = "none" },
          SnacksPickerInput = { bg = "none" },
          EndOfBuffer = { bg = "none" },
          NonText = { bg = "none" },
          LineNr = { bg = "none" },
          CursorLineNr = { bg = "none" },
          -- Add more groups as needed
        },
      },
    },
  },

  -- Vibrant Colorschemes
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
  { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },


  -- No Neck Pain (Centered buffer - Zen mode)
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    opts = {
      width = 120,                    -- ← Change this to your liking (recommended: 100–130)
      min_side_buffer_width = 10,
      disable_on_split = true,        -- automatically disable when you split windows
      autocmd = {
        enable_on_vim_enter = false,  -- set to `true` if you want it always enabled on startup
      },
    },
    keys = {
      { "<Leader>zn", "<cmd>NoNeckPain<CR>", desc = "Toggle No Neck Pain" },
    },
  },

  -- Aerial configuration fix
  {
    "stevearc/aerial.nvim",
    opts = {
      -- Disable treesitter backend as it is causing "method nil" errors in Neovim 0.12+
      -- Aerial will fall back to LSP, which is more reliable for Rust anyway.
      backends = { "lsp", "man" },
    },
  },
}
