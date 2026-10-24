---@type LazySpec
return {
  -- Open .ipynb as Python with # %% cell markers
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "hydrogen",
      output_extension = "auto",
      force_ft = "python",
      custom_language_formatting = {},
    },
  },

  -- Run cells and show output
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 24
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_auto_open_output = true
      vim.g.molten_output_show_more = true
    end,
  },

  -- Image rendering for plots/figures
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {},
      max_width = 120,
      max_height = 20,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = { ft = { "compiled" }, buftype = { "nvim-popup", "cmp_menu", "cmp_docs", "scrollview", "scrollview_hover", "floating" } },
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_hover" },
    },
  },
}
