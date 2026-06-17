# Story 001: Sound Effects & Audio Integration

> **Epic**: audio
> **Status**: Complete
> **Layer**: Presentation
> **Type**: Visual/Feel
> **Estimate**: 2.0
> **Manifest Version**: 2026-06-09
> **Last Updated**: 2026-06-13

## Context

**GDD**: `design/gdd/game-concept.md`
**Requirement**: "Crisp UI sounds, satisfying crystal chimes for light bounces"

**ADR Governing Implementation**: N/A
**ADR Decision Summary**: N/A

**Engine**: Godot 4.6 | **Risk**: LOW

## Acceptance Criteria

*From GDD, scoped to this story:*

- [x] Create and import `~5` UI sound effects (`.ogg` or `.wav`).
- [x] Create and import `~5` Gameplay sound effects (crystal chimes/bounces).
- [x] Create and import `~2` Background music tracks.
- [x] Add `AudioStreamPlayer` nodes to `main.tscn`, `briefcase_ui.tscn`, and tool scenes where appropriate.
- [x] Implement an Audio bus or simple audio manager to handle playback.

## Implementation Notes

We need to source or generate the audio assets first. Once acquired, an `AudioManager` autoload is recommended to play non-spatial UI and global sound effects easily without scene clutter.

## QA Test Cases

- **Manual check**: Audio plays during gameplay
  - Setup: Start Level 1.
  - Verify: Place a mirror, let the beam hit it, click UI buttons.
  - Pass condition: BGM plays seamlessly, crystal chimes play on bounce, UI sounds play on interaction.

## Dependencies

- Depends on: None
- Unlocks: None
