local table_roll = require("kleros.table_roll")

local all_passed = true

local function test(name, table_name, should_match)
	local tbl_name, tbl_dice, total, entry = table_roll.table_roll(table_name)
	local passed = true

	if should_match and not entry:match(should_match) and not entry:match("^Error:") then
		passed = false
	end

	if entry and entry:match("^Error:") then
		if not should_match then
			passed = false
		end
	end

	local status = passed and "PASS" or "FAIL"
	print(string.format("[%s] %s: %s (%s=%s)", status, name, entry or "nil", tbl_dice or "", tostring(total)))
	if not passed then
		all_passed = false
	end
	return passed
end

print("\n=== Kleros.nvim Full Test Suite ===\n")

print("--- Simple Tables ---")
test("isAction", "isAction", nil)
test("isTheme", "isTheme", nil)
test("isDescriptor", "isDescriptor", nil)
test("isFocus", "isFocus", nil)
test("isPromptBuild", "isPromptBuild", nil)
test("isCharacterRevealedDetails", "isCharacterRevealedDetails", nil)

print("\n--- Range Tables: Overland ---")
test("isOverlandLandmark", "isOverlandLandmark", nil)
test("isOverlandPeril", "isOverlandPeril", nil)
test("isOverlandOpportunity", "isOverlandOpportunity", nil)

print("\n--- Range Tables: Coastal Waters ---")
test("isCoastalWatersLandmark", "isCoastalWatersLandmark", nil)
test("isCoastalWatersPeril", "isCoastalWatersPeril", nil)
test("isCoastalWatersWaypoint", "isCoastalWatersWaypoint", nil)
test("isCoastalWatersOpportunity", "isCoastalWatersOpportunity", nil)

print("\n--- Range Tables: Settlement ---")
test("isSettlementCondition", "isSettlementCondition", nil)
test("isSettlementDisposition", "isSettlementDisposition", nil)
test("isSettlementFirstLook", "isSettlementFirstLook", nil)
test("isSettlementProject", "isSettlementProject", nil)
test("isSettlementTroubles", "isSettlementTroubles", nil)
test("isSettlementCulturalTouchstones", "isSettlementCulturalTouchstones", nil)

print("\n--- Range Tables: Character ---")
test("isCharacterActivity", "isCharacterActivity", nil)
test("isCharacterDisposition", "isCharacterDisposition", nil)
test("isCharacterRole", "isCharacterRole", nil)
test("isCharacterGoal", "isCharacterGoal", nil)
test("isCharacterFirstLook", "isCharacterFirstLook", nil)

print("\n--- Select Tables ---")
test("isSettlementType", "isSettlementType", "^Select:")

print("\n--- Compound Tables ---")
test("isSettlementNameGenerator", "isSettlementNameGenerator", nil)

print("\n--- Procedural Tables ---")
test("isDelveSiteName", "isDelveSiteName", nil)
test("isDelveSiteNameDescription", "isDelveSiteNameDescription", nil)
test("isDelveSiteNameDetail", "isDelveSiteNameDetail", nil)
test("isDelveSiteNameNamesake", "isDelveSiteNameNamesake", nil)
test("isDelveSiteNamePlace", "isDelveSiteNamePlace", nil)

print("\n--- Nested Select ---")
test("isSettlementType.settledLands", "isSettlementType.settledLands", nil)
test("isSettlementType.boundaryLands", "isSettlementType.boundaryLands", nil)
test("isSettlementType.remoteLands", "isSettlementType.remoteLands", nil)

print("\n--- Error Cases ---")
test("invalid_table", "invalidTable", "^Error:")

print("\n=== Results ===")
if all_passed then
	print("All tests PASSED")
else
	print("Some tests FAILED")
	os.exit(1)
end