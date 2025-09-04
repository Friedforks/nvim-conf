-- lua/snippets/tex.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("tex", {

  -- Full report skeleton (variables for course, author, date, first chapter)
  s(
    "note",
    fmt(
      [[
\documentclass{{report}}

\input{{preamble}}
\input{{macros}}
\input{{letterfonts}}

\title{{\Huge{{{course}}}}}
\author{{\huge{{Brian Zu}}}}
\date{{{date}}}

\begin{{document}}

\maketitle
\newpage% or \cleardoublepage
% \pdfbookmark[<level>]{{<title>}}{{<dest>}}
\pdfbookmark[section]{{\contentsname}}{{toc}}
% \tableofcontents
\pagebreak

\chapter{{{title}}}

\end{{document}}
]],
      {
        course = i(1, "MAT 240 Algebra I"),
        date = i(2, "2025 Fall"),
        title = i(3, "Week 1:"),
      }
    )
  ),

  -- Quick helpers
  s("chapter", fmt([[ \chapter{{Week {}: {}}} ]], { i(1, "1"), i(2, "Topic") })),
  s("brac", {
    t("\\{ "),
    i(1),
    t(" \\}"),
  }),
  -- Bold text: \textbf{}
  s("bf", {
    t("\\textbf{"),
    i(1),
    t("}"),
  }),

  -- Italic text: \textit{}
  s("it", {
    t("\\textit{"),
    i(1),
    t("}"),
  }),
})
