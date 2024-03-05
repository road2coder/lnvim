local M = {}

-- 获取 visual 模式选中的文本（非 normal 为上次选中）
function M.get_selection()
  local a_orig = vim.fn.getreg("a")
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" then
    -- vim.cmd([[normal! gv]])
    return ""
  end
  vim.cmd([[silent! normal! "aygv]])
  local text = vim.fn.getreg("a")
  vim.fn.setreg("a", a_orig)
  return text
end

-- 转换字符串的形式
function M.convert_case(str, case)
  -- 可转换的模式
  local separators = {
    kebab = "-",
    camel = "",
    pascal = "",
    snake = "_",
  }
  local sep = separators[case]
  if not sep then
    return nil
  end

  -- pascal case 处理
  if string.find(str, "[a-z]") ~= nil then
    str = str:gsub("%u", " %0"):gsub("^%s*(.-)%s*$", "%1")
  end

  local words = {}
  for word in str:gmatch("%a+") do
    table.insert(words, word)
  end

  local result = ""
  for i, word in ipairs(words) do
    -- kebab 或 snake: 将单词全部小写
    if case == "kebab" or case == "snake" then
      word = word:lower()
    -- camel 或 pascal: 将单词首字母大写，其余小写
    elseif case == "camel" or case == "pascal" then
      word = word:sub(1, 1):upper() .. word:sub(2):lower()
    end
    -- camel 且单词是第一个: 将单词首字母小写
    if case == "camel" and i == 1 then
      word = word:sub(1, 1):lower() .. word:sub(2)
    end
    result = result .. word
    if i < #words then
      result = result .. sep
    end
  end

  return result
end

-- 替换选中的内容
function M.replace_selection(case)
  local str = M.get_selection()
  if not str then
    return nil
  end
  local to_replace = M.convert_case(str, case)
  vim.api.nvim_feedkeys("c" .. to_replace, "n", true)
  -- local len = #to_replace - 1
  -- local key = vim.api.nvim_replace_termcodes('<esc>'..len.."hv"..len.."l", true, false, true)
  local key = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(key, "n", true)
end

function M.copy_selection(case)
  local str = M.get_selection()
  if not str then
    return nil
  end
  local to_copy = M.convert_case(str, case)
  vim.fn.setreg("*", to_copy)
  vim.api.nvim_input("<esc>")
end

function M.basename(path)
  if path == nil or path == "" then
    return ""
  end
  local sep1 = "\\"
  local sep2 = "/"
  local pos1 = path:reverse():find(sep1)
  local pos2 = path:reverse():find(sep2)
  if pos1 == nil and pos2 == nil then
    return path
  end
  local pos = pos1 or pos2
  if pos1 ~= nil and pos2 ~= nil then
    pos = math.min(pos1, pos2)
  end
  local filename = path:sub(-pos + 1)
  return filename
end

function M.get_selection_pos()
  local unpack = table.unpack or unpack
  local m = vim.fn.mode()
  if m ~= "v" and m ~= "V" then
    return nil
  end
  local start = vim.fn.getpos("v")
  local line1, col1 = unpack(start, 2, 3)
  local pos1 = { row = line1, col = col1 }
  local cur = vim.fn.getpos(".")
  local line2, col2 = unpack(cur, 2, 3)
  local pos2 = { row = line2, col = col2 }
  local res = line2 > line1 and { pos1, pos2 } or { pos2, pos1 }
  if m == "V" then
    res[1].col = 0
    res[2].col = vim.fn.col("$") - 1
  end
  return res
end

-- 简单的柯里化函数
function M.curry(fn, ...)
  local args = {}
  local n1 = select("#", ...)
  for i = 1, n1 do
    table.insert(args, (select(i, ...)))
  end
  return function(...)
    local n2 = select("#", ...)
    local unpack = unpack or table.unpack
    for i = 1, n2 do
      table.insert(args, (select(i, ...)))
    end
    fn(unpack(args))
  end
end

function M.switch_ime_en()
  local has = vim.fn.has
  if has("win32") == 1 or has("wsl") == 1 then
    vim.fn.system({ "im-select.exe", "1033" })
  elseif vim.fn.has("linux") == 1 then
    vim.fn.system({ "fcitx5-remote", "-s", "keyboard-us" })
  end
end

function M.switch_ime_cn()
  local has = vim.fn.has
  if has("win32") == 1 or has("wsl") == 1 then
    vim.fn.system({ "im-select.exe", "2052" })
  end
end

return M
