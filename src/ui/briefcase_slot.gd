extends Control
class_name BriefcaseSlot

@export var tool_type: String = "mirror"
@export var tool_icon: Texture2D

@onready var icon_rect: TextureRect = $IconRect
@onready var count_label: Label = $CountLabel

var count: int = 0:
	set(value):
		count = value
		if count_label:
			count_label.text = "x" + str(count)
		modulate.a = 1.0 if count > 0 else 0.5

func _ready() -> void:
	if tool_icon and icon_rect:
		icon_rect.texture = tool_icon
	# Sync UI state with the current count (which was set before _ready)
	if count_label:
		count_label.text = "x" + str(count)
	modulate.a = 1.0 if count > 0 else 0.5
	
	mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered() -> void:
	if count > 0 and has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("ui_hover")

func consume_item() -> void:
	if count > 0:
		self.count -= 1

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
