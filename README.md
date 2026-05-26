# kleros.nvim

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Neovim](https://img.shields.io/badge/Neovim-0.10+-green.svg)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-5.1-blue.svg)](https://lua.org)

Random table generation for TTRPGs in Neovim — roll actions, themes, character details, settlements, fantasy names, and more directly from your editor.

Built-in tables adapted from **Ironsworn Lodestar Extended** and the **Juice Name Generator**. Supports custom user tables in JSON format.

[Quick Start](#quick-start) • [Usage](#usage) • [Table Types](#table-types) • [User Tables](#user-tables) • [Configuration](#configuration) • [API](#api)

---

## Quick Start

**Installation** with lazy.nvim:

```lua
{
  "Django0033/kleros.nvim",
  opts = {},
}
```

With other plugin managers:

```vim
" vim-plug
Plug 'Django0033/kleros.nvim'
" packer.nvim
use 'Django0033/kleros.nvim'
```

Using `vim-pack`:

```bash
git clone https://github.com/Django0033/kleros.nvim.git \
  ~/.local/share/nvim/site/pack/plugins/start/kleros.nvim
```

**Setup** in your `init.lua`:

```lua
require("kleros").setup()
```

---

## Usage

### Commands

```vim
:Kleros isAction                  " Roll a random action
:Kleros isCharacterActivity       " Roll with weighted ranges
:Kleros isSettlementType          " List available sub-tables
:Kleros isSettlementType.settledLands  " Roll a specific sub-table
:Kleros jNameGenerator            " Generate a procedural fantasy name
:Kleros jNameGenerator!           " Roll with advantage
:Kleros jNameGenerator?           " Roll with disadvantage
:KlerosBrowse                     " Browse and roll tables via Telescope
```

### Examples

```
:Kleros isAction     →  Weaken (1d100=3)
:Kleros isTheme      →  Portent (1d100=68)
:Kleros isCharacterActivity →  Journeying (1d100=47)
:Kleros isDelveSiteName       →  Dark Dig (1d100=2)
:Kleros jNameGenerator!       →  Meloshai (1d20=15)
```

### Floating Window

Results appear in a centered floating window with these keybinds:

| Key | Action |
|-----|--------|
| `q` / `Esc` | Close |
| `y` / `Y` | Copy to clipboard |
| `Enter` | Insert at cursor (markdown buffers only) |

### Telescope Browser

Optional integration — use `:KlerosBrowse` to navigate all built-in tables with live entry preview and roll on confirm.

> [!NOTE]
> Requires [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for the browser feature. The core `:Kleros` command works without it.

---

## Table Types

kleros.nvim supports 5 table types:

| Type | Description | Example |
|------|-------------|---------|
| `simple` | Direct index: `entries[roll]` | `isAction`, `isTheme` |
| `range` | Weighted: `min ≤ roll ≤ max` | `isCharacterActivity`, `isOverlandPeril` |
| `select` | Sub-tables via dot notation | `isSettlementType.settledLands` |
| `compound` | Combine elements from multiple pools | `isSettlementNameGenerator` |
| `procedural` | Template with `[Placeholder]` resolution | `isDelveSiteName`, `jNameGenerator` |

### Built-in Tables (40+)

**Ironsworn** — Actions, themes, descriptors, focuses, character traits (names, roles, goals, dispositions, first looks, activities, revealed details), settlement generators (types, conditions, projects, troubles, dispositions, cultural touchstones, name generator), overland and coastal waters elements (landmarks, perils, opportunities, waypoints), delve site names (descriptions, details, namesakes, places).

**Juice** — Fantasy name generation using 3 syllable pools and procedural template resolution.

---

## User Tables

Create custom tables as JSON files in `~/.config/nvim/kleros-tables/` (configurable).

**Simple table:**

```json
{
  "name": "NPC Types",
  "type": "simple",
  "dice": "1d6",
  "entries": ["Merchant", "Guard", "Villager", "Noble", "Thief", "Mage"]
}
```

**Range table:**

```json
{
  "name": "Treasure",
  "type": "range",
  "dice": "1d100",
  "entries": [
    { "min": 1, "max": 50, "result": "Nothing" },
    { "min": 51, "max": 80, "result": "10 gold" },
    { "min": 81, "max": 100, "result": "Magic item" }
  ]
}
```

All 5 table types are supported in JSON. Use the same structure as the built-in Lua tables.

---

## Configuration

```lua
require("kleros").setup({
  -- Custom tables directory (default: stdpath("config") .. "/kleros-tables")
  tables_dir = "~/my-ttrpg-tables",

  -- Floating window appearance (default values shown)
  float = {
    border = "rounded",  -- Any Neovim border style
    height = 0.4,        -- Fraction of editor height (0-1)
    width = 0.6,         -- Fraction of editor width (0-1)
  },
})
```

---

## API

```lua
local kleros = require("kleros")

-- Roll a table by name
local name, dice, total, result = kleros.table_roll("isAction")

-- With advantage/disadvantage
local _, _, total, name = kleros.table_roll("jNameGenerator!")

-- Low-level dice roller
local dice = require("kleros.dice")
local results, total = dice.roll("2d6")
```

### Module Reference

| Module | Description |
|--------|-------------|
| `kleros.dice` | Dice roller — parse and roll expressions like `"1d100"` |
| `kleros.table_roll` | Table resolution — roll any built-in or user table |
| `kleros.ui` | Floating window for result display |
| `kleros.browser` | Telescope integration for browsing tables |
| `kleros.user_tables` | Load and manage custom JSON tables |
| `kleros.config` | Plugin configuration getter |

---

## Development

Run tests:

```bash
nvim --headless -c "luafile tests/test_kleros.lua" -c "qa"
```

All 36+ test cases should pass.
