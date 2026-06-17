class_name WallGenerator extends Node

@export var corridor_width: float = 1.0
@export var wall_thickness: float = 0.2
@export var wall_height: float = 2.0

## Instantiates StaticBody3D walls along the path and adds them as children
func generate_walls(path: PackedVector3Array) -> void:
	# Clean up any existing generated walls
	for child in get_children():
		child.queue_free()
		
	if path.size() < 2:
		return
		
	# Detect if propagation is in XZ plane or XY plane
	var is_xz_plane := true
	for pt in path:
		if not is_zero_approx(pt.y):
			is_xz_plane = false
			break
			
	var vertical_axis: Vector3 = Vector3(0, 1, 0) if is_xz_plane else Vector3(0, 0, 1)
	
	for i in range(path.size() - 1):
		var p1: Vector3 = path[i]
		var p2: Vector3 = path[i+1]
		var segment_vec: Vector3 = p2 - p1
		var length: float = segment_vec.length()
		
		if length < 0.001:
			continue
			
		var dir: Vector3 = segment_vec.normalized()
		
		# Shrink walls at ends to prevent ray interception at corners
		var shrink_amount: float = corridor_width * 0.5
		var wall_length: float = length - (shrink_amount * 2.0)
		
		if wall_length <= 0.01:
			continue
			
		var segment_center: Vector3 = p1 + dir * (length * 0.5)
		var local_x: Vector3 = vertical_axis.cross(dir).normalized()
		
		# We create left and right walls
		for offset_sign in [-1.0, 1.0]:
			var wall_center: Vector3 = segment_center + local_x * (corridor_width * 0.5 * offset_sign)
			
			var wall_body := StaticBody3D.new()
			wall_body.collision_layer = 2 # LAYER_WALLS
			wall_body.collision_mask = 0
			add_child(wall_body)
			
			var collision_shape := CollisionShape3D.new()
			wall_body.add_child(collision_shape)
			
			var box := BoxShape3D.new()
			box.size = Vector3(wall_thickness, wall_height, wall_length)
			collision_shape.shape = box
			
			# Position and orient the wall
			wall_body.global_position = wall_center
			wall_body.global_transform.basis = Basis(local_x, vertical_axis, dir)
