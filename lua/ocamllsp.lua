local log = require('vim.lsp.log')
local util = require("vim.lsp.util")

local M = {}

local function switchHandler(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')
    return nil
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local location = {}
  location.uri = result[1]
  util.show_document(location, client.offset_encoding)
end

function M.switchImplIntf ()
  vim.lsp.buf_request(
    0, "ocamllsp/switchImplIntf",
    { vim.uri_from_bufnr(0) },
    switchHandler
  )
end

function M.hoverExtended ()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(
    0, "ocamllsp/hoverExtended",
    params, function (_, res, ctx, config)
      ctx["method"] = nil
      config = config or {}
      return vim.lsp.handlers["textDocument/hover"](_, res, ctx, config)
    end
  )
end

return M
