# ADR-0001: Core Gameplay Logic (GDScript vs C#)

## Status
Accepted

## Date
2026-06-09

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Scripting / Core |
| **Knowledge Risk** | HIGH |
| **References Consulted** | `docs/engine-reference/godot/breaking-changes.md`, `docs/engine-reference/godot/current-best-practices.md` |
| **Post-Cutoff APIs Used** | None |
| **Verification Required** | None |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | None |
| **Enables** | None |
| **Blocks** | None |
| **Ordering Note** | Foundational language decision. |

## Context

### Problem Statement
The project needs to standardize on a primary language for core gameplay logic, balancing development speed with performance and typing needs. Currently, the project consists entirely of GDScript files across the `src/gameplay/` and `src/ui/` directories.

### Constraints
- Must be fully compatible with the Web (HTML5) export target (Compatibility renderer).
- Must support rapid iteration cycles.

### Requirements
- Must provide sufficient typing and architecture support for complex logic systems (e.g., puzzles, reflections).

## Decision

We will use **GDScript** as the primary language for core gameplay logic, UI, and foundation layers.

### Architecture Diagram
N/A - Language choice.

### Key Interfaces
- All GDScript files must use static typing (`-> void`, `: int`, etc.) to compensate for dynamic typing risks.
- Abstract classes should utilize the new `@abstract` decorator (Godot 4.5+).

## Alternatives Considered

### Alternative 1: C#
- **Description**: Use C# for core logic, leveraging the .NET ecosystem.
- **Pros**: Stronger typing, more robust refactoring tools, potential performance improvements for CPU-bound tasks.
- **Cons**: Slower iteration times, requires external build steps, potential friction with Godot's web exports (Compatibility renderer).
- **Rejection Reason**: The current project is already heavily developed in GDScript. The overhead of switching to C# is not justified given the performance needs of the current design and the web target constraint.

## Consequences

### Positive
- Fastest iteration cycle.
- No external build steps needed.
- High compatibility with Web exports.

### Negative
- Dynamic typing requires strict adherence to our typing conventions to prevent runtime errors.
- Lower performance ceiling compared to compiled languages.

### Risks
- If CPU performance bottlenecks arise in specific heavy calculations, GDScript may be too slow.
- **Mitigation**: Profile early and adhere strictly to performance budgets. If necessary, migrate isolated heavy systems to GDExtension.

## GDD Requirements Addressed

| GDD System | Requirement | How This ADR Addresses It |
|------------|-------------|--------------------------|
| N/A | General project architecture | Establishes the foundational programming language. |

## Performance Implications
- **CPU**: GDScript execution is slower than C# but adequate for planned mechanics.
- **Memory**: Standard Godot overhead.
- **Load Time**: Minimal impact; GDScript compiles quickly on load.
- **Network**: N/A

## Migration Plan
No migration needed. Existing codebase is already in GDScript.

## Validation Criteria
Code reviews will enforce strict static typing and usage of modern GDScript features.

## Related Decisions
- None
