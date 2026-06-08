# Title Screen UX Spec

## User Flows

1. **Boot Sequence**: The player launches the game and is immediately presented with the Title Screen. The background particles and WorldEnvironment glow are active to establish atmosphere.
2. **Game Start**: The player presses the "Begin Journey" button.
3. **Transition**: The `TransitionManager` Singleton captures the input and initiates a 1-second smooth fade-to-black.
4. **Level Load**: Once the screen is completely black, the engine swaps the active scene to `level_1.tscn` and fades back in, handing control over to the player.

## Interaction States

Definitions for the primary "Begin Journey" interface element:

- **Normal**: The button rests at default scale (1.0x). Text color is standard cyan `#00FFFF` and emits a subtle HDR glow.
- **Hover**: On desktop, the mouse cursor changes to a pointing hand. The button scales up (1.05x) and the font color shifts to a brighter, whiter cyan to indicate interactivity. On mobile, this state is skipped.
- **Focus**: For keyboard/gamepad navigation, the button receives a high-contrast bounding box or glowing underline to indicate selection.
- **Disabled**: N/A (The start button is always enabled).
- **Error**: N/A.

## Wireframe Description

- **Background**: A live 2D scene acting as the backdrop. The environment is dark (`#0d0d14`) with a floating dust particle system. A dummy laser setup (Sun and Mirror) fires across the screen to establish the game's core visual identity immediately.
- **Title Block**: Centered in the top third of the screen. The text "SOLSTICE CIPHER" is rendered in a large, clean font, colored in a bright, glowing gold (`#FFD700`).
- **Subtitle Block**: Centered directly below the main title. The text "Decrypt the Light" is rendered in a smaller, cyan font (`#00FFFF`).
- **Primary Action Area**: The "Begin Journey" button is anchored to the bottom third of the screen, center-aligned, with generous padding to isolate the touch target for mobile readiness.

## Accessibility Notes

- **Keyboard Navigation**: The "Begin Journey" button must be explicitly set to focusable in Godot so players can navigate to it using `Tab` or a gamepad `D-pad`, and trigger it using `Enter` or the primary action button.
- **Color Contrast Ratio**: The dark room background (`#0d0d14`) against the glowing gold (`#FFD700`) and cyan (`#00FFFF`) text easily exceeds the WCAG AAA contrast ratio requirements for large text.
- **Screen Reader Considerations**: The text label "Begin Journey" is highly descriptive of the action.
- **Motion Sensitivity**: The background dust particles and laser animations are slow, ambient, and non-flashing. It is safe for most players, but an option to disable background animations could be considered in a future settings menu for users with severe vestibular disorders.
