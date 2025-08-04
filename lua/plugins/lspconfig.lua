return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Set up LSP keymaps via LazyVim's keymaps utility
    local Keys = require("lazyvim.plugins.lsp.keymaps").get()
    vim.list_extend(Keys, {
      {
        "gd",
        "<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>",
        desc = "Goto Definition",
        has = "definition",
      },
      {
        "gr",
        "<cmd>FzfLua lsp_references      jump1=true ignore_current_line=true<cr>",
        desc = "References",
        nowait = true,
      },
      { "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
      {
        "gy",
        "<cmd>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<cr>",
        desc = "Goto T[y]pe Definition",
      },
    })

    -- Highlight settings
    opts.highlight = opts.highlight or {}

    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, { "bibtex" })
    end
    if type(opts.highlight.disable) == "table" then
      vim.list_extend(opts.highlight.disable, { "latex" })
    else
      opts.highlight.disable = { "latex" }
    end
  end,
}
