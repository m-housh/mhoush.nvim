-- Setup snippets here.
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local ms = ls.multi_snippet
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local t = ls.text_node

ls.add_snippets("lua", {
	s("hello", {
		t('print("hello '),
		i(1),
		t(' world")'),
	}),
})
