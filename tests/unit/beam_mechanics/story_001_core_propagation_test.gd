class_name Story001CorePropagationTest extends "res://addons/gut/test.gd"

const Mirror = preload("res://src/gameplay/mirror.gd")

# AC-1: Mirror reflects beam at 90°
func test_mirror_reflects_beam_at_90_degrees():
	var mirror = add_child_autofree(Mirror.new())
	# Mirror rotated 45 degrees
	mirror.rotation = deg_to_rad(45.0)
	
	# Beam coming straight down the Y axis
	var incoming_dir = Vector2.DOWN
	var result = mirror.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	
	assert_eq(result.size(), 1, "Mirror should reflect one beam")
	
	# Should reflect exactly to the right (+X axis)
	var expected_dir = Vector2.RIGHT
	assert_true(result[0]["direction"].is_equal_approx(expected_dir), "Beam should reflect at 90 degrees")

# AC-1 Edge Case: Beam striking back of mirror
func test_mirror_blocks_beam_from_behind():
	var mirror = add_child_autofree(Mirror.new())
	
	# Beam hitting the back of the mirror (same direction as normal)
	var incoming_dir = Vector2.UP
	var result = mirror.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	
	assert_eq(result.size(), 0, "Mirror should block beams from behind")

# AC-2: Mirrors snap to 15° increments
func test_mirror_snaps_to_15_degrees():
	var mirror = add_child_autofree(Mirror.new())
	
	# Rotate by 7 degrees
	mirror.rotate_mirror_by(deg_to_rad(7.0))
	assert_eq(mirror.rotation_degrees, 0.0, "Should snap down to 0")
	
	# Rotate by 8 degrees
	mirror.rotate_mirror_by(deg_to_rad(8.0))
	assert_eq(mirror.rotation_degrees, 15.0, "Should snap up to 15")
