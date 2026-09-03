return {
  "lervag/vimtex",
  lazy = false, -- lazy-loading will disable inverse search
  config = function()
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
    vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    if vim.fn.has("mac") == 1 then
      -- macOS: Skim via AppleScript (native VimTeX viewer, sync on compile).
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1 -- forward-search after successful compile
      vim.g.vimtex_view_skim_activate = 1 -- bring Skim to front on :VimtexView
    else
      -- Linux: Zathura with SyncTeX forward + inverse search.
      -- Use `zathura_simple` (no xdotool) since we're on Wayland.
      vim.g.vimtex_view_method = "zathura_simple"
    end
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-shell-escape",
      },
    }
  end,
  keys = {
    { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
  },
}
