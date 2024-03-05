return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "html",
        "vue",
        "javascript",
        "tsx",
        "typescript",
        "css",
        "scss",
        "bash",
        "c",
        "diff",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "python",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      lsp_fallback = true,
      ensure_installed = {
        -- lsp
        "lua-language-server",
        -- "typescript-language-server",
        "vue-language-server",
        "html-lsp",
        "css-lsp",
        -- formatter
        "prettierd",
        "stylua", -- lua
        "shfmt", -- sh
        -- linter
        "eslint_d",
      },
    },
  },
  {
    "folke/flash.nvim",
    vscode = true,
    keys = {
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
      {
        ",s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        ",,",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- volar 开启 take over 模式
        volar = {
          filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "json",
          },
        },
      },
    },
  },
}
