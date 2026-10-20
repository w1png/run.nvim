# run.nvim

**Planned**:
- [x] package.json
- [ ] Makefile
- [ ] Cargo.toml
- [ ] Justfile

## Installation

#### Install the plugin via your package manager

```lua
vim.pack.add({
	"https://github.com/w1png/run.nvim",
})
```

#### Require and call the runner

```lua
vim.keymap.set("n", "<leader>rr", function()
	require("run.nvim").pick()
end)
```


