vim.cmd('color gruvbox')

local lspconfig = require('lspconfig')

local function on_attach(_, buffer)
  vim.api.nvim_buf_set_keymap(buffer, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>',
    { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buffer, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>',
    { noremap = true, silent = true })
end
lspconfig.pyright.setup {
  on_attach = on_attach,
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  --root_dir = function(filename)
    --return util.root_pattern(unpack(root_files))(filename) or util.path.dirname(filename),
  --end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
  --settings = {
  --python = {
  --analysis = {
  --typeCheckingMode = "basic" -- Adjust as needed ("off", "basic", "strict")
  --}
  --}
  --}
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
          args = { "-t", "py311", "--line-length", "130", "-" },
          stdin = true
        }
      end
    }
  }
})

vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Format<CR>', { noremap = true, silent = true })

--local null_ls = require("null-ls")

--null_ls.setup({
--sources = {
--null_ls.builtins.diagnostics.flake8.with({
---- Specify `flake8` options here
--extra_args = { "--max-line-length=10", "--ignore=E501,E203,W503" },
--}),
--},
--})


vim.keymap.set('n', '<leader>t', function()
  vim.cmd('w')
  local file = vim.api.nvim_buf_get_name(0)

  local buf = vim.api.nvim_create_buf(false, true)
  local w = math.floor(vim.o.columns * 0.8)
  local h = math.floor(vim.o.lines * 0.6)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = math.floor((vim.o.lines - h) / 2 - 1),
    col = math.floor((vim.o.columns - w) / 2),
    width = w, height = h,
    style = 'minimal',
    border = 'rounded',
    title = ' terminal: python ' .. vim.fn.fnamemodify(file, ':t') .. ' ',
    title_pos = 'center',
  })

  vim.fn.termopen({ 'python', file })
  vim.cmd('startinsert')

  -- Esc to normal; q to close
  vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { buffer = buf, silent = true })
  vim.keymap.set('n', 'q', function() pcall(vim.api.nvim_win_close, win, true) end,
    { buffer = buf, silent = true })
end, { desc = 'Run current file (float terminal)' })

local dap = require('dap')
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return 'python'
    end,
  },
}
dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

require("nvim-dap-virtual-text").setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    clear_on_continue = false,
    display_callback = function(variable, buf, stackframe, node, options)
      if options.virt_text_pos == 'inline' then
        return ' = ' .. variable.value
      else
        return variable.name .. ' = ' .. variable.value
      end
    end,
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil,
}
require("dapui").setup()
vim.cmd[[hi Normal guibg=NONE ctermbg=NONE]]
