# kleros.nvim

Random tables plugin for TTRPGs in Neovim.

## Installation

### Using vim.pack (built-in)

Add this to your `init.lua` before calling `setup()`:

```lua
vim.pack.add({
    name = "kleros.nvim",
    url = "https://github.com/yourusername/kleros.nvim.git",
})
```

### Using a plugin manager

```lua
-- lazy.nvim
{ "yourusername/kleros.nvim" }
```

```vim
" vim-plug
Plug 'yourusername/kleros.nvim'
```

## Setup

```lua
-- In your init.lua
require("kleros").setup()
```

## Usage

### Rolling Dice

```vim
:KlerosRoll d20      " Roll a d20 (default)
:KlerosRoll 2d6      " Roll 2d6
:KlerosRoll d6       " Roll a d6
```

Output: `Rolled 2d6: [3, 5] = 8`

### Getting Table Results

Tables use dice rolls to select a random result:

```lua
local dice = require("kleros.dice")
local table = require("kleros.tables.test_table").test_table

local _, total = dice.roll_dice(table.dice)
local result = table.entries[total]

-- If total = 3, result = "result 3"
```

## Adding New Tables

Create a new file in `lua/kleros/tables/`:

```lua
-- lua/kleros/tables/my_table.lua
local M = {}

M.my_table = {
    name = "my_table",
    dice = "1d6",
    entries = {
        "Result 1",
        "Result 2",
        "Result 3",
        "Result 4",
        "Result 5",
        "Result 6",
    },
}

return M
```

## Structure

```
lua/kleros/
├── init.lua          -- Entry point
├── dice.lua          -- Dice rolling engine
└── tables/
    └── test_table.lua -- Example table
plugin/
└── kleros.lua        -- User commands
```

## Commands

| Command | Description |
|---------|-------------|
| `:KlerosRoll [expr]` | Roll dice (default: d20) |

Supported notation: `d4`, `d6`, `d8`, `d10`, `d12`, `d20`, `d100`, `2d6`, etc.
