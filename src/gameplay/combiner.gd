class_name Combiner extends Area2D

signal state_changed

var is_moving: bool = false
var is_rotating: bool = false
var move_offset: Vector2 = Vector2.ZERO
var initial_angle: float = 0.0

var input_left_active := false
var input_left_color := Color.BLACK
var input_right_active := false
var input_right_color := Color.BLACK

@onready var interact_area = get_node_or_null("InteractArea")

func _ready() -> void:
	add_to_group("combiners")
	if interact_area:
		interact_area.input_event.connect(_on_interact_area_input_event)

func _draw() -> void:
	# Draw diamond shape
	var points := PackedVector2Array([
		Vector2(40, 0),
		Vector2(0, -30),
		Vector2(-40, 0),
		Vector2(0, 30)
	])
	var border_color := Color(1.0, 0.8, 0.2, 0.8) # Amber/Gold
	if input_left_active and input_right_active:
		border_color = Color(1.0, 1.0, 1.0, 1.0)
	
	draw_polygon(points, [Color(0.2, 0.15, 0.05, 0.5)])
	draw_polyline(PackedVector2Array([points[0], points[1], points[2], points[3], points[0]]), border_color, 3.0, true)
	
	# Draw indicators for left and right input faces
	var left_color := input_left_color if input_left_active else Color(0.3, 0.3, 0.3, 0.8)
	var right_color := input_right_color if input_right_active else Color(0.3, 0.3, 0.3, 0.8)
	
	draw_circle(Vector2(0, -20), 8.0, left_color)
	draw_circle(Vector2(0, 20), 8.0, right_color)
	
	# Output direction arrow
	var arrow := Vector2.RIGHT * 50.0
	draw_line(Vector2.ZERO, arrow, Color.WHITE if (input_left_active and input_right_active) else Color(0.5, 0.5, 0.5, 0.5), 2.0)

func clear_inputs() -> void:
	input_left_active = false
	input_left_color = Color.BLACK
	input_right_active = false
	input_right_color = Color.BLACK
	queue_redraw()

func process_beam(_incoming_origin: Vector2, incoming_dir: Vector2, incoming_color: Color) -> Array[Dictionary]:
	# Local direction
	var local_dir := incoming_dir.rotated(-rotation)
	
	# Left face (normal = Vector2(0, -1))
	if local_dir.dot(Vector2(0, -1)) < -0.5:
		input_left_active = true
		input_left_color = incoming_color
	# Right face (normal = Vector2(0, 1))
	elif local_dir.dot(Vector2(0, 1)) < -0.5:
		input_right_active = true
		input_right_color = incoming_color
		
	queue_redraw()
	return []

func resolve_beams() -> Array[Dictionary]:
	if input_left_active and input_right_active:
		var global_out_dir := Vector2.RIGHT.rotated(rotation).snapped(Vector2(0.001, 0.001)).normalized()
		var blended_color = Color(
			minf(1.0, input_left_color.r + input_right_color.r),
			minf(1.0, input_left_color.g + input_right_color.g),
			minf(1.0, input_left_color.b + input_right_color.b),
			1.0
		)
		return [{
			"origin": global_position,
			"direction": global_out_dir,
			"color": blended_color
		}]
	return []

func _on_interact_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var local_mouse := get_local_mouse_position()
			var dist := local_mouse.length()
			
			if dist < 40.0:
				is_moving = true
				move_offset = global_position - get_global_mouse_position()
			else:
				is_rotating = true
				initial_angle = get_global_mouse_position().angle_to_point(global_position) - rotation
				
			var tween := create_tween()
			tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.1)
			get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		var was_interacting := is_moving or is_rotating
		
		if is_moving:
			is_moving = false
			global_position = global_position.snapped(Vector2(10, 10))
			
		if is_rotating:
			is_rotating = false
			rotation = round(rotation / (PI / 12.0)) * (PI / 12.0)
			
		if was_interacting:
			if global_position.y > 1120:
				var briefcase := get_tree().get_first_node_in_group("briefcase_ui")
				if briefcase:
					briefcase.return_piece("combiner")
					queue_free()
					return
			
			var tween := create_tween()
			tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
			state_changed.emit()
			
	if event is InputEventMouseMotion:
		if is_moving:
			global_position = get_global_mouse_position() + move_offset
			state_changed.emit()
		elif is_rotating:
			var current_angle := get_global_mouse_position().angle_to_point(global_position)
			rotation = current_angle - initial_angle
			state_changed.emit()
