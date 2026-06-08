# Mobile Export & Compatibility

## Overview
Solstice Cipher must natively support execution on Android, iOS, and mobile web browsers without code fragmentation. The game will rely on Godot's HTML5 export with mobile-first touch scaling rather than requiring native compiled app store packages.

## Rules
- **Resolution Handling**: The engine must use `window/stretch/mode="canvas_items"` and `stretch/aspect="expand"` to dynamically adapt to varying mobile aspect ratios (e.g., 16:9, 19.5:9).
- **Touch Targets**: All interactive elements (mirrors, splitters) must maintain a minimum collision radius of `100px` to support "fat-finger" touch inputs.
- **Visual Feedback**: Desktop "hover" states are deprecated in favor of immediate tactile scaling (1.15x pop) upon `InputEventScreenTouch`.
- **Export Target**: The project will build to standard WebAssembly. No desktop-exclusive or non-web-compatible Godot plugins may be used.

## Acceptance Criteria
- [ ] The game loads and runs at 60 FPS in mobile Safari (iOS) and mobile Chrome (Android).
- [ ] The Cipher UI remains anchored to the top of the screen and is not cut off by device notches.
- [ ] The player can successfully grab, rotate, and drop a mirror using purely capacitive touch (no mouse).
