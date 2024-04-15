local filetypes = {
    "help",
    "alpha",
    "dashboard",
    "neo-tree",
    "Trouble",
    "trouble",
    "lazy",
    "mason",
    -- "notify",
    "toggleterm",
    "lazyterm",
}

return {
    {
        "echasnovski/mini.bufremove",
        keys = {
            {
                "<leader>bd",
                function()
                    local bd = require("mini.bufremove").delete
                    if vim.bo.modified then
                        local choice = vim.fn.confirm(("Save changes to %q"):format(vim.fn.bufname()),
                            "&Yes\n&No\n&Cancel")
                        if choice == 1 then -- Yes
                            vim.cmd.write()
                            bd(0)
                        elseif choice == 2 then -- No
                            bd(0, true)
                        end
                    else
                        bd(0)
                    end
                end,
                desc = "Delete Buffer",
            },

            -- stylua: ignore
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
        },
    },
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = {
            options = {
                custom_commentstring = function()
                    return vim.bo.commentstring
                end,
            },
        },
    },
    {
        "echasnovski/mini.indentscope",
        version = false,
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },

        dependencies = {
            "lukas-reineke/indent-blankline.nvim",
            event = { "BufReadPost", "BufWritePost", "BufNewFile" },
            opts = {
                indent = {
                    char = "│",
                    tab_char = "│",
                },
                scope = { enabled = false },
                exclude = {
                    filetypes = filetypes,
                },
            },
            main = "ibl",
        },

        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },

        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = filetypes,
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },
}
