# Briefcase UI & Inventory Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the Briefcase inventory system at the bottom of the screen, allowing players to drag pieces onto the board and drag them back into the Briefcase to reclaim them.

**Architecture:** We will create a `BriefcaseUI` Control node that sits at the bottom of the screen. It manages individual `BriefcaseSlot` nodes for each tool type. The level script will initialize the starting inventory. We will implement drag-and-drop by detecting input events to spawn a "ghost" piece being dragged, and when dropped in the valid play area, instantiate the actual piece. Placed pieces can be dragged back to a 'drop zone' on the briefcase to return to inventory.

**Tech Stack:** Godot 4 (GDScript, Control Nodes, InputEvents)

---

## Chunk 1: Briefcase UI Layout

### Task 1: Create BriefcaseSlot Scene

**Files:**
- Create: `src/ui/briefcase_slot.tscn`
- Create: `src/ui/briefcase_slot.gd`

- [ ] **Step 1: Create the scene structure**
Create a `Control` (or `MarginContainer`) named `BriefcaseSlot`.
Add a `TextureRect` for the icon.
Add a `Label` for the count (e.g., "x2").

- [ ] **Step 2: Add logic to update count**
```gdscript
extends Control
class_name BriefcaseSlot

@export var tool_type: String = "mirror"
@export var tool_icon: Texture2D

@onready var icon_rect: TextureRect = $IconRect
@onready var count_label: Label = $CountLabel

var count: int = 0:
	set(value):
		count = value
		count_label.text = "x" + str(count)
		modulate.a = 1.0 if count > 0 else 0.5

func _ready() -> void:
	if tool_icon:
		icon_rect.texture = tool_icon
	count = 0
```

### Task 2: Create BriefcaseUI Scene

**Files:**
- Create: `src/ui/briefcase_ui.tscn`
- Create: `src/ui/briefcase_ui.gd`

- [ ] **Step 1: Create the scene structure**
Create a `Control` named `BriefcaseUI`. Set anchors to bottom-wide (anchors 0,1,1,1). Set height to 160.
Add a `ColorRect` background (dark, semi-transparent).
Add an `HBoxContainer` centered inside for the slots.

- [ ] **Step 2: Add initialization logic**
```gdscript
extends Control
class_name BriefcaseUI

const SLOT_SCENE = preload("res://src/ui/briefcase_slot.tscn")

@onready var container: HBoxContainer = $HBoxContainer

# Called by the Level script to set starting pieces
func initialize_inventory(inventory: Dictionary) -> void:
	for child in container.get_children():
		child.queue_free()
		
	for tool_type in inventory:
		var slot = SLOT_SCENE.instantiate() as BriefcaseSlot
		slot.tool_type = tool_type
		slot.count = inventory[tool_type]
		container.add_child(slot)
```

## Chunk 2: Drag and Drop from Briefcase

### Task 3: Implement Dragging from Slot

**Files:**
- Modify: `src/ui/briefcase_slot.gd`

- [ ] **Step 1: Override `_get_drag_data` in BriefcaseSlot**
```gdscript
func _get_drag_data(at_position: Vector2) -> Variant:
	if count <= 0:
		return null
		
	# Create visual preview
	var preview = TextureRect.new()
	preview.texture = icon_rect.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.custom_minimum_size = Vector2(64, 64)
	preview.modulate.a = 0.7
	
	var control = Control.new()
	control.add_child(preview)
	preview.position = -preview.custom_minimum_size / 2.0
	set_drag_preview(control)
	
	return {"type": "briefcase_item", "tool_type": tool_type, "slot_ref": self}
```

### Task 4: Handle Dropping in the Level

**Files:**
- Modify: `src/gameplay/main.gd` (and potentially other level scripts, we will handle `main.gd` as the base first)

- [ ] **Step 1: Make `main.tscn` able to receive drops**
Since `main.tscn` uses a Node2D root, we should add a full-screen `Control` node (named `DropZone`) spanning the whole screen to catch `_can_drop_data` and `_drop_data`. Alternatively, attach script to an existing background `ColorRect` if we turn it into a Control. Let's add a `Control` named `BoardDropZone` covering `Rect2(0, 0, 720, 1120)` (everything above the briefcase).

- [ ] **Step 2: Add drop logic to the BoardDropZone**
```gdscript
# Attach this to BoardDropZone in main.tscn
extends Control

signal item_dropped_on_board(tool_type, drop_position, slot_ref)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("type") and data["type"] == "briefcase_item"

func _drop_data(at_position: Vector2, data: Variant) -> void:
	item_dropped_on_board.emit(data["tool_type"], at_position, data["slot_ref"])
```

