--- @alias RunIn "tmux"
---            | "terminal"

--- @class TmuxConfig
--- @field pane "split"|"vsplit"|integer|string|nil # Only "split" and "vsplit" are supported for now
--- @field switch boolean|nil

--- @class Config
--- @field run_in RunIn | nil
--- @field tmux TmuxConfig | nil

--- @type Config
local DEFAULT_CONFIG = {
	run_in = "terminal",
	tmux = {
		pane = "vsplit",
		switch = true,
	},
}

vim.g.runner_config = DEFAULT_CONFIG

--- @param cfg Config
local function setup(cfg)
	vim.g.runner_config = vim.tbl_deep_extend("force", DEFAULT_CONFIG, cfg)
end

return {
	config = vim.g.runner_config,
	setup = setup,
}
