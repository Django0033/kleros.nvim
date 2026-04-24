# kleros.nvim

Random tables plugin for TTRPGs in Neovim.

## Tables (Ironsworn Lodestar Extended)

This plugin includes tables adapted from the **[Ironsworn Lodestar Extended](https://shawn-tomkin.itch.io/ironsworn-lodestar-expanded-reference-guide)** supplement, a fan-made companion to the Ironsworn TTRPG by Shawn Tomkin.

All Ironsworn tables use the `is` prefix with PascalCase (e.g., `:Kleros isAction`).

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

### Getting Table Results

```vim
:Kleros isAction             " Ironsworn Action table (1d100)
:Kleros isTheme             " Ironsworn Theme table (1d100)
:Kleros isDescriptor         " Ironsworn Descriptor table (1d100)
:Kleros isFocus             " Ironsworn Focus table (1d100)
:Kleros isPromptBuild       " Ironsworn Prompt Build (1d100, range)
:Kleros isOverlandLandmark  " Ironsworn Overland Landmark (1d100, range)
:Kleros isOverlandWaypoint  " Ironsworn Overland Waypoint (1d100)
:Kleros isOverlandPeril     " Ironsworn Overland Peril (1d100, range)
:Kleros isOverlandOpportunity " Ironsworn Overland Opportunity (1d100, range)
:Kleros isCoastalWatersLandmark  " Ironsworn Coastal Waters Landmark (1d100, range)
:Kleros isCoastalWatersWaypoint  " Ironsworn Coastal Waters Waypoint (1d100, range)
:Kleros isCoastalWatersPeril    " Ironsworn Coastal Waters Peril (1d100, range)
:Kleros isCoastalWatersOpportunity " Ironsworn Coastal Waters Opportunity (1d100, range)
:Kleros isSettlementType           " Ironsworn Settlement Type (select, nested)
:Kleros isSettlementType.settledLands    " Settled Lands (1d100, range)
:Kleros isSettlementType.boundaryLands   " Boundary Lands (1d100, range)
:Kleros isSettlementType.remoteLands    " Remote Lands (1d100, range)
:Kleros isSettlementCondition    " Ironsworn Settlement Condition (1d100, range)
:Kleros isSettlementDisposition  " Ironsworn Settlement Disposition (1d100, range)
:Kleros isSettlementFirstLook    " Ironsworn Settlement First Look (1d100, range)
:Kleros isSettlementProject     " Ironsworn Settlement Project (1d100, range)
:Kleros isSettlementTroubles    " Ironsworn Settlement Troubles (1d100, range)
:Kleros isSettlementCulturalTouchstones " Ironsworn Settlement Cultural Touchstones (1d100, range)
:Kleros isSettlementNameGenerator " Ironsworn Settlement Name Generator (compound)
:Kleros myCustomTable         " User-defined table (JSON)
```

Output: `tbl: Ironsworn Action 1d100=47 -> Reveal`

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

### Select Table (nested.json)

```json
{
    "name": "My Nested Table",
    "type": "select",
    "entries": {
        "regionA": {
            "name": "Region A",
            "type": "simple",
            "dice": "1d6",
            "entries": ["Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta"]
        },
        "regionB": {
            "name": "Region B",
            "type": "range",
            "dice": "1d6",
            "entries": [
                { "min": 1, "max": 3, "result": "Low value" },
                { "min": 4, "max": 6, "result": "High value" }
            ]
        }
    }
}
```

Usage: `:Kleros nested.regionA`

### Compound Table (name_generator.json)

```json
{
    "name": "Character Name",
    "type": "compound",
    "dice": "2d20",
    "elements": 2,
    "separator": "-",
    "pools": {
        "element1": ["Alric", "Bryn", "Cedric", "Doran", "Eldric"],
        "element2": ["the Bold", "Ironhand", "of Winter", "the Swift", "of Oak"]
    }
}
```

Output: `tbl: Character Name 2d20=[1,3] -> Alric-the`

## Table Types

| Type       | How entries are selected              |
|:-----------|:----------------------------------|
| `simple`   | `entries[total]` - index by dice roll |
| `range`    | Match where `min <= total <= max`     |
| `select`   | Use dot notation to pick sub-table (e.g., `table.subkey`) |
| `compound` | Concatenate multiple elements from a single entry |

### Nested Tables (Select Type)

Some tables contain multiple sub-tables. Use dot notation to access:
- `:Kleros isSettlementType.settledLands`
- `:Kleros isSettlementType.boundaryLands`
- `:Kleros isSettlementType.remoteLands`

### Compound Tables

Some tables combine multiple elements into one result. Multiple dice rolls retrieve multiple parts concatenated:
- `:Kleros isSettlementNameGenerator` → "2d60=[36,31] -> Woodbreak"

## Table Fields

| Field      | Type       | Required   | Description                              |
|:-----------|:-----------|:----------|:----------------------------------------|
| `name`     | string     | Yes       | Table name (used for lookup)               |
| `type`     | string     | Yes       | 'simple', 'range', 'select', or 'compound' |
| `dice`     | string     | Yes       | Dice notation (e.g., '1d6', '2d60')    |
| `entries`  | array      | Yes       | Array of entries                         |
| `elements` | number     | No        | Number of elements to combine (for compound) |
| `pools`    | table      | No        | Separate element pools for compound tables |
| `separator`| string     | No        | Separator between compound elements (default: "") |


## Structure

```
lua/kleros/
├── init.lua          -- Entry point with setup()
├── dice.lua       -- Dice rolling engine
├── table_roll.lua  -- Table rolling logic
├── json_loader.lua  -- JSON file loader
├── user_tables.lua  -- User table manager
└── tables/
    ├── init.lua                  -- Built-in tables index
    ├── isAction.lua           -- Ironsworn Action (1d100)
    ├── isTheme.lua            -- Ironsworn Theme (1d100)
    ├── isDescriptor.lua       -- Ironsworn Descriptor (1d100)
    ├── isFocus.lua           -- Ironsworn Focus (1d100)
    ├── isPromptBuild.lua     -- Ironsworn Prompt Build (1d100, range)
    ├── isOverlandLandmark.lua  -- Ironsworn Overland Landmark (1d100, range)
    ├── isOverlandWaypoint.lua  -- Ironsworn Overland Waypoint (1d100)
    ├── isOverlandPeril.lua    -- Ironsworn Overland Peril (1d100, range)
    ├── isOverlandOpportunity.lua -- Ironsworn Overland Opportunity (1d100, range)
    ├── isCoastalWatersLandmark.lua  -- Ironsworn Coastal Waters Landmark (1d100, range)
    ├── isCoastalWatersWaypoint.lua  -- Ironsworn Coastal Waters Waypoint (1d100, range)
    ├── isCoastalWatersPeril.lua    -- Ironsworn Coastal Waters Peril (1d100, range)
    ├── isCoastalWatersOpportunity.lua -- Ironsworn Coastal Waters Opportunity (1d100, range)
    ├── isSettlementType.lua -- Ironsworn Settlement Type (nested, select)
    ├── isSettlementCondition.lua -- Ironsworn Settlement Condition (1d100, range)
    ├── isSettlementDisposition.lua -- Ironsworn Settlement Disposition (1d100, range)
    ├── isSettlementFirstLook.lua -- Ironsworn Settlement First Look (1d100, range)
    ├── isSettlementProject.lua -- Ironsworn Settlement Project (1d100, range)
    ├── isSettlementTroubles.lua -- Ironsworn Settlement Troubles (1d100, range)
    ├── isSettlementCulturalTouchstones.lua -- Ironsworn Settlement Cultural Touchstones (1d100, range)
    └── isSettlementNameGenerator.lua -- Ironsworn Settlement Name Generator (compound)
plugin/
└── kleros.lua        -- User commands
```

## Commands

| Command | Description |
|---------|-------------|
| `:Kleros [name]` | Get random table result |

## API

```lua
local dice = require("kleros.dice")
local table_roll = require("kleros.table_roll")

-- Roll from table
local tbl_name, tbl_dice, total, entry = table_roll.table_roll("isAction")
```

## License

Ironsworn tables adapted from Ironsworn Lodestar Extended are fan content. Ironsworn was created by Shawn Tompkin and is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).