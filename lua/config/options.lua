-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- line number
vim.opt.relativenumber = true
vim.opt.number = true

-- tabs & indentation
vim.opt.tabstop = 4        -- 4 space for tabs
vim.opt.shiftwidth = 4     -- 4 space for tabs (read docs for explaination)
vim.opt.smarttab = true    -- del 4 space
vim.opt.expandtab = true   -- replace tab to space
vim.opt.smartindent = true -- auto indent in new line

-- line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- appearance
-- vim.opt.termguicolors = true
-- vim.opt.background = "dark"

-- backspace
vim.opt.backspace = "indent,eol,start"

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- spelling
-- vim.opt.spell = true
-- vim.opt.spelllang { "en_us", "ru" }

-- redundancy
vim.opt.undofile = true -- keep undo history beetween sessions
