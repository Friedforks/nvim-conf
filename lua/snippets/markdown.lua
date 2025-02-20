-- from https://www.youtube.com/watch?v=FmHhonPjvvA
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("markdown", {
  s("pmatrix", {
    t("\\begin{pmatrix}"),
    i(1),
    t("\\end{pmatrix}"),
  }),

  s("cases", {
    t("\\begin{cases}"),
    i(1),
    t("\\end{cases}"),
  }),
})
