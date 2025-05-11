local utils = require("surf.utils")

local M = {}

M.defaults = {
	keymaps = {
		search = "<leader>o",
	},
	search_history_limit = 500,
	default_engine = "Google",
	engines = {
		["Brave"] = "https://search.brave.com/search?q=%s&source=desktop",
		["Google"] = "https://www.google.com/search?q=%s",
		["DuckDuckGo"] = "https://duckduckgo.com/?q=%s&ia=web",
		["Bing"] = "https://www.bing.com/search?q=%s",
	},
	bangs = { ["g"] = "" },
	picker_mappings = {
		-- { "mode", "keymap", function(prompt_bufnr, map, actions, action_state) }
		{
			"i", "<C-y>",
			function(prompt_bufnr, _, _, action_state)
				local selection = action_state.get_selected_entry()
				if not selection then return end
				action_state.get_current_picker(prompt_bufnr):set_prompt(selection[1])
			end
		},
		{
			"n", "<C-y>",
			function(prompt_bufnr, _, _, action_state)
				local selection = action_state.get_selected_entry()
				if not selection then return end
				action_state.get_current_picker(prompt_bufnr):set_prompt(selection[1])
			end
		},
		{ "i", "<C-c>", function(prompt_bufnr, _, actions, _) actions.close(prompt_bufnr) end },
		{ "n", "<C-c>", function(prompt_bufnr, _, actions, _) actions.close(prompt_bufnr) end },
	},
}

---@param opts table | nil
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

	M.os = utils.get_os_name()
end

M.get_default_search_link = function()
	return M.opts.engines[M.opts.default_engine]
end

return M
