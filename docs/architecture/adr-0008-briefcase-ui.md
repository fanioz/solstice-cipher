# ADR-0008: Drag-and-Drop Interaction & Briefcase UI

## Status
Accepted

## Date
2026-06-10

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Core / Scripting / UI & Physics |
| **Knowledge Risk** | HIGH |
| **References Consulted** | docs/engine-reference/godot/VERSION.md, docs/engine-reference/godot/breaking-changes.md |
| **Post-Cutoff APIs Used** | `Node3D.reset_physics_interpolation()` (Godot 4.5), Recursive Control disable (Godot 4.5) |
| **Verification Required** | Input Event consumption rules between Control nodes and Viewport, Jolt Collision Masks |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | ADR-0003-input-handling.md, ADR-0005-puzzle-solver-algorithm.md |
| **Enables** | Placing inventory items into the 3D world |
| **Blocks** | Briefcase UI implementation |
| **Ordering Note** | Must align with the `InputManager` autoload required by ADR-0003. |

## Context

### Problem Statement
We need a performant, reliable system to bridge 2D UI space (the Briefcase inventory) with 3D world space (the puzzle grid). Players must be able to select logic nodes (mirrors, lenses) and place them onto the valid procedural radial graph nodes.

### Constraints
- Must maintain a heavy, tactile, mechanical feel (physics-based rather than abstract UI).
- Must avoid conflicts between 2D UI input swallowing and 3D raycasting.
- Must prevent physics interpolation jitter when snapping to grid locations.
- Must strictly route all input checks through the central `InputManager` (ADR-0003).

## Decision

We will use **Decoupled Physics-based 3D Proxy Dragging** for briefcase-to-world interaction.
We explicitly bypass the native 2D Control `_get_drag_data()` pipeline, which cannot cross the boundary from CanvasItem space into Node3D space efficiently. We also enforce a strict boundary between the 2D UI and 3D world.

### Phase 1: Initiation (2D Domain)
When a player clicks and holds an item in the 2D Briefcase UI:
1. The 2D item is hidden, and the UI tree is temporarily disabled using Godot 4.5's recursive Control disable feature to prevent stray hover/click events.
2. The `BriefcaseManager` emits a `drag_started(item_id)` signal and performs NO 3D math.

### Phase 2: Dragging & 3D Raycasting (3D Domain)
A dedicated 3D node, the `PlacementController`, listens for the `drag_started` signal.
1. It immediately instances a 3D `PlacementProxy` node.
2. Because the UI swallows the initial click event, the `PlacementController` uses `_input(event)` to globally intercept the mouse movement and the release event, preventing the framerate desync issues caused by polling action states in `_physics_process()`. All input queries route through the `InputManager`.
3. During `_physics_process()`, `Camera3D.project_ray_origin` and `project_ray_normal` are used to cast a ray via `PhysicsDirectSpaceState3D.intersect_ray()` against a strictly isolated "Placement Layer" Jolt physics mask to prevent false positives.
4. If the ray hits a valid procedural graph node (defined in ADR-0005), the proxy snaps to that exact 3D transform.
5. If the ray misses, the proxy mathematically intersects a virtual floating `Plane` at a fixed depth from the camera.
6. **Critical Fix:** Whenever the proxy snaps between the virtual floating plane and a hard grid node, `Node3D.reset_physics_interpolation()` MUST be called to prevent Godot 4.5+ from visibly interpolating the sudden spatial jump, which would cause visual jitter.

### Phase 3: Resolution
Upon mouse release (detected via `_input`), if positioned over a valid node, the proxy is replaced by the actual `OpticNode` instance, and the player's inventory updates. If released over an invalid area, the proxy visually interpolates back to its 2D briefcase slot and the inventory item is unhidden.

### Key Interfaces
- **BriefcaseManager (2D)**
  - `signal drag_started(item_id: String)`
  - `signal drag_ended(success: bool)`
- **PlacementController (3D)**
  - `func _on_briefcase_drag_started(item_id: String) -> void`
  - `func _input(event: InputEvent) -> void`
  - `func _physics_process(delta: float) -> void`

## Alternatives Considered

### Alternative 1: Native Control Drag-and-Drop
- **Description**: Using Godot's built-in 2D drag system (`_get_drag_data()`, `_can_drop_data()`) and translating the final drop coordinates into 3D space on release.
- **Pros**: Easy to implement 2D dragging.
- **Cons**: Cannot show a live 3D preview of the object sitting on the procedural nodes with accurate lighting/depth before release.
- **Rejection Reason**: Lacks the required tactile, mechanical feel. Fails to provide necessary 3D spatial context during the drag.

## Consequences

### Positive
- Strict decoupling of 2D UI and 3D world states.
- Tactile, immersive dragging experience with full 3D lighting and shadow interaction.
- Bypasses input focus complexities by using global `_input` during the drag.
- Eliminates physics jitter with `reset_physics_interpolation()`.

### Negative
- Requires manual syncing between the 2D inventory visual state and the 3D proxy state.

### Risks
- Viewport mismatches if the 2D UI and 3D Camera are separated into sub-viewports.
  - *Mitigation*: The `PlacementController` must query the mouse position from the specific viewport that owns the active `Camera3D`.
