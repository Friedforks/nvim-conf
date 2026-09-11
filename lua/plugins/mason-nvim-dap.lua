-- mason-nvim-dap auto-configures every adapter that happens to be installed in
-- Mason. codelldb is superseded by the gdb config in lua/plugins/dap.lua, but it
-- is still installed, so its handler would keep appending stale "LLDB: Launch"
-- entries to the config picker — easy to select by accident, and still broken
-- for libstdc++ STL iterators. Skipping the handler leaves the two gdb configs.
return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = {
    handlers = {
      codelldb = function() end,
    },
  },
}
