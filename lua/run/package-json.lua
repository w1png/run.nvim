--- @class PackageJson
--- @field scripts table|nil

return {
	handle = function()
		local root = vim.fs.root(vim.fn.getcwd(), "package.json")
		local path = vim.fs.joinpath(root, "package.json")

		if vim.fn.filereadable(path) == 0 then
			return {}
		end

		local contents = table.concat(vim.fn.readfile(path), " ")

		--- @type PackageJson
		local parsed = vim.json.decode(contents)
		if not parsed then
			return {}
		end

		local scripts_raw = parsed["scripts"]
		if not scripts_raw then
			return {}
		end

		--- @type Script[]
		local scripts = vim.tbl_map(function(script)
			return {
				name = script,
				command = scripts_raw[script],
			}
		end, vim.tbl_keys(scripts_raw))

		return scripts
	end,
}
