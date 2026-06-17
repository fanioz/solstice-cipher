# ADR-0003: Input Handling

## Status
Accepted

## Date
2026-06-09

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Input |
| **Knowledge Risk** | HIGH |
| **References Consulted** | `docs/engine-reference/godot/modules/input.md` |
| **Post-Cutoff APIs Used** | Aware of dual-focus UI system and SDL3 gamepad backend. |
| **Verification Required** | Must verify that UI interactions do not trigger underlying gameplay actions (dual-focus UI vs `_unhandled_input`). |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | None |
| **Enables** | None |
| **Blocks** | None |
| **Ordering Note** | Core pattern that Player Controller and UI will depend upon. |

## Context

### Problem Statement
The project needs a standardized input handling architecture that supports gameplay actions, input buffering, and UI navigation, while correctly integrating with the Godot 4.6 dual-focus system.

### Constraints
- Must not steal focus or input from UI Control nodes.
- Must support potential future input buffering for responsive gameplay.

### Requirements
- Provide a centralized place for querying input states so that input remapping or buffering can be implemented later without rewriting gameplay scripts.

## Decision

We will implement a **Custom Input Manager Autoload** that wraps Godot's native `Input` singleton for all core gameplay logic.

### Architecture Diagram
```
[Hardware] -> [OS] -> [Godot Input Map] 
                           |
                           v
              [Godot UI System (Dual Focus)] --(consumes UI input)
                           |
                           v (Unhandled)
                [InputManager Autoload] --(buffers/maps actions)
                           |
                           v
        [Player Controller / Gameplay Systems]
```

### Key Interfaces
- **`InputManager` (Autoload)**: Exposes methods like `get_movement_vector()`, `is_action_pressed()`, `is_action_just_pressed()`.
- Gameplay code must **not** call `Input.is_action_pressed()` directly. It must query the `InputManager`.

## Alternatives Considered

### Alternative 1: Built-in Input Map (Direct Calls)
- **Description**: Call `Input.get_vector()` and `Input.is_action_pressed()` directly in gameplay scripts.
- **Pros**: Native, fast, no boilerplate.
- **Cons**: Difficult to add global input buffering, combo detection, or intercept input state during cutscenes/pauses.
- **Rejection Reason**: Scatters input logic and creates tight coupling to the native input system, making future gameplay polish (like buffering) harder.

### Alternative 2: Third-party Addon (e.g., Godot Input Helper)
- **Description**: Use a community-maintained input manager plugin.
- **Pros**: Ready-to-use remapping UI and advanced device routing.
- **Cons**: Introduces a dependency. May conflict with the new 4.6 dual-focus separation or SDL3 changes.
- **Rejection Reason**: The project's input needs can be met with a lightweight custom wrapper without inheriting third-party maintenance risks.

## Consequences

### Positive
- Centralized point for input interception (e.g., ignoring input while the game is paused or during a cutscene).
- Easy to add input buffering or combo detection later.

### Negative
- Requires initial boilerplate to set up the Autoload and define its API.
- Developers must remember to use `InputManager` instead of `Input`.

### Risks
- `InputManager` might intercept UI inputs if not implemented correctly.
- **Mitigation**: The `InputManager` should primarily update its state based on `_unhandled_input()` to ensure UI Controls have first priority.

## GDD Requirements Addressed

| GDD System | Requirement | How This ADR Addresses It |
|------------|-------------|--------------------------|
| Player Controller | Responsive Controls | Lays the groundwork for input buffering. |

## Performance Implications
- **CPU**: Negligible overhead (one extra method call per input query).
- **Memory**: Minimal footprint.
- **Load Time**: N/A
- **Network**: N/A

## Migration Plan
1. Create `src/core/input_manager.gd` and add it as an Autoload named `InputManager`.
2. Refactor existing `src/gameplay/` scripts to call `InputManager` instead of `Input`.

## Validation Criteria
- Character moves using `InputManager` queries.
- Clicking on a UI button (using mouse or gamepad focus) does not trigger underlying gameplay actions simultaneously.

## Related Decisions
- None
