local M = {}

M.state = { floating = { buf = -1, win = -1 } }

M.create_window = function(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	local window = vim.api.nvim_open_win(buf, true, win_opts)

	return { buf = buf, win = window }
end

M.toggle_window = function()
	if vim.api.nvim_win_is_valid(M.state.floating.win) then
		vim.api.nvim_win_hide(M.state.floating.win)
	else
		M.state.floating = M.create_window({ buf = M.state.floating.buf })
	end
end

return M
