local g = vim.g
local opt = vim.opt

g.autoformat = false
opt.fileformats = "unix,dos"
opt.title = true
opt.titlestring="filename"

if vim.g.vscode then
  opt.timeoutlen = 1000
end

