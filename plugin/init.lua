vim.cmd('color happy_hacking')

local lspconfig = require('lspconfig')

local function on_attach(_, buffer)
  vim.api.nvim_buf_set_keymap(buffer, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>',
    { noremap = true, silent = true })
end
lspconfig.pyright.setup {
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic" -- Adjust as needed ("off", "basic", "strict")
      }
    }
  }
}

--require 'lspsaga'.setup {
--settings = {
--python = {
--analysis = {
--typeCheckingMode = "basic" -- Adjust as needed ("off", "basic", "strict")
--}
--}
--}
--}

require('formatter').setup({
  filetype = {
    python = {
      -- Black
      function()
        return {
          exe = "black",
          args = { "-t", "py311", "-" },
          stdin = true
        }
      end
    }
  }
})

vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Format<CR>', { noremap = true, silent = true })

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.flake8.with({
      -- Specify `flake8` options here
      extra_args = { "--max-line-length=10", "--ignore=E501,E203,W503" },
    }),
  },
})

vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>!python %<CR>', { noremap = true, silent = true })
