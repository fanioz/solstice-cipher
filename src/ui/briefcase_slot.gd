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
	self.count = 0
