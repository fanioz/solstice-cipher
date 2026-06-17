class_name Story002BackwardsSolverTest extends "res://addons/gut/test.gd"

const BackwardsSolverClass = preload("res://src/procedural_generation/backwards_solver.gd")

func test_solve_simple_straight_path() -> void:
	var solver = add_child_autofree(BackwardsSolverClass.new())
	
	# Source at (1, 16), Glyph at (1, 10) - straight path, no turns
	var level_config := {
		"source_position": Vector2i(1, 16),
		"glyphs": [
			{
				"letter": "A",
				"index": 0,
				"position": Vector2i(1, 10),
				"color": "white"
			}
		]
	}
	
	var solution: Dictionary = solver.solve_backwards(level_config, 1)
	assert_true(not solution.is_empty(), "Should find a solution")
	assert_eq(solution["tools"].size(), 0, "No tools needed for a straight line")

func test_solve_path_with_turns() -> void:
	var solver = add_child_autofree(BackwardsSolverClass.new())
	
	# Source at (1, 16), Glyph at (5, 12) - requires a turn (Mirror)
	# Path should go (1,16) -> (1,12) -> (5,12) (turn at (1,12))
	# or (1,16) -> (5,16) -> (5,12) (turn at (5,16))
	var level_config := {
		"source_position": Vector2i(1, 16),
		"glyphs": [
			{
				"letter": "B",
				"index": 0,
				"position": Vector2i(5, 12),
				"color": "white"
			}
		]
	}
	
	var solution: Dictionary = solver.solve_backwards(level_config, 1)
	assert_true(not solution.is_empty())
	assert_eq(solution["tools"].size(), 1, "Should place exactly 1 mirror for the turn")
	
	var tool = solution["tools"][0]
	assert_eq(tool["type"], "mirror")
	assert_true(tool["position"] == Vector2i(1, 12) or tool["position"] == Vector2i(5, 16), "Mirror should be placed at the turning corner")

func test_solve_multiple_glyphs_with_prism() -> void:
	var solver = add_child_autofree(BackwardsSolverClass.new())
	
	# Source at (1, 16), Glyphs at (1, 10) and (5, 12)
	# Path to Glyph 1: (1,16) -> (1,10)
	# Path to Glyph 2: (1,16) -> (1,12) -> (5,12)
	# Intersection is at (1,12). It should place a Prism at (1,12)!
	var level_config := {
		"source_position": Vector2i(1, 16),
		"glyphs": [
			{
				"letter": "A",
				"index": 0,
				"position": Vector2i(1, 10),
				"color": "white"
			},
			{
				"letter": "B",
				"index": 1,
				"position": Vector2i(5, 12),
				"color": "white"
			}
		]
	}
	
	var solution: Dictionary = solver.solve_backwards(level_config, 2)
	assert_true(not solution.is_empty())
	
	var tools = solution["tools"]
	
	# We expect 2 tools: 1 Prism at (1,12), and 1 Mirror at (1,12) or (5,12) etc.
	# Let's count types
	var mirror_count := 0
	var prism_count := 0
	
	for t in tools:
		if t["type"] == "mirror":
			mirror_count += 1
		elif t["type"] == "prism":
			prism_count += 1
			assert_eq(t["position"], Vector2i(1, 12), "Prism must be at the intersection cell")
			
	assert_eq(prism_count, 1, "Should place exactly 1 prism at the intersection")

func test_colored_glyph_places_filter() -> void:
	var solver = add_child_autofree(BackwardsSolverClass.new())
	
	# Source at (1, 16), Glyph at (1, 10) requiring red light
	var level_config := {
		"source_position": Vector2i(1, 16),
		"glyphs": [
			{
				"letter": "C",
				"index": 0,
				"position": Vector2i(1, 10),
				"color": "red"
			}
		]
	}
	
	var solution: Dictionary = solver.solve_backwards(level_config, 3) # Tier 3
	assert_true(not solution.is_empty())
	
	var tools = solution["tools"]
	assert_eq(tools.size(), 1, "Should place exactly 1 filter")
	assert_eq(tools[0]["type"], "filter")
	assert_eq(tools[0]["color"], "red")

func test_budget_exceeded_fails() -> void:
	var solver = add_child_autofree(BackwardsSolverClass.new())
	
	# A complex layout requiring many mirrors (say, 5 mirrors) but tier budget is 3
	# E.g. Zig-zag path: (1,16) -> (3,16) -> (3,14) -> (5,14) -> (5,12) -> (7,12)
	# Turning corners at: (3,16), (3,14), (5,14), (5,12) -> 4 mirrors needed.
	# If we request Tier 1 (budget 3), it should reject and return empty {}!
	var level_config := {
		"source_position": Vector2i(1, 16),
		"glyphs": [
			{
				"letter": "D",
				"index": 0,
				"position": Vector2i(3, 10),
				"color": "white"
			},
			{
				"letter": "E",
				"index": 1,
				"position": Vector2i(5, 12),
				"color": "white"
			},
			{
				"letter": "F",
				"index": 2,
				"position": Vector2i(7, 14),
				"color": "white"
			},
			{
				"letter": "G",
				"index": 3,
				"position": Vector2i(9, 8),
				"color": "white"
			}
		]
	}
	
	var solution: Dictionary = solver.solve_backwards(level_config, 1) # Tier 1 -> budget 3
	assert_true(solution.is_empty(), "Should reject the level layout as over budget")
