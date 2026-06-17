class_name Story004PathBlockingTest extends "res://addons/gut/test.gd"

const Shade = preload("res://src/gameplay/shade.gd")
const Prism = preload("res://src/gameplay/splitter.gd")

# AC-1: Shade stops a beam dead
func test_shade_stops_beam_dead():
	var shade = add_child_autofree(Shade.new())
	var incoming_dir = Vector2.DOWN
	
	var results = shade.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	
	assert_eq(results.size(), 0, "Shade should return no new rays, blocking the beam completely")

# AC-2: Shade in a split path blocks only that branch
func test_shade_blocks_only_one_branch_of_split():
	var prism = add_child_autofree(Prism.new())
	var shade = add_child_autofree(Shade.new())
	
	var incoming_dir = Vector2.DOWN
	
	# Simulating the beam hitting the prism
	var split_results = prism.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	assert_eq(split_results.size(), 2, "Prism should split beam into two")
	
	# Simulating Branch A hitting the shade
	var branch_a = split_results[0]
	var shade_results = shade.process_beam(branch_a["origin"], branch_a["direction"], branch_a["color"])
	
	assert_eq(shade_results.size(), 0, "Shade should block Branch A")
	
	# Branch B continues unaffected
	var branch_b = split_results[1]
	assert_true(branch_b["direction"] != Vector2.ZERO, "Branch B should exist and continue unaffected")

# AC-3: Multiple beams striking the same Shade
func test_multiple_beams_hitting_shade():
	var shade = add_child_autofree(Shade.new())
	
	# Beam 1 from top
	var incoming_dir_1 = Vector2.DOWN
	var results_1 = shade.process_beam(Vector2(0, -1), incoming_dir_1, Color.RED)
	
	# Beam 2 from left
	var incoming_dir_2 = Vector2.RIGHT
	var results_2 = shade.process_beam(Vector2(-1, 0), incoming_dir_2, Color.BLUE)
	
	assert_eq(results_1.size(), 0, "Shade should block first beam")
	assert_eq(results_2.size(), 0, "Shade should block second beam simultaneously without issue")

# Edge cases for AC-1: Beam hitting the exact corner or grazing
func test_shade_grazing_hit():
	var shade = add_child_autofree(Shade.new())
	
	# Even at extreme grazing angles, a shade should block the beam if hit.
	var grazing_dir = Vector2(0.01, 0.99).normalized()
	var results = shade.process_beam(Vector2.ZERO, grazing_dir, Color.WHITE)
	
	assert_eq(results.size(), 0, "Shade should block beam regardless of angle of incidence")
