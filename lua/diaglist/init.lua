local M = {
  debug = false,
  buf_clients_only = true,
  debounce_ms = 150,
  auto_open = true
}

local q = require('diaglist.quickfix')
local l = require('diaglist.loclist')

function M.init(opts)
  vim.api.nvim_command [[aug diagnostics]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au DiagnosticChanged * lua require("diaglist").diagnostics_hook(true)]]
  vim.api.nvim_command [[au WinEnter * lua require("diaglist").diagnostics_hook(false)]]
  vim.api.nvim_command [[au BufEnter * lua require("diaglist").diagnostics_hook(false)]]
  vim.api.nvim_command [[aug END]]

  if opts == nil then
    opts = {}
  end

  if opts['debug'] ~= nil then
    M.debug = opts['debug']
  end

  q.debug = M.debug
  l.debug = M.debug

  if opts['debounce_ms'] ~= nil then
    M.debounce_ms = opts['debounce_ms']
  end

  q.debounce_ms = M.debounce_ms
  if M.debug then
    print(q.debounce_ms)
  end

  if opts['buf_clients_only'] ~= nil then
    M.buf_clients_only = opts['buf_clients_only']
  end

  q.buf_clients_only = M.buf_clients_only

  q.init()
end

function M.open_buffer_diagnostics()
  l.open_buffer_diagnostics()
end

function M.open_all_diagnostics()
  q.open_all_diagnostics()
end

function M.diagnostics_hook(diag_changed)
  if M.debug then
    if diag_changed then
      print("diagnostics changed")
    else
      print("winenter hook")
    end
  end
  if M.auto_open and diag_changed then
      print("open qf list now")
      vim.api.nvim_command("cwindow")
      vim.api.nvim_command("wincmd p")
  end
  l.diagnostics_hook()
  q.diagnostics_hook()
end

return M