- [ ] **Step 3: Handle the drop signal in `main.gd`**
```gdscript
const MIRROR_SCENE = preload("res://src/gameplay/mirror.tscn")
const SPLITTER_SCENE = preload("res://src/gameplay/splitter.tscn")

func _on_board_drop_zone_item_dropped_on_board(tool_type: String, drop_position: Vector2, slot_ref: BriefcaseSlot) -> void:
	# Decrement count
	slot_ref.count -= 1
	
	var new_piece: Node2D = null
	if tool_type == "mirror":
		new_piece = MIRROR_SCENE.instantiate()
	elif tool_type == "prism":
		new_piece = SPLITTER_SCENE.instantiate()
		
	if new_piece:
		add_child(new_piece)
		# Convert control local position to global, then to Node2D local space
		new_piece.global_position = $BoardDropZone.get_global_transform() * drop_position
		# Update rays
		call_deferred("_update_rays")
```

## Chunk 3: Returning Pieces to Briefcase

### Task 5: Allow Dragging Board Pieces Back to Briefcase

**Files:**
- Modify: `src/gameplay/mirror.gd` and `splitter.gd` (or base DraggablePiece if they inherit one)
- Modify: `src/ui/briefcase_ui.gd`

- [ ] **Step 1: Setup BriefcaseUI as a Drop Zone**
Add `_can_drop_data` and `_drop_data` to `BriefcaseUI`.

```gdscript
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("type") and data["type"] == "board_piece"

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var tool_type = data["tool_type"]
	var piece_node = data["piece_node"]
	
	# Find matching slot and increment
	for child in container.get_children():
		var slot = child as BriefcaseSlot
		if slot.tool_type == tool_type:
			slot.count += 1
			break
			
	# Destroy the piece from the board
	piece_node.queue_free()
	# The level needs to update rays. We can emit a signal or rely on piece tree_exiting.
```

- [ ] **Step 2: Modify Draggable Pieces to hook into drag-and-drop**
Currently pieces use `_input_event` for dragging. Godot's built-in drag-and-drop is mainly for `Control` nodes. For `Area2D` pieces, if the user drags them over the UI, we need a way to detect it. 
Alternatively, since we already have custom dragging for pieces:
When a piece is "dropped" (mouse button released), check if its global `Y` coordinate is `> 1120` (inside the Briefcase area). If so, remove it and add to inventory!

```gdscript
# In mirror.gd / splitter.gd (the drop event)
func _input(event: InputEvent) -> void:
	if is_dragging and event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = false
		
		# Check if dropped in Briefcase zone (Y > 1120)
		if global_position.y > 1120:
			# Get a reference to BriefcaseUI and return it
			var briefcase = get_tree().get_first_node_in_group("briefcase_ui")
			if briefcase:
				briefcase.return_piece("mirror") # or "prism"
				queue_free()
				# Optionally emit signal so main.gd updates rays
		else:
			# Normal drop on board
			pass
```

- [ ] **Step 3: Add `return_piece` to `BriefcaseUI` and Group**
In `BriefcaseUI`, set its group to `briefcase_ui`. Add `return_piece(tool_type)` method.
```gdscript
func return_piece(tool_type: String) -> void:
	for child in container.get_children():
		if child is BriefcaseSlot and child.tool_type == tool_type:
			child.count += 1
			return
```

## Chunk 4: Level Setup

### Task 6: Add Briefcase UI to Levels

**Files:**
- Modify: `src/gameplay/main.tscn`

- [ ] **Step 1: Add BriefcaseUI and BoardDropZone to main.tscn**
Add the `BoardDropZone` control and connect its signal to `main.gd`.
Add `BriefcaseUI` to `main.tscn`.

- [ ] **Step 2: Initialize Inventory in `main.gd`**
```gdscript
func _ready() -> void:
	$BriefcaseUI.initialize_inventory({"mirror": 3})
	# ... existing ready logic ...
```

- [ ] **Step 3: Remove pre-placed Mirrors/Splitters**
Delete the `Mirror1` node from `main.tscn` so the board starts empty except for the Sun and Symbol. Player must place the mirror from the briefcase to win.

- [ ] **Step 4: Update rays when pieces are deleted**
In `main.gd`, ensure `_update_rays` is called when a piece is returned to the briefcase.

- [ ] **Step 5: Apply same setup to `level_2.tscn` and `level_3.tscn`**
Level 2: `{"mirror": 1, "prism": 2}`
Level 3: `{"mirror": 2, "prism": 3}`

---

**Plan complete.**
