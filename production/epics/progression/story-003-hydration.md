# Story 003: Progression System Hydration

> **Epic**: progression
> **Status**: Complete
> **Layer**: Core
> **Type**: Integration
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-006`

**ADR Governing Implementation**: ADR-0009-save-system.md
**ADR Decision Summary**: Integrate the `SaveManager` so it reads from disk on boot and writes to disk when a level finishes.

**Engine**: Godot 4.6 | **Risk**: LOW
**Engine Notes**: Signal connections across autoloads.

**Control Manifest Rules (this layer)**:
- Required: Event-driven saves rather than polling or timer-based saves.

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [x] Automatically trigger a save state update upon successful level completion.
- [x] Hydrate the active game state from the `SaveManager` on boot, correctly unlocking accessible levels in the internal progression tracker and setting up the Briefcase tool inventory limits.

---

## Implementation Notes

*Derived from ADR-0009 Implementation Guidelines:*

- Use an event bus or direct signal (e.g. `LevelManager.level_completed`) connected to `SaveManager.save_game()`.
- On boot (`_ready()` in a root node or `GameManager` autoload), call `SaveManager.load_game()` and distribute the loaded state to the relevant systems.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Level completion condition checking (handled by the actual Puzzle Solver).

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: Automatically trigger a save state update upon successful level completion.**
  - **Given:** An active level and a valid `SaveManager` instance.
  - **When:** The successful level completion signal is emitted.
  - **Then:** The `SaveManager`'s save function is invoked with the newly updated game state.
  - **Edge cases:** Rapid successive completion signals, completing a level that is already marked as completed.

- **Test: Hydrate the active game state from the `SaveManager` on boot, correctly unlocking accessible levels and setting up Briefcase tool inventory limits.**
  - **Given:** A loaded save state with specific unlocked levels and unlocked Briefcase tools.
  - **When:** The progression system initializes.
  - **Then:** The internal progression tracker unlocks the specified levels, and the Briefcase configures its inventory limits based on the loaded tools.
  - **Edge cases:** Hydrating with tool IDs that no longer exist in the game, hydrating with invalid level IDs, missing fields in the loaded dictionary.

---

## Test Evidence

**Story Type**: Integration
**Required evidence**:
- Integration: `tests/integration/progression/story_003_hydration_test.gd` — must exist and pass

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 002
- Unlocks: None
