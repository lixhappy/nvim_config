return {
    "folke/lazy.nvim",
    {
        "LazyVim/LazyVim",
        version = "12.0.0",
    },

    -- { "folke/neodev.nvim", opts = {} },
    { "folke/neoconf.nvim",    cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
    { "nvim-lua/plenary.nvim", lazy = true },

    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        config = true,
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
        },
    },

    {
        "b0o/SchemaStore.nvim",
        lazy = true,
        version = false,
    },

    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        opts = {},
    },

    {
        "Eandrju/cellular-automaton.nvim",
        event = "VeryLazy",
        cmd = "CellularAutomaton",
    },

    {
        "rktjmp/playtime.nvim",
        event = "VeryLazy",
        cmd = "Playtime",
    }
}
