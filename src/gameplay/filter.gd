extends Area2D

signal state_changed

@export_enum("red", "green", "blue") var filter_color: String = "red"

var is_moving: bool = false
var move_offset: Vector2 = Vector2.ZERO

@onready var sprite = $Sprite2D

func _ready() -> void:
	input_event.connect(_on_input_event)
	
	var color_map = {
		"red": Color(1.0, 0.2, 0.2, 0.5),
		"green": Color(0.2, 1.0, 0.2, 0.5),
		"blue": Color(0.2, 0.5, 1.0, 0.5)
	}
	if sprite:
		sprite.modulate = color_map.get(filter_color, Color.WHITE)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_moving = true
			move_offset = global_position - get_global_mouse_position()
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.1)
			get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		var was_interacting = is_moving
		if is_moving:
			is_moving = false
			global_position = global_position.snapped(Vector2(10, 10))
			
			if was_interacting:
				if global_position.y > 1120:
					var briefcase = get_tree().get_first_node_in_group("briefcase_ui")
					if briefcase:
						briefcase.return_piece("filter_" + filter_color)
						queue_free()
						return
						
				var tween = create_tween()
				tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
				state_changed.emit()
			
	if event is InputEventMouseMotion and is_moving:
		global_position = get_global_mouse_position() + move_offset
		state_changed.emit()
