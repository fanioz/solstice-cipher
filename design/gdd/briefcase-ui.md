# Briefcase UI & Inventory System GDD

## 1. Overview
The Briefcase UI serves as the player's inventory, containing a budget of optical components (mirrors, prisms, filters, etc.) that can be placed on the board to solve puzzles.

## 2. Core Mechanics

### Inventory Budget
- Each level defines a starting inventory (e.g. `{"mirror": 2, "prism": 1}`).
- The slots display the current count of available items.
- If the count for a slot is `0`, the slot is disabled/faded.

### Spawning (Drag & Drop)
- Players click and drag an item out of a slot.
- A translucent drag preview follows the mouse cursor.
- Dropping the item on a valid board location instantiates the piece at that position.
- Spawning decrements the slot's count.

### Reclaiming (Drag Back)
- Placed board pieces can be clicked and dragged back into the Briefcase area (defined as `Y > 1120` in the resolution coordinate system).
- Dropping a piece in the Briefcase area deletes it from the board and increments its inventory count.

## 3. UI Representation
- **BriefcaseUI**: Dark semi-transparent container anchored at the bottom of the screen.
- **BriefcaseSlot**: Vertical container containing the tool icon and a text label indicating count (e.g., "x2").
