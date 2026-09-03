-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
opt = vim.opt
opt.clipboard = "unnamedplus"
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.tabstop = 4

-- Neovide (GUI) font — pin it explicitly so it doesn't drift with fontconfig changes.
vim.g.neovide_font = "JetBrainsMono Nerd Font:h12"

-- Fallback for other GUI frontends / plain `gui` handling.
vim.opt.guifont = "JetBrainsMono Nerd Font:h12"

function CompileAndRunCpp()
  local filename = vim.fn.expand("%:p")
  local basename = vim.fn.expand("%:p:r")

  -- Shell-quote both so filenames with spaces or [brackets] aren't split/globbed.
  -- Abs paths (%:p) also let the run step resolve without a PATH lookup.
  local sfname = vim.fn.shellescape(filename)
  local sbase = vim.fn.shellescape(basename)

  -- Save the current buffer
  vim.cmd("write")

  -- Find existing terminal buffer
  local term_buf = nil
  local term_win = nil

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      term_buf = buf
      term_win = win
      break
    end
  end

  if term_buf and term_win then
    -- Reuse existing terminal
    vim.api.nvim_set_current_win(term_win)

    -- Check if job is still running
    local job_id = vim.b.terminal_job_id
    if job_id and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
      -- Terminal is active, send commands
      vim.fn.jobsend(job_id, "clear\n")
      local compile_cmd = string.format("g++ -std=c++17 %s -o %s && %s\n", sfname, sbase, sbase)
      vim.fn.jobsend(job_id, compile_cmd)
    else
      -- Terminal exists but job ended, create new one
      vim.cmd("quit")
      vim.cmd("below split")
      vim.cmd("resize 8")
      local compile_cmd = string.format("g++ -std=c++17 %s -o %s && %s", sfname, sbase, sbase)
      vim.cmd("terminal " .. compile_cmd)
      vim.cmd("startinsert")
    end
  else
    -- Create new terminal
    vim.cmd("below split")
    vim.cmd("resize 8")
    local compile_cmd = string.format("g++ -std=c++17 %s -o %s && %s", sfname, sbase, sbase)
    vim.cmd("terminal " .. compile_cmd)
    vim.cmd("startinsert")
  end
end

-- Create keymap for F5 to compile and run
vim.keymap.set("n", "<F5>", ":lua CompileAndRunCpp()<CR>", { noremap = true, silent = true })

-- Always be in insert when entering a terminal window
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "WinEnter" }, {
  pattern = "term://*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})
