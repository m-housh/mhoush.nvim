-- Setup snippets here.
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local ms = ls.multi_snippet
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("lua", {
  -- Setup a new snippet file.
  s("sf", {
    t({
      "-- Setup snippets.",
      'local ls = require("luasnip")',
      "local s = ls.snippet",
      "local sn = ls.snippet_node",
      "local ms = ls.multi_snippet",
      "local i = ls.insert_node",
      "local f = ls.function_node",
      "local c = ls.choice_node",
      "local t = ls.text_node",
      "-- Add snippets",
    }),
    t('ls.add_snippets("'),
    i(1, "<file-type>"),
    t({
      '", {',
      "\t-- Define snippets here.",
      "})",
    }),
  }),
  s("c", {
    c(1, {
      fmt("{}", { i(1), t("debug") }),
      fmt("{}", { i(1), t("warning") }),
    }),
  }),
})
