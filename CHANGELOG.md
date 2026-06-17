# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2026-06-15

### Changed
- **Tutorial Progression**: Adjusted the handcrafted tutorial flow (Levels 1–15) to follow a smooth character length progression (1-character for Levels 1–5, 2-character for Levels 6–10, 3-character for Levels 11–15).
- **Optimization**: Removed deprecated duplicate game scenes to optimize game size.

### Fixed
- **Level Blockers**: Fixed a progression blocker where Levels 4–10 were mathematically impossible to solve because light beams terminate upon hitting target glyphs and no splitting Prisms were provided (BUG-0006).

## [1.0.1] - 2026-06-13

### Added
- **HUD Indicator**: Added a level name and number indicator HUD at the top of the screen during gameplay (e.g., "LEVEL 3: SUN") (BUG-0005).

### Fixed
- **UI & Load Errors**: Fixed an issue where selecting Level 1 from the level select menu would fail to start the game (BUG-0003).
- **Progression Flow**: Fixed a level flow progression gap where completing Level 3 would incorrectly redirect players to the demo end screen instead of Level 4 (BUG-0004).

## [1.0.0] - 2026-06-13

### Added
- **Core Mechanics**: Implemented full set of optical elements (Mirrors, Prisms, Benders, Combiners, Shades, Portals).
- **Solver Engine**: Built custom Radial A* Solver with support for float quantization and snapped vector calculations.
- **Android Mobile Build**: Created Google Play Store export presets, configured portrait orientation, touch mouse emulation, and custom adaptive launcher icons.
- **Privacy Policy**: Created standard compliance privacy policy at `docs/privacy_policy.md`.
- **Release Checklists**: Created full Release and Launch checklists mapping QA, Store, and Operational sign-offs.

### Changed
- **Assets Optimization**: Converted all sprite formats to highly compressed `.webp` format for reduced binary size (30.5 MB final package).
- **Debug Print Cleanup**: Removed all 9 debug prints across gameplay and UI systems to ensure a clean release log.

### Fixed
- **UI Interaction**: Fixed `mouse_filter` bug on `BoardDropZone` in levels 2 and 3.
- **Scene Management**: Fixed null tree errors caused by deferred light updates during level transition.
- **Win Condition Timing**: Added a 1.0 second delay to the target-lit condition to ensure continuous illumination before triggering victory.
