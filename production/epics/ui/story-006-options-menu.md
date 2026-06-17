# Story 006: Options Menu

> **Epic**: ui
> **Status**: Complete
> **Layer**: Presentation
> **Type**: Integration
> **Estimate**: 2.0
> **Manifest Version**: 2026-06-09
> **Last Updated**: 2026-06-13

## Context

**GDD**: `design/gdd/game-concept.md`
**Requirement**: Allow players to toggle Fullscreen and adjust audio bus volumes.

**ADR Governing Implementation**: N/A
**ADR Decision Summary**: N/A

**Engine**: Godot 4.6 | **Risk**: LOW

## Acceptance Criteria

*From GDD, scoped to this story:*

- [x] Create an `options_menu.tscn` CanvasLayer overlay.
- [x] Integrate sliders for Master, BGM, and SFX buses.
- [x] Integrate toggle for Fullscreen mode.
- [x] Extend `SaveManager` to persist settings to `user://settings.cfg`.
- [x] Add Options buttons to Title Screen and Level Select screen.

## Implementation Notes

Use `ConfigFile` for settings to keep it distinct from the game progression dictionary.

## QA Test Cases

- **Manual check**: Volume persistence
  - Setup: Start game, change BGM volume, close game.
  - Verify: Open game again, BGM volume slider remembers position and actual bus volume is set correctly.

## Dependencies

- Depends on: Epic Audio
- Unlocks: None
