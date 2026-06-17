class_name Story005DiagonalRoutingTest extends "res://addons/gut/test.gd"

const Bender = preload("res://src/gameplay/bender.gd")

# AC-1: Bender deflects the beam at 45°
func test_bender_deflects_beam_at_45_degrees():
	var bender = add_child_autofree(Bender.new())
	# Bender is at default rotation 0, normal is Vector2.UP
	# Beam coming straight down
	var incoming_dir = Vector2.DOWN
	var result = bender.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	
	assert_eq(result.size(), 1, "Bender should route one beam")
	
	var global_normal = Vector2.UP
	var expected_dir = global_normal.rotated(deg_to_rad(45.0)).snapped(Vector2(0.001, 0.001)).normalized()
	
	assert_true(result[0]["direction"].is_equal_approx(expected_dir), "Beam should deflect at exactly 45 degrees relative to normal")

# AC-1 Edge Case: Beam striking the back or non-routing sides
func test_bender_blocks_beam_from_back_and_sides():
	var bender = add_child_autofree(Bender.new())
	
	# Back hit: incoming is same direction as normal (Vector2.UP)
	var incoming_dir_back = Vector2.UP
	var result_back = bender.process_beam(Vector2.ZERO, incoming_dir_back, Color.WHITE)
	assert_eq(result_back.size(), 0, "Bender should block beams from behind")
	
	# Side hit: incoming is perpendicular to normal (Vector2.RIGHT)
	var incoming_dir_side = Vector2.RIGHT
	var result_side = bender.process_beam(Vector2.ZERO, incoming_dir_side, Color.WHITE)
	assert_eq(result_side.size(), 0, "Bender should block beams from the side")

# AC-2: Benders snap to 15° increments
func test_bender_snaps_to_15_degrees():
	var bender = add_child_autofree(Bender.new())
	
	# Rotate by 7 degrees
	bender.rotate_bender_by(deg_to_rad(7.0))
	assert_eq(bender.rotation_degrees, 0.0, "Should snap down to 0")
	
	# Rotate by 8 degrees
	bender.rotate_bender_by(deg_to_rad(8.0))
	assert_eq(bender.rotation_degrees, 15.0, "Should snap up to 15")

# AC-2 Edge Case: Rapid, continuous rotation input
func test_bender_rapid_rotation_snapping():
	var bender = add_child_autofree(Bender.new())
	
	# Simulate multiple small increments that add up
	for _i in range(10):
		bender.rotate_bender_by(deg_to_rad(2.0))
		
	# 10 * 2 = 20 degrees, which snaps to 15 degrees at the final step
	assert_eq(bender.rotation_degrees, 15.0, "Should accumulate small deltas and snap to 15")
	
	bender.rotate_bender_by(deg_to_rad(10.0))
	# 20 + 10 = 30 -> snaps to 30
	assert_eq(bender.rotation_degrees, 30.0, "Should accumulate to 30 and snap")
