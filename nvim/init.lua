--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================mason-lsp

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/

  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html

--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
require("option-config")
require("lua-util")
require("keymap-config")
require("lazy-config")
require("lualine-config")
require("treesitter-config")
require("mason-config")
require("nvim-cmp-config")
require("autocommand-config")
require("which-key-config")
require("telescope-config")

-- Setup neovim lua configuration
require('neodev').setup()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
