# ADR-0002: Rendering Engine (Compatibility)

## Status
Accepted

## Date
2026-06-09

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Rendering |
| **Knowledge Risk** | HIGH |
| **References Consulted** | `docs/engine-reference/godot/modules/rendering.md`, `docs/engine-reference/godot/breaking-changes.md` |
| **Post-Cutoff APIs Used** | None |
| **Verification Required** | HTML5 Export Validation, visual parity checks without Forward+ features. |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | None |
| **Enables** | None |
| **Blocks** | None |
| **Ordering Note** | Foundational rendering decision impacting all visual asset creation. |

## Context

### Problem Statement
The project needs to select a rendering backend that guarantees broad platform support, specifically allowing the game to be exported and played via Web browsers (HTML5). 

### Constraints
- Must support WebGL 2 via HTML5 export.
- Must run acceptably on lower-end devices.

### Requirements
- Provide adequate visual fidelity for the art style without relying on high-end features like hardware raytracing or advanced SSR.

## Decision

We will use the **Compatibility (OpenGL 3.3 / WebGL 2)** rendering backend as the default for the project.

### Architecture Diagram
N/A - Project Setting (`rendering/renderer/rendering_method="gl_compatibility"`).

### Key Interfaces
- Shaders must be written with GLES3 limitations in mind.
- Advanced post-processing and volumetric effects that require Forward+ are disallowed.

## Alternatives Considered

### Alternative 1: Forward+
- **Description**: Default Godot 4.x renderer utilizing Vulkan or D3D12.
- **Pros**: Access to advanced features like SDFGI, VoxelGI, advanced SSR, volumetric fog, and clustering.
- **Cons**: Does not support Web export. Requires relatively modern hardware.
- **Rejection Reason**: Violates the constraint of HTML5 web export compatibility.

### Alternative 2: Mobile
- **Description**: Vulkan/Metal backend optimized for mobile.
- **Pros**: Good performance on mobile devices, better feature set than Compatibility.
- **Cons**: Still no Web export support.
- **Rejection Reason**: Violates the constraint of HTML5 web export compatibility.

## Consequences

### Positive
- Guaranteed support for HTML5 browser exports.
- Lowest hardware barrier to entry for players.

### Negative
- Cannot use high-end 3D features (SDFGI, VoxelGI, advanced SSR, volumetric fog).
- Visuals must rely on baked lighting, clever shaders, and strong art direction rather than brute-force rendering features.

### Risks
- Art team may accidentally use Forward+ specific nodes or features.
- **Mitigation**: Automated checks in the asset pipeline or QA process to ensure scenes render correctly in the Compatibility backend.

## GDD Requirements Addressed

| GDD System | Requirement | How This ADR Addresses It |
|------------|-------------|--------------------------|
| N/A | Target Platform: Web | Ensures the engine renderer can compile to WebGL 2. |

## Performance Implications
- **CPU**: Lower driver overhead compared to heavy Forward+ pipelines on older machines.
- **Memory**: Lower VRAM requirements as high-end features are disabled.
- **Load Time**: Generally faster shader compilation than Vulkan/D3D12.
- **Network**: N/A

## Migration Plan
If not already set, open Project Settings -> Rendering -> Renderer -> Rendering Method -> set to `gl_compatibility`.
Existing scenes must be visually audited to ensure they do not rely on missing Forward+ features.

## Validation Criteria
- Project successfully exports to Web without rendering crashes.
- No console spam regarding missing Vulkan/D3D12 features when running the game.

## Related Decisions
- None
