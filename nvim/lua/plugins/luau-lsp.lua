return {
        "lopi-py/luau-lsp.nvim",
        opts = {

                platform = {
                        type = "roblox",
                },
                types = {
                        roblox_security_level = "PluginSecurity",
                },
                sourcemap = {
                        enabled = false,
                },
        },
        dependencies = {
                "nvim-lua/plenary.nvim",
        },
}
