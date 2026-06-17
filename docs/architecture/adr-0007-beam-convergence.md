# ADR-0007: Multi-source Beam Convergence

## Status
Accepted

## Date
2026-06-10

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Core / Scripting / Physics |
| **Knowledge Risk** | HIGH |
| **References Consulted** | docs/engine-reference/godot/VERSION.md, docs/engine-reference/godot/breaking-changes.md |
| **Post-Cutoff APIs Used** | `@abstract` (Godot 4.5) |
| **Verification Required** | Frame synchronization for multi-raycast hit resolution, State Resetting, HDR Glow tonemapping |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | ADR-0006-beam-propagation-system.md |
| **Enables** | Complex logic gate networks |
| **Blocks** | Logic node implementations |
| **Ordering Note** | Must integrate within the iterative raycast loop defined by ADR-0006. |

## Context

### Problem Statement
We need a performant, deterministic logic system to resolve scenarios where multiple light beams intersect at the same location or strike the same interactive node simultaneously, handling cryptographic color mixing (e.g., Red + Blue = Magenta) and state resolution.

### Constraints
- Must guarantee deterministic resolution regardless of processing order.
- Must not introduce 1-frame visual lag during cascading beam combinations.
- Must safely clear ghost states when beams are blocked upstream.
- Must adhere strictly to ADR-0006's anti-recursion (iterative-only) mandate.

## Decision

We will use **Node-based Additive Color Blending** for beam convergence. 
Free-space intersections (beams crossing in mid-air) will visually pass through each other without interacting logically. Logical convergence and cryptographic color mixing will only occur when two or more beams strike the same interactive `OpticNode` (specifically, a Combiner node or a generic receptor). 

During the `BeamPropagationManager` iterative raycast loop (ADR-0006), a **two-phase accumulate-then-resolve pattern** will be used:
1. **Clear Phase**: At the start of the frame's update cycle, all `OpticNode` objects must clear their incoming beam arrays to eliminate ghost state from the previous frame.
2. **Accumulation Pass**: As beams propagate and hit an `OpticNode`, the node stores the incoming raycast data (color, direction) in an internal array. It does *not* immediately compute the output.
3. **Resolution Pass**: Once all primary beams finish their traversal, the `BeamPropagationManager` calls `_resolve_convergence()` on nodes with queued beams. The nodes mathematically blend their colors and return the new beam vector/color data to the Manager. The Manager then appends these new beams back into its iterative queue to be processed within the same `max_bounces` loop.

**HDR Blending & Tonemapping:** Godot 4.6 processes glow *before* tonemapping. Additive color blending will freely exceed RGB 1.0 values (HDR) to explicitly trigger the bloom threshold. The engine's tonemapper will correctly compress these intense colors into screen space, achieving the "physical arcane" aesthetic without manual clamping.

### Key Interfaces
- `@abstract class_name OpticNode extends Node3D`
- `@abstract func _register_incoming_beam(color: Color, direction: Vector3) -> void`
- `@abstract func _resolve_convergence() -> Dictionary` # Returns {"color": Color, "direction": Vector3}
- `func blend_beam_colors(colors: Array[Color]) -> Color`

## Alternatives Considered

### Alternative 1: Spatial Interference (Space-based)
- **Description**: Beams intersect dynamically in free space, generating new output vectors mathematically at the point of intersection.
- **Pros**: Visually impressive and emergent.
- **Cons**: Requires complex volumetric collision detection instead of simple raycasting, drastically reducing performance.
- **Rejection Reason**: Unnecessary complexity. Node-based convergence achieves the puzzle logic goals perfectly and deterministically.

## Consequences

### Positive
- Two-phase resolution guarantees determinism regardless of raycast evaluation order.
- Appending combinations to the iterative queue eliminates stack overflow risks completely, adhering to ADR-0006.
- Leveraging HDR values correctly utilizes Godot 4.6's rendering pipeline.

### Negative
- Beams cannot dynamically interact in free space, restricting puzzle logic specifically to physical node locations.

### Risks
- **Ghost State Persistence**: If the clear phase fails or skips a node, it will endlessly emit beams from past frames.
  - *Mitigation*: Centralize the clear signal (`BeamPropagationManager` explicitly clears all registered nodes before starting the raycast loop).
