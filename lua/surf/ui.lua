local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local config = require("telescope.config").values

local M = {}

---@param opts table
---@param results string[]
---@param selection function
M.custom_picker = function(opts, results, selection)
	pickers.new(opts, {
		prompt_title = "Surf",
		finder = finders.new_table({
			results = results,
		}),
		sorter = config.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				local prompt = action_state.get_current_line()
				actions.close(prompt_bufnr)
				if selection then selection(prompt) end
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
