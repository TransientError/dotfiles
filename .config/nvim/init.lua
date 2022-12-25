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

  map.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
  map.set("", "<leader>wh", ":wincmd h<CR>", { noremap = true })
  map.set("", "<leader>wj", ":wincmd j<CR>", { noremap = true })
  map.set("", "<leader>wk", ":wincmd k<CR>", { noremap = true })
  map.set("", "<leader>wl", ":wincmd l<CR>", { noremap = true })
  map.set("", "<leader>wH", ":wincmd H<CR>", { noremap = true })
  map.set("", "<leader>wJ", ":wincmd J<CR>", { noremap = true })
  map.set("", "<leader>wK", ":wincmd K<CR>", { noremap = true })
  map.set("", "<leader>wL", ":wincmd L<CR>", { noremap = true })
  map.set("", "<leader>ws", ":wincmd s<CR>", { noremap = true })
  map.set("", "<leader>wv", ":wincmd v<CR>", { noremap = true })
  map.set("", "<leader>wd", ":close<CR>", { noremap = true })
  map.set("", "<leader>w=", ":wincmd =<CR>", { noremap = true })
  map.set("", "<leader>wmm", ":wincmd _<CR>", { noremap = true })
  map.set("", "<leader>qq", ":qa!<CR>", { noremap = true })
  map.set("", "<leader>bl", "<C-o>", { noremap = true })
  map.set("", "<leader>hrr", ":source % | PackerCompile<CR>", { noremap = true })
  map.set("", "<leader>hri", ":source % | PackerInstall<CR>", { noremap = true })
  map.set("", "<leader>hrs", ":source % | PackerSync<CR>", { noremap = true })
  map.set("n", "<Esc><Esc>", ":noh<CR>", { noremap = true })
  map.set("i", "<C-v>", '"+p')

  map.set("", "<leader>fp", ":cd ~/.config/nvim<CR>:e ~/.config/nvim/init.lua<CR>", { noremap = true })

  vim.api.nvim_create_autocmd("VimResized", { pattern = "*", command = "wincmd =" })
end
