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
  -- {
  --   "AstroNvim/astroui",
  --   ---@type AstroUIOpts
  --   opts = {
  --     highlights = {
  --       init = { -- applies to all colorschemes
  --         Normal = { bg = "none" },
  --         NormalNC = { bg = "none" },
  --         NormalFloat = { bg = "none" },
  --         FloatBorder = { bg = "none" },
  --         SignColumn = { bg = "none" },
  --         FoldColumn = { bg = "none" },
  --         WinBar = { bg = "none" },
  --         WinBarNC = { bg = "none" },
  --         WinSeparator = { bg = "none" },
  --         StatusLine = { bg = "none" },
  --         StatusLineNC = { bg = "none" },
  --         TabLine = { bg = "none" },
  --         TabLineFill = { bg = "none" },
  --         TabLineSel = { bg = "none" },
  --         NeoTreeNormal = { bg = "none" },
  --         NeoTreeNormalNC = { bg = "none" },
  --         Pmenu = { bg = "none" },
  --         TelescopeNormal = { bg = "none" },
  --         -- Add more groups as needed
  --       },
  --     },
  --   },
  -- },

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
}
