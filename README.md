# kleros.nvim

Random tables plugin for TTRPGs in Neovim.

[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)
[![Neovim](https://img.shields.io/badge/Neovim-0.10+-57a943?style=flat-square&logo=neovim)](https://github.com/neovim/neovim/releases/tag/v0.10.0)

A plugin that brings random table generation to Neovim, perfect for tabletop role-playing games. Generate actions, themes, character details, settlements, fantasy names, and more with a simple command.

[Overview](#overview) • [Quick Start](#quick-start) • [Usage](#usage) • [Table Types](#table-types) • [Configuration](#configuration) • [API](#api)

## Overview

kleros.nvim provides on-demand random table generation directly in Neovim. Built-in tables come from two systems:

- **Ironsworn Lodestar Extended** - Actions, themes, character traits, settlements, delve sites
- **Juice Name Generator** - Procedural fantasy name generation using syllable tables

> [!TIP]
> You can add your own custom tables in JSON format. See [User Tables](#user-tables) for details.

## Features

- **5 Table Types**: simple, range, select, compound, and procedural
- **Advantage/Disadvantage**: Roll twice and take higher/lower for procedural tables
- **User-Defined Tables**: Load custom JSON tables from your config directory
- **Autocompletion**: Tab-complete table names with the `:Kleros` command
- **Floating Window**: Results displayed in a clean floating window with copy/insert options
- **Lua API**: Programmatic access for scripting and automation

## Quick Start

### Installation

```lua
-- lazy.nvim
{ "yourusername/kleros.nvim" }
```

```vim
" vim-plug
Plug 'yourusername/kleros.nvim'
```

### Setup

```lua
require("kleros").setup()

-- Optional: specify custom tables directory
require("kleros").setup({
    tables_dir = vim.fn.stdpath("config") .. "/kleros-tables"
})
```

## Usage

```vim
:Kleros isAction             " Random action (1d100)
:Kleros isTheme              " Random theme (1d100)
:Kleros isCharacterActivity " Character activity (1d100, range)
:Kleros isSettlementType    " Settlement type (select - shows sub-tables)
:Kleros isSettlementType.settledLands " Specific sub-table
:Kleros jNameGenerator       " Generate a fantasy name (procedural)
```

### Advantage and Disadvantage

Append `!` for advantage or `?` for disadvantage on procedural tables:

```vim
:Kleros jNameGenerator   " Normal roll
:Kleros jNameGenerator!  " Advantage (roll twice, take higher)
:Kleros jNameGenerator?  " Disadvantage (roll twice, take lower)
```

Output examples:
- `:Kleros jNameGenerator` → `tbl: Juice Name Generator 1d20=7 -> Kalvari`
- `:Kleros jNameGenerator!` → `tbl: Juice Name Generator 1d20=15 -> Meloshai`

### User Tables

Create JSON files in your tables directory (default: `~/.config/nvim/kleros-tables/`).

**Simple Table:**
```json
{
    "name": "NPC Types",
    "type": "simple",
    "dice": "1d6",
    "entries": ["Merchant", "Guard", "Villager", "Noble", "Thief", "Mage"]
}
```

**Range Table:**
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

| Type | Description |
|------|-------------|
| `simple` | Direct index: `entries[total]` |
| `range` | Match: `min <= total <= max` |
| `select` | Sub-tables accessed via dot notation |
| `compound` | Concatenate multiple elements |
| `procedural` | Template with nested placeholders |

### Nested Tables (Select Type)

Some tables contain multiple sub-tables. Use dot notation:

```vim
:Kleros isSettlementType.settledLands
:Kleros isSettlementType.boundaryLands
:Kleros isSettlementType.remoteLands
```

## Configuration

```lua
require("kleros").setup({
    -- Custom tables directory
    tables_dir = "~/my-ttrpg-tables",

    -- Floating window options
    float = {
        border = "rounded",  -- Border style
        height = 0.4,        -- Window height (0-1)
        width = 0.6,         -- Window width (0-1)
    }
})
```

## API

```lua
local dice = require("kleros.dice")
local table_roll = require("kleros.table_roll")

-- Roll from table
local tbl_name, tbl_dice, total, entry = table_roll.table_roll("isAction")

-- Roll with advantage/disadvantage
local _, _, total, name = table_roll.table_roll("jNameGenerator!")
```

## Available Tables

| Prefix | System | Examples |
|--------|--------|----------|
| `is*` | Ironsworn | `isAction`, `isTheme`, `isCharacterActivity`, `isSettlementType` |
| `j*` | Juice | `jSyllable1`, `jSyllable2`, `jNameGenerator` |

## Project Structure

```
lua/kleros/
├── init.lua          -- Entry point
├── dice.lua          -- Dice rolling engine
├── table_roll.lua    -- Table resolution logic
├── json_loader.lua   -- JSON file loader
├── user_tables.lua   -- User table manager
├── config.lua        -- Configuration
└── tables/           -- Built-in tables (40+ files)

plugin/kleros.lua     -- :Kleros command
tests/test_kleros.lua -- Test suite
```

## Contributing

Contributions welcome! Please ensure tests pass before submitting PRs.

```bash
nvim --headless -c "luafile tests/test_kleros.lua" -c "qa"
```

## License

Ironsworn tables adapted from Ironsworn Lodestar Extended are fan content. Ironsworn was created by Shawn Tompkin and is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).