class_name Story003ColorFiltrationTest extends "res://addons/gut/test.gd"

const Filter = preload("res://src/gameplay/filter.gd")
const Mirror = preload("res://src/gameplay/mirror.gd")
const Prism = preload("res://src/gameplay/splitter.gd")

# AC-1: Filter tints the beam
func test_filter_tints_beam() -> void:
	var filter = add_child_autofree(Filter.new())
	filter.filter_color = Color.RED
	
	var incoming_dir = Vector2.DOWN
	var result = filter.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	
	assert_eq(result.size(), 1, "Filter should output one beam")
	assert_eq(result[0]["direction"], incoming_dir, "Filter should not change direction")
	assert_eq(result[0]["color"], Color.RED, "Filter should tint beam to red")

# AC-1 Edge Case: A colored beam entering a filter of its exact same color
func test_filter_same_color() -> void:
	var filter = add_child_autofree(Filter.new())
	filter.filter_color = Color.BLUE
	
	var incoming_dir = Vector2.DOWN
	var result = filter.process_beam(Vector2.ZERO, incoming_dir, Color.BLUE)
	
	assert_eq(result.size(), 1)
	assert_eq(result[0]["color"], Color.BLUE)

# AC-2: Last Filter's color wins
func test_last_filter_wins() -> void:
	var filter_red = add_child_autofree(Filter.new())
	filter_red.filter_color = Color.RED
	
	var filter_blue = add_child_autofree(Filter.new())
	filter_blue.filter_color = Color.BLUE
	
	var incoming_dir = Vector2.DOWN
	
	# Pass through Red Filter first
	var res1 = filter_red.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	assert_eq(res1[0]["color"], Color.RED)
	
	# Pass through Blue Filter second
	var res2 = filter_blue.process_beam(res1[0]["origin"], res1[0]["direction"], res1[0]["color"])
	assert_eq(res2[0]["color"], Color.BLUE, "Second filter should overwrite the color")

# AC-3: Colored beams interact with other objects (Mirror & Prism)
func test_colored_beam_interactions() -> void:
	var mirror = add_child_autofree(Mirror.new())
	mirror.rotation = deg_to_rad(45.0)
	
	var prism = add_child_autofree(Prism.new())
	
	# 1. Red beam hits Mirror (should bounce to +X keeping Red)
	var incoming_dir = Vector2.DOWN
	var mirror_res = mirror.process_beam(Vector2.ZERO, incoming_dir, Color.RED)
	assert_eq(mirror_res.size(), 1)
	assert_true(mirror_res[0]["direction"].is_equal_approx(Vector2.RIGHT))
	assert_eq(mirror_res[0]["color"], Color.RED)
	
	# 2. Red beam hits Prism (should split straight and right, keeping Red)
	var prism_res = prism.process_beam(Vector2.ZERO, incoming_dir, Color.RED)
	assert_eq(prism_res.size(), 2)
	assert_eq(prism_res[0]["color"], Color.RED)
	assert_eq(prism_res[1]["color"], Color.RED)
