return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false,
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = vim.fn.executable("make") == 1 and "make"
                or
                "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            enabled = vim.fn.executable("make") == 1 or vim.fn.executable("cmake") == 1,
            config = function()
                LazyVim.on_load("telescope.nvim", function()
                    require("telescope").load_extension("fzf")
                end)
            end,
        },
        keys = {},
        opts = function()
            local actions = require("telescope.actions")

            local open_with_trouble = function(...)
                return require("trouble.providers.telescope").open_with_trouble(...)
            end

            local open_selected_with_touble = function(...)
                return require("trouble.providers.telescope").open_selected_with_touble(...)
            end

            local find_files_no_ignore = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                LazyVim.telescope("find_files", { no_ignore = true, default_text = line })()
            end

            local find_files_with_hidden = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                LazyVim.telescope("find_files", { hidden = true, default_text = line })()
            end

            return {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",

                    -- open files in the first window that is an actual file.
                    -- use the current window if no other window is availbale.
                    get_selection_window = function()
                        local wins = vim.api.nvim_list_wins()
                        table.insert(wins, 1, vim.api.nvim_get_current_win())
                        for _, win in ipairs(wins) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].buftype == "" then
                                return win
                            end
                        end
                        return 0
                    end,

                    mappings = {
                        --  TODO:
                        i = {},
                        n = {},
                    },
                }
            }
        end
    }
}
