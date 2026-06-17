# Story 002: Atomic File Writing & Secure Loading

> **Epic**: progression
> **Status**: Complete
> **Layer**: Core
> **Type**: Logic
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-006`

**ADR Governing Implementation**: ADR-0009-save-system.md
**ADR Decision Summary**: Write securely to disk using `.tmp` files and `DirAccess.rename` for atomicity. Read using `FileAccess.get_var(allow_objects = false)` to prevent code injection.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: Atomicity requires precise file locking order. `allow_objects` is the critical security parameter.

**Control Manifest Rules (this layer)**:
- Required: Handle OS level file access failures gracefully (no crashes).
- Forbidden: Trusting loaded data blindly (must validate structure before applying).

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [x] Implement `SaveManager` Autoload to handle disk I/O.
- [x] To prevent corruption, write the dictionary to `user://savegame.sav.tmp` using `FileAccess.store_var()` and perform an atomic overwrite using `DirAccess.rename()` to `user://savegame.sav`.
- [x] To prevent ACE vulnerabilities, load the file exclusively using `FileAccess.get_var(allow_objects = false)`.
- [x] Handle failure states (corrupt file, non-existent file) by gracefully returning a default new-game state.

---

## Implementation Notes

*Derived from ADR-0009 Implementation Guidelines:*

- Ensure `FileAccess` instances are explicitly closed or fall out of scope before attempting `DirAccess.rename()`. Windows will block renaming if the handle is still open.
- When calling `FileAccess.get_var(true)`, Godot 4 explicitly throws an error if an object is encountered. This needs a try-catch equivalent or check. *Correction based on ADR*: The argument is `allow_objects = false`.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: The serialization of the actual data.
- Story 003: Triggering the save when a level completes.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: Implement `SaveManager` Autoload to handle disk I/O.**
  - **Given:** The game runtime environment.
  - **When:** The SceneTree is initialized.
  - **Then:** The `SaveManager` Autoload is present and globally accessible.
  - **Edge cases:** N/A

- **Test: Write the dictionary to `user://savegame.sav.tmp` using `FileAccess.store_var()` and perform an atomic overwrite using `DirAccess.rename()` to `user://savegame.sav`.**
  - **Given:** A valid save data Dictionary.
  - **When:** The save routine is executed.
  - **Then:** A file is temporarily created at `user://savegame.sav.tmp` and successfully renamed to `user://savegame.sav`.
  - **Edge cases:** Disk write permissions denied, existing stale `.tmp` file, out of disk space.

- **Test: Load the file exclusively using `FileAccess.get_var(allow_objects = false)`.**
  - **Given:** A save file on disk.
  - **When:** The load routine is executed.
  - **Then:** The data is successfully loaded and deserialized as a Dictionary without object instantiation.
  - **Edge cases:** A malicious or improperly formatted save file containing serialized objects (should be rejected or stripped).

- **Test: Handle failure states (corrupt file, non-existent file) by gracefully returning a default new-game state.**
  - **Given:** No save file exists, or an existing save file is corrupt/invalid.
  - **When:** The load routine is executed.
  - **Then:** A default new-game state Dictionary is returned and the game proceeds without crashing.
  - **Edge cases:** Empty file, file containing an Array instead of a Dictionary, file locked by another process.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/progression/story_002_atomic_file_test.gd` — must exist and pass

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 001
- Unlocks: Story 003
