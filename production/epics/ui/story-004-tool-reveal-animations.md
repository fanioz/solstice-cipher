# Story 004: Tool Reveal Animations

> **Epic**: ui
> **Status**: Ready
> **Layer**: Core
> **Type**: Visual/Feel
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-005`

**ADR Governing Implementation**: ADR-0008-briefcase-ui.md
**ADR Decision Summary**: Visual animations within the 2D UI space for new tier introductions.

**Engine**: Godot 4.6 | **Risk**: LOW
**Engine Notes**: AnimationPlayer and CanvasItem Shaders recommended.

**Control Manifest Rules (this layer)**:
- Required: Visual effects must not interrupt or freeze the game thread.

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Play a brief "tool reveal" animation (showing tool name and description) the first time a new tier begins.
- [ ] Apply a subtle glow/pulse effect to the newly unlocked tool's Briefcase icon during the first 3 levels of its tier.

---

## Implementation Notes

*Derived from ADR-0008 Implementation Guidelines:*

- Use `AnimationPlayer` for the tool reveal pop-up.
- Use a simple `ShaderMaterial` on the icon's `TextureRect` for the glow/pulse effect, driving a time-based sine wave uniform.
- Save progress states to know when the first 3 levels have passed to disable the glow.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Save state progression logic (handled in Progression Epic). Simply expose a mechanism to trigger/disable these effects.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For UI / Visual stories — manual verification specs]:**

- **Manual check: Play a brief "tool reveal" animation (showing tool name and description) the first time a new tier begins.**
  - **Setup:** Load a save state just before unlocking a new tier of tools. Complete the level to trigger the new tier. Enter the next level.
  - **Verify:** Watch the UI as the new level initializes.
  - **Pass condition:** An animation successfully plays displaying the newly unlocked tool's name and description. Exiting and restarting the level does NOT play the animation again.

- **Manual check: Apply a subtle glow/pulse effect to the newly unlocked tool's Briefcase icon during the first 3 levels of its tier.**
  - **Setup:** Unlock a new tier. Proceed to play the 1st, 2nd, and 3rd levels of that tier in sequence. Finally, load the 4th level.
  - **Verify:** Observe the Briefcase icon for the newly unlocked tool during each level.
  - **Pass condition:** The glow/pulse VFX is clearly visible and looping on the icon during levels 1, 2, and 3. On level 4, the effect is entirely disabled.

---

## Test Evidence

**Story Type**: Visual/Feel
**Required evidence**:
- Visual: `production/qa/evidence/story_004_tool_reveal_animations.md` — must contain screenshots/videos of the working UI.

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 001
- Unlocks: None
