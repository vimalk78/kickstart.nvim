-- Fill required constructor/function arguments as LuaSnip tab-stops.
--
-- With the cursor between the empty parens of `Foo()`, asks the LSP for
-- signature help (pyright resolves dataclass fields via the generated
-- __init__) and expands `Foo(x=${1:x}, y=${2:y})`. Parameters with defaults
-- are skipped; self/cls and *args/**kwargs are ignored.

local M = {}

-- Turn one signature parameter into a name, or nil if it should be skipped.
local function param_name(sig_label, param)
  local label = param.label
  if type(label) == 'table' then
    label = sig_label:sub(label[1] + 1, label[2])
  end
  if label:find('=', 1, true) then return nil end -- has a default
  local name = label:match('^%s*([%a_][%w_]*)')
  if not name or name == 'self' or name == 'cls' then return nil end
  return name
end

local function build_body(sig)
  local parts = {}
  for _, p in ipairs(sig.parameters or {}) do
    local name = param_name(sig.label, p)
    if name then
      table.insert(parts, string.format('%s=${%d:%s}', name, #parts + 1, name))
    end
  end
  return table.concat(parts, ', ')
end

function M.fill()
  local ls = require('luasnip')
  local win, buf = 0, 0
  local cursor = vim.api.nvim_win_get_cursor(win)
  local clients = vim.lsp.get_clients({ bufnr = buf, method = 'textDocument/signatureHelp' })
  if #clients == 0 then
    vim.notify('fill_args: no LSP with signature help attached', vim.log.levels.WARN)
    return
  end

  local params = vim.lsp.util.make_position_params(win, clients[1].offset_encoding)
  vim.lsp.buf_request(buf, 'textDocument/signatureHelp', params, function(err, result)
    if err or not result or not result.signatures or #result.signatures == 0 then
      vim.notify('fill_args: no signature help here', vim.log.levels.INFO)
      return
    end

    -- Bail if the user moved while the request was in flight.
    local now = vim.api.nvim_win_get_cursor(win)
    if now[1] ~= cursor[1] or now[2] ~= cursor[2] then return end

    -- Only fill an empty call: `(|)`.
    local line = vim.api.nvim_get_current_line()
    local before, after = line:sub(1, now[2]), line:sub(now[2] + 1)
    if not before:match('%($') or not after:match('^%)') then return end

    local sig = result.signatures[(result.activeSignature or 0) + 1]
    local body = build_body(sig)
    if body == '' then return end

    ls.snip_expand(ls.parser.parse_snippet('', body))
  end)
end

return M
