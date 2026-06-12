
-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.rust",
    opts = {mason = false},
  },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  -- { import = "astrocommunity.colorscheme.everforest" },
  -- import/override with your plugins folder
}
