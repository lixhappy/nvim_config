return {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = "BufReadPre",
    keys = {
        { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" }
    },
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            }
        },
        ensure_installed = {
            -- lua
            "luals",
            -- C++
            "clangd",
            -- Cmake
            "neocmake",
            "cmakelang",
            "cmakelint",
            -- Docker
            "hadolint",
            -- Go
            "goimports",
            "gofumpt",
            "gomodifytags",
            "impl",
            "delve",
            -- Markdown
            "markdownlint",
            "marksman",
            -- Rust
            "codelldb",
        },
    },
}
