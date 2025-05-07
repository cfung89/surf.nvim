local config = require("surf.config")

local M = {}

M.setup = function(opts)
	opts = vim.tbl_deep_extend("force", config.defaults, opts or {})
end

return M
