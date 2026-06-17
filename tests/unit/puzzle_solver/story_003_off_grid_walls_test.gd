class_name Story003OffGridWallsTest extends "res://addons/gut/test.gd"

const WallGeneratorClass = preload("res://src/puzzle_solver/wall_generator.gd")

func test_accept_path_edge_cases() -> void:
	var generator = add_child_autofree(WallGeneratorClass.new())
	
	# Empty path should not crash or generate walls
	generator.generate_walls(PackedVector3Array())
	assert_eq(generator.get_child_count(), 0)
	
	# Single point path should not crash or generate walls
	generator.generate_walls(PackedVector3Array([Vector3(0, 0, 0)]))
	assert_eq(generator.get_child_count(), 0)

func test_generate_and_instantiate_walls() -> void:
	var generator = add_child_autofree(WallGeneratorClass.new())
	generator.corridor_width = 2.0
	generator.wall_thickness = 0.2
	generator.wall_height = 3.0
	
	# A simple straight path in XZ plane
	var path = PackedVector3Array([
		Vector3(0, 0, 0),
		Vector3(10, 0, 0)
	])
	
	generator.generate_walls(path)
	
	# Should generate 2 walls (left and right of the single segment)
	assert_eq(generator.get_child_count(), 2)
	
	for child in generator.get_children():
		assert_true(child is StaticBody3D, "Wall must be StaticBody3D")
		assert_eq(child.collision_layer, 2, "Wall collision layer must be 2 (LAYER_WALLS)")
		
		var collision_shape = child.get_child(0)
		assert_true(collision_shape is CollisionShape3D)
		
		var box_shape = collision_shape.shape as BoxShape3D
		assert_true(box_shape != null)
		assert_almost_eq(box_shape.size.y, 3.0, 0.001, "Height should match config")
		assert_almost_eq(box_shape.size.x, 0.2, 0.001, "Thickness should match config")
		# Length = 10.0 - corridor_width = 10.0 - 2.0 = 8.0
		assert_almost_eq(box_shape.size.z, 8.0, 0.001, "Length should be shrunk by corridor_width")

func test_walls_do_not_intersect_ray_paths() -> void:
	var generator = add_child_autofree(WallGeneratorClass.new())
	generator.corridor_width = 2.0
	generator.wall_thickness = 0.2
	
	# A L-shaped path in XY plane to test corners
	var path = PackedVector3Array([
		Vector3(0, 0, 0),
		Vector3(10, 0, 0),
		Vector3(10, 10, 0)
	])
	
	generator.generate_walls(path)
	
	# 2 segments -> 4 walls
	assert_eq(generator.get_child_count(), 4)
	
	for child in generator.get_children():
		var wall := child as StaticBody3D
		var wall_pos := wall.global_position
		
		var dist_to_seg1 := absf(wall_pos.y)
		var dist_to_seg2 := absf(wall_pos.x - 10.0)
		
		# Ensure the wall is offset correctly
		assert_true(is_equal_approx(dist_to_seg1, 1.0) or is_equal_approx(dist_to_seg2, 1.0), 
			"Wall must be offset by exactly corridor_width/2 from its segment line")
			
		# Check that the wall bounds do not overlap the other segment's line
		if is_equal_approx(dist_to_seg1, 1.0):
			assert_true(wall_pos.x <= 9.0, "Segment 1 wall should not extend into Segment 2 path")
		elif is_equal_approx(dist_to_seg2, 1.0):
			assert_true(wall_pos.y >= 1.0, "Segment 2 wall should not extend into Segment 1 path")
