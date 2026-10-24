---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
      },
    },
    mappings = {
      n = {
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        ["<C-k>"] = {
          function()
            local commands = {
              python = "python %",
              cpp = "g++ % -o %:r && %:r",
              c = "gcc % -o %:r && %:r",
              go = "go run %",
              rust = "rustc % -o %:r && %:r",
              lua = "lua %",
              javascript = "node %",
              typescript = "npx ts-node %",
              ruby = "ruby %",
              sh = "bash %",
            }
            local ft = vim.bo.filetype
            local cmd = commands[ft]
            if not cmd then
              vim.notify("No run command for " .. ft, vim.log.levels.WARN)
              return
            end
            cmd = cmd:gsub("%%", vim.fn.expand("%:p"))
            cmd = cmd:gsub("%%:r", vim.fn.expand("%:p:r"))
            vim.cmd("vnew | term " .. cmd)
          end,
          desc = "Run/Compile file",
        },
        -- Molten / Jupyter notebooks
        ["<Leader>mi"] = { ":MoltenInit<CR>", desc = "Molten: init kernel" },
        ["<Leader>ml"] = { ":MoltenEvaluateLine<CR>", desc = "Molten: evaluate line" },
        ["<Leader>mc"] = { ":MoltenReevaluateCell<CR>", desc = "Molten: re-evaluate cell" },
        ["<Leader>md"] = { ":MoltenDelete<CR>", desc = "Molten: delete output" },
        ["<Leader>mo"] = { ":MoltenShowOutput<CR>", desc = "Molten: show output" },
        ["<Leader>mh"] = { ":MoltenHideOutput<CR>", desc = "Molten: hide output" },
        ["<Leader>mr"] = { ":MoltenRestart<CR>", desc = "Molten: restart kernel" },
        ["<Leader>me"] = { ":MoltenEvaluateOperator<CR>", desc = "Molten: evaluate operator" },
      },
      v = {
        ["<Leader>mv"] = { ":<C-u>MoltenEvaluateVisual<CR>gv<ESC>", desc = "Molten: evaluate selection" },
      },
    },
  },
}
