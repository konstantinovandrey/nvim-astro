return {
  {
    -- Catppuccin Mocha + F4 toggles Nightfly
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = { flavour = "mocha" },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
      local themes = { "catppuccin", "nightfly" }
      local idx = 1
      vim.keymap.set("n", "<F4>", function()
        idx = idx % #themes + 1
        vim.cmd.colorscheme(themes[idx])
        vim.notify("Theme: " .. themes[idx])
      end, { desc = "Cycle themes" })
    end,
  },

  {
    -- Nightfly: dark blue, no pink
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = false,
    priority = 999,
  },

  {
    -- Scala LSP (Metals)
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
  },
}
