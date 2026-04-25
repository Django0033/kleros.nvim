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
:Kleros isAction             " Ironsworn Action (1d100, simple)
:Kleros isTheme             " Ironsworn Theme (1d100, simple)
:Kleros isDescriptor         " Ironsworn Descriptor (1d100, simple)
:Kleros isFocus             " Ironsworn Focus (1d100, simple)
:Kleros isPromptBuild       " Ironsworn Prompt Build (1d100, range)
:Kleros isCharacterActivity  " Ironsworn Character Activity (1d100, range)
:Kleros isCharacterFirstLook " Ironsworn Character First Look (1d100, range)
:Kleros isCharacterDisposition " Ironsworn Character Disposition (1d100, range)
:Kleros isCharacterRole " Ironsworn Character Role (1d100, range)
:Kleros isCharacterGoal " Ironsworn Character Goal (1d100, range)
:Kleros isOverlandLandmark  " Ironsworn Overland Landmark (1d100, range)
:Kleros isOverlandWaypoint  " Ironsworn Overland Waypoint (1d100, simple)
:Kleros isOverlandPeril     " Ironsworn Overland Peril (1d100, range)
:Kleros isOverlandOpportunity " Ironsworn Overland Opportunity (1d100, range)
:Kleros isCoastalWatersLandmark  " Ironsworn Coastal Waters Landmark (1d100, range)
:Kleros isCoastalWatersWaypoint  " Ironsworn Coastal Waters Waypoint (1d100, range)
:Kleros isCoastalWatersPeril    " Ironsworn Coastal Waters Peril (1d100, range)
:Kleros isCoastalWatersOpportunity " Ironsworn Coastal Waters Opportunity (1d100, range)
:Kleros isSettlementType           " Ironsworn Settlement Type (select)
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
:Kleros isDelveSiteName " Ironsworn Delve Site Name (procedural)
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
|:-----------|:-----------------------------------|
| `simple`   | `entries[total]` - index by dice roll |
| `range`    | Match where `min <= total <= max`     |
| `select`   | Use dot notation to pick sub-table  |
| `compound` | Concatenate multiple elements      |
| `procedural` | Generate result from template with nested sub-tables |

### Nested Tables (Select Type)

Some tables contain multiple sub-tables. Use dot notation:
- `:Kleros isSettlementType.settledLands`
- `:Kleros isSettlementType.boundaryLands`
- `:Kleros isSettlementType.remoteLands`

### Compound Tables

Concatenate multiple elements from pools:
- `:Kleros isSettlementNameGenerator` → "2d60=[36,31] -> Woodbreak"

### Procedural Tables

Procedural tables use templates with placeholders that resolve to other sub-tables. The result is generated by rolling on multiple tables based on a pattern template.

Example template: `[Place] of [Namesake]'s [Detail]`
- Rolls on `Place` table first
- Then rolls on `Namesake` table
- Then rolls on `Detail` table
- Concatenates: "Temple of Garion's Wrath"

Output: `tbl: Ironsworn Delve Site Name 1d100=73 -> Temple of Garion's Wrath`

## Table Fields

| Field      | Type       | Required   | Description                              |
|:-----------|:-----------|:----------|:----------------------------------------|
| `name`     | string     | Yes       | Table name (used for lookup)               |
| `type`     | string     | Yes       | 'simple', 'range', 'select', 'compound', or 'procedural' |
| `dice`     | string     | Yes       | Dice notation (e.g., '1d6', '2d60')    |
| `entries`  | array      | Yes       | Array of entries                         |
| `elements` | number     | No        | Number of elements to combine (for compound) |
| `pools`    | table      | No        | Separate element pools for compound tables |
| `separator`| string     | No        | Separator between compound elements       |
| `template` | string     | No        | Template string with placeholders (for procedural) |
| `place_types` | array   | No        | Types for nested place table (for procedural) |


## User-Defined Procedural Tables (delve_site.json)

