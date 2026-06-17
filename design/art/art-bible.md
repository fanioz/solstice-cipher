# Solstice Cipher - Art Bible

> **Art Director Sign-Off (AD-ART-BIBLE)**: APPROVED

## 1. Visual Identity Statement

**Direction Name:** Neon Cipher

**One-Line Visual Rule**
"Luminescence is function; everything else is the void." 
*(If an element does not emit, modify, or receive light, it must be dark and recede into the background.)*

**Supporting Visual Principles**

1. **Information Over Aesthetics**
   *Anchored to Pillar 4: Intuitive Predictability*
   The state of the light beam must be the most visually prominent element on the screen at all times. Glow, bloom, and high color saturation are reserved strictly for active light trajectories and the tools currently manipulating them.
   **Design Test**: When deciding how much detail to add to a background tile, this principle says choose to strip texture and brightness away so the active neon beams remain instantly readable.

2. **Geometric Modularity**
   *Anchored to Pillar 2: Algorithmic Infinite Replayability*
   Because levels scale infinitely through procedural generation, visual assets must be inherently modular. We use a crisp, grid-aligned, vector-style UI aesthetic so that any generated combination of pieces feels like a deliberately designed, cohesive circuit board.
   **Design Test**: When designing the edge boundaries for a randomly generated level, this principle says choose clean, straight, snapping neon lines over organic or irregular shapes to ensure the algorithmic seams always look intentional.

3. **Color as Mechanical Language**
   *Anchored to Pillar 3: Mechanical Escalation*
   As complexity scales with new tools (prisms, color filters, portals), color must never be used for mere decoration. Specific neon hues are strictly mapped to specific mechanical states or components (e.g., Cyan = raw light, Magenta = filtered light, Yellow = target Glyphs).
   **Design Test**: When picking an accent palette for a newly unlocked optical tool, this principle says choose a starkly distinct, unused neon hue rather than an aesthetic gradient to ensure it immediately signals a new gameplay mechanic.

## 2. Mood & Atmosphere

### 1. Main Menu / Level Select (The Dormant Grid)
- **Emotional Target**: Anticipation and stark clarity; the feeling of booting up a dormant, high-precision supercomputer.
- **Lighting Character**: Low contrast, cool and desaturated tones. Deep space void (pitch black/dark navy) with a faint, ambient presence. Think "pre-dawn" darkness.
- **Visual Element**: A faint, slow-breathing cyan or deep blue glow on unselected puzzle nodes. When navigating, a selected node emits a sharp, stable white light that momentarily traces the underlying, rigid vector grid connecting the system, emphasizing modularity.

### 2. Active Puzzle Solving (The Circuit Awakens)
- **Emotional Target**: Deep focus, flow-state, and analytical tension.
- **Lighting Character**: Extreme high contrast. A pitch-black void set against highly saturated, piercing neon trajectories. Zero ambient lighting—only active, functioning mechanics cast light. 
- **Visual Element**: The active light beams themselves. They cast sharp, mathematically precise reflections on nearby interactive geometry (mirrors/prisms). The background grid from the level select fades entirely into the void so visual priority is 100% on the mechanical routing and neon hues.

### 3. Word Decrypted / Victory (The Luminescent Cascade)
- **Emotional Target**: Catharsis, revelation, and triumphant completion.
- **Lighting Character**: Warm, high-exposure burst. Contrast momentarily drops as the screen floods with localized, controlled bloom. Think "high noon" brilliance, but purely synthetic and geometric.
- **Visual Element**: A shockwave of pure gold/warm-white light travels backward along the established trajectories, overcharging the completed circuit into a blinding, cohesive geometric shape. It then snaps instantly to black, revealing the deciphered word in crisp, glowing, high-intensity typography.

### 4. Failure / Reset (The Void Claims)
- **Emotional Target**: Sudden absence, cold reset, and brief disorientation.
- **Lighting Character**: Instant light decay. Pitch black void with harsh, flickering falloff of previous light sources.
- **Visual Element**: The active light beams abruptly sever and retract, leaving a momentary trailing dark red/orange "burn" or "cooling" effect at the endpoints. The vector UI stutters with sharp, grid-aligned visual noise (like a mechanical short-circuit) before snapping back to the dormant Level Select state.

## 3. Shape Language

### Shape Language Definition: The Perfected Circuit

**1. Primary Shape Principle: Orthogonal & Angular Dominance (The Grid)**
*   **Description**: Strict adherence to geometric primitives (squares, perfect hexagons, and 45/90-degree angles). Complete absence of organic curves, soft edges, or irregular polygons. All forms snap to an invisible, mathematical grid.
*   **Connection to Visual Identity**: Defines the "Geometric Modularity" and "cohesive circuit board" aesthetic. The stark contrast between sharp geometry and nothingness reinforces that "everything else is the void."
*   **Connection to Pillar**: **Intuitive Predictability**. By restricting shapes to predictable, grid-aligned geometry, the player can instantly calculate angles, intersections, and the exact trajectory of light without ambiguity.
*   **Emotional Communication**: Deep focus and analytical tension. It makes the player feel cold, calculating, and precise—like they are operating the logic gates of a dormant supercomputer. It strips away distraction, demanding absolute concentration.

