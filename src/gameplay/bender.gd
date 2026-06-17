class_name Bender extends Area2D

signal state_changed

var is_moving: bool = false
var is_rotating: bool = false
var move_offset: Vector2 = Vector2.ZERO
var initial_angle: float = 0.0

@onready var interact_area = get_node_or_null("InteractArea")

func _ready() -> void:
	add_to_group("benders")
	if interact_area:
		interact_area.input_event.connect(_on_interact_area_input_event)

func _draw() -> void:
	# Mobile friendly: Draw a larger 100px rotation ring
	draw_arc(Vector2.ZERO, 100.0, 0, TAU, 32, Color(1.0, 1.0, 1.0, 0.4), 3.0, true)
	# Draw an inner ring at 40px to show the "move" zone
	draw_arc(Vector2.ZERO, 40.0, 0, TAU, 32, Color(1.0, 1.0, 1.0, 0.3), 2.0, true)

func _on_interact_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Handle Touch & Click equally
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var local_mouse = get_local_mouse_position()
			var dist = local_mouse.length()
			
			# Mobile friendly: Move radius is 40px, outside is rotation
			if dist < 40.0:
				is_moving = true
				move_offset = global_position - get_global_mouse_position()
			else:
				is_rotating = true
				initial_angle = get_global_mouse_position().angle_to_point(global_position) - rotation
				
			# Pop up when touched for tactile feedback
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.1)
				
			get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		var was_interacting = is_moving or is_rotating
		
		if is_moving:
			is_moving = false
			global_position = global_position.snapped(Vector2(10, 10))
			
		if is_rotating:
			is_rotating = false
			var snapped_rotation = round(rotation / (PI / 12.0)) * (PI / 12.0) # Snap to 15 degrees
			rotation = snapped_rotation
			
		if was_interacting:
			if global_position.y > 1120:
				var briefcase = get_tree().get_first_node_in_group("briefcase_ui")
				if briefcase:
					briefcase.return_piece("bender")
					queue_free()
					return
			
			# Shrink back down when released
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
			state_changed.emit()
			
	if event is InputEventMouseMotion:
		if is_moving:
			global_position = get_global_mouse_position() + move_offset
			state_changed.emit()
		elif is_rotating:
			var current_angle = get_global_mouse_position().angle_to_point(global_position)
			rotation = current_angle - initial_angle
			state_changed.emit()

func get_normal() -> Vector2:
	return Vector2.UP.rotated(rotation).normalized()

## Process the incoming light ray in 2D space.
## Returns deflected ray (at 45 degrees relative to normal), or empty array if blocked.
func process_beam(incoming_origin: Vector2, incoming_dir: Vector2, incoming_color: Color) -> Array[Dictionary]:
	var global_normal := get_normal()
	
	# Validate front-face hit: dot product must be <= -0.01
	if incoming_dir.dot(global_normal) > -0.01:
		return []
		
	# The output beam travels at a 45° angle relative to the Bender's normal
	var outgoing_dir := global_normal.rotated(deg_to_rad(45.0)).snapped(Vector2(0.001, 0.001)).normalized()
	
	return [{
		"origin": incoming_origin,
		"direction": outgoing_dir,
		"color": incoming_color
	}]

var _raw_rotation: float = 0.0

## Helper method for tests to snap/rotate the bender's Y rotation
func rotate_bender_by(angle_radians: float) -> void:
	if _raw_rotation == 0.0 and rotation != 0.0:
		_raw_rotation = rotation
	_raw_rotation += angle_radians
	rotation = round(_raw_rotation / (PI / 12.0)) * (PI / 12.0) # Snap to 15 degrees
	state_changed.emit()
