# ADR-0009: Save System and State Persistence

## Status
Accepted

## Date
2026-06-10

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Core / Scripting / Data Management |
| **Knowledge Risk** | HIGH |
| **References Consulted** | docs/engine-reference/godot/VERSION.md |
| **Post-Cutoff APIs Used** | None strictly |
| **Verification Required** | ACE vulnerability prevention via `FileAccess`, Atomic File Operations |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | ADR-0004-procedural-generation-system.md, ADR-0005-puzzle-solver-algorithm.md |
| **Enables** | State continuity across sessions |
| **Blocks** | Level select and campaign progression |
| **Ordering Note** | Must track the random seeds defined in ADR-0004. |

## Context

### Problem Statement
We need a robust, deterministic way to save and load player progress. This includes their current zone, solved puzzle seeds, and the exact state of their Briefcase inventory. The system must prevent corruption, easily serialize complex data structures, and absolutely prevent Arbitrary Code Execution (ACE) vulnerabilities common in Godot save sharing.

### Constraints
- Must safely serialize/deserialize complex data (inventory arrays, seeds).
- MUST completely block Arbitrary Code Execution (ACE) if players download and share save files. Godot's native `ResourceLoader` executes `_init()` on embedded scripts before type validation, making it inherently unsafe for untrusted save files.
- MUST prevent file corruption if the game crashes, the OS terminates the process, or power is lost mid-write.

## Decision

We will use **Dictionary Serialization via `FileAccess` with Atomic Writes** for our save system, strictly banning the use of `ResourceSaver` and `ResourceLoader` for save files. 

All persistable game state will be consolidated into a structured GDScript `Dictionary`. This dictionary must contain only primitives (Strings, ints, floats, Arrays, Dictionaries) and Godot mathematical Variants (`Vector2`, `Vector3`, `Transform3D`, etc.).

### Atomic Saving (Corruption Prevention)
To prevent corruption, the `SaveManager` Autoload will never write directly to the primary save file. Instead:
1. It calls `FileAccess.store_var(save_dict)` to write the data to a temporary binary file (`user://savegame.sav.tmp`).
2. After confirming the write was successful and the file is closed, it uses `DirAccess.rename("user://savegame.sav.tmp", "user://savegame.sav")` to safely overwrite the primary file. 

### Secure Loading (ACE Prevention)
To guarantee security against ACE vulnerabilities, the `SaveManager` will load the file exclusively using `FileAccess.get_var(allow_objects = false)`. By setting `allow_objects` to `false`, the engine securely refuses to decode or instantiate any GDScript Objects or Resources (like node scripts or malicious executable code), effectively nullifying injection threats. Built-in mathematical Variants (`Vector3`, `Transform3D`) do not count as Objects and are perfectly safe to load.

### Key Interfaces
- `class_name SaveManager extends Node` (Autoload)
- `var current_save: Dictionary`
- `func save_game() -> Error`
- `func load_game() -> Error`

## Alternatives Considered

### Alternative 1: Custom Resource Serialization (`.res` / `.tres`)
- **Description**: Storing a custom `class_name SaveData extends Resource` via `ResourceSaver`.
- **Pros**: Highly idiomatic, integrates tightly with the editor.
- **Cons**: `ResourceLoader` parses and executes `_init()` on embedded GDScript objects before you can validate the file.
- **Rejection Reason**: Security vulnerability (ACE). Unsafe for a game where players might share save files.

### Alternative 2: JSON
- **Description**: Serializing the Dictionary to JSON text.
- **Pros**: Safe, human-readable.
- **Cons**: Slower to parse, requires manual type casting for nested elements, and lacks native support for Godot specific variants (like `Vector3`) without tedious string parsing.
- **Rejection Reason**: `store_var` with `allow_objects = false` provides the exact same security as JSON but is significantly faster and natively supports Godot data types.

## Consequences

### Positive
- 100% immunity to save file ACE vulnerabilities.
- Binary format via `store_var` is fast and natively supports Godot primitives and math vectors.
- Atomic renaming completely eliminates the risk of mid-write file corruption.

### Negative
- We lose the ability to easily edit save files in the Godot Inspector during debugging (must write a debug tool if needed).
- Cannot save Resource references directly; we must convert Resource data into Strings (e.g., item ID strings) before saving.

### Risks
- Developers accidentally introducing `Object` or `Resource` instances into the save dictionary, which will cause `get_var()` to throw an error on load because `allow_objects` is false.
  - *Mitigation*: Unit tests must verify that `save_game()` output can be successfully loaded with `get_var(allow_objects = false)`.
