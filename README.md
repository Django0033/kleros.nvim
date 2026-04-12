# kleros.nvim

Random tables plugin for TTRPGs in Neovim.

## Tables (Ironsworn Lodestar Extended)

This plugin includes tables adapted from the **[Ironsworn Lodestar Extended](https://shawn-tomkin.itch.io/ironsworn-lodestar-expanded-reference-guide)** supplement, a fan-made companion to the Ironsworn TTRPG by Shawn Tomkin.

All Ironsworn tables use the `is_` prefix (e.g., `:KlerosTables is_action`).

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
:KlerosTables is_test_table           " Built-in simple table (1d6)
:KlerosTables is_test_range_table     " Built-in range table (1d6)
:KlerosTables is_action             " Ironsworn Action table (1d100)
:KlerosTables is_theme             " Ironsworn Theme table (1d100)
:KlerosTables is_descriptor         " Ironsworn Descriptor table (1d100)
:KlerosTables is_focus             " Ironsworn Focus table (1d100)
:KlerosTables is_overland_landmark " Ironsworn Overland Landmark (1d100, range)
:KlerosTables is_overland_waypoint " Ironsworn Overland Waypoint (1d100)
:KlerosTables is_overland_peril       " Ironsworn Overland Peril (1d100, range)
:KlerosTables is_overland_opportunity " Ironsworn Overland Opportunity (1d100, range)
:KlerosTables is_coastal_waters_landmark " Ironsworn Coastal Waters Landmark (1d100, range)
:KlerosTables is_coastal_waters_waypoint " Ironsworn Coastal Waters Waypoint (1d100, range)
:KlerosTables is_coastal_waters_peril   " Ironsworn Coastal Waters Peril (1d100, range)
:KlerosTables is_coastal_waters_opportunity " Ironsworn Coastal Waters Opportunity (1d100, range)
:KlerosTables is_settlement_type.settled_lands " Ironsworn Settlement Type - Settled Lands (1d100, range)
:KlerosTables is_settlement_type.boundary_lands " Ironsworn Settlement Type - Boundary Lands (1d100, range)
:KlerosTables is_settlement_type.remote_lands " Ironsworn Settlement Type - Remote Lands (1d100, range)
:KlerosTables is_prompt_build     " Ironsworn Prompt Build (1d100, range)
:KlerosTables npc                 " User-defined table (JSON)
```

Output: `tbl: Ironsworn Test Table 1d6=3 -> result 3`

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
| `select`   | Use dot notation to pick sub-table (e.g., `table.subkey`) |

### Nested Tables (Select Type)

Some tables contain multiple sub-tables. Use dot notation to access:
- `:KlerosTables is_settlement_type.settled_lands`
- `:KlerosTables is_settlement_type.boundary_lands`
- `:KlerosTables is_settlement_type.remote_lands`

## Table Fields

| Field      | Type       | Required   | Description                              |
|:-----------|:-----------|:-----------|:-----------------------------------------|
| `name`     | string     | Yes        | Table name (used for lookup)             |
| `type`     | string     | Yes        | 'simple' or 'range'                     |
| `dice`     | string     | Yes        | Dice notation (e.g., '1d6', '1d100')    |
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
    ├── init.lua                  -- Built-in tables
    ├── is_test_table.lua        -- Example simple table (1d6)
    ├── is_test_range_table.lua -- Example range table
    ├── is_action.lua           -- Ironsworn Action (1d100)
    ├── is_theme.lua            -- Ironsworn Theme (1d100)
    ├── is_descriptor.lua       -- Ironsworn Descriptor (1d100)
    ├── is_focus.lua            -- Ironsworn Focus (1d100)
    ├── is_overland_landmark.lua -- Ironsworn Overland Landmark (1d100, range)
    ├── is_overland_waypoint.lua  -- Ironsworn Overland Waypoint (1d100)
    ├── is_overland_peril.lua   -- Ironsworn Overland Peril (1d100, range)
    ├── is_overland_opportunity.lua -- Ironsworn Overland Opportunity (1d100, range)
    ├── is_coastal_waters_landmark.lua -- Ironsworn Coastal Waters Landmark (1d100, range)
    ├── is_coastal_waters_waypoint.lua -- Ironsworn Coastal Waters Waypoint (1d100, range)
    ├── is_coastal_waters_peril.lua   -- Ironsworn Coastal Waters Peril (1d100, range)
    ├── is_coastal_waters_opportunity.lua -- Ironsworn Coastal Waters Opportunity (1d100, range)
    ├── is_settlement_type.lua -- Ironsworn Settlement Type (nested, select)
    └── is_prompt_build.lua     -- Ironsworn Prompt Build (1d100, range)
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
local tbl_name, tbl_dice, total, entry = table_roll.table_roll("is_test_table")
```

## License

Ironsworn tables adapted from Ironsworn Lodestar Extended are fan content. Ironsworn was created by Shawn Tompkin and is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).