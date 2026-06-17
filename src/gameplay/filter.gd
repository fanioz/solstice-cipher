class_name Filter extends Area2D

signal state_changed

@export var filter_color = "red"

var is_moving: bool = false
var move_offset: Vector2 = Vector2.ZERO

@onready var sprite = get_node_or_null("Sprite2D")

func _ready() -> void:
	input_event.connect(_on_input_event)
	add_to_group("filters")
	
	var color_map = {
		"red": Color(1.0, 0.2, 0.2, 0.5),
		"green": Color(0.2, 1.0, 0.2, 0.5),
		"blue": Color(0.2, 0.5, 1.0, 0.5)
	}
	if sprite:
		sprite.modulate = color_map.get(filter_color, Color.WHITE)

## Process the incoming light ray in 2D space.
## Returns the beam passing straight through, tinted to the filter's color.
func process_beam(incoming_origin: Vector2, incoming_dir: Vector2, incoming_color: Color) -> Array[Dictionary]:
	var result_color := incoming_color
	
	if typeof(filter_color) == TYPE_COLOR:
		result_color = filter_color
	elif filter_color is String:
		var string_colors = {
			"red": Color.RED,
			"green": Color.GREEN,
			"blue": Color.BLUE,
			"white": Color.WHITE
		}
		result_color = string_colors.get(filter_color.to_lower(), incoming_color)
		
	return [{
		"origin": incoming_origin,
		"direction": incoming_dir,
		"color": result_color
	}]

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
