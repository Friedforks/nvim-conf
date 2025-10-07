-- -- lua/vimtex_server.lua (or anywhere in your config)
--
-- local function write_server_name()
--   -- Choose temp dir (match Vimscript logic)
--   local tmpdir
--   if vim.fn.has("win32") == 1 then
--     tmpdir = vim.env.TEMP or vim.fn.stdpath("cache")
--   else
--     tmpdir = "/tmp"
--   end
--   local outfile = tmpdir .. "/vimtexserver.txt"
--
--   -- Ensure we actually have a servername (Neovim sets this only if started with --listen or similar)
--   local server = vim.v.servername
--   if not server or server == "" then
--     -- Start an RPC server so vim.v.servername gets populated
--     -- Using a unique socket path/name under the temp dir
--     local name = vim.fn.tempname()
--     vim.fn.serverstart(name)
--     server = vim.v.servername
--   end
--
--   -- Write the server name to file (as a one-line list of strings)
--   vim.fn.writefile({ server }, outfile)
-- end
--
-- -- Create the autocmd: run for TeX buffers
-- local grp = vim.api.nvim_create_augroup("vimtex_common", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--   group = grp,
--   pattern = "tex",
--   callback = write_server_name,
-- })

-- vimtex_server.lua
-- Automatically write Neovim’s RPC server name to /tmp/vimtexserver.txt
-- for Skim (macOS PDF viewer) reverse search

local function write_server_name()
  -- Determine temp directory (like the Vimscript version)
  local tmpdir
  if vim.fn.has("win32") == 1 then
    tmpdir = vim.env.TEMP or vim.fn.stdpath("cache")
  else
    tmpdir = "/tmp"
  end
  local outfile = tmpdir .. "/vimtexserver.txt"

  -- Ensure we have a valid Neovim RPC server
  local server = vim.v.servername
  if not server or server == "" then
    local name = vim.fn.tempname()
    vim.fn.serverstart(name)
    server = vim.v.servername
  end

  -- Write cleanly (overwrite only, no appending)
  vim.fn.writefile({ server }, outfile)
end

-- Create an autocmd that runs whenever a TeX file is opened
local group = vim.api.nvim_create_augroup("vimtex_common", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "tex",
  callback = write_server_name,
})

-- Optional: Manual command to force-rewrite the server file
vim.api.nvim_create_user_command("VimtexResetServerFile", function()
  write_server_name()
  print("vimtexserver.txt rewritten with: " .. (vim.v.servername or "nil"))
end, {})