**2. Secondary Shape Principle: High-Contrast, Unbroken Vectors (The Path)**
*   **Description**: Razor-sharp, uniform line weights that represent the travel of light. Lines never taper off; they either terminate sharply at a node or extend infinitely.
*   **Connection to Visual Identity**: Directly executes "Luminescence is function." The vector-style aesthetic ensures that the active elements (the light) are the only things cutting through the void.
*   **Connection to Pillar**: **Light is the Absolute Mechanic**. The vector paths *are* the gameplay. Their crisp, unbroken nature defines the core mechanical interaction.
*   **Connection to Mood**: When completed, these lines flare into "blinding geometric completion" (Victory). When inactive, they sit as thin, dormant conduits (Main Menu).
*   **Emotional Communication**: Clarity, objective truth, and triumphant power. Watching a sharp line snap perfectly into a node triggers a deep sense of mechanical satisfaction and rightness. 

**3. Tertiary Shape Principle: Fractal Fragmentation (The Noise)**
*   **Description**: Sharp, jagged offsets, intersecting glitch blocks, and sudden, rigid subdivisions of the primary grid. These shapes are still mathematical but represent corrupted or chaotic data.
*   **Connection to Visual Identity**: Fulfills the "Sharp, grid-aligned visual noise" required for failure states.
*   **Connection to Pillar**: **Mechanical Escalation** & **Algorithmic Infinite Replayability**. As the puzzles become more complex, the shapes subdivide and fragment, visually representing the escalating complexity of the algorithm.
*   **Emotional Communication**: Anxiety, tension, and systemic failure. When the grid fragments, it feels jarring and mathematically "wrong," communicating a stark error state without relying on traditional red screens or organic blood splatters.

## 4. Color System

### Color Palette & Hex Codes

**The Void (Backgrounds)**
- **True Void (Active Puzzle):** `#050508` (Near-pitch black with a microscopic cool tint for depth)
- **Dormant Void (Main Menu):** `#0B0C10` (Deep space void, slightly lifted)

**Light & Energy (Core Mechanics)**
- **Active Light Beam (Primary):** `#00FFFF` (Neon Cyan) - The absolute brightest element on screen.
- **Inactive Elements (Secondary):** `#1F4040` (Muted Teal/Cyan) - Visible but explicitly unpowered.

**Mechanical Entities**
- **Light Emitter (Source):** `#FFFFFF` (Pure White core) with a `#00FFFF` (Cyan) outer glow.
- **Mirrors (Reflectors):** `#E0E0E0` (Silver/White vector lines) - Neutral and highly reflective.
- **Prisms (Splitters):** `#FF00FF` (Neon Magenta) - Distinct from the primary beam, indicating state change/refraction.
- **Receivers (Targets):** 
  - *Unpowered:* `#003300` (Dark Green)
  - *Powered:* `#00FF00` (Neon Green)
- **Blocked Paths / Obstacles:** `#1A1A1A` (Dark Grey grids/lines). If the beam hits them, a brief `#FF3333` (Red) warning flare occurs at the impact point.

**Feedback & Mood States**
- **Victory (Completion):** `#FFD700` (Gold) and `#FFF8E7` (Warm White) - An expanding shockwave replacing the cold cyan.
- **Failure (Decay/Disconnection):** `#FF3300` (Electric Orange/Red) - Sharp flickers transitioning to dormant void.

### Contrast Strategy for Readability
1. **Luminance as Hierarchy:** The void absorbs all light. Only functional mechanics emit light. The player's eye will instantly track the `#00FFFF` beam against the `#050508` void due to maximum contrast.
2. **Zero Ambient Light:** There is no global illumination or ambient light. Shadows do not exist; there is only light and the absence of light.
3. **Accessibility (Color Blindness):** The palette uses distinct hues (Cyan, Magenta, Green, Silver). Even in grayscale, the active elements (100% luminance) will sharply contrast with inactive elements (<20% luminance) and the void (1% luminance).

## 5. Character Art Direction
N/A - No characters in this design. The "actors" in this game are the optical tools (Mirrors, Prisms) and the light beams themselves, which are governed by the Shape Language and Color System.

## 6. Environment & Level Art
The "environment" is a strict, abstract void space governed by the Grid.
- **The Void**: Pure black/dark navy background with zero ambient lighting.
- **The Grid / Node Sockets**: Faint, subtle geometric outlines (cyan/blue) that indicate where tools can be placed. These fade out entirely when the puzzle is active to maintain focus on the beams.
- **Level Boundaries**: Clean, straight, snapping neon lines that border the playable area, keeping the algorithmic seams looking intentional and cohesive.
- **Obstacles**: Dark grey grid lines/blocks that block light.

