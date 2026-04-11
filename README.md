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

-- Optional: specify custom tables directory
require("kleros").setup({
    tables_dir = "~/my-ttrpg-tables"  -- default: ~/.config/nvim/kleros-tables
})
```

## Usage

### Rolling Dice

```vim
:KlerosRoll d20      " Roll a d20 (default)
:KlerosRoll 2d6     " Roll 2d6
:KlerosRoll d6        " Roll a d6
```

Output: `Rolled 2d6: [3, 5] = 8`

### Getting Table Results

```vim
:KlerosTables test_table        " Built-in simple table
:KlerosTables test_range_table  " Built-in range table
:KlerosTables ironsworn_action  " Built-in 100-entry action table
:KlerosTables npc              " User-defined table (JSON)
```

Output: `tbl: Test Table 1d6=3 -> result 3`

## User-Defined Tables

Create JSON files in your tables directory (default: `~/.config/nvim/kleros-tables/`).

### Simple Table (npc.json)

```json
{
    "name": "NPC Types",
    "type": "simple",
    "dice": "1d6",
    "entries": [
        "Merchant",
        "Guard",
        "Villager",
        "Noble",
        "Thief",
        "Mage"
    ]
}
```

### Range Table (treasure.json)

```json
{
    "name": "Treasure",
    "type": "range",
    "dice": "1d100",
    "entries": [
        { "min": 1, "max": 50, "result": "Empty pockets" },
        { "min": 51, "max": 80, "result": "10 gold coins" },
        { "min": 81, "max": 95, "result": "Gemstone (50g)" },
        { "min": 96, "max": 100, "result": "Magic item!" }
    ]
}
```

## Table Types

| Type       | How entries are selected              |
|:-----------|:--------------------------------------|
| `simple`   | `entries[total]` - index by dice roll |
| `range`    | Match where `min <= total <= max`     |

## Table Fields

| Field      | Type       | Required   | Description                              |
|:-----------|:-----------|:-----------|:-----------------------------------------|
| `name`     | string     | Yes        | Table name (used for lookup)             |
| `type`     | string     | Yes        | ''simple'' or ''range''                  |
| `dice`     | string     | Yes        | Dice notation (e.g., ''1d6'', ''1d100'') |
| `entries`  | array      | Yes        | Array of entries                         |


## Structure

```
lua/kleros/
├── init.lua          -- Entry point with setup()
├── dice.lua          -- Dice rolling engine
├── table_roll.lua    -- Table rolling logic
├── json_loader.lua   -- JSON file loader
├── user_tables.lua   -- User table manager
└── tables/
    ├── init.lua            -- Built-in tables
    ├── test_table.lua      -- Example simple table (1d6)
    ├── test_range_table.lua -- Example range table
    └── ironsworn_action.lua -- 100-entry action table (1d100)
plugin/
└── kleros.lua        -- User commands
```

## Commands

| Command | Description |
|---------|-------------|
| `:KlerosRoll [expr]` | Roll dice (default: d20) |
| `:KlerosTables [name]` | Get random table result |

Supported dice notation: `d4`, `d6`, `d8`, `d10`, `d12`, `d20`, `d100`, `2d6`, etc.

## API

```lua
local dice = require("kleros.dice")
local table_roll = require("kleros.table_roll")

-- Roll dice
local results, total = dice.roll_dice("2d6")

-- Roll from table
local tbl_name, tbl_dice, total, entry = table_roll.table_roll("test_table")
```
