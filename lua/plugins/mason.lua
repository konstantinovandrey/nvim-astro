return {
  -- auto-install LSP servers, formatters, debuggers via Mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "pyright",              -- Python
        "clangd",               -- C / C++
        "gopls",                -- Go
        "rust-analyzer",        -- Rust
        "lua-language-server",  -- Lua
        "vtsls",                -- TypeScript / JavaScript
        "jdtls",                -- Java
        "bash-language-server", -- Bash
        "ruby-lsp",             -- Ruby
        -- formatters
        "stylua",
        "tree-sitter-cli",
      },
    },
  },

  -- LSP keymaps for ALL servers at once
  {
    "AstroNvim/astrolsp",
    opts = {
    },
  },
}
