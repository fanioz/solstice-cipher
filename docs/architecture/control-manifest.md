# Control Manifest

> **Engine**: Godot 4.6
> **Last Updated**: 2026-06-09
> **Manifest Version**: 2026-06-09
> **ADRs Covered**: ADR-0001, ADR-0002, ADR-0003
> **Status**: Active — regenerate with `/create-control-manifest update` when ADRs change

This manifest is a programmer's quick-reference extracted from all Accepted ADRs, technical preferences, and engine reference docs. For the reasoning behind each rule, see the referenced ADR.

---

## Foundation Layer Rules

*Applies to: scene management, event architecture, save/load, engine initialisation*

### Required Patterns
- **InputManager queries** — Use `InputManager` for all non-UI input queries. — source: ADR-0003
- **Static Typing** — All GDScript files must use static typing (`-> void`, `: int`, etc.). — source: ADR-0001

### Forbidden Approaches
- **Never call Input directly** — Avoid `Input.get_vector()` or `Input.is_action_pressed()`. — source: ADR-0003
- **Never use untyped GDScript variables** — Runtime errors are too high risk. — source: ADR-0001

### Performance Guardrails
- **None explicitly defined yet**

---

## Core Layer Rules

*Applies to: core gameplay loop, main player systems, physics, collision*

### Required Patterns
- **InputManager queries** — Use `InputManager` for all gameplay input. — source: ADR-0003
- **Static Typing** — All GDScript files must use static typing. — source: ADR-0001

### Forbidden Approaches
- **Never call Input directly** — Avoid native input queries in gameplay scripts. — source: ADR-0003
- **Never use untyped GDScript** — Maintain strict typing discipline. — source: ADR-0001

### Performance Guardrails
- **None explicitly defined yet**

---

## Feature Layer Rules

*Applies to: secondary mechanics, AI systems, secondary features*

### Required Patterns
- **InputManager queries** — Connect feature inputs via `InputManager`. — source: ADR-0003
- **Static Typing** — Must be fully statically typed. — source: ADR-0001

### Forbidden Approaches
- **Never call Input directly** — Do not bypass the `InputManager`. — source: ADR-0003
- **Never use untyped GDScript** — Maintain strict typing discipline. — source: ADR-0001

---

## Presentation Layer Rules

*Applies to: rendering, audio, UI, VFX, shaders, animations*

### Required Patterns
- **Compatibility backend** — Shaders and materials must compile and work correctly under GLES3/WebGL 2 limitations. — source: ADR-0002
- **Static Typing** — Ensure all UI and VFX scripts are fully typed. — source: ADR-0001

### Forbidden Approaches
- **Never use Forward+ features** — Do not use SDFGI, VoxelGI, advanced SSR, or volumetric fog. — source: ADR-0002

---

## Global Rules (All Layers)

### Naming Conventions
| Element | Convention | Example |
|---------|-----------|---------|
| Classes | PascalCase | `LightRay` |
| Variables | snake_case | `current_rotation` |
| Signals/Events | snake_case, past tense | `mirror_rotated` |
| Files | snake_case.gd | `light_ray.gd` |
| Scenes/Prefabs | PascalCase.tscn | `Mirror.tscn` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_REFLECTIONS` |

*(Source: `.claude/docs/technical-preferences.md`)*

### Performance Budgets
| Target | Value |
|--------|-------|
| Framerate | [TO BE CONFIGURED] |
| Frame budget | [TO BE CONFIGURED] |
| Draw calls | [TO BE CONFIGURED] |
| Memory ceiling | [TO BE CONFIGURED] |

### Approved Libraries / Addons
- None currently configured.

### Forbidden APIs (Godot 4.6)
These APIs are deprecated or unverified for Godot 4.6:
- **TileMap** — Use `TileMapLayer` instead. (Since 4.3)
- **VisibilityNotifier2D/3D** — Use `VisibleOnScreenNotifier2D/3D` instead. (Since 4.0)
- **YSort** — Use `Node2D.y_sort_enabled` instead. (Since 4.0)
- **Navigation2D/3D nodes** — Use `NavigationServer2D/3D` instead. (Since 4.0)
- **EditorSceneFormatImporterFBX** — Use `EditorSceneFormatImporterFBX2GLTF` instead. (Since 4.3)
- **yield()** — Use `await signal` instead. (Since 4.0)
- **String-based connect()** — Use `signal.connect(callable)` instead. (Since 4.0)
- **instance()** — Use `instantiate()` instead. (Since 4.0)
- **get_world()** — Use `get_world_3d()` instead. (Since 4.0)
- **OS.get_ticks_msec()** — Use `Time.get_ticks_msec()` instead. (Since 4.0)
- **duplicate() for nested resources** — Use `duplicate_deep()` instead. (Since 4.5)
- **bone_pose_updated signal** — Use `skeleton_updated` instead. (Since 4.3)
- **AnimationPlayer playback properties** — Use `AnimationMixer` base class equivalents instead. (Since 4.3)
- **GodotPhysics3D for new 3D projects** — Jolt Physics 3D is default. (Since 4.6)
- **Manual post-process viewport chains** — Use `Compositor` + `CompositorEffect`. (Since 4.3)

*(Source: `docs/engine-reference/godot/deprecated-apis.md`)*

### Cross-Cutting Constraints
- **Variadic Arguments**: Permitted and encouraged for debug/logging (4.5+).
- **Abstract Classes**: Enforce inheritance with `@abstract` (4.5+).
- **Dual-Focus UI**: Mouse/touch focus is separate from keyboard/gamepad focus. Ensure UI interactions do not trigger gameplay actions (ADR-0003, Godot 4.6).
- **Ripgrep Type**: Always use `rg --glob "*.gd"`, never `--type gdscript`.

*(Source: `docs/engine-reference/godot/current-best-practices.md`)*
