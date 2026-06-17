# ADR-0010: Global Event Bus Architecture

## Status
Accepted

## Date
2026-06-11

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Foundation / Signal Management |
| **Knowledge Risk** | LOW |
| **References Consulted** | docs/engine-reference/godot/VERSION.md |
| **Post-Cutoff APIs Used** | None |
| **Verification Required** | None |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | None |
| **Enables** | Decoupled cross-layer communication |
| **Blocks** | Implementation of Core & UI layers |
| **Ordering Note** | Foundational |

## Context

### Problem Statement
In a modular architecture, tight coupling between UI components, core gameplay logic, and progression systems leads to spaghetti code. We need a standardized method for systems to communicate without holding direct references to one another.

### Constraints
- Must be globally accessible from any node.
- Must support strict static typing for payloads.
- Must not bottleneck frame performance.

### Requirements
- Clear distinction between when to use the Event Bus versus local, direct signals.
- Standardized naming convention for signals.

## Decision

We will implement a Global Event Bus via an Autoload named `EventBus`.

### Signal Usage Rules
1. **Global Event Bus (`EventBus`)**: Use ONLY for cross-layer communication or high-level game state changes that multiple disparate systems care about (e.g., `level_solved`, `tier_unlocked`, `settings_changed`, `tool_selected`).
2. **Local Signals (Direct Connection)**: Use for intra-module communication (e.g., a button inside a UI panel signaling its parent panel, or a tool emitting `drag_started` to the board).

### Architecture Diagram
```text
[Cipher UI] --emits--> [EventBus.level_solved]
                              |
     +------------------------+------------------------+
     v                        v                        v
[Level Progression]       [Save System]            [Audio System]
(Updates unlocks)         (Triggers save)          (Plays victory SFX)
```

### Key Interfaces
- `autoload EventBus extends Node`
- All signals must declare explicit argument types. Example: `signal tool_placed(tool_type: StringName, pos: Vector2i)`
- Signal naming convention: `noun_verbed` (e.g., `level_loaded`, `tool_dropped`).

## Alternatives Considered

### Alternative 1: Dependency Injection / Service Locator
- **Description**: Systems register themselves to a locator, and nodes request the system they need.
- **Pros**: Very robust for large enterprise apps.
- **Cons**: Overkill for Godot, breaks the "Call down, signal up" paradigm Godot is built around.
- **Rejection Reason**: Unnecessary complexity.

## Consequences

### Positive
- Systems remain completely decoupled and can be tested in isolation.
- Adding new listeners (like achievements or analytics later) requires zero changes to the emitter.

### Negative
- Signals can be harder to trace in a large codebase than direct function calls.
- Risk of creating "god signals" that carry too much unrelated data.

### Risks
- Memory leaks if nodes connect to the autoload but don't disconnect.
- **Mitigation**: Godot 4 automatically handles disconnection of standard signals when nodes are freed. We will rely on implicit disconnection unless manual management is strictly required.

## GDD Requirements Addressed

| GDD System | Requirement | How This ADR Addresses It |
|------------|-------------|--------------------------|
| Architecture | Decoupling Layers | Ensures Presentation and Feature layers do not hold cyclic references to each other. |

## Performance Implications
- **CPU**: Negligible overhead for signal emission.
- **Memory**: Minimal.
- **Load Time**: N/A
- **Network**: N/A

## Migration Plan
N/A

## Validation Criteria
- No cross-layer direct node paths (e.g., `get_node("../../UI")`) are found during code reviews.
- All EventBus signals have strict typing.
