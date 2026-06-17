# Color Filter Mechanics GDD

## 1. Overview
The Color Filter system allows light rays to change colors when passing through filters, requiring symbols on the board to be lit by specific colors.

## 2. Core Mechanics

### Ray Colors
Rays carry a color property (represented as strings):
- `"white"` (Gold/white light, default)
- `"red"`
- `"green"`
- `"blue"`

### Color Propagation
- The source (Sun) emits white light.
- When a light ray strikes a Mirror, Prism, Bender, or Portal, the reflected or transmitted ray preserves the incoming ray's color.
- When a light ray passes through a **Filter**, the outgoing ray changes to match the filter's color (e.g., passing white through a Red Filter changes it to red).

### Symbol Target Verification
- Symbols require a specific color to activate. By default, they require `"white"`.
- If a symbol receives light that does **not** match its `required_color`, it remains unlit.
- If a matching color strikes the symbol, it illuminates and updates the level solve checker.
