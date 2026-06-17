# ADR-0004: Procedural Generation System

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
| **Post-Cutoff APIs Used** | `duplicate_deep()` for per-instance resources, `@abstract` for generation interface |
| **Verification Required** | Loading screen freezing behavior during heavy synchronous generation |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | None |
| **Enables** | Procedural zone generation |
| **Blocks** | Level implementation epics |
| **Ordering Note** | None |

## Context

### Problem Statement
The game concept specifies hand-crafted puzzles, but to mitigate the level design bottleneck (or for dynamic environments), we need a system for procedural generation of solvable optical logic puzzles.

### Constraints
- Must guarantee solvable optical paths.
- Must ensure deterministic generation from a seed.
- Must avoid main thread freezing during loading screens and maintain web export compatibility.

### Requirements
- Must interface with the Godot scene tree correctly (instantiating interactable prefabs).
- Must maintain a 60fps target and avoid OS "Not Responding" triggers during generation.

## Decision

We will implement a backwards-solve path-tracing algorithm (tracing paths from the Glyphs back to the Source) to procedurally generate solvable optical logic puzzles.

To prevent the main thread from freezing and the OS from triggering an ANR, while maintaining web export compatibility, the generation calculation will be chunked across frames using coroutines (`await get_tree().process_frame`) during the loading screen. We will strictly avoid `WorkerThreadPool` for this generation step to prevent issues with HTML5/Web exports involving SharedArrayBuffer restrictions.

We will use a definitive 2D node structure: static, non-interactive elements (walls, floors) will use `TileMapLayer` to retain internal batching optimizations. Interactive elements (mirrors, lenses, switches) will be instantiated as individual `Node2D` prefabs on a strict grid. This balances draw call optimization with the need for independent complex logic on interactive objects.

For RNG, the system will instantiate a local `RandomNumberGenerator` with the `difficulty_seed` rather than using global `randi()`, guaranteeing determinism. If nested resources are modified per-instance, `duplicate_deep()` will be used.

### Architecture Diagram
A grid-based generator traces light from goal nodes back to the source, instantiating mirror and logic nodes where path reflections are needed, creating a guaranteed solvable maze before chunked instantiation into the `TileMapLayer` and `SceneTree`.

### Key Interfaces
- `@abstract class_name ProceduralPuzzleGenerator extends Node`
- `func generate_puzzle(grid_size: Vector2i, difficulty_seed: int) -> void` (Starts async generation via coroutine)
- `func get_valid_placements(cell_coords: Vector2i) -> Array[PackedScene]`
- `signal generation_complete(puzzle_nodes: Array[Node])`

## Alternatives Considered

### Alternative 1: Wave Function Collapse Algorithm
- **Description**: Forward-solve constraints generation using WFC.
- **Pros**: Very organic structure generation.
- **Cons**: High complexity in guaranteeing globally solvable light paths.
- **Rejection Reason**: Explicitly conflicts with the mandated backwards-solve path-tracing algorithm and introduces unmanageable complexity.

### Alternative 2: Synchronous generation or WorkerThreadPool
- **Description**: Blocking generation or multi-threading via WorkerThreadPool.
- **Pros**: Simpler code / faster raw generation.
- **Cons**: Blocking freezes the main thread. WorkerThreadPool risks breaking web export compatibility.
- **Rejection Reason**: Unacceptable UX and platform compatibility risks.

## Consequences

### Positive
- Allows virtually unlimited solvable puzzles, fixing the content bottleneck.
- Smooth loading screens via chunked generation.
- Deterministic behavior enables easy bug reproduction via seed sharing.
- Guaranteed Web/HTML5 compatibility.

### Negative
- Coroutine chunking slightly extends the absolute duration of the loading screen compared to pure multithreading.

### Risks
- Path-tracing failing to find a valid source path.
- Mitigation: Implement backtracking or a max-retry limit that silently regenerates with a slight seed perturbation if the solver gets stuck.

## GDD Requirements Addressed

| GDD System | Requirement | How This ADR Addresses It |
|------------|-------------|--------------------------|
| game-concept.md | 20-30 puzzles content bottleneck | Procedural generation supplements hand-crafted puzzles with mathematically solvable layouts. |

## Performance Implications
- **CPU**: Negligible during gameplay. During loading, generation is spread over frames to maintain responsiveness.
- **Memory**: 2D generation uses `TileMapLayer` to minimize node overhead.
- **Load Time**: Marginally increased but keeps the main thread unlocked.
- **Network**: N/A

## Migration Plan
N/A (New feature implementation).

## Validation Criteria
1. Generation runs without main-thread freezing or dropping the loading screen FPS below 30.
2. Web build exports and runs successfully.
3. Every generated puzzle is mathematically solvable by the player.

## Related Decisions
- None
