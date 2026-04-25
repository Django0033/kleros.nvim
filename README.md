# kleros.nvim

Random tables plugin for TTRPGs in Neovim.

## Tables

This plugin includes tables from two systems:

### Ironsworn Lodestar Extended

Tables using the `is` prefix with PascalCase (e.g., `:Kleros isAction`).

### Juice Name Generator

Procedural name generator using the `j` prefix with PascalCase (e.g., `:Kleros jNameGenerator`).

---

## Installation

### Using vim.pack (built-in)

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

---

## Setup

```lua
require("kleros").setup()

-- Optional: specify custom tables directory
require("kleros").setup({
    tables_dir = "~/my-ttrpg-tables"
})
```

---

## Usage

### Ironsworn Tables

```vim
:Kleros isAction             " Action (1d100, simple)
:Kleros isTheme             " Theme (1d100, simple)
:Kleros isCharacterActivity " Character Activity (1d100, range)
:Kleros isSettlementType           " Settlement Type (select)
:Kleros isSettlementType.settledLands    " Settled Lands
:Kleros isSettlementNameGenerator " Settlement Name (compound)
:Kleros isDelveSiteName " Delve Site Name (procedural)
```

### Juice Name Generator

```vim
:Kleros jNameGenerator     " Generate name
:Kleros jNameGenerator!   " Generate name with advantage (female-leaning)
:Kleros jNameGenerator?   " Generate name with disadvantage (male-leaning)
```

Output examples:
- `:Kleros jNameGenerator` → `tbl: Juice Name Generator 1d20=7 -> Kalvari`
- `:Kleros jNameGenerator!` → `tbl: Juice Name Generator 1d20=15 -> Meloshai`
- `:Kleros jNameGenerator?` → `tbl: Juice Name Generator 1d20=4 -> Dekori`

### Syllable Tables

```vim
:Kleros jSyllable1  " First syllable (1d20)
:Kleros jSyllable2  " Second syllable (1d20)
:Kleros jSyllable3  " Third syllable (1d20)
```

### User Tables

```vim
:Kleros myCustomTable  " User-defined table (JSON)
```

---

## Advantage and Disadvantage

For procedural tables, append `!` for advantage or `?` for disadvantage:

| Suffix | Effect |
|--------|--------|
| `!` | Roll twice, take higher |
| `?` | Roll twice, take lower |

Example: `:Kleros jNameGenerator!` generates a name with the pattern roll at advantage.

---

## Table Types

| Type | How entries are selected |
|:-----|:-------------------------|
| `simple` | `entries[total]` - index by dice roll |
| `range` | Match where `min <= total <= max` |
| `select` | Use dot notation to pick sub-table |
| `compound` | Concatenate multiple elements |
| `procedural` | Generate result from template with nested sub-tables |

---

## Juice Name Generator System

The Juice system generates fantasy names using syllable tables and procedural templates.

### Syllable Tables

| Table | Description | Dice |
|-------|-------------|------|
| `jSyllable1` | First/primary syllables | 1d20 |
| `jSyllable2` | Second syllables | 1d20 |
| `jSyllable3` | Third/ending syllables | 1d20 |

### Modifiers

The `jSyllable3` placeholder supports modifiers:

| Placeholder | Dice Roll | Range |
|-------------|-----------|-------|
| `[jSyllable3-]` | 1d10 | 1-10 |
| `[jSyllable3+]` | 1d10+10 | 11-20 |
| `[jSyllable3]` | 1d20 | 1-20 |

### Name Patterns (20 patterns)

| Roll (1d20) | Pattern |
|------------|---------|
| 1 | `[jSyllable1][jSyllable2]o` |
| 2-3 | `[jSyllable1][jSyllable2]` |
| 4 | `[jSyllable2][jSyllable3-]o` |
| 5-6 | `[jSyllable2][jSyllable3-]` |
| 7 | `[jSyllable1][jSyllable2][jSyllable3-]o` |
| 8-9 | `[jSyllable1][jSyllable2][jSyllable3-]` |
| 10-11 | `[jSyllable1][jSyllable1][jSyllable1]` |
| 12 | `[jSyllable1][jSyllable2][jSyllable3]` |
| 13 | `[jSyllable1][jSyllable2]a` |
| 14 | `[jSyllable1][jSyllable2]i` |
| 15 | `[jSyllable2][jSyllable3-]a` |
| 16 | `[jSyllable2][jSyllable3-]i` |
| 17 | `[jSyllable2][jSyllable3+]` |
| 18 | `[jSyllable1][jSyllable2][jSyllable3-]a` |
| 19 | `[jSyllable1][jSyllable2][jSyllable3-]i` |
| 20 | `[jSyllable1][jSyllable2][jSyllable3+]` |

