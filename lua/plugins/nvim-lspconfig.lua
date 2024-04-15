-- if true then return {} end

return {
    "neovim/nvim-lspconfig",
    -- event = "LazyFile",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
        { "folke/neodev.nvim",  opts = {} },
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },

    ---@class PluginLspOpts
    opts = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.opts
        diagnostics = {

            underline = true,

            update_in_insert = false,

            virtual_text = {
                spacing = 4,
                source = "if_many",

                -- prefix = "●",
                -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                prefix = "icons",
            },

            severity_sort = true,

            signs = {
                text = function()
                    local icons = require("lazyvim.config").icons
                    return {
                        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
                        [vim.diagnostic.severity.WARN]  = icons.diagnostics.Warn,
                        [vim.diagnostic.severity.HINT]  = icons.diagnostics.Hint,
                        [vim.diagnostic.severity.INFO]  = icons.diagnostics.Info,
                    }
                end,
            },
        },

        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
            enabled = false,
        },

        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
            enabled = false,
        },

        -- add any global capabilities here
        capabilities = {},

        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
            formatting_options = nil,
            timeout_ms = nil,
        },

        -- LSP Server Settings
        --@type lspconfig.options
        servers = {
            lua_ls = {
                -- mason = false, -- set to false if you don't want this server to be installed with mason

                -- Use this to add any additional keymaps
                -- for specific lsp servers
                -- @type LazyKeySpec[]
                -- keys= {},

                settings = {
                    Lua = {
                        workspace = {
                            checkThirdParty = false,
                        },
                        codeLens = {
                            enable = true,
                        },
                        completion = {
                            callSnippet = "Replace",
                        },
                    },
                },
            },

            clangd = {
                root_dir = function(fname)
                    return require("lspconfig.util").root_pattern(
                        "Makefile",
                        "configure.ac",
                        "configure.in",
                        "config.h.in",
                        "meson.build",
                        "meson_options.txt",
                        "build.ninja"
                    )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
                        fname
                    ) or require("lspconfig.util").find_git_ancestor(fname)
                end,
                capabilities = {
                    offsetEncoding = { "utf-16" },
                },
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            },

            gopls = {
                settings = {
                    gopls = {
                        gofumpt = true,
                        codelenses = {
                            gc_details = false,
                            generate = true,
                            regenerate_cgo = true,
                            run_govulncheck = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true,
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        analyses = {
                            fieldalignment = true,
                            nilness = true,
                            unusedparams = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        usePlaceholders = true,
                        completeUnimported = true,
                        staticcheck = true,
                        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                        semanticTokens = true,
                    },
                },
            },

            jsonls = {
                -- lazy-load schemastore when needed
                on_new_config = function(new_config)
                    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
                end,
                settings = {
                    json = {
                        format = {
                            enable = true,
                        },
                        validate = { enable = true },
                    },
                },
            },

            rust_analyzer = {},
            taplo = {
                keys = {
                    {
                        "K",
                        function()
                            if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                                require("crates").show_popup()
                            else
                                vim.lsp.buf.hover()
                            end
                        end,
                        desc = "Show Crate Documentation",
                    },
                },
            },

            neocmake = {},
            dockerls = {},
            docker_compose_language_service = {},
            marksman = {},
        },

        -- you can do any additional lsp server setup here
        -- return true if your don't want this server to be setup with lspconfig
        --@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
            -- example to setyp with typescript.nvim
            -- ```lua
            -- tsserver = function(_, opts)
            --  require("typescript").setup({ server = opts })
            --  return true
            -- end,
            -- ```
            -- Specify * to use this function as a fallback for any server
            -- ["*"] = funciton(server, opts) end,

            clangd = function(_, opts)
                local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
                require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
                return false
            end,

            gopls = function(_, opts)
                -- workaround for gopls not supporting semanticTokensProvider
                -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
                LazyVim.lsp.on_attach(function(client, _)
                    if client.name == "gopls" then
                        if not client.server_capabilities.semanticTokensProvider then
                            local semantic = client.config.capabilities.textDocument.semanticTokens
                            client.server_capabilities.semanticTokensProvider = {
                                full = true,
                                legend = {
                                    tokenTypes = semantic.tokenTypes,
                                    tokenModifiers = semantic.tokenModifiers,
                                },
                                range = true,
                            }
                        end
                    end
                end)
                -- end workaround
            end,

            rust_analyzer = function()
                return true
            end,
        },
    },

    ---@param opts PluginLspOpts
    config = function(_, opts)
        if LazyVim.has("neoconf.nvim") then
            local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
            require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
        end

        -- setup autoformat
        LazyVim.format.register(LazyVim.lsp.formatter())

        -- setup keymaps
        LazyVim.lsp.on_attach(function(client, buffer)
            require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
        end)

        local register_capability = vim.lsp.handlers["client/registerCapability"]

        vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
            ---@diagnostic disable-next-line: no-unknown
            local ret = register_capability(err, res, ctx)
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            local buffer = vim.api.nvim_get_current_buf()
            require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
            return ret
        end

        -- diagnostics signs
        if vim.fn.has("nvim-0.10.0") == 0 then
            for severity, icon in pairs(opts.diagnostics.signs.text()) do
                local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end
        end

        -- inlay hints
        if opts.inlay_hints.enabled then
            LazyVim.lsp.on_attach(function(client, buffer)
                if client.supports_method("textDocument/inlayHint") then
                    LazyVim.toggle.inlay_hints(buffer, true)
                end
            end)
        end

        -- code lens
        if opts.codelens.enabled and vim.lsp.codelens then
            LazyVim.lsp.on_attach(function(client, buffer)
                if client.support_method("textDocument/codeLens") then
                    vim.lsp.codelens.refresh()
                    --- autocmd BufEnter, CursorHold, InsertLeave <buffer> lua vim.lsp.codelens.refresh()
                    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = buffer,
                        callback = vim.lsp.codelens.refresh,
                    })
                end
            end)
        end

        if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
            opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
                or function(diagnostic)
                    local icons = require("lazyvim.config").icons.diagnostics
                    for d, icon in pairs(icons) do
                        if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                            return icon
                        end
                    end
                end
        end

        vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

        local servers = opts.servers
        local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            has_cmp and cmp_nvim_lsp.default_capabilities() or {},
            opts.capabilities or {}
        )

        local function setup(server)
            local server_opts = vim.tbl_deep_extend("force", {
                capabilities = vim.deepcopy(capabilities),
            }, servers[server] or {})

            if opts.setup[server] then
                if opts.setup[server](server, server_opts) then
                    return
                end
            elseif opts.setup["*"] then
                if opts.setup["*"](server, server_opts) then
                    return
                end
            end
            require("lspconfig")[server].setup(server_opts)
        end

        -- get all the servers that are available through mason-lspconfig
        local have_mason, mlsp = pcall(require, "mason-lspconfig")
        local all_mslp_servers = {}
        if have_mason then
            all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
        end

        local ensure_installed = {} ---@type string[]
        for server, server_opts in pairs(servers) do
            if server_opts then
                server_opts = server_opts == true and {} or server_opts
                -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                    setup(server)
                elseif server_opts.enabled ~= false then
                    ensure_installed[#ensure_installed + 1] = server
                end
            end
        end

        if have_mason then
            mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
        end

        if LazyVim.lsp.get_config("denols") and LazyVim.lsp.get_config("tsserver") then
            local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
            LazyVim.lsp.disable("tsserver", is_deno)
            LazyVim.lsp.disable("denols", function(root_dir)
                return not is_deno(root_dir)
            end)
        end
    end,
}