```json
{
    "name": "Custom Delve Site",
    "type": "procedural",
    "dice": "1d100",
    "entries": [
        { "min": 1, "max": 50, "template": "[Type] of [Origin]" },
        { "min": 51, "max": 100, "template": "[Origin]'s [Type]" }
    ],
    "sub_tables": {
        "type": {
            "name": "Type",
            "type": "simple",
            "dice": "1d6",
            "entries": ["Cavern", "Ruin", "Temple", "Fortress", "Crypt", "Vault"]
        },
        "origin": {
            "name": "Origin",
            "type": "simple",
            "dice": "1d6",
            "entries": ["Ancient", "Forgotten", "Eldritch", "Divine", "Cursed", "Lost"]
        }
    }
}
```


## Structure

```
lua/kleros/
├── init.lua          -- Entry point with setup()
├── dice.lua         -- Dice rolling engine
├── table_roll.lua   -- Table rolling logic
├── json_loader.lua  -- JSON file loader
├── user_tables.lua  -- User table manager
└── tables/
    ├── init.lua                  -- Built-in tables index
    ├── isAction.lua             -- Ironsworn Action (1d100, simple)
    ├── isTheme.lua              -- Ironsworn Theme (1d100, simple)
    ├── isDescriptor.lua        -- Ironsworn Descriptor (1d100, simple)
    ├── isFocus.lua            -- Ironsworn Focus (1d100, simple)
    ├── isPromptBuild.lua      -- Ironsworn Prompt Build (1d100, range)
    ├── isCharacterActivity.lua -- Ironsworn Character Activity (1d100, range)
    ├── isCharacterFirstLook.lua -- Ironsworn Character First Look (1d100, range)
    ├── isCharacterDisposition.lua -- Ironsworn Character Disposition (1d100, range)
    ├── isCharacterRole.lua -- Ironsworn Character Role (1d100, range)
    ├── isCharacterGoal.lua -- Ironsworn Character Goal (1d100, range)
    ├── isOverlandLandmark.lua  -- Ironsworn Overland Landmark (1d100, range)
    ├── isOverlandWaypoint.lua  -- Ironsworn Overland Waypoint (1d100, simple)
    ├── isOverlandPeril.lua    -- Ironsworn Overland Peril (1d100, range)
    ├── isOverlandOpportunity.lua -- Ironsworn Overland Opportunity (1d100, range)
    ├── isCoastalWatersLandmark.lua  -- Ironsworn Coastal Waters Landmark (1d100, range)
    ├── isCoastalWatersWaypoint.lua  -- Ironsworn Coastal Waters Waypoint (1d100, range)
    ├── isCoastalWatersPeril.lua    -- Ironsworn Coastal Waters Peril (1d100, range)
    ├── isCoastalWatersOpportunity.lua -- Ironsworn Coastal Waters Opportunity (1d100, range)
    ├── isSettlementType.lua -- Ironsworn Settlement Type (select)
    ├── isSettlementCondition.lua -- Ironsworn Settlement Condition (1d100, range)
    ├── isSettlementDisposition.lua -- Ironsworn Settlement Disposition (1d100, range)
    ├── isSettlementFirstLook.lua -- Ironsworn Settlement First Look (1d100, range)
    ├── isSettlementProject.lua -- Ironsworn Settlement Project (1d100, range)
    ├── isSettlementTroubles.lua -- Ironsworn Settlement Troubles (1d100, range)
    ├── isSettlementCulturalTouchstones.lua -- Ironsworn Settlement Cultural Touchstones (1d100, range)
    ├── isSettlementNameGenerator.lua -- Ironsworn Settlement Name Generator (compound)
    ├── isDelveSiteName.lua -- Ironsworn Delve Site Name (procedural)
    ├── isDelveSiteNameDescription.lua -- Sub-table for Delve Site Name
    ├── isDelveSiteNameDetail.lua -- Sub-table for Delve Site Name
    ├── isDelveSiteNameNamesake.lua -- Sub-table for Delve Site Name
    └── isDelveSiteNamePlace.lua -- Sub-table for Delve Site Name (with nested place types)
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