### Parenthesis Handling

The `jSyllable1` table includes entries with parentheses indicating consonant/vowel pairs:
- First syllable with parentheses: removes content inside, keeps vowel
- Other syllables: removes only parentheses, keeps content

Example: `(f)a + kel + ne` → `Aelne` (first `(f)a` becomes `a`, others remove parens only)

### Name Capitalization

All generated names start with an uppercase letter.

---

## Nested Tables (Select Type)

Some tables contain multiple sub-tables. Use dot notation:
- `:Kleros isSettlementType.settledLands`
- `:Kleros isSettlementType.boundaryLands`
- `:Kleros isSettlementType.remoteLands`

---

## User-Defined Tables

Create JSON files in your tables directory (default: `~/.config/nvim/kleros-tables/`).

### Simple Table

```json
{
    "name": "NPC Types",
    "type": "simple",
    "dice": "1d6",
    "entries": ["Merchant", "Guard", "Villager", "Noble", "Thief", "Mage"]
}
```

### Range Table

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

---

## Table Fields

| Field | Type | Required | Description |
|:------|:-----|:---------|:------------|
| `name` | string | Yes | Table name |
| `type` | string | Yes | 'simple', 'range', 'select', 'compound', or 'procedural' |
| `dice` | string | Yes | Dice notation (e.g., '1d6', '2d60') |
| `entries` | array | Yes | Array of entries |
| `elements` | number | No | Number of elements to combine (compound) |
| `pools` | table | No | Separate element pools (compound) |
| `separator` | string | No | Separator between compound elements |
| `template` | string | No | Template string with placeholders (procedural) |
| `place_types` | array | No | Types for nested place table (procedural) |

---

## Structure

```
lua/kleros/
├── init.lua          -- Entry point with setup()
├── dice.lua         -- Dice rolling engine
├── table_roll.lua   -- Table rolling logic
├── json_loader.lua  -- JSON file loader and validator
├── user_tables.lua  -- User table manager
├── constants.lua    -- Constants (table types, placeholders)
└── tables/
    ├── init.lua                  -- Auto-loaded tables index
    ├── isAction.lua             -- Ironsworn Action
    ├── isTheme.lua              -- Ironsworn Theme
    ├── isCharacter*.lua         -- Character tables (range)
    ├── isOverland*.lua          -- Overland tables (range)
    ├── isCoastalWaters*.lua     -- Coastal Waters tables (range)
    ├── isSettlement*.lua        -- Settlement tables
    ├── isDelveSiteName*.lua     -- Delve Site Name tables (procedural)
    ├── isCharacterName1.lua     -- Character Names 1
    ├── isCharacterName2.lua     -- Character Names 2
    ├── isCharacterRevealedDetails.lua -- Character Details
    ├── jSyllable1.lua           -- Juice Syllable 1 (simple)
    ├── jSyllable2.lua           -- Juice Syllable 2 (simple)
    ├── jSyllable3.lua           -- Juice Syllable 3 (simple)
    └── jNameGenerator.lua       -- Juice Name Generator (procedural)
plugin/
└── kleros.lua        -- User commands
tests/
└── test_kleros.lua   -- Test suite
```

---

## Commands

| Command | Description |
|---------|-------------|
| `:Kleros [name]` | Get random table result |
| `:Kleros [name]!` | Get result with advantage (procedural tables) |
| `:Kleros [name]?` | Get result with disadvantage (procedural tables) |

---

## API

```lua
local dice = require("kleros.dice")
local table_roll = require("kleros.table_roll")

-- Roll from table
local tbl_name, tbl_dice, total, entry = table_roll.table_roll("isAction")

-- Roll with advantage/disadvantage
local _, _, total, name = table_roll.table_roll("jNameGenerator!")
```

---

## License

Ironsworn tables adapted from Ironsworn Lodestar Extended are fan content. Ironsworn was created by Shawn Tompkin and is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).