local M = {}

M.defaults = {
	keymaps = {},
	cmd = "Surf",
}

---@param opts table
M.set = function(opts)
	M.opts = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
