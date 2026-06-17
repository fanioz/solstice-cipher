# Game Concept: Solstice Cipher

*Created: 2026-06-10*
*Status: Approved*

---

## Elevator Pitch

> It's an optical logic puzzle where you place tools from a limited briefcase inventory to route light beams into floating letter Glyphs, spelling out words across 100 increasingly complex levels.

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Optical Logic Puzzle / Word Puzzle |
| **Platform** | PC (Steam) & Mobile (iOS / Android) |
| **Target Audience** | Analytical Thinkers, Puzzle Solvers |
| **Player Count** | Single-player |
| **Session Length** | 5-15 minutes (Quick drop-in/drop-out) |
| **Monetization** | Premium |
| **Estimated Scope** | Medium (100 Levels: 15 hand-crafted tutorials, 85 procedurally generated) |
| **Comparable Titles** | The Witness, Laser Match, Wordscapes |

---

## Core Fantasy

You are decoding the secrets of light and language. By predicting trajectories and managing a limited inventory of optical tools, you spell out mystical words. The pure satisfaction comes from the procedural variety and the moment when the scattered beams finally hit the right letters to complete the cipher.

---

## Unique Hook

Mind-bending optical physics (reflection, splitting, color filtering) combined with a word-spelling mechanic and a highly replayable procedural generation system that guarantees solvable, infinite puzzles.

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics (What the player FEELS)

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Sensation** | 2 | Instant, highly satisfying audiovisual feedback of light beams aligning and letters decrypting. |
| **Challenge** | 1 | Pushing spatial logic and inventory management to route light correctly. |
| **Discovery** | 3 | Understanding the spatial relationships and unlocking new tools every 10 levels. |
| **Submission** | 4 | A relaxed, untimed environment for contemplation and continuous puzzle-solving. |

### Key Dynamics (Emergent player behaviors)

- Players will drag and drop tools from the Briefcase, experimenting with beam routing.
- Players will focus on lighting up the correct Glyphs in any order to spell the word.
- Players will constantly manage their piece budget to find the most efficient routing.

### Core Mechanics (Systems we build)

1. **Light Propagation Engine:** Accurate raycasting that bounces, splits, and filters based on placed optic nodes.
2. **Briefcase UI System:** Drag-and-drop inventory management for placing limited tools (Mirrors, Prisms, Filters, etc.) on the board. Includes Right-Click to return a single tool to inventory.
3. **Procedural Generation System:** Algorithm that backwards-solves from Glyphs to the Source to generate guaranteed solvable levels. Must guarantee complexity scales to meet a 2-minute target solve time per puzzle.
4. **Cipher Mechanic:** Decrypting letter Glyphs by hitting them with the correct color/beam to spell words.

---

## Visual Identity Anchor

**Direction Name:** Neon Cipher
**One-Line Rule:** Clean, crisp UI-driven design where glowing neon beams cut through a dark void.

**Supporting Principles:**
- **Sleek & Digital:** The aesthetic should lean towards clean vectors, smooth UI transitions, and glowing neon against deep dark backgrounds.
- **Readable Board:** The grid and tools must be instantly readable; no visual clutter to distract from the puzzle logic.
- **Clear Feedback:** Unlocked letters glow brightly, distinguishing decrypted states clearly.

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** | The game never tells the player the answer; they derive it entirely from observable rules and experimentation. | Core |
| **Competence** | Solving procedural puzzles and managing a tight inventory budget makes the player feel clever. | Core |

### Player Type Appeal (Bartle Taxonomy)
- [x] **Achievers** — How: Beating all 100 levels and mastering the mechanics.
- [x] **Explorers** — How: Unlocking all 7 tools and seeing how they interact.

### Flow State Design
- **Onboarding curve**: 15 hand-crafted levels teach the basic tools (Mirrors, Prisms).
- **Difficulty scaling**: Every 15 levels (a "Tier"), a new tool is introduced. The piece budget tightens, and the word length increases.
- **Feedback clarity**: Light beams update instantly as tools are placed. Letters light up in the Cipher UI immediately.
- **Recovery from failure**: No fail states. The player just drags pieces back to the Briefcase and tries again.

