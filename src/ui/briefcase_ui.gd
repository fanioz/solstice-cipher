extends Control
class_name BriefcaseUI

const SLOT_SCENE = preload("res://src/ui/briefcase_slot.tscn")

@onready var container: HBoxContainer = $HBoxContainer

func _ready() -> void:
	add_to_group("briefcase_ui")

# Called by the Level script to set starting pieces
func initialize_inventory(inventory: Dictionary) -> void:
	if not container:
		return
	for child in container.get_children():
		child.queue_free()
		
	for tool_type in inventory:
		var slot = SLOT_SCENE.instantiate() as BriefcaseSlot
		slot.tool_type = tool_type
		slot.count = inventory[tool_type]
		container.add_child(slot)

func return_piece(tool_type: String) -> void:
	for child in container.get_children():
		if child is BriefcaseSlot and child.tool_type == tool_type:
			child.count += 1
			return

