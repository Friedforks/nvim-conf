return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        -- Linux path:
        -- require("luasnip.loaders.from_lua").load({ paths = { "/home/asdf/.config/nvim/lua/snippets" } })
        --
        -- Mac path:
        require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/lua/snippets" } })
      end,
    },
  },
}
