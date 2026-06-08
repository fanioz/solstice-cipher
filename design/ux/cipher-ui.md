# Cipher UI UX Spec

## User Flows

1. **Initialization**: The player enters a level. The Cipher UI initializes at the top of the screen, dynamically generating a row of underscore placeholders (e.g., `_ _ _`) based on the length of the current level's target word.
2. **Partial Decryption**: The player successfully directs a laser into a Symbol node. The game emits a signal to the UI, which replaces the specific underscore with the decrypted letter (e.g., `S _ _`) accompanied by a brief visual pulse.
3. **Full Decryption**: The player illuminates the final remaining Symbol node. The UI populates the final letter (e.g., `S U N`).
4. **Victory Trigger**: The UI detects that the word array is complete and emits a `level_solved` signal to the main game loop to initiate the level transition.

## Interaction States

The Cipher UI is a non-interactive display element, so traditional input states do not apply, but its display states convey critical game logic:

- **Normal (Encrypted)**: Displayed as a dim, cyan underscore (`_`).
- **Hover**: N/A (HUD is non-clickable).
- **Focus**: N/A.
- **Disabled**: N/A.
- **Error**: N/A.
- **Decrypted (Active)**: Replaces the underscore with the target letter (e.g., `M`). The letter is rendered in bright, glowing gold (`#FFD700`) to match the laser color and immediately draw the player's eye.

## Wireframe Description

- **Layout Container**: An `HBoxContainer` wrapped inside a `MarginContainer` anchored to the top edge of the screen (`anchors_preset = 10`), spanning the full screen width.
- **Alignment**: The `HBoxContainer` is centered horizontally (`alignment = 1`), guaranteeing the letters always appear perfectly centered at the top of the screen regardless of word length or mobile/desktop aspect ratio.
- **Typography**: Employs a clean, bold monospace or sans-serif font, sized large enough (e.g., 64px) to be highly legible without blocking the gameplay area beneath it.
- **Spacing**: A fixed `theme_override_constants/separation` is applied between each character label so they don't visually crowd each other.

## Accessibility Notes

- **Keyboard Navigation**: Not applicable, as this is a read-only HUD element that does not accept player input.
- **Color Contrast Ratio**: The dark background (`#0d0d14`) against the glowing gold (`#FFD700`) and cyan (`#00FFFF`) text easily exceeds the WCAG AAA contrast ratio requirements for large text.
- **Screen Reader Considerations**: If the game is ported to HTML5 with screen reader support, an ARIA-live region could be used to announce when a letter is decrypted (e.g., "Letter M decrypted") and when the full word is complete.
- **Visual Feedback**: The color shift from cyan (encrypted) to gold (decrypted) is paired with a distinct brightness shift, ensuring players with colorblindness can still easily detect state changes through luminance/brightness rather than hue alone.
