# Solstice Cipher — Master Architecture

## Document Status
- Version: 0.1
- Last Updated: 2026-06-11
- Engine: Godot 4.6
- GDDs Covered: `game-concept.md`, `level-progression-design.md`
- ADRs Referenced: 0001, 0002, 0003, 0004, 0005, 0006, 0007, 0008, 0009

## Engine Knowledge Gap Summary
- **Physics**: Jolt is now the DEFAULT 3D physics engine (4.6).
- **Rendering**: Glow processes BEFORE tonemapping (4.6), Shader Baker added, SMAA 1x, Stencil buffer (4.5), D3D12 default on Windows (4.6).
- **UI**: Dual-focus system separates mouse/touch from keyboard/gamepad (4.6), Recursive Control behavior, Screen reader support (4.5).
- **Core / GDScript**: `@abstract`, variadic args, `duplicate_deep()` (4.5).

## System Layer Map

┌─────────────────────────────────────────────┐
│ PRESENTATION LAYER                          │ 
│  - Briefcase UI System ⚠️ (HIGH RISK: UI)   │
│  - Cipher/Decryption UI                     │
│  - Beam Visuals/VFX ⚠️ (HIGH RISK: Glow)    │
├─────────────────────────────────────────────┤
│ FEATURE LAYER                               │ 
│  - Procedural Generation System             │
│  - Level Progression (Unlocks)              │
│  - Puzzle Solver Algorithm (Backward A*)    │
├─────────────────────────────────────────────┤
│ CORE LAYER                                  │ 
│  - Light Propagation Engine (Raycasting)    │
│  - Beam Convergence Logic                   │
│  - Grid & Tool Placement Logic              │
├─────────────────────────────────────────────┤
│ FOUNDATION LAYER                            │ 
│  - Save System (Persistence)                │
│  - Global Event Bus                         │
│  - Input Manager                            │
├─────────────────────────────────────────────┤
│ PLATFORM LAYER                              │ 
│  - Godot 4.6 (Compatibility WebGL)          │
## Module Ownership

### PRESENTATION LAYER
**Briefcase UI System**
- **Owns**: UI state for the drag-and-drop tool inventory, counts display.
- **Exposes**: `tool_dropped(type, pos)` signal.
- **Consumes**: Level Progression (for unlocked tools), Input Manager.
- **Engine APIs**: `Control`, `TextureRect`, ⚠️ Dual-Focus system (Godot 4.6, HIGH risk).

**Cipher/Decryption UI**
- **Owns**: Visual state of the decrypted word, glowing letter animations.
- **Exposes**: `cipher_completed` signal.
- **Consumes**: Beam Convergence Logic.
- **Engine APIs**: `RichTextLabel`, `ColorRect`.

**Beam Visuals/VFX**
- **Owns**: Line renderers and particle systems at bounce/split points.
- **Exposes**: `draw_beam(path, color)` method.
- **Consumes**: Light Propagation Engine.
- **Engine APIs**: `Line2D`, ⚠️ `WorldEnvironment` Glow (Godot 4.6, HIGH risk), `GPUParticles2D`.

### FEATURE LAYER
**Procedural Generation System**
- **Owns**: Level seed, generated tool budget, generation algorithm.
- **Exposes**: `generate_level(seed, tier) -> LevelData`.
- **Consumes**: Puzzle Solver Algorithm, Level Progression.
- **Engine APIs**: `WorkerThreadPool` (off-thread gen).

**Puzzle Solver Algorithm**
- **Owns**: Backward Radial A* search logic.
- **Exposes**: `find_backward_path(target, grid) -> PathResult`.
- **Consumes**: Grid & Tool Placement Logic.
- **Engine APIs**: Native `Array`/`Dictionary`.

**Level Progression**
- **Owns**: Current tier, unlocked tools, completed levels list.
- **Exposes**: `get_available_tools() -> Dictionary`.
- **Consumes**: Save System.
- **Engine APIs**: Native GDScript.

### CORE LAYER
**Light Propagation Engine**
- **Owns**: Raycast simulation logic, resolving bounces/splits.
- **Exposes**: `simulate_light() -> Array[BeamPath]`.
- **Consumes**: Grid & Tool Placement Logic.
- **Engine APIs**: `PhysicsDirectSpaceState2D`.

**Beam Convergence Logic**
- **Owns**: Color mixing logic when beams collide.
- **Exposes**: `mix_colors(c1, c2) -> Color`.
- **Consumes**: Nothing.
- **Engine APIs**: Native `Color`.

**Grid & Tool Placement Logic**
- **Owns**: State of the puzzle board (tools, positions, rotations).
- **Exposes**: `place_tool()`, `remove_tool()`, `get_tool_at()`.
- **Consumes**: Nothing.
- **Engine APIs**: Native `Vector2i`, 2D Arrays.

### FOUNDATION LAYER
**Save System**
- **Owns**: File IO for persistence.
- **Exposes**: `save_game()`, `load_game()`.
- **Consumes**: Level Progression.
- **Engine APIs**: ⚠️ `FileAccess` (Godot 4.4+ return types changed to `bool`, MEDIUM risk).

## Data Flow

