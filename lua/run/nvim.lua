--- @class Script
--- @field name string
--- @field command string

local package_json = require("run.package-json")
local makefile = require("run.makefile")

--- @param item Script
local on_select = function(item)
	if not item then
		return
	end
	vim.fn.system({
		"tmux",
		"split-window",
		"-hd",
		item.command .. "; exec $SHELL",
	})
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

	vim.print(vim.inspect(scripts))

	pick(scripts)
end

return {
	pick = main,
}
