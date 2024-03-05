return {
  -- A: 更好的折叠效果
  {
    "kevinhwang91/nvim-ufo",
    event = { "InsertEnter" },
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities.textDocument.foldingRange = {
      --   dynamicRegistration = false,
      --   lineFoldingOnly = true,
      -- }
      -- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
      -- for _, ls in ipairs(language_servers) do
      --   require("lspconfig")[ls].setup({
      --     capabilities = capabilities,
      --   })
      -- end
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open All Folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close All Folds" })
      require("ufo").setup({
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      })
    end,
  },
  -- M: 格式化相关配置
  {
    "stevearc/conform.nvim",
    opts = {
      lsp_fallback = true,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        vue = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        less = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
      },
    },
  },
  -- M: 代码校验
  {
    "mfussenegger/nvim-lint",
    opts = {
      events = {
        "BufWritePost",
        "BufReadPost",
        "InsertLeave",
        "TextChanged",
      },
      linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
        html = { "eslint_d" },
      },
    },
  },
  -- M: <c-i> 触发补全
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["	"] = cmp.mapping.complete(), -- <c-i>
      })
    end,
  },
  -- M: surround 使用 vim-surround 的习惯
  {
    "echasnovski/mini.surround",
    enable = true,
    opts = {
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        replace = "cs", -- Replace surrounding
      },
    },
  },
  -- M: 使用 \c 在行尾插入注释
  {
    "numToStr/Comment.nvim",
    vscode = true,
    event = "VeryLazy",
    keys = {
      {
        "\\c",
        function()
          local fn = require("Comment.api").locked("insert.linewise.eol")
          fn("line")
        end,
        desc = "Comment insert end of line",
      },
    },
    config = true,
  },
}
