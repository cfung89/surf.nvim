local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local config = require("surf.config")

local M = {}

---@param opts table | nil --opts for picker
---@param results string[]
---@param action_fct function
M.custom_picker = function(opts, results, action_fct)
	opts = opts or {}
	local finder = finders.new_table({ results = results, })
	pickers.new(opts, {
		prompt_title = "Surf",
		finder = finder,
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			map("n", config.opts.keymaps.search, function() actions.close(prompt_bufnr) end)
			for _, key in ipairs(config.opts.picker_mappings) do
				map(key[1], key[2], function() key[3](prompt_bufnr, map, actions, action_state) end)
			end

			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				local prompt = action_state.get_current_line()
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
