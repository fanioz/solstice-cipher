class_name Portal extends Area2D

signal state_changed

var is_moving: bool = false
var is_rotating: bool = false
var move_offset: Vector2 = Vector2.ZERO
var initial_angle: float = 0.0

@export var linked_portal: Area2D = null

@onready var interact_area = get_node_or_null("InteractArea")

func _ready() -> void:
	add_to_group("portals")
	if interact_area:
		interact_area.input_event.connect(_on_interact_area_input_event)

func _draw() -> void:
	# Cyan portal aura and vortex
	var color := Color(0.2, 0.6, 1.0, 0.8)
	draw_arc(Vector2.ZERO, 30.0, 0, TAU, 32, color, 4.0, true)
	draw_circle(Vector2.ZERO, 15.0, Color(0.1, 0.2, 0.4, 0.5))
	# Facing direction indicator arrow
	var facing := Vector2.RIGHT * 45.0
	draw_line(Vector2.ZERO, facing, Color.WHITE, 2.0)
	draw_line(facing, facing + Vector2(-10, -5), Color.WHITE, 2.0)
	draw_line(facing, facing + Vector2(-10, 5), Color.WHITE, 2.0)

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
					briefcase.return_piece("portal")
					if is_instance_valid(linked_portal):
						linked_portal.queue_free()
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

## Process the incoming light ray in 2D space.
## Teleports the ray to the linked portal, inverting the local X component of the direction.
func process_beam(incoming_origin: Vector2, incoming_dir: Vector2, incoming_color: Color) -> Array[Dictionary]:
	if not linked_portal or not is_instance_valid(linked_portal):
		return []
		
	# Convert incoming origin and direction to local space of this portal
	var local_pos := (incoming_origin - global_position).rotated(-rotation)
	var local_dir := incoming_dir.rotated(-rotation)
	
	# Validate front-face hit: normal faces local +X (so dot product must be <= -0.01)
	if local_dir.dot(Vector2.RIGHT) > -0.01:
		return [] # Blocked (strikes backside or sides)
		
	# Flip local X component of the direction to travel out of the linked portal
	var local_exit_dir := Vector2(-local_dir.x, local_dir.y)
	
	# Translate local exit position and direction to linked portal's global space
	var outgoing_origin := linked_portal.global_position + local_pos.rotated(linked_portal.rotation)
	var outgoing_dir := local_exit_dir.rotated(linked_portal.rotation).snapped(Vector2(0.001, 0.001)).normalized()
	
	return [{
		"origin": outgoing_origin,
		"direction": outgoing_dir,
		"color": incoming_color,
		"exclude": [linked_portal.get_rid()] # Exclude the exit portal from immediate next collision
	}]
