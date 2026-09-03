-- lua/config/vimtex_server.lua
--
-- Ensure Neovim is always listening on an RPC server. VimTeX's inverse search
-- (the `:VimtexInverseSearch` command run by the PDF viewer) reaches this
-- instance by reading `v:servername` into its own `nvim_servernames.log` cache
-- (see `:h vimtex-synctex-inverse-search`).
--
-- The server must exist *before* VimTeX initializes a TeX buffer (VimTeX's
-- buffer init prunes/registers servernames), so we start it at startup rather
-- than on FileType.

if vim.fn.empty(vim.v.servername) == 1 then
  -- Start an RPC server on a temporary socket; this also sets `v:servername`.
  vim.fn.serverstart()
end
