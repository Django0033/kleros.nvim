# Code Deletion Log

## [2026-05-25] Refactor Session — Dead Code Cleanup

### Unused Files Deleted
- `lua/kleros/browser/telescope.lua` - Entire file dead; neither `register()` nor `load_extension()` were ever called anywhere in the codebase. The file depended on `telescope._extensions.kleros` which does not exist.

### Dead Code Removed
- `lua/kleros/browser/init.lua`:
  - `get_table_roll()` function — defined but never called
  - `get_table_index()` function — defined but never called
  - `M.loaded` variable — only set (`false`/`true`), never read by any caller

### Duplicate Code Consolidated
- `lua/kleros/json_loader.lua` — Replaced inline `valid_types` list with import of `constants.TABLE_TYPES` from `lua/kleros/constants.lua`. The list was identical (`"simple", "range", "select", "compound", "procedural"`) and now shares a single source of truth.

### Impact
- Files deleted: 1
- Lines of code removed: ~55
- Dead functions removed: 3
- Unused variable removed: 1
- Unused constant consolidated: 1 (now properly imported)

### Testing
- All 36+ test cases passing
- `nvim --headless -c "luafile tests/test_kleros.lua" -c "qa"` — PASS
