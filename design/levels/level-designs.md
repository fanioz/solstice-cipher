# Level Layouts & Solution Log

This document details the configuration and step-by-step solution paths for the 15 handcrafted levels.

*Note: Coordinates represent pixel positions on the 720x1280 screen. Tool angles snap to 15-degree increments (in radians).*

---

### Level 1: Introduction (Word: "I")
- **Scene File**: [level_1.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_1.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 1 Mirror
- **Targets**:
  - `Symbol1` ("I"): `(360, 300)`
- **Solution**:
  - Place a **Mirror** at `(360, 800)`.
  - Rotate the Mirror to 45 degrees so that the normal points to the top-left, reflecting the rightward beam straight Up to strike the symbol at `(360, 300)`.

---

### Level 2: Split (Word: "S")
- **Scene File**: [level_2.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_2.tscn)
- **Sun Emitter**: Position `(100, 900)`, Rotation `0` (facing Right)
- **Briefcase**: 1 Mirror
- **Targets**:
  - `Symbol1` ("S"): `(600, 600)` [Index 0]
- **Solution**:
  - Place a **Mirror** at `(600, 900)`.
  - Rotate the Mirror to 45 degrees so that the normal points to the top-left, reflecting the rightward beam straight Up to strike the symbol at `(600, 600)`.

---

### Level 3: Sun (Word: "R")
- **Scene File**: [level_3.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_3.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 1 Mirror
- **Targets**:
  - `Symbol1` ("R"): `(620, 500)` [Index 0]
- **Solution**:
  - Place a **Mirror** at `(620, 800)`.
  - Rotate the Mirror to 45 degrees so that the normal points to the top-left, reflecting the rightward beam straight Up to strike the symbol at `(620, 500)`.

---

### Level 4: Grid Reflection (Word: "O")
- **Scene File**: [level_4.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_4.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 2 Mirrors
- **Targets**:
  - `Symbol1` ("O"): `(350, 400)` [Index 0]
- **Solution**:
  - Place a **Mirror** at `(500, 800)` rotated at 45 degrees to reflect the beam Up to `(500, 400)`.
  - Place a **Mirror** at `(500, 400)` rotated at 45 degrees to reflect the beam Left to strike the symbol at `(350, 400)`.

---

### Level 5: Ray Path (Word: "L")
- **Scene File**: [level_5.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_5.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 2 Mirrors
- **Targets**:
  - `Symbol1` ("L"): `(200, 400)` [Index 0]
- **Solution**:
  - Place a **Mirror** at `(500, 800)` rotated at 45 degrees to reflect the beam Up to `(500, 400)`.
  - Place a **Mirror** at `(500, 400)` rotated at 45 degrees to reflect the beam Left to strike the symbol at `(200, 400)`.

---

### Level 6: Light Wave (Word: "ON")
- **Scene File**: [level_6.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_6.tscn)
- **Sun Emitter**: Position `(100, 900)`, Rotation `0` (facing Right)
- **Briefcase**: 1 Mirror, 1 Prism
- **Targets**:
  - `Symbol1` ("O"): `(600, 900)` [Index 0]
  - `Symbol2` ("N"): `(100, 600)` [Index 1]
- **Solution**:
  - Place a **Prism** at `(100, 900)`.
  - Rotate the Prism to reflect Upwards. The Prism splits the beam: the transmitted portion passes straight through to strike the "O" symbol at `(600, 900)`, while the reflected portion is directed Up to strike the "N" symbol at `(100, 600)`.

---

### Level 7: Arc Path (Word: "GO")
- **Scene File**: [level_7.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_7.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 1 Mirror, 1 Prism
- **Targets**:
  - `Symbol1` ("G"): `(360, 300)` [Index 0]
  - `Symbol2` ("O"): `(620, 800)` [Index 1]
- **Solution**:
  - Place a **Prism** at `(360, 800)`.
  - Rotate the Prism to reflect Upwards. The Prism splits the beam: the transmitted portion passes straight through to strike the "O" symbol at `(620, 800)`, while the reflected portion is directed Up to strike the "G" symbol at `(360, 300)`.

---

### Level 8: Orbit (Word: "UP")
- **Scene File**: [level_8.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_8.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 1 Mirror, 1 Prism
- **Targets**:
  - `Symbol1` ("U"): `(350, 400)` [Index 0]
  - `Symbol2` ("P"): `(500, 600)` [Index 1]
- **Solution**:
  - Place a **Prism** at `(350, 800)` rotated to reflect Up. The reflected beam strikes "U" at `(350, 400)`.
  - Place a **Mirror** at `(500, 800)` rotated at 45 degrees to reflect Up to strike "P" at `(500, 600)`.

---

### Level 9: Sky Vault (Word: "SO")
- **Scene File**: [level_9.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_9.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 2 Mirrors, 1 Prism
- **Targets**:
  - `Symbol1` ("S"): `(200, 400)` [Index 0]
  - `Symbol2` ("O"): `(500, 600)` [Index 1]
- **Solution**:
  - Place a **Prism** at `(350, 800)` rotated to reflect Up.
  - Place a **Mirror** at `(350, 400)` rotated at 45 degrees to reflect Left to strike "S" at `(200, 400)`.
  - Place a **Mirror** at `(500, 800)` rotated at 45 degrees to reflect Up to strike "O" at `(500, 600)`.

---

### Level 10: Daybreak (Word: "HE")
- **Scene File**: [level_10.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_10.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 2 Mirrors, 1 Prism
- **Targets**:
  - `Symbol1` ("H"): `(200, 400)` [Index 0]
  - `Symbol2` ("E"): `(500, 400)` [Index 1]
- **Solution**:
  - Place a **Prism** at `(200, 800)` rotated to reflect Up. The reflected beam strikes "H" at `(200, 400)`.
  - Place a **Mirror** at `(500, 800)` rotated at 45 degrees to reflect Up to strike "E" at `(500, 400)`.

---

### Level 11: Dawn Refraction (Word: "SUN")
- **Scene File**: [level_11.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_11.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 2 Mirrors, 2 Prisms
- **Targets**:
  - `Symbol1` ("S"): `(200, 400)` [Index 0]
  - `Symbol2` ("U"): `(500, 600)` [Index 1]
  - `Symbol3` ("N"): `(650, 800)` [Index 2]
- **Solution**:
  - Place a **Prism** at `(200, 800)` rotated to reflect Up to strike "S" at `(200, 400)`.
  - Place a **Prism** at `(500, 800)` rotated to reflect Up to strike "U" at `(500, 600)`. The transmitted beam from the second prism continues straight to hit "N" at `(650, 800)`.

---

### Level 12: Dusk Shadow (Word: "RAY")
- **Scene File**: [level_12.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_12.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 2 Mirrors, 2 Prisms
- **Targets**:
  - `Symbol1` ("R"): `(200, 400)` [Index 0]
  - `Symbol2` ("A"): `(500, 400)` [Index 1]
  - `Symbol3` ("Y"): `(600, 600)` [Index 2]
- **Solution**:
  - Place a **Prism** at `(200, 800)` rotated to reflect Up to strike "R" at `(200, 400)`.
  - Place a **Prism** at `(500, 800)` rotated to reflect Up to strike "A" at `(500, 400)`.
  - Place a **Mirror** at `(600, 800)` rotated at 45 degrees to reflect Up to strike "Y" at `(600, 600)`.

---

### Level 13: Star Field (Word: "LUX")
- **Scene File**: [level_13.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_13.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 2 Mirrors, 2 Prisms
- **Targets**:
  - `Symbol1` ("L"): `(150, 350)` [Index 0]
  - `Symbol2` ("U"): `(550, 450)` [Index 1]
  - `Symbol3` ("X"): `(200, 650)` [Index 2]
- **Solution**:
  - Place a **Prism** at `(200, 800)` to split the beam Up and Right.
  - Place a **Prism** at `(200, 650)` to split the vertical beam Left (hitting "X" at `(150, 650)`) and Up.
  - Place a **Mirror** at `(200, 350)` to reflect the remaining vertical beam Left to hit "L" at `(150, 350)`.
  - Place a **Mirror** at `(550, 800)` to reflect the horizontal branch Up to hit "U" at `(550, 450)`.

---

### Level 14: Moonlight (Word: "ARC")
- **Scene File**: [level_14.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_14.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 2 Mirrors, 2 Prisms
- **Targets**:
  - `Symbol1` ("A"): `(150, 600)` [Index 0]
  - `Symbol2` ("R"): `(600, 400)` [Index 1]
  - `Symbol3` ("C"): `(500, 500)` [Index 2]
- **Solution**:
  - Place a **Prism** at `(300, 800)` to split the beam Up and Right.
  - Place a **Mirror** at `(300, 600)` to reflect the vertical beam Left to hit "A" at `(150, 600)`.
  - Place a **Prism** at `(500, 800)` to split the horizontal beam Up (hitting "C" at `(500, 500)`) and Right.
  - Place a **Mirror** at `(600, 800)` to reflect the remaining horizontal beam Up to hit "R" at `(600, 400)`.

---

### Level 15: Halo Corona (Word: "ORB")
- **Scene File**: [level_15.tscn](file:///Users/fanioz/solstice-cipher/src/gameplay/level_15.tscn)
- **Sun Emitter**: Position `(100, 800)`, Rotation `0` (facing Right)
- **Briefcase**: 2 Mirrors, 2 Prisms
- **Targets**:
  - `Symbol1` ("O"): `(250, 300)` [Index 0]
  - `Symbol2` ("R"): `(150, 500)` [Index 1]
  - `Symbol3` ("B"): `(400, 400)` [Index 2]
- **Solution**:
  - Place a **Prism** at `(250, 800)` to split the beam Up and Right.
  - Place a **Prism** at `(250, 500)` to split the vertical beam Left (hitting "R" at `(150, 500)`) and Up (hitting "O" at `(250, 300)`).
  - Place a **Mirror** at `(550, 800)` to reflect the horizontal beam Up to `(550, 400)`.
  - Place a **Mirror** at `(550, 400)` to reflect the beam Left to hit "B" at `(400, 400)`.
