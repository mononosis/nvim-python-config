require'lspconfig'.pyright.setup{
    on_attach = function(client, bufnr)
        -- Key mappings and other configuration that should only be set
        -- after the language server attaches to the current buffer
    end,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "strict"  -- Adjust as needed ("off", "basic", "strict")
            }
        }
    }
}

