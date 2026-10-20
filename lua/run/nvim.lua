--- @class PackageJson
--- @field scripts table|nil

--- @class Script
--- @field name string
--- @field command string

--- @return string|nil
local function read_package_json()
	local root = vim.fs.root(vim.fn.getcwd(), "package.json")
	local path = vim.fs.joinpath(root, "package.json")

	if vim.fn.filereadable(path) == 0 then
		return nil
	end

	local contents = vim.fn.readfile(path)
	return table.concat(contents, " ")
end

--- @param contents string
--- @return Script[] | nil
local parse_scripts = function(contents)
	--- @type PackageJson
	local parsed = vim.json.decode(contents)
	if not parsed then
		return nil
	end

	local scripts_raw = parsed["scripts"]
	if not scripts_raw then
		return nil
	end

	--- @type Script[]
	local scripts = vim.tbl_map(function(script)
		return {
			name = script,
			command = scripts_raw[script],
		}
	end, vim.tbl_keys(scripts_raw))

	return scripts
end

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

local main = function()
	local contents = read_package_json()
	if not contents then
		vim.notify("package.json not found in project root")
		return
	end

	local scripts = parse_scripts(contents)
	if not scripts then
		vim.notify("failed to parse scripts from package.json")
		return
	end

	pick(scripts)
end

return {
	pick = main,
}
