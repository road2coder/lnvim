return {
  -- A: 更好的折叠效果
  {
    "kevinhwang91/nvim-ufo",
    event = { "VeryLazy" },
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      -- 一些必要的设置
      vim.opt.foldcolumn = '1'
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open All Folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close All Folds" })

      -- 显示折叠的总行数
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, {suffix, 'MoreMsg'})
        return newVirtText
      end
      require("ufo").setup({
        -- 使用 treesitter 和 缩进 进行折叠
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
        close_fold_kinds = {'imports', 'comment'},
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
  -- {
  --   "mfussenegger/nvim-lint",
  --   opts = {
  --     events = {
  --       "BufWritePost",
  --       "BufReadPost",
  --       "InsertLeave",
  --       "TextChanged",
  --     },
  --     linters_by_ft = {
  --       javascript = { "eslint_d" },
  --       javascriptreact = { "eslint_d" },
  --       typescript = { "eslint_d" },
  --       typescriptreact = { "eslint_d" },
  --       vue = { "eslint_d" },
  --       html = { "eslint_d" },
  --     },
  --   },
  -- },
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
