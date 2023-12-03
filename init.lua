vim.cmd('color happy_hacking')

require 'lspconfig'.pyright.setup {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic" -- Adjust as needed ("off", "basic", "strict")
      }
    }
  }
}

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
      extra_args = { "--max-line-length=100", "--ignore=E203,W503" },
    }),
  },
})

vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>!python %<CR>', { noremap = true, silent = true })