## 7. UI Visual Language
- **Briefcase Inventory**: A sleek, high-tech interface. When open, it displays tools in stark, grid-aligned slots. Minimal text, relying on clear iconography.
- **Iconography**: Vector-based, flat icons using geometric primitives that perfectly match the shape language of the active tools.
- **Typography**: Crisp, high-intensity typography for deciphered words. No overly decorative fonts—fonts should feel like a terminal or clean sci-fi HUD (e.g., monospace or modern sans-serif).
- **HUD Elements**: Unobtrusive, dark and recessed until interacted with, lighting up sharply when selected or used.

## 8. Asset Standards

**1. Textures & 2D Sprites**
* **Format:** `.webp` (Lossless for sharp lines, Lossy for baked glows). Avoid PNGs for web payload size.
* **Dimensions:** MUST be Power of Two (POT) for WebGL memory optimization.
* **Max Atlas/Spritesheet Size:** `2048x2048`. (Reject if > 2048x2048).
* **Max Individual Sprite Size:** `512x512`. (Reject if > 512x512).
* **Import Settings:** Mipmaps **OFF**, Compress Mode **Lossless/VRAM Uncompressed**, Filter **Nearest** (for crisp vector edges) or **Linear** (if soft glow).

**2. Geometry & Poly Counts**
* **2D Polygons / Line2D Points:** Max `512` vertices per node. (Reject if > 512).
* **3D Meshes (if using pseudo-3D nodes):** Max `500` triangles per mesh. (Reject if > 500).
* **Overdraw Limit:** Max `4` overlapping transparent layers per screen region (WebGL alpha blending bottleneck).

**3. Materials & Shaders**
* **Material Type:** `CanvasItemMaterial`. Light Mode MUST be **Unshaded**. Real-time 2D lights should be avoided entirely.
* **Blend Modes:** `Add` (for neon light combining) or `Mix`.
* **Custom Shaders (`ShaderMaterial`):** Must be GLES3/WebGL2 compliant. `for`/`while` loops and complex branching are **STRICTLY FORBIDDEN**.
* **WorldEnvironment Glow:** Enabled, but highly restricted. High Quality **OFF**, Bicubic Upscale **OFF**, Blend Mode **Additive**, limit active levels to 2 or 3.

**4. Fonts**
* **Format:** `.ttf` or `.otf` imported as **MSDF** (Multichannel Signed Distance Field) to allow infinite crisp scaling without massive raster textures.
* **Max Font Texture Size:** `1024x1024`. (Reject if > 1024x1024).

**5. Audio**
* **SFX:** `.wav` format. Max duration **2.0 seconds**. (Reject if > 2.0s).
* **Music/Ambience:** `.ogg` format. Max bitrate **96 kbps**. (Reject if > 96 kbps).

## 9. Style Prohibitions

Any visual choice that breaks the rule *"Luminescence is function; everything else is the void"* must be strictly avoided. The following elements will result in an immediate rejection of a piece of art:

**1. No Organic Curves or Imperfect Geometry**
*   **Prohibited:** Hand-drawn lines, rough edges, irregular polygons, Bezier curves, or soft, fluid shapes.
*   **Reasoning:** Everything must snap to the rigid mathematical grid. Geometric modularity and 45/90-degree angles are absolute.

**2. No Realistic or PBR Materials**
*   **Prohibited:** Textures, noise maps, metallic reflections, bump maps, dirt, scratches, or realistic shading.
*   **Reasoning:** *"Everything else is the void."* Surfaces must be flat vectors, clean colors, or pure voids. Ambient light does not exist, so complex material responses have no place here.

**3. No Decorative or Ambient Lighting**
*   **Prohibited:** Global illumination, ambient occlusion, soft drop shadows, atmospheric scattering, or background gradients.
*   **Reasoning:** Luminescence is purely functional. If something emits or receives light, it must be part of the active mechanical circuit. Shadows are non-existent; only pitch-black voids exist where there is no active light.

**4. No Aesthetic Gradients or Unassigned Colors**
*   **Prohibited:** Pastel palettes, muted earth tones, complex color gradients, or using colors purely for visual flair.
*   **Reasoning:** Color is a mechanical language. Each neon hue (e.g., Cyan, Magenta, Gold) strictly maps to a specific mechanical state or tool. Randomly chosen colors destroy the intuitive predictability of the circuit.

**5. No Softness or Ambiguity**
*   **Prohibited:** Gaussian blurs (except for controlled, highly localized neon bloom on active elements), feathered masking, or blurry edges.
*   **Reasoning:** The visual identity demands razor-sharp, unbroken vectors. Softness implies ambiguity, which contradicts the cold precision and analytical tension of the aesthetic.
