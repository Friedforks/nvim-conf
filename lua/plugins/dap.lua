return {
  "mfussenegger/nvim-dap",
  optional = true,
  dependencies = {
    -- Ensure C/C++ debugger is installed
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "codelldb" } },
  },
  keys = {
    { "<F9>",  function() require("dap").step_into() end,        desc = "DAP: step into" },
    { "<F10>", function() require("dap").step_over() end,        desc = "DAP: step over" },
    { "<F11>", function() require("dap").step_out() end,         desc = "DAP: step out" },
    { "<F12>", function() require("dap").terminate() end,        desc = "DAP: terminate" },
    { "<F6>",  function() require("dap").continue() end,         desc = "DAP: continue" },
    { "<F7>",  function() require("dap").toggle_breakpoint() end, desc = "DAP: toggle breakpoint" },
  },
  opts = function()
    local dap = require("dap")
    if not dap.adapters["codelldb"] then
      require("dap").adapters["codelldb"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = {
            "--port",
            "${port}",
          },
        },
      }
    end
    -- Workspace root = the dir containing 'Practices/' — the same convention
    -- competitest uses to place built binaries (<workspace>/binaries). Resolved
    -- at run time from the file being debugged, so it works no matter where
    -- Neovide was launched.
    -- Pick the C/C++ source file robustly: prefer the current buffer, but fall
    -- back to scanning open buffers. (At DAP launch the current buffer can be a
    -- scratch / dapui / netrw window rather than the source — that broke the
    -- earlier version which trusted buffer 0.)
    local function is_csrc(name)
      if name == "" then return false end
      local ext = vim.fn.fnamemodify(name, ":e")
      return ext == "c" or ext == "cpp" or ext == "cc" or ext == "cxx"
    end
    local function source_file()
      local cur = vim.api.nvim_buf_get_name(0)
      if is_csrc(cur) then return cur end
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local n = vim.api.nvim_buf_get_name(buf)
        if is_csrc(n) then return n end
      end
      return cur ~= "" and cur or vim.fn.getcwd()
    end
    local function workspace_root()
      local dir = vim.fn.fnamemodify(source_file(), ":p:h")
      local root = dir
      while root ~= "/" and root ~= "" do
        if vim.fn.isdirectory(root .. "/Practices") == 1 then
          return root
        end
        local parent = vim.fn.fnamemodify(root, ":h")
        if parent == root then break end
        root = parent
      end
      return vim.fn.getcwd()
    end
    for _, lang in ipairs({ "c", "cpp" }) do
      dap.configurations[lang] = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file",
          -- Function so it resolves the CURRENT buffer at run time (fixes the old
          -- bug where expand("%:t:r") was frozen to the buffer at plugin load).
          program = function()
            local base = vim.fn.fnamemodify(source_file(), ":t:r")
            return workspace_root() .. "/binaries/" .. base
          end,
          cwd = function() return workspace_root() end,
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          pid = require("dap.utils").pick_process,
          cwd = function() return workspace_root() end,
        },
      }
    end

    -- Build the current file (same clang command as competitest, into
    -- <workspace>/binaries/) before the FIRST launch, so debugging always runs
    -- the latest code instead of a stale binary. Wrapping dap.continue keeps
    -- LazyVim's debug keymaps working unchanged.
    local builtin_continue = dap.continue
    dap.continue = function()
      if dap.session() then
        return builtin_continue()
      end
      local src = source_file()
      if not is_csrc(src) then
        return builtin_continue()
      end
      local ws = workspace_root()
      local bin = ws .. "/binaries/" .. vim.fn.fnamemodify(src, ":t:r")
      -- $HOME expands in the shell; -I provides the bits/stdc++.h shim on macOS
      -- and is harmlessly ignored on Linux.
      local cmd = string.format(
        "mkdir -p '%s' && clang++ -Wall -std=c++17 -g -I\"$HOME/.local/share\" %s -o %s",
        vim.fn.shellescape(ws .. "/binaries"),
        vim.fn.shellescape(src),
        vim.fn.shellescape(bin)
      )
      local errors = {}
      vim.notify("Building " .. vim.fn.fnamemodify(src, ":t") .. " ...")
      vim.fn.jobstart({ "sh", "-c", cmd }, {
        stderr_buffered = true,
        on_stderr = function(_, data)
          if data then
            vim.list_extend(errors, data)
          end
        end,
        on_exit = function(_, code)
          if code == 0 then
            vim.schedule(builtin_continue)
          else
            vim.schedule(function()
              vim.fn.setqflist(vim.tbl_map(function(l)
                return { text = l }
              end, errors))
              vim.cmd("copen")
              vim.notify("Build failed — see quickfix", vim.log.levels.ERROR)
            end)
          end
        end,
      })
    end
  end,
}
