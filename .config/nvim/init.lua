vim.g.mapleader = " "
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

vim.filetype.add {
  extension = {
    j2 = "htmldjango",
  },
}

if g.vscode then
  require "vscode"
else
  if g.neovide then
    if vim.fn.hostname() == "apollo" then
      opt.guifont = "LigaHack Nerd Font:h8"
    else
      opt.guifont = "LigaHack Nerd Font:h12"
    end

    map.set("", "<leader>qr", ":!pkill neovide; neovide<CR>", { noremap = true })
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
  map.set("n", "<Esc><Esc>", ":noh<CR>", { noremap = true })
  map.set("", "<leader>l", ":Lazy<CR>", { noremap = true})
  map.set("", "<leader>m", ":Mason<CR>", { noremap = true})

  map.set("", "<leader>fp", ":cd ~/.config/nvim<CR>:e ~/.config/nvim/init.lua<CR>", { noremap = true })

  vim.api.nvim_create_autocmd("VimResized", { pattern = "*", command = "wincmd =" })

  local uname = vim.fn.system("uname -a")
  if string.find(uname, "WSL") then
    vim.g.clipboard = {
      name = 'win32yank',
      copy = {
        ['+'] = 'win32yank.exe -i --crlf',
        ['*'] = 'win32yank.exe -i --crlf'
      },
      paste = {
        ['+'] = 'win32yank.exe -o --lf',
        ['*'] = 'win32yank.exe -o --lf'
      },
      cache_enabled = 0
    }
  end
end

require "config.lazy"
