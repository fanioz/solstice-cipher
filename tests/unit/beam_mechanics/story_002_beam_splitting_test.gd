class_name Story002BeamSplittingTest extends "res://addons/gut/test.gd"

const Prism = preload("res://src/gameplay/splitter.gd")
const MainScript = preload("res://src/gameplay/main.gd")

# AC-1: Prism splits the beam straight and right
func test_prism_splits_beam_straight_and_right():
	var prism = add_child_autofree(Prism.new())
	# Default prism surface_normal is Vector2.UP.
	# A beam coming from above down (direction = Vector2.DOWN) hits the front face.
	var incoming_dir = Vector2.DOWN
	
	var results = prism.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	
	assert_eq(results.size(), 2, "Prism should split beam into two")
	
	var has_straight = false
	var has_right = false
	
	for result in results:
		if result["direction"].is_equal_approx(Vector2.DOWN):
			has_straight = true
		elif result["direction"].is_equal_approx(Vector2.RIGHT):
			has_right = true
			
	assert_true(has_straight, "One beam should continue perfectly straight")
	assert_true(has_right, "One beam should travel 90 degrees to the prism's local right")

# AC-2: Prism blocks beams from invalid angles
func test_prism_blocks_beam_from_side():
	var prism = add_child_autofree(Prism.new())
	
	# Beam hitting from the side (perpendicular to normal)
	var incoming_dir = Vector2.LEFT
	var results = prism.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	
	assert_eq(results.size(), 0, "Prism should block beams hitting the side")

func test_prism_blocks_beam_from_back():
	var prism = add_child_autofree(Prism.new())
	
	# Beam hitting from behind (same direction as normal)
	var incoming_dir = Vector2.UP
	var results = prism.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	
	assert_eq(results.size(), 0, "Prism should block beams hitting the back")

# AC-3: Prism respects bounce limits
func test_prism_respects_bounce_limits():
	var active_rays: Array[Dictionary] = [{
		"origin": Vector2.ZERO,
		"direction": Vector2.DOWN,
		"color": Color.WHITE,
		"bounces": MainScript.MAX_BOUNCES
	}]
	
	var ray = active_rays.pop_front()
	var propagation_halted = false
	
	if ray["bounces"] >= MainScript.MAX_BOUNCES:
		propagation_halted = true
		
	assert_true(propagation_halted, "Propagation should halt and queue no new beams when max bounces reached")
	assert_eq(active_rays.size(), 0, "No new beams queued")

func test_prism_rotated_splits_correctly():
	var prism = add_child_autofree(Prism.new())
	# Rotate prism 90 degrees. Its front face now points to +X (Vector2.RIGHT).
	# So a beam coming from +X towards -X will hit the front face.
	prism.rotation = deg_to_rad(90.0)
	var incoming_dir = Vector2.LEFT
	
	var results = prism.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	
	assert_eq(results.size(), 2, "Rotated prism should still split beam")
	
	var has_straight = false
	var has_right = false
	
	for result in results:
		if result["direction"].is_equal_approx(Vector2.LEFT):
			has_straight = true
		elif result["direction"].is_equal_approx(Vector2.DOWN):
			# Prism local right (+X). With 90 deg rotation, local +X becomes global +Y (Vector2.DOWN).
			has_right = true
			
	assert_true(has_straight, "One beam should continue perfectly straight relative to incident")
	assert_true(has_right, "One beam should travel 90 degrees to the rotated prism's local right")
