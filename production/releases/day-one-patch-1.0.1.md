# Day-One Patch: Solstice Cipher v1.0.1

**Date prepared**: 2026-06-13
**Target release**: launch day
**Base build**: v1.0.0-gold
**Patch build**: v1.0.1-patch

---

## Patch Notes (Internal)

### Bugs Fixed
| BUG-ID | Severity | Description | Fix summary |
|--------|----------|-------------|-------------|
| BUG-0003 | S1-Critical | Clicking Level 1 on the level select screen does not load the game screen | Renamed `main.tscn` to `level_1.tscn` and updated the root node name to `Level1` to match filename mapping |
| BUG-0004 | S2-Major | Level 3 progression next level path goes to end screen instead of level 4 | Updated `next_level_path` in `level_3.tscn` to point to `level_4.tscn` to enable full demo flow |
| BUG-0005 | S2-Major | No HUD indicator showing current level or name | Restructured CipherUI with a VBoxContainer and a LevelLabel displaying the level number and name (Introduction, Split, etc.) |

### Deferred to 1.1
*None.*

---

## QA Sign-Off

**QA scope**: Targeted smoke check & Broader regression tests
**Verdict**: PASS
**QA lead**: Antigravity (QA Lead role)
**Date**: 2026-06-13
**Warnings (if any)**: None

---

## Rollback Plan

See: `production/releases/rollback-plan-1.0.1.md`

**Trigger condition**: Revert to v1.0.0 if any S1 crash regressions are reported.
**Rollback owner**: User (Creative Director)

---

## Approvals Required Before Deploy

- [x] lead-programmer: all fixes reviewed
- [x] qa-lead: QA gate PASS confirmed
- [x] producer: deployment timing approved
- [x] release-manager: platform submission confirmed

---

## Player-Facing Patch Notes

- Fixed an issue where selecting Level 1 from the level select menu would fail to start the game.
- Fixed a level flow progression gap where completing Level 3 would incorrectly redirect players to the demo end screen instead of Level 4.
- Added a level name and number indicator HUD at the top of the screen during gameplay (e.g. "LEVEL 3: SUN").
