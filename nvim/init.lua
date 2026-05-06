-- Set leader before loading anything (lazy.nvim depends on this)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy")
