local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local config = require("surf.config")

local M = {}

M.last_prompt_bufnr = -1

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
			M.last_prompt_bufnr = prompt_bufnr
			for _, key in ipairs(config.opts.picker_mappings) do
				map(key[1], key[2], function() key[3](prompt_bufnr, map, actions, action_state) end)
			end
			-- map("i", "!", function()
			-- 	local picker = action_state.get_current_picker(prompt_bufnr)
			-- 	action_state.get_current_picker(prompt_bufnr):set_prompt("!")
			-- 	local line = action_state.get_current_line()
			-- 	if #line ~= 0 then return end
			-- 	picker:refresh(
			-- 		finders.new_table({
			-- 			results = config.bangs_array,
			-- 			entry_maker = function(entry)
			-- 				return {
			-- 					value = entry,
			-- 					ordinal = entry,
			-- 					display = entry .. " | " .. config.bangs[entry]
			-- 				}
			-- 			end
			-- 		}),
			-- 		{
			-- 			callback = function() picker:refresh(finder) end
			-- 		})
			-- end)

			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				local prompt = action_state.get_current_line()
				actions.close(prompt_bufnr)
				if action_fct then
					local mode = vim.api.nvim_get_mode().mode
					if selection ~= nil and (mode == "n" or selection.index > 1 or (mode == "i" and selection.index == 1)) then
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
