local map = vim.keymap.set
local utils = require("utils")
local curry = utils.curry

map("n", "gh", vim.lsp.buf.hover, { desc = "Hover" })

-- 转换选中的内容
map("v", "\\1", curry(utils.replace_selection, "kebab"), { desc = "Replace selection(kebab)" })
map("v", "\\2", curry(utils.replace_selection, "camel"), { desc = "Replace selection(camel)" })
map("v", "\\3", curry(utils.replace_selection, "pascal"), { desc = "Replace selection(pascal)" })
map("v", "\\4", curry(utils.replace_selection, "snake"), { desc = "Replace selection(snake)" })

-- 复制选中内容的指定形式到剪切板
map("v", "\\q", curry(utils.copy_selection, "snake"), { desc = "copy(kebab)" })
map("v", "\\w", curry(utils.copy_selection, "camel"), { desc = "copy(camel)" })

map("v", "\\e", curry(utils.copy_selection, "pascal"), { desc = "copy(pascal)" })
map("v", "\\r", curry(utils.copy_selection, "snake"), { desc = "copy(snake)" })

map("v", "p", '"_dP', { desc = "paste multiple times" }) -- 一次复制可粘贴多次

if not vim.g.vscode then
  -- \f 格式化
  map({ "n", "v" }, "\\f", function()
    require("lazyvim.util").format({ force = true })
    local m = vim.fn.mode()
    if m == "v" or m == "v" then
      local key = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
      vim.api.nvim_feedkeys(key, "n", true)
    end
  end, { desc = "Format" })

  -- insert 使用 ctrl + shift + v 可粘贴
  map("!", "<c-s-v>", "<c-r>+", { desc = "paste" })
  map("!", "", "<c-r>+", { desc = "paste" })

  map("n", "\\r", vim.lsp.buf.rename, { desc = "rename" })
else
  local action = require("vscode-neovim").action

  map("n", "\\f", curry(action, "editor.action.formatDocument"))
  map("v", "\\f", curry(action, "editor.action.formatSelection"))
  map("n", "\\r", curry(action, "editor.action.rename"))
  -- workbench.action.previousEditor
  map("n", "H", curry(action, "workbench.action.previousEditorInGroup"))
  map("n", "[b", curry(action, "workbench.action.previousEditorInGroup"))
  map("n", "L", curry(action, "workbench.action.nextEditorInGroup"))
  map("n", "]b", curry(action, "workbench.action.nextEditorInGroup"))
end
