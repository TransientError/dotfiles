vim.g.mapleader = " "
require "plugins"
local utils = require "utils"

local g = vim.g
local opt = vim.opt
local fn = vim.fn
local cmd = vim.cmd
local map = vim.keymap

utils.process_settings {
  opt = {
    expandtab = true,
    smartcase = true,
    ignorecase = true,
    shiftwidth = 2,
  },
}

if g.vscode then
  require "vscode"
else
  if g.neovide then
    if vim.fn.hostname() == "apollo" then
      opt.guifont = "Liga Hack:h8"
    else
      opt.guifont = "Liga Hack:h12"
    end
  end
  utils.process_settings {
    opt = {
      number = true,
      relativenumber = true,
      listchars = { tab = "▸▸", trail = "·" },
      colorcolumn = "120",
      tabstop = 4,
    },
  }

  map.set("t", "<Esc>", "<C-\\><C-n>")
  map.set("", "<leader>wh", ":wincmd h<CR>")
  map.set("", "<leader>wj", ":wincmd j<CR>")
  map.set("", "<leader>wk", ":wincmd k<CR>")
  map.set("", "<leader>wl", ":wincmd l<CR>")
  map.set("", "<leader>ws", ":wincmd s<CR>")
  map.set("", "<leader>wv", ":wincmd v<CR>")
  map.set("", "<leader>wd", ":q<CR>")
  map.set("", "<leader>w=", ":wincmd =<CR>")
  map.set("", "<leader>qq", ":qa!<CR>")
  map.set("", "<leader>ot", ":split term://fish<CR>")
  map.set("", "<leader>bl", "<C-o>")
  map.set("", "<leader>hrr", ":source % | PackerCompile<CR>")
  map.set("", "<leader>hri", ":source % | PackerInstall<CR>")
  map.set("", "<leader>hrs", ":source % | PackerSync<CR>")

  map.set("", "<leader>fp", ":cd ~/.config/nvim<CR>:e ~/.config/nvim/init.lua<CR>")

  vim.api.nvim_create_autocmd("VimResized", { pattern = "*", command = "wincmd =" })
end
