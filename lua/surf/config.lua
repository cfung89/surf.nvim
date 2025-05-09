local M = {}

M.defaults = {
	keymaps = {
		search = "<leader>o"
	},
	commands = {
		search = "Surf",
		clear_history = "SurfClear"
	},
	search_history_limit = 500,
	default_engine = "",
	bangs = { ["hi"] = "world" }
}

---@param opts table | nil
M.set = function(opts)
	opts = opts or {}
	M.opts = vim.tbl_deep_extend("force", M.defaults, opts)
end

return M