---

## Core Loop

### Moment-to-Moment (30 seconds)
Dragging tools from the Briefcase onto the board. Rotating them to snap the beam into a letter Glyph. Watching the UI update with the decrypted letter.

### Short-Term (5-15 minutes)
Completing a puzzle level by successfully lighting all Glyphs to spell the target word, then advancing to the next level in the tier.

### Session-Level (30-60 minutes)
Completing a full tier (10 levels), mastering the newly introduced tool, and unlocking the next tier.

### Long-Term Progression
Working through the 100-level campaign to master all 7 tools and complete the Solstice Cipher.

### Retention Hooks
- **Tool Progression**: Wanting to unlock the next tool (e.g., Portal, Combiner) to see what it does.
- **Bite-sized Puzzles**: The 100-level format encourages "just one more level" gameplay.

---

## Game Pillars

### Pillar 1: Light is the Absolute Mechanic
Every puzzle, interaction, and solution must fundamentally revolve around manipulating light rays or casting shadows.

### Pillar 2: Algorithmic Infinite Replayability
The game relies on a robust procedural generation system to ensure infinite solvable puzzles. High volume and variety of puzzles are key to the experience.

### Pillar 3: Mechanical Escalation
The difficulty curve relies on unlocking new tools (Mirrors -> Prisms -> Filters -> Portals) and combining them to solve longer word ciphers.

### Pillar 4: Intuitive Predictability
The behavior of light must remain predictable, consistent, and instantly readable. Difficulty must arise strictly from the spatial configuration and piece budget.

### Anti-Pillars (What This Game Is NOT)
- **NOT time-pressured**: No countdowns. We want pure contemplation.
- **NOT a heavy physics simulation**: Keep the interaction simple, drag-and-drop, snapping to grids/angles.
- **NOT punishing**: No game-overs. Exploration of solutions is safe.

---

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| **Recommended Engine** | Godot 4.6 (Compatibility Renderer) - Best for cross-platform 2D/3D UI logic and mobile performance. |
| **Key Technical Challenges** | 1. Procedural Generation Algorithm ensuring 100% solvability. 2. Raycast recursion limits for infinite light bounces. |
| **Art Style** | 2D/3D Stylized (Neon Cipher aesthetic) |
| **Art Pipeline Complexity** | Low-Medium (Requires clean vector/UI art and simple glowing 3D objects or 2D sprites). |
| **Audio Needs** | Moderate. Crisp UI sounds, satisfying crystal chimes for light bounces. |
| **Networking** | None |
| **Content Volume** | 100 levels (15 hand-crafted, 85 procedural). |

---

## Risks and Open Questions

### Design Risks
- Procedural generation might create puzzles that are solvable but not "fun" or "elegant".
- The UI might become cluttered on mobile devices with large Briefcase inventories.

### Technical Risks
- Main thread freezing during procedural generation of complex levels.
- Raycasting performance on mobile devices with dozens of bounces.

### Scope Risks
- The procedural algorithm may be harder to perfect than anticipated, requiring significant iteration to ensure it produces good puzzle variety.

---

## MVP Definition

**Core hypothesis**: Players find routing light with a limited drag-and-drop inventory to spell words highly satisfying and replayable.

**Required for MVP**:
1. Briefcase UI with drag-and-drop piece placement.
2. Light beam propagation with reflection logic (Mirrors only).
3. Cipher UI that decrypts when letter Glyphs are hit.
4. A basic version of the procedural generation algorithm capable of producing solvable 3-letter word puzzles.

**Explicitly NOT in MVP**:
- Advanced tools (Filters, Portals, Combiners).
- Full 100-level tier progression.
- Complex 3D environments.

### Scope Tiers

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | Procedural engine + Mirrors | Briefcase UI, Basic Raycasting | Weeks |
| **Vertical Slice** | Tiers 1-3 (30 levels) | Mirrors, Prisms, Filters | 1 Month |
| **Full Vision** | 100 levels | All 7 tools, full generation | 2-3 Months |

