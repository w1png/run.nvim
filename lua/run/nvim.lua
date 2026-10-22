--- @class Script
--- @field name string
--- @field command string

local package_json = require("run.package-json")
local makefile = require("run.makefile")
local cfg_module = require("run.config")

--- @param item Script
local on_select = function(item)
	local config = vim.g.runner_config

	if not item then
		return
	end

	if config.run_in == "tmux" then
		--- @type string[]
		local cmd = {}
		table.insert(cmd, "tmux")

		if config.tmux.pane == "split" or config.tmux.pane == "vsplit" then
			table.insert(cmd, "split-window")

			if not config.tmux.switch then
				table.insert(cmd, "-d")
			end

			if config.tmux.pane == "vsplit" then
				table.insert(cmd, "-h")
			end
		end

		table.insert(cmd, item.command .. "; exec $SHELL")

		vim.fn.system(cmd)
	else
		vim.cmd('call jobstart("' .. item.command .. "\", {'term':v:true})")
	end
end

--- @param scripts Script[]
local pick = function(scripts)
	vim.ui.select(scripts, {
		prompt = "Pick a script",
		--- @param item Script
		format_item = function(item)
			return string.format("%s: %s", item.name, item.command)
		end,
	}, on_select)
end

--- @param source_scripts Script[]
--- @param dest_scripts Script[]
local function add_scripts(source_scripts, dest_scripts)
	if not source_scripts then
		return
	end
	local initial_len = #dest_scripts
	for i, script in ipairs(source_scripts) do
		dest_scripts[i + initial_len] = script
	end
end

local main = function()
	local package_json_scripts = package_json.handle()
	local makefile_scripts = makefile.handle()

	local scripts = {}
	add_scripts(package_json_scripts, scripts)
	add_scripts(makefile_scripts, scripts)

	pick(scripts)
end

return {
	pick = main,
	setup = cfg_module.setup,
}
