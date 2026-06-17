# HUD Design

> **Status**: Approved
> **Author**: fanioz + ux-designer
> **Last Updated**: 2026-06-11
> **Template**: HUD Design

---

## HUD Philosophy

**Information-dense.** The HUD keeps all decision-relevant tools and controls permanently visible on screen. This ensures the player always has immediate access to their inventory, progress, and quick actions (like Reset and Pause) without needing to dig into menus or rely on contextual hovers. The interface is highly functional and transparent, complementing the precise, calculating nature of the optical puzzles.

---

## Information Architecture

### Full Information Inventory

1. Target Word & Deciphered Letters (Cipher UI)
2. Available Optical Tools & Quantities (Briefcase UI)
3. Current Level Number / Tier Progress
4. Pause / Settings Button
5. Reset / Clear Board Button

### Categorization

| Information | Category |
| ----------- | -------- |
| Available Optical Tools & Quantities | **Must Show** |
| Current Level Number / Tier Progress | **Must Show** |
| Pause / Settings Button | **Must Show** |
| Reset / Clear Board Button | **Must Show** |
| Target Word & Deciphered Letters | **Contextual** |

---

## Layout Zones

The HUD utilizes **"The Frame"** arrangement, prioritizing unobstructed central space for the puzzle board.

- **Top Bar (Left)**: Current Level Number / Tier Progress.
- **Top Bar (Right)**: Pause / Settings and Reset / Clear Board Buttons.
- **Top-Center Overlay**: Cipher UI (Target Word & Deciphered Letters) appearing dynamically just below the top edge.
- **Bottom Bar**: Briefcase UI spanning horizontally across the bottom, acting as a dock for all optical tools and quantities.
- **Center Space**: Reserved entirely for the active puzzle grid and neon light beams.

---

## HUD Elements

### Top Bar (Left)
- **Level Progress Indicator**: Stat display showing current level number (e.g., "Level 14"). Non-interactive.

### Top Bar (Right)
- **Reset Button**: Icon button (circular arrow). Interactive (Tap/Click to clear board).
- **Pause Button**: Icon button (two vertical lines). Interactive (Tap/Click to open Pause Menu).

### Bottom Bar
- **Briefcase Dock**: Horizontal container panel holding tool slots.
- **Tool Slots**: Draggable card/icon components displaying the tool icon (Mirror, Prism) and remaining quantity. Interactive (Drag to place on board). Introduced new pattern: Draggable Tool Slot.

### Top-Center Overlay
- **Cipher Word Display**: Text panel showing the target word with undiscovered letters as underscores. Non-interactive directly, but updates contextually when letters are deciphered.

---

## Dynamic Behaviors

- **Level Start (Entrance)**: The entire HUD fades in smoothly over 0.5s once the puzzle grid is fully rendered.
- **Tool Dragging**: When a tool is grabbed from the Briefcase, the active icon detaches and follows the cursor, glowing brighter. A ghostly, low-opacity outline of the tool remains in the dock slot to indicate origin.
- **Empty Tool Slot**: When a tool's available quantity reaches 0, the slot does not disappear. Instead, it dims to 40% opacity with a faint geometric vector outline, remaining readable but clearly inactive.
- **Victory State (Exit)**: Upon deciphering the final letter, the entire HUD (Top Bar, Briefcase) fades out entirely over 0.5s. A subtle "Click to Continue" prompt appears. This ensures maximum contrast so the "Luminescent Cascade" and the deciphered word dominate the screen without distraction.

---

## Platform & Input Variants

- **Universal Touch-First Sizing**: The HUD elements (buttons, tool slots) use a single universal scale designed to be large and touch-friendly by default. There is no dynamic scaling between PC and Mobile; the interface maintains the same proportions to ensure ease of interaction via both mouse clicks and touch taps.
- **Input Methods**: Fully supports Mouse (drag-and-drop, click) and Touch (tap, drag). No gamepad specific UI variants exist.

---

## Accessibility

- **Colorblind Support**: Crucial for a light-based game. While the void background provides extreme contrast naturally, neon light colors must be distinguishable. Tool slots and puzzle beams should rely on shape language and distinct intensity patterns (e.g., dotted lines, dashed lines, specific geometry) in addition to color. A dedicated Colorblind Mode toggle in settings will enhance these secondary visual cues.

---

## Open Questions

- None at this time.
