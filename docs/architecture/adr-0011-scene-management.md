# ADR-0011: Scene Management & Loading Strategy

## Status
Accepted

## Date
2026-06-11

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Foundation / Scene Loading |
| **Knowledge Risk** | MEDIUM |
| **References Consulted** | docs/engine-reference/godot/VERSION.md |
| **Post-Cutoff APIs Used** | None |
| **Verification Required** | WebGL memory limit during transitions |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | None |
| **Enables** | Main Menu -> Gameplay transition |
| **Blocks** | Application bootstrap |
| **Ordering Note** | Foundational |

## Context

### Problem Statement
Solstice Cipher transitions between a Title Screen, potentially a Level Select screen, and the core Gameplay scene. Given that levels 16+ are procedurally generated (ADR-0004), the transition to the Gameplay scene must gracefully handle loading screens. Furthermore, WebGL limits memory aggressively, so we cannot keep old scenes in memory.

### Constraints
- Must remain performant on HTML5/WebGL.
- Must cleanly release memory of previous scenes.
- Loading procedurally generated levels must not trigger browser "Unresponsive" prompts.

### Requirements
- A robust system to manage `get_tree().change_scene_to_packed()`.

## Decision

We will implement a single `Main` bootstrap node that acts as the root orchestrator, rather than directly using `get_tree().change_scene_to_file()`.

### Scene Hierarchy
```text
Root
 └── Main (Node)
      ├── TransitionScreen (CanvasLayer, ColorRect fade)
      └── CurrentSceneContainer (Node)
           └── [TitleScreen.tscn OR Gameplay.tscn]
```

When changing scenes:
1. `Main` fades in the `TransitionScreen`.
2. `Main` calls `queue_free()` on the child of `CurrentSceneContainer`.
3. `Main` awaits the next frame to ensure memory is freed (`await get_tree().process_frame`).
4. For Gameplay scenes requiring procedural generation:
   - `Main` spawns the `Gameplay` scene.
   - `Gameplay` initiates the procedural generator (chunked coroutine).
   - Once generation is complete, `Gameplay` signals `Main`.
5. `Main` fades out the `TransitionScreen`.

### Key Interfaces
- `autoload SceneManager extends Node` (Acts as the API for the `Main` root).
- `func change_scene(scene_path: String, loading_data: Dictionary = {}) -> void`

## Alternatives Considered

### Alternative 1: Native `change_scene_to_file()`
- **Description**: Use Godot's built-in scene changer.
- **Pros**: Zero boilerplate.
- **Cons**: Fails to provide a continuous CanvasLayer for fade transitions, making loading screens jarring. Doesn't allow passing complex setup data between scenes without global state.
- **Rejection Reason**: Unacceptable UX for a premium puzzle game.

## Consequences

### Positive
- Smooth, professional fade transitions.
- Safely garbage-collects large scenes before instantiating new ones, protecting WebGL memory limits.
- Allows passing typed data dicts to the new scene during initialization.

### Negative
- Slightly more complex setup than native methods.
- Requires ensuring `Main` is the actual first scene loaded in Project Settings.

### Risks
- Procedural generation taking too long while the screen is black.
- **Mitigation**: The `TransitionScreen` can display a subtle pulsing loading animation, updated during the generation coroutine's `process_frame` yields.

## GDD Requirements Addressed

| GDD System | Requirement | How This ADR Addresses It |
|------------|-------------|--------------------------|
| Architecture | WebGL compatibility | Enforces strict scene un-loading before loading to prevent OOM errors on web. |

## Performance Implications
- **CPU**: Negligible.
- **Memory**: Optimal, guarantees no scene overlap.
- **Load Time**: Adds a ~0.5s fade to transitions.
- **Network**: N/A

## Migration Plan
N/A

## Validation Criteria
- Memory profile shows a drop between unloading Title and loading Gameplay.
- Transition animations never hitch during scene swaps.