### 1. Frame Update Path (Core Gameplay)
```text
[InputManager] → (poll) → [Briefcase UI] (Mouse Drag)
                               ↓ (Sync Call)
                       [Grid & Tool Logic] (Updates tool position)
                               ↓ (Sync Call)
                  [Light Propagation Engine] (Recalculates raycasts)
                               ↓ (Sync Call)
                   [Beam Convergence Logic] (Mixes colors on impact)
                               ↓ (State Read)
    [Cipher/Decryption UI] ← ┤  ├ → [Beam Visuals/VFX]
  (Checks if word is solved)          (Updates Line2D points)
```

### 2. Event/Signal Path
We use a centralized `EventBus` autoload to decouple high-level state changes:
```text
[Cipher/Decryption UI] → emits `EventBus.level_solved`
                               ↓
                       [Level Progression] (Updates unlocks)
                               ↓ → emits `EventBus.tier_unlocked`
                          [Save System] (Triggers auto-save)
```

### 3. Procedural Generation (Off-Thread)
To prevent frame drops on WebGL during the 85 procedural levels:
```text
[Level Progression] → requests level N → [Procedural Gen System]
                                               ↓
(WorkerThreadPool)                      [Puzzle Solver Algorithm]
                                        (Runs Radial A* backwards)
                                               ↓
                                   (Thread Safe Callback to Main)
                                               ↓
[Grid & Tool Logic] ← (Loads new level state) ← ┘
```

### 4. Save/Load Path
```text
[Main Menu] → requests load → [Save System] (FileAccess.get_var)
                                     ↓ (Returns Dictionary)
                            [Level Progression] (Hydrates state)
                                     ↓
                            [Briefcase UI] (Unlocks available tools)
```

### 5. Initialization Order
1. `InputManager` (Autoload)
2. `EventBus` (Autoload)
3. `SaveSystem` (Autoload)
4. `LevelProgression` (Autoload)
## API Boundaries

### 1. Level Progression (Autoload)
- **Exposes**:
  - `func get_unlocked_tools() -> Dictionary`
  - `func load_level(level_index: int) -> void`
- **Signals**:
  - `signal level_loaded(level_data: Dictionary)`
- **Guarantees**: Will seamlessly route to either hardcoded `LevelData` or call the `Procedural Generation System` if the level > 15.

### 2. Procedural Generation System
- **Exposes**:
  - `func generate_level(seed: int, tier: int) -> Dictionary`
- **Invariants**: Must be executed via `WorkerThreadPool` to prevent WebGL lockups.
- **Guarantees**: The returned level data is mathematically verified to be 100% solvable (by calling the Puzzle Solver).

### 3. Puzzle Solver Algorithm
- **Exposes**:
  - `func find_backward_path(target_glyph: Dictionary, grid_state: Array) -> Array`
- **Guarantees**: Returns an empty array if no path is possible within the piece budget.

### 4. Grid & Tool Placement Logic
- **Exposes**:
  - `func place_tool(tool_type: StringName, pos: Vector2i, rot_degrees: int) -> bool`
  - `func remove_tool(pos: Vector2i) -> bool`
  - `func get_grid_state() -> Array`
- **Invariants**: `rot_degrees` must strictly be multiples of 45° or 90°. Cannot place two tools on the same `Vector2i`.

### 5. Light Propagation Engine
- **Exposes**:
  - `func simulate_light(sources: Array, grid: Array) -> Array[Dictionary]`
- **Invariants**: Must enforce a strict `MAX_BOUNCES` and a hard cap on recursive splits (e.g., max 3 active Prisms chained) to prevent infinite loops and frame stuttering on WebGL.

### 6. Save System (Autoload)
- **Exposes**:
  - `func save_progress(data: Dictionary) -> bool`
  - `func load_progress() -> Dictionary`
## ADR Audit

| ADR | Engine Compat | Version | GDD Linkage | Conflicts | Valid |
|-----|--------------|---------|-------------|-----------|-------|
| 0001: Core Gameplay Logic | ✅ | ✅ | ✅ | None | ✅ |
| 0002: Rendering Engine | ✅ | ✅ | ✅ | None | ✅ |
| 0003: Input Handling | ✅ | ✅ | ✅ | None | ✅ |
| 0004: Procedural Generation | ✅ | ✅ | ✅ | None | ✅ |
| 0005: Puzzle Solver | ✅ | ✅ | ✅ | None | ✅ |
| 0006: Beam Propagation | ✅ | ✅ | ✅ | None | ✅ |
| 0007: Beam Convergence | ✅ | ✅ | ✅ | None | ✅ |
| 0008: Briefcase UI | ✅ | ✅ | ✅ | None | ✅ |
| 0009: Save System | ✅ | ✅ | ✅ | None | ✅ |

### Traceability Coverage Check

| Req ID | Requirement | ADR Coverage | Status |
|--------|-------------|--------------|--------|
| TR-level-001 | 100 levels (85 procedural) | ADR-0004 | ✅ |
| TR-level-002 | Solver solves backward | ADR-0005 | ✅ |
| TR-level-003 | Tools modify paths/colors | ADR-0006 | ✅ |
| TR-level-004 | Combiner requires two inputs | ADR-0007 | ✅ |
| TR-level-005 | Briefcase UI bottom 160px | ADR-0008 | ✅ |
---
*Master Architecture Document completed via `/create-architecture` workflow.*

