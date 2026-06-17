class_name Story007MultiSourceConvergenceTest extends "res://addons/gut/test.gd"

const CombinerClass = preload("res://src/gameplay/combiner.gd")

class MockSource extends Node2D:
	var beam_color: Color = Color.WHITE
	var direction: Vector2 = Vector2.ZERO
	
	func _init(p_pos: Vector2, p_dir: Vector2, p_color: Color) -> void:
		position = p_pos
		direction = p_dir
		beam_color = p_color

class TestPropagationManager extends Node:
	const MAX_BOUNCES = 15
	var mock_hits: Array[Dictionary] = []
	var traced_rays: Array[Dictionary] = []
	
	func update_beams(sources: Array) -> void:
		var active_rays: Array[Dictionary] = []
		for source in sources:
			active_rays.append({
				"origin": source.position,
				"direction": source.direction,
				"color": source.beam_color,
				"bounces": 0
			})
			
		var pass_count = 0
		var fired_combiners: Dictionary = {}
		while active_rays.size() > 0 and pass_count < 10:
			var propagation_queue = active_rays.duplicate()
			active_rays.clear()
			
			while propagation_queue.size() > 0:
				var ray = propagation_queue.pop_front()
				_trace_beam(ray, active_rays)
				
			# Combiner resolution
			var combiners = []
			for hit in mock_hits:
				if is_instance_valid(hit["collider"]) and not hit["collider"] in combiners:
					combiners.append(hit["collider"])
					
			for combiner in combiners:
				if combiner in fired_combiners:
					continue
				var results = combiner.resolve_beams()
				if not results.is_empty():
					fired_combiners[combiner] = true
					for res in results:
						active_rays.append({
							"origin": res["origin"],
							"direction": res["direction"],
							"color": res["color"],
							"bounces": 1
						})
			pass_count += 1
			
	func _trace_beam(ray: Dictionary, active_rays: Array[Dictionary]) -> void:
		traced_rays.append(ray.duplicate())
		
		if ray["bounces"] >= MAX_BOUNCES:
			return
			
		for hit in mock_hits:
			if ray["direction"].is_equal_approx(hit["direction"]):
				var hit_node = hit["collider"]
				var new_rays = hit_node.process_beam(Vector2.ZERO, ray["direction"], ray["color"])
				for new_ray in new_rays:
					new_ray["bounces"] = ray["bounces"] + 1
					active_rays.append(new_ray)
				return

# AC-1: Combiner input matching and color mixing
func test_combiner_left_and_right_inputs() -> void:
	var combiner = add_child_autofree(CombinerClass.new())
	combiner.global_position = Vector2.ZERO
	
	# Beam 1 hits top/left face: coming from -Y towards +Y (direction = (0, 1))
	var left_incoming_dir = Vector2.DOWN
	var left_res = combiner.process_beam(Vector2(0, -2), left_incoming_dir, Color.RED)
	assert_eq(left_res.size(), 0, "No output when only left input is active")
	assert_true(combiner.input_left_active, "Left input should be active")
	assert_false(combiner.input_right_active, "Right input should not be active")
	
	# Beam 2 hits bottom/right face: coming from +Y towards -Y (direction = (0, -1))
	var right_incoming_dir = Vector2.UP
	var right_res = combiner.process_beam(Vector2(0, 2), right_incoming_dir, Color.BLUE)
	assert_true(combiner.input_right_active, "Right input should be active")
	
	# Resolve the combiner
	var final_res = combiner.resolve_beams()
	assert_eq(final_res.size(), 1, "Should output a combined beam when both inputs are active")
	assert_eq(final_res[0]["color"], Color.MAGENTA, "Blended color should be Magenta")
	assert_true(final_res[0]["direction"].is_equal_approx(Vector2.RIGHT), "Output should fire forward (+X)")

# AC-2: Ignoring non-inputs
func test_combiner_ignores_non_inputs() -> void:
	var combiner = add_child_autofree(CombinerClass.new())
	combiner.global_position = Vector2.ZERO
	
	# Beam hits from front: coming from -X towards +X (direction = (1, 0))
	var front_res = combiner.process_beam(Vector2(-2, 0), Vector2.RIGHT, Color.RED)
	assert_eq(front_res.size(), 0)
	assert_false(combiner.input_left_active, "Left input should not be active from front hit")
	assert_false(combiner.input_right_active, "Right input should not be active from front hit")
	
	var final_res = combiner.resolve_beams()
	assert_eq(final_res.size(), 0)

# AC-3: Integration with TestPropagationManager
func test_propagation_manager_resolves_combiner() -> void:
	var root_node = add_child_autofree(Node2D.new())
	
	var combiner = CombinerClass.new()
	root_node.add_child(combiner)
	combiner.global_position = Vector2.ZERO
	
	var manager = TestPropagationManager.new()
	root_node.add_child(manager)
	
	var source_left = MockSource.new(Vector2(0, -2), Vector2.DOWN, Color.RED)
	var source_right = MockSource.new(Vector2(0, 2), Vector2.UP, Color.BLUE)
	root_node.add_child(source_left)
	root_node.add_child(source_right)
	
	manager.mock_hits.append({
		"direction": Vector2.DOWN,
		"collider": combiner
	})
	manager.mock_hits.append({
		"direction": Vector2.UP,
		"collider": combiner
	})
	
	manager.update_beams([source_left, source_right])
	
	assert_eq(manager.traced_rays.size(), 3, "Should trace 3 rays total")
	var combined_ray = manager.traced_rays[2]
	assert_eq(combined_ray["color"], Color.MAGENTA)
	assert_true(combined_ray["direction"].is_equal_approx(Vector2.RIGHT))
	assert_eq(combined_ray["bounces"], 1)
