class_name Story006SpatialTeleportationTest extends "res://addons/gut/test.gd"

const Portal = preload("res://src/gameplay/portal.gd")

# AC-1: Portals maintain relative direction
func test_portals_maintain_relative_direction() -> void:
	var portal_a = add_child_autofree(Portal.new())
	var portal_b = add_child_autofree(Portal.new())
	portal_a.linked_portal = portal_b
	portal_b.linked_portal = portal_a
	
	# Portal B rotated 90 degrees relative to Portal A
	portal_b.rotation = deg_to_rad(90.0)
	
	# Beam enters A perpendicular to its face (direction = Vector2.LEFT)
	var incoming_dir = Vector2.LEFT
	var result = portal_a.process_beam(Vector2.ZERO, incoming_dir, Color.WHITE)
	
	assert_eq(result.size(), 1, "Should output one teleported beam")
	
	# Portal B is rotated 90 degrees. Its local normal is Vector2.RIGHT.
	# With 90 deg rotation, local +X becomes global +Y (Vector2.DOWN).
	# So the exit beam should travel along global Vector2.DOWN.
	var expected_dir = Vector2.DOWN
	assert_true(result[0]["direction"].is_equal_approx(expected_dir), "Exit beam should travel perpendicular to Portal B's face")

# AC-2: Portals are fully bidirectional
func test_portals_bidirectional() -> void:
	var portal_a = add_child_autofree(Portal.new())
	var portal_b = add_child_autofree(Portal.new())
	portal_a.linked_portal = portal_b
	portal_b.linked_portal = portal_a
	
	# Beam 1 enters A -> exits B going right
	var res_a = portal_a.process_beam(Vector2.ZERO, Vector2.LEFT, Color.RED)
	assert_eq(res_a.size(), 1)
	assert_true(res_a[0]["direction"].is_equal_approx(Vector2.RIGHT), "Should exit B going right (+X)")
	assert_eq(res_a[0]["color"], Color.RED)
	
	# Beam 2 enters B -> exits A going right
	var res_b = portal_b.process_beam(Vector2.ZERO, Vector2.LEFT, Color.BLUE)
	assert_eq(res_b.size(), 1)
	assert_true(res_b[0]["direction"].is_equal_approx(Vector2.RIGHT), "Should exit A going right (+X)")
	assert_eq(res_b[0]["color"], Color.BLUE)

# AC-3: Portals process multiple distinct simultaneous beams
func test_portals_multiple_beams() -> void:
	var portal_a = add_child_autofree(Portal.new())
	var portal_b = add_child_autofree(Portal.new())
	portal_a.linked_portal = portal_b
	portal_b.linked_portal = portal_a
	
	# Two separate parallel beams enter Portal A at different offset points
	var origin_1 = Vector2(0, 0.5)
	var origin_2 = Vector2(0, -0.5)
	var incoming_dir = Vector2.LEFT
	
	var res1 = portal_a.process_beam(origin_1, incoming_dir, Color.WHITE)
	var res2 = portal_a.process_beam(origin_2, incoming_dir, Color.WHITE)
	
	assert_eq(res1.size(), 1)
	assert_eq(res2.size(), 1)
	
	# Verify they maintain their relative offsets on Portal B
	assert_true(res1[0]["origin"].is_equal_approx(Vector2(0, 0.5)))
	assert_true(res2[0]["origin"].is_equal_approx(Vector2(0, -0.5)))
