-- Override nvim-dap-ui panel sizes so the LEFT pane uses a FIXED column width.
-- LazyVim's dap core passes `opts` straight to `dapui.setup(opts)`, so this
-- merges in under its existing `config` (keeping the auto-open/close listeners).
--
-- nvim-dap-ui's default left layout is `size = 40` (fixed columns, since the
-- value is >= 1). The earlier override set it to 45, which is *wider* than the
-- default — that's why the panel was still wide. Drop it to a narrow fixed
-- width so scopes/watches/stacks stay compact regardless of window size.
return {
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes",  size = 0.25 },
            { id = "watches", size = 0.25 },
            { id = "stacks",  size = 0.25 },
          },
          -- FIXED width in columns (< 1 = fraction of the window, >= 1 = columns).
          position = "left",
          size = 30,
        },
        {
          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 14, -- fixed rows
        },
      },
      controls = {
        enabled = true,
        icons = {
          paused = "⏸",
          play = "▶",
          step_into = "⤵",
          step_over = "⏭",
          step_out = "⤴",
          terminate = "⏹",
          restart = "↻",
        },
      },
    },
  },
}
