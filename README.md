# run.nvim

**Planned**:
- [x] package.json
- [x] Makefile
- [ ] ...

## Installation

#### Install the plugin via your package manager

```lua
vim.pack.add({
	"https://github.com/w1png/run.nvim",
})
```

#### Call setup and configure the plugin

```lua
require("run.nvim").setup({
	run_in = "tmux",
	tmux = {
		pane = "vsplit",
		switch = false,
	},
})
```

#### Call pick to start the picker

```lua
vim.keymap.set("n", "<leader>rr", function()
	require("run.nvim").pick()
end)
```


