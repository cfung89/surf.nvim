local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local config = require("telescope.config").values

local M = {}

---@param opts table
---@param results string[]
---@param action_fct function
M.custom_picker = function(opts, results, action_fct)
	pickers.new(opts, {
		prompt_title = "Surf",
		finder = finders.new_table({
			results = results,
		}),
		sorter = config.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			map("i", "<C-y>", function() end)
			actions.select_default:replace(function()
				local prompt = action_state.get_current_line()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				if action_fct then
					local mode = vim.api.nvim_get_mode().mode
					if selection ~= nil and (mode == "n" or selection.index > 1) then
						action_fct(selection[1])
					elseif mode == "i" then
						action_fct(prompt)
					end
				end
			end)
			return true
		end,
		layout_config = {
			prompt_position = "top",
		},
		layout_strategy = "center",
		sorting_strategy = "ascending",
		debounce = 100,
		previewer = false,
	}):find()
end

return M
