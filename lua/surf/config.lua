local utils = require("surf.utils")

local M = {}

M.defaults = {
	keymaps = {
		search = "<leader>o",
	},

	history_limit = 500,
	default_engine = "Google",

	engines = {
		Google = {
			bang = "!g",
			url = "https://www.google.com/search?q=%s",
		},
		Brave = {
			bang = "!br",
			url = "https://search.brave.com/search?q=%s&source=desktop",
		},
		DuckDuckGo = {
			bang = "!ddg",
			url = "https://duckduckgo.com/?q=%s&ia=web",
		},
		Bing = {
			bang = "!b",
			url = "https://www.bing.com/search?q=%s",
		},
		Youtube = {
			bang = "!yt",
			url = "https://www.youtube.com/results?search_query=%s",
		},
	},

	picker_mappings = {
		-- { "mode", "keymap", function(prompt_bufnr, map, actions, action_state) }
		{
			"i", "<C-y>",
			function(prompt_bufnr, _, _, action_state)
				local selection = action_state.get_selected_entry()
				if not selection then return end
				if selection.value then
					action_state.get_current_picker(prompt_bufnr):set_prompt(selection.value .. " ")
				else
					action_state.get_current_picker(prompt_bufnr):set_prompt(selection[1])
				end
			end
		},
		{
			"n", "<C-y>",
			function(prompt_bufnr, _, _, action_state)
				local selection = action_state.get_selected_entry()
				if not selection then return end
				if selection.value then
					action_state.get_current_picker(prompt_bufnr):set_prompt(selection.value .. " ")
				else
					action_state.get_current_picker(prompt_bufnr):set_prompt(selection[1])
				end
			end
		},
		{ "i", "<C-c>", function(prompt_bufnr, _, actions, _) actions.close(prompt_bufnr) end },
		{ "n", "<C-c>", function(prompt_bufnr, _, actions, _) actions.close(prompt_bufnr) end },
	},
}

M.opts = {}
M.engines = {}
M.bangs = {}
M.bangs_array = {}
M.bangs_name = {}

---@param opts table?
M.set = function(opts)
	opts = opts or {}
	M.opts = vim.tbl_deep_extend("force", M.defaults, opts)

	M.opts.picker_mappings = opts.picker_mappings or M.opts.picker_mappings
	for _, key in ipairs(M.opts.picker_mappings) do
		assert(#key == 3, "Assertion Error: Invalid number of keys in picker_mappings.")
		assert(type(key[1]) == "string", "Assertion Error: Invalid key for picker_mappings, is not a string.")
		assert(type(key[2]) == "string", "Assertion Error: Invalid key for picker_mappings, is not a string.")
		assert(type(key[3]) == "function", "Assertion Error: Invalid key for picker_mappings, is not a function.")
	end

	M.set_engines()
	M.os = utils.get_os_name()
end

M.get_default_search_link = function()
	return M.bangs[M.engines[M.opts.default_engine]]
end

M.set_engines = function()
	for name, props in pairs(M.opts.engines) do
		assert(type(name) == "string", "Assertion Error: Invalid key type, not a string.")
		assert(type(props.bang) == "string" and props.bang:sub(1, 1) == "!",
			"Assertion Error: Invalid value of bang for '" .. name .. "', is not a string.")
		assert(type(props.url) == "string", "Assertion Error: Invalid value of url '" .. name .. "', is not a string.")
		assert(string.find(props.url, "%%s"), "Assertion Error: Invalid url for '" .. name .. "', no '%s' in the link.")
		M.engines[name] = props.bang
		M.bangs_name[props.bang] = name
		M.bangs[props.bang] = props.url
		table.insert(M.bangs_array, props.bang)
	end
end

return M
