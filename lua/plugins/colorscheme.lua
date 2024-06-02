return {
    {
        "ellisonleao/gruvbox.nvim",
        -- lazy = true,
    },
    {
        "sainnhe/sonokai",
        -- lazy = true,
        opts = {
            sonokai_style = "espresso",
        },
    },
    {
        "sainnhe/gruvbox-material",
    },
    {
        "rebelot/kanagawa.nvim",
        -- lazy = true,
    },
    {
        "loctvl842/monokai-pro.nvim",
        -- lazy = true,
        opts = {
            filter = "spectrum" -- classic | octagon | pro | machine | ristretto | spectrum
        },
    },
    {
        "marko-cerovac/material.nvim",
        -- lazy = true,
        opts = {
            plugins = { -- Uncomment the plugins that you use to highlight them
                -- Available plugins:
                -- "coc"
                -- "dap",
                "dashboard",
                -- "eyeliner",
                -- "fidget",
                -- "flash",
                "gitsigns",
                -- "harpoon",
                -- "hop",
                -- "illuminate",
                "indent-blankline",
                -- "lspsaga",
                "mini",
                -- "neogit",
                -- "neotest",
                "neo-tree",
                -- "neorg",
                -- "noice",
                "nvim-cmp",
                -- "nvim-navic",
                -- "nvim-tree",
                "nvim-web-devicons",
                -- "rainbow-delimiters",
                -- "sneak",
                "telescope",
                "trouble",
                "which-key",
                -- "nvim-notify",
            },

            lualine_style = "stealth",
        }
    },
    {
        "ramojus/mellifluous.nvim",
        -- lazy = true,
        -- Available 'mellifluous', 'alduin', 'mountain', 'tender', 'kanagawa_dragon'
        opts = { color_set = "alduin" },
    },

    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox-material",
        },
    }
}
