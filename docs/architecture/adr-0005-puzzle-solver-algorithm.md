# ADR-0005: Puzzle Solver & Generator Algorithm

## Status
Accepted

## Date
2026-06-10

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Core / Scripting / Procedural Generation |
| **Knowledge Risk** | HIGH |
| **References Consulted** | docs/engine-reference/godot/VERSION.md, docs/engine-reference/godot/breaking-changes.md, docs/engine-reference/godot/deprecated-apis.md |
| **Post-Cutoff APIs Used** | Custom Pure GDScript Pathfinding |
| **Verification Required** | Float snapping reliability across long ray paths |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | ADR-0004-procedural-generation-system.md |
| **Enables** | Dynamic puzzle instantiation |
| **Blocks** | Core puzzle engine implementation |
| **Ordering Note** | Supersedes the strict grid requirement for interactive elements. |

## Context

### Problem Statement
Detailed design of the backwards-solve path-tracing algorithm mandated by ADR-0004 to ensure generated puzzles are solvable, deterministic, and scalable, while retaining 15-degree angular precision for light beams.

### Constraints
- Must guarantee solvable optical paths using 15-degree increment angles.
- Must eliminate float drift over iterative geometric calculations.
- Must remain highly performant in GDScript within the chunked loading coroutine.
- Must cleanly order operations between the geometric solver and the physical scene instantiation.

## Decision

We will implement a pure GDScript A* pathfinding class tailored exclusively for our radial/polar geometric graph. This backwards-solver guarantees solvability by tracing valid ray paths from goal nodes back to a source.

**Grid Abandonment:** To allow physically accurate 15-degree light paths, we officially abandon strict tile constraints for interactive elements. Interactive nodes (mirrors/lenses) and static wall boundaries will be placed dynamically using modular `Node2D` components that snap precisely to the calculated 15-degree ray vectors.

**Float Quantization:** We will explicitly quantize positions and vectors at every node evaluation step using `Vector2.snapped(Vector2(0.001, 0.001))`. This prevents cumulative floating-point drift and guarantees that intersection checks remain mathematically exact.

**GDScript Performance:** To avoid the massive cross-language context-switching overhead of overriding native `AStar2D` methods in GDScript, our custom `OpticalRadialAStar` will handle all heuristic and cost calculations locally in pure GDScript via inline `match` statements based on an `enum DifficultyMode`.

**Order of Operations:** The generation pipeline strictly requires that the mathematical path is calculated *first* (in a pure data format). Only after a valid path is found will the physical walls be procedurally generated *around* the active light paths. This avoids any reliance on the physics engine or bounding box checks during the generation phase.

### Key Interfaces
- `class_name OpticalRadialAStar extends RefCounted`
- `enum DifficultyMode { DIRECT, WINDING, MAXIMUM_BOUNCES }`
- `func _snap_vector(vec: Vector2) -> Vector2`
- `func calculate_backwards_path(goal_pos: Vector2, source_pos: Vector2, mode: DifficultyMode) -> PackedVector2Array`

## Alternatives Considered

### Alternative 1: Native AStar2D with GDScript Overrides
- **Description**: Inherit from Godot's built-in `AStar2D`.
- **Pros**: Built-in data structure management.
- **Cons**: Massive performance bottleneck due to C++/GDScript context switching on every edge evaluation.
- **Rejection Reason**: Unacceptable performance, even within a coroutine.

### Alternative 2: Strict Cartesian Grid
- **Description**: Force 15-degree rays to align with a grid.
- **Pros**: Retains GridMap optimizations.
- **Cons**: Mathematically impossible (irrational tangents), leading to broken light beams that miss mirrors.
- **Rejection Reason**: Mechanically non-viable for 15-degree angles.

## Consequences

### Positive
- Radial/off-grid placement ensures pixel-perfect light reflections at exactly 15-degree angles.
- Pure GDScript A* allows fast, highly tunable puzzle difficulty via custom heuristics.
- Explicit snapping eliminates the subtle bugs associated with floating-point accumulation.

### Negative
- Abandoning the strict grid for interactables increases manual alignment difficulty, meaning we must carefully manage draw calls via `MultiMeshInstance2D` or manual batching for the generated modular walls.

### Risks
- High number of CSG or standard nodes used for walls may hurt performance.
- Mitigation: Implement a baking step that merges the procedural static walls into a single mesh post-generation.

## GDD Requirements Addressed

| GDD System | Requirement | How This ADR Addresses It |
|------------|-------------|--------------------------|
| game-concept.md | Solvable optical logic | The backwards solver guarantees a mathematical path exists before the player ever sees the puzzle. |
| game-concept.md | Precise optics | Explicit quantization ensures the light behaves identically every time it is reflected. |
