extends Control

signal item_dropped_on_board(tool_type, drop_position, slot_ref)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("type") and data["type"] == "briefcase_item"

func _drop_data(at_position: Vector2, data: Variant) -> void:
	item_dropped_on_board.emit(data["tool_type"], at_position, data["slot_ref"])
