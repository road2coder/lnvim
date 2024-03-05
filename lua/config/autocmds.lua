local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local utils = require("utils")

local ime_grp = augroup("input_method", { clear = true })

-- 不知道为什么 VimLeave 事件没触发，直接调用
utils.switch_ime_en()

-- 进入 nvim、离开 insert 模式时，自动切换至英文输入法
autocmd("InsertLeave", {
  group = ime_grp,
  callback = utils.switch_ime_en,
})

-- windows系统下，进入 insert 模式自动切换到中文输入法
autocmd({ "InsertEnter", "VimLeave" }, {
  group = ime_grp,
  callback = utils.switch_ime_cn,
})

autocmd({ "BufEnter" }, {
  group = augroup("change_title", { clear = true }),
  callback = function()
    local str = vim.api.nvim_buf_get_name(0)
    local basename = utils.basename(str)
    vim.opt.titlestring = basename
  end,
})
