return {
  -- M: 一个 buffer 时也显示 bufferline
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
  -- M: 修改 neo-tree 快揵键
  {
    "nvim-neo-tree/neo-tree.nvim",
    init = function()
      vim.g.neo_tree_remove_legacy_commands = true
    end,
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
      {
        "<leader>o",
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd("p")
          else
            vim.cmd.Neotree("focus")
          end
        end,
        desc = "Toggle Explorer Focus",
      },
    },
    opts = {
      auto_clean_after_session_restore = true,
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        content_tayout = "center",
      },
      commands = {
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
      },
      window = {
        width = 35,
        -- 放到右侧会和 nvim-notify 冲突
        -- position = "right",
        mappings = {
          ["space"] = false,
          ["<C-h>"] = "prev_source",
          ["<C-l>"] = "next_source",
          l = "open",
          h = "parent_or_close",
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = vim.fn.has("win32") ~= 1,
      },
    },
  },
  -- A: 顶部文件路径、symbols 等
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = {
      "SmiteshP/nvim-navic",
    },
    config = true,
  },
  -- M: 更改缩进线样式，关闭动画
  {
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "╎",
      draw = {
        delay = 10,
        animation = require("mini.indentscope").gen_animation.none(),
      },
    },
  },
  -- M: lualine 增加文件换行符
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "fileformat")
    end,
  },
}
