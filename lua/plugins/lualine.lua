return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",

    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- set an empty statusline till lualine loads
            vim.o.statusline = " "
        else
            -- hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,

    opts = function()
        local icons = require("lazyvim.config").icons
        vim.o.laststatus = vim.g.lualine_laststatus

        return {
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = {
                    statusline = { "alpha" },
                },
            },
            sections = {
                -- +-------------------------------------------------+
                -- | A | B | C                             X | Y | Z |
                -- +-------------------------------------------------+

                lualine_a = { "mode" },
                lualine_b = { "branch" },

                lualine_c = {
                    LazyVim.lualine.root_dir(),
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.diagnostics.Error,
                            warn = icons.diagnostics.Warn,
                            info = icons.diagnostics.Info,
                            hint = icons.diagnostics.Hint,
                        },
                    },
                    { "filetype",                   icon_only = false, separator = "", padding = { left = 1, right = 0 } },
                    { LazyVim.lualine.pretty_path() },
                },
                lualine_x = {
                    -- {
                    --     function()
                    --         return require("noice").api.status.command.get()
                    --     end,
                    --     cond = function()
                    --         return package.loaded["noice"] and require("noice").api.status.command.has()
                    --     end,
                    --     color = LazyVim.ui.fg("Statement"),
                    -- },

                    -- { LazyVim.lualine.cmp_source("codeium") },

                    --
                    -- {
                    --     function()
                    --         return require("noice").api.status.mode.get()
                    --     end,
                    --     cond = function()
                    --         return package.loaded["noice"] and require("noice").api.status.mode.has()
                    --     end,
                    --     color = LazyVim.ui.fg("Constant"),
                    -- },
                    --
                    -- {
                    --     function()
                    --         return " " .. require("dap").status()
                    --     end,
                    --     cond = function()
                    --         return package.loaded["dap"] and require("dap").status() ~= ""
                    --     end,
                    --     color = LazyVim.ui.fg("Debug"),
                    -- },

                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = LazyVim.ui.fg("Special"),
                    },
                },
                lualine_y = {
                    { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
                    { "location", padding = { left = 0, right = 1 } },
                },
                lualine_z = {
                    function()
                        return " " .. os.date("%R")
                    end,
                },
            },
            extensions = { "neo-tree", "lazy" },
        }
    end,
}
