local utils = require "utils"

vim.api.nvim_create_user_command("Opam", utils.opam, {})
