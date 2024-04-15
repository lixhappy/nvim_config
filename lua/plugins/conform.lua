if true then return {} end

return {
    "stevearc/conform.nvim",
    dependecies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
        {
            "<leader>cF",
            function()
                require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
            end,
            mode = { "n", "v" },
            desc = "Format Injected Langs",
        },
    },

    opts = {
        formatters_by_ft = {
            go = { "goimports", "gofumpt" },
        },
    },
}
