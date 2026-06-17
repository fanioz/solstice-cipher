# Story 004: Async Scene Instantiation

> **Epic**: procedural-generation
> **Status**: Ready
> **Layer**: Core
> **Type**: Integration
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-001`

**ADR Governing Implementation**: ADR-0004-procedural-generation-system.md
**ADR Decision Summary**: To prevent main thread freezing, the generation calculation will be chunked across frames using coroutines (`await get_tree().process_frame`) during the loading screen. We strictly avoid `WorkerThreadPool` for Web export compatibility.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: Verification required for loading screen freezing behavior. Web export compatibility must be preserved.

**Control Manifest Rules (this layer)**:
- Required: Static typing, async/await coroutine usage for chunked tasks.
- Forbidden: `WorkerThreadPool` or Thread classes for this generation step.
- Guardrail: Maintain 30 FPS minimum during loading screen generation.

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] The generation calculation must be chunked across frames using coroutines (`await get_tree().process_frame`) during the loading screen.
- [ ] Generation runs without main-thread freezing or dropping the loading screen FPS below 30.
- [ ] Web build exports and runs successfully.

---

## Implementation Notes

*Derived from ADR-0004 Implementation Guidelines:*

- Modify the `generate_puzzle` function to track processing time per frame (`Time.get_ticks_msec()`).
- If processing a chunk exceeds a targeted millisecond threshold (e.g., 8-10ms), `await get_tree().process_frame` to yield control back to the engine, allowing the loading screen animation to update.
- Do NOT use Threading due to SharedArrayBuffer restrictions in Web exports.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: Level Scaffolding.
- Story 002: Algorithm logic optimization.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: Generation calculation must be chunked across frames using coroutines.**
  - **Given:** A level generation request.
  - **When:** The generation process is executed in a controlled test environment tracking frame execution.
  - **Then:** The process yields execution back to the main thread multiple times before completion.
  - **Edge cases:** Extremely fast generation that could potentially complete in one frame; generation errors occurring mid-chunk.

- **Test: Generation runs without main-thread freezing or dropping loading screen FPS below 30.**
  - **Given:** A loading scene running a background level generation.
  - **When:** The framerate is monitored over the duration of the generation.
  - **Then:** The recorded FPS never drops below 30.
  - **Edge cases:** Worst-case generation retry loops (e.g., repeatedly failing to find a valid path and restarting).

---

## Test Evidence

**Story Type**: Integration
**Required evidence**:
- Integration: `tests/integration/procedural_generation/story_004_async_instantiation_test.gd` OR playtest doc

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 003
- Unlocks: None
