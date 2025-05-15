local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local config = require("surf.config")

local M = {}

M.last_prompt_bufnr = -1

---@param opts table? --opts for picker
---@param results string[]?
---@param action_func function?
---@param calc_history string[]?
---@param calc_func function?
M.custom_picker = function(opts, results, action_func, calc_history, calc_func)
	opts = opts or {}
	results = results or {}
	calc_history = calc_history or {}

	local current_finder = "normal"
	local finder = finders.new_table({ results = results, })
	local calc_finder = finders.new_table({ results = calc_history, })
	local bang_finder = finders.new_table({
		results = config.bangs_array,
		entry_maker = function(entry)
			return { value = entry, ordinal = entry, display = entry .. " | " .. config.bangs_name[entry] }
		end
	})
	pickers.new(opts, {
		prompt_title = "Surf",
		finder = finder,
		sorter = conf.generic_sorter(opts),
		on_input_filter_cb = function(prompt, _)
			local bang = vim.startswith(prompt, "!") and prompt:match("^%S+$")
			local calc = vim.startswith(prompt, "=")
			if bang and current_finder ~= "bang" then
				current_finder = "bang"
				return { prompt = prompt, updated_finder = bang_finder }
			elseif not bang and calc and current_finder ~= "calc" then
				current_finder = "calc"
				return { prompt = prompt, updated_finder = calc_finder }
			elseif not bang and not calc and current_finder ~= "normal" then
				current_finder = "normal"
				return { prompt = prompt, updated_finder = finder }
			end
			return { prompt = prompt }
		end,
		attach_mappings = function(prompt_bufnr, map)
			M.last_prompt_bufnr = prompt_bufnr
			for _, key in ipairs(config.opts.picker_mappings) do
				map(key[1], key[2], function() key[3](prompt_bufnr, map, actions, action_state) end)
			end

			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				local prompt = action_state.get_current_line()
				if calc_func and vim.startswith(prompt, "=") then
					local res = calc_func(prompt)
					if not res then return end
					action_state.get_current_picker(prompt_bufnr):set_prompt("= " .. tostring(res))
					local picker = action_state.get_current_picker(prompt_bufnr)
					calc_finder = finders.new_table({ results = calc_history })
					picker:refresh(calc_finder, { reset_prompt = false })
					return
				end
				actions.close(prompt_bufnr)
				if action_func then
					local mode = vim.api.nvim_get_mode().mode
					if selection ~= nil and (mode == "n" or selection.index > 1 or (mode == "i" and selection.index == 1)) then
						action_func(selection[1])
					elseif mode == "i" then
						action_func(prompt)
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
