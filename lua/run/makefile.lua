return {
	handle = function()
		local root = vim.fs.root(vim.fn.getcwd(), "Makefile")
		local path = vim.fs.joinpath(root, "Makefile")

		if vim.fn.filereadable(path) == 0 then
			return {}
		end

		local lines = vim.fn.readfile(path)

		--- @type Script[]
		local scripts = {}

		--- @type Script|nil
		local current = nil

		for _, line in ipairs(lines) do
			local name = line:match("(.+):")
			if name then
				if current then
					table.insert(scripts, current)
				end

				current = { name = vim.fn.trim(name), command = "" }
			else
				if current then
					current.command = current.command .. vim.fn.trim(line):gsub("\\$", "")
				end
			end
		end
		table.insert(scripts, current)

		return scripts
	end,
}
