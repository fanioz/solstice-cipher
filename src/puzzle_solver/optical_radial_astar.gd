class_name OpticalRadialAStar extends RefCounted
## Custom pure GDScript pathfinding tailored for radial/polar geometric graph.
## Handles calculation of deterministic, float-snapped paths ensuring 15-degree precision.

enum DifficultyMode { DIRECT, WINDING, MAXIMUM_BOUNCES }

const ANGLE_STEP_RAD := PI / 12.0 # 15 degrees
const PRECISION_VEC3 := Vector3(0.001, 0.001, 0.001)
const PRECISION_VEC2 := Vector2(0.001, 0.001)

## Data structure for representing off-grid nodes in a radial graph context.
class RadialNode extends RefCounted:
	var id: int
	var radius: float
	var angle_rad: float
	var neighbors: Dictionary = {} # Dictionary[int, float] mapping neighbor_id to edge cost
	
	func _init(p_id: int, p_radius: float, p_angle: float) -> void:
		id = p_id
		radius = p_radius
		angle_rad = p_angle

	## Calculates Cartesian coordinates mapped from the polar coordinates, heavily quantized.
	func get_position() -> Vector2:
		var x := cos(angle_rad) * radius
		var y := sin(angle_rad) * radius
		return Vector2(x, y).snapped(Vector2(0.001, 0.001))

var _nodes: Dictionary = {} # Dictionary[int, RadialNode]
var _next_id: int = 1

## Explicitly quantizes 3D vector coordinates to precision boundaries.
func _snap_vector(vec: Vector3) -> Vector3:
	return vec.snapped(PRECISION_VEC3)

## Explicitly quantizes 2D vector coordinates to precision boundaries.
func _snap_vector2(vec: Vector2) -> Vector2:
	return vec.snapped(PRECISION_VEC2)

## Snaps angle to strictly 15-degree increments to prevent iterative drift.
func quantize_angle(angle_rad: float) -> float:
	var quantized := snappedf(angle_rad, ANGLE_STEP_RAD)
	# Wrap between 0 and TAU, but if it's exactly TAU we want 0.0 for consistency
	var wrapped := wrapf(quantized, 0.0, TAU)
	# Avoid negative zero or tiny floating issues near 0
	if is_zero_approx(wrapped) or is_equal_approx(wrapped, TAU):
		return 0.0
	return wrapped

## Registers a new off-grid radial node into the graph data structure.
func add_node(radius: float, angle_rad: float) -> int:
	var id := _next_id
	_next_id += 1
	var q_angle := quantize_angle(angle_rad)
	_nodes[id] = RadialNode.new(id, radius, q_angle)
	return id

## Retrieves the instance of a node by its ID.
func get_node(id: int) -> RadialNode:
	return _nodes.get(id) as RadialNode

## Adds a bidirectional edge connecting two node IDs with an implicitly calculated Euclidean cost.
func connect_nodes(id1: int, id2: int) -> void:
	if not _nodes.has(id1) or not _nodes.has(id2):
		return
	if id1 == id2:
		return
	var n1: RadialNode = _nodes[id1]
	var n2: RadialNode = _nodes[id2]
	var cost := n1.get_position().distance_to(n2.get_position())
	n1.neighbors[id2] = cost
	n2.neighbors[id1] = cost

## Returns a Dictionary mapping neighbor IDs to edge costs for a given node.
func get_neighbors(id: int) -> Dictionary:
	var node: RadialNode = _nodes.get(id)
	if node:
		return node.neighbors
	return {}

func _find_closest_node(pos: Vector3) -> int:
	var pos_2d := Vector2(pos.x, pos.y)
	var closest_id := -1
	var min_dist := INF
	for id: int in _nodes:
		var d := pos_2d.distance_to((_nodes[id] as RadialNode).get_position())
		if d < min_dist:
			min_dist = d
			closest_id = id
	return closest_id

func _compute_heuristic(node_pos: Vector2, target_pos: Vector2, mode: DifficultyMode) -> float:
	var base_dist := node_pos.distance_to(target_pos)
	match mode:
		DifficultyMode.DIRECT:
			return base_dist
		DifficultyMode.WINDING:
			return base_dist * 2.0
		DifficultyMode.MAXIMUM_BOUNCES:
			return base_dist * 0.1
	return base_dist

## Calculates mathematical backward solvable paths.
func _evaluate_neighbors(current_id: int, mode: DifficultyMode, target_pos_2d: Vector2, open_set: Array[int], came_from: Dictionary, g_score: Dictionary, f_score: Dictionary) -> void:
	var current_node := _nodes[current_id] as RadialNode
	var neighbors: Dictionary = current_node.neighbors
	
	for neighbor_id_var: Variant in neighbors:
		var neighbor_id: int = neighbor_id_var
		var edge_cost: float = neighbors[neighbor_id]
		
		var penalty := 0.0
		var neighbor_pos := (_nodes[neighbor_id] as RadialNode).get_position()
		match mode:
			DifficultyMode.WINDING:
				var pen := 0.0
				if came_from.has(current_id):
					var parent_id: int = came_from[current_id]
					var p1 := (_nodes[parent_id] as RadialNode).get_position()
					var p2 := current_node.get_position()
					var p3 := neighbor_pos
					var dir1 := (p2 - p1).normalized()
					var dir2 := (p3 - p2).normalized()
					var dot_val := dir1.dot(dir2)
					# dot_val == 1 means straight line. Penalize straight lines heavily.
					pen = maxf(0.0, dot_val) * 200.0
				penalty = pen
			DifficultyMode.MAXIMUM_BOUNCES:
				penalty = edge_cost * edge_cost * 0.1
				
		var tentative_g: float = g_score[current_id] + edge_cost + penalty
		
		if tentative_g < g_score[neighbor_id]:
			came_from[neighbor_id] = current_id
			g_score[neighbor_id] = tentative_g
			var h := _compute_heuristic(neighbor_pos, target_pos_2d, mode)
			f_score[neighbor_id] = tentative_g + h
			if not open_set.has(neighbor_id):
				open_set.append(neighbor_id)

func calculate_backwards_path(goal_pos: Vector3, source_pos: Vector3, mode: DifficultyMode) -> PackedVector3Array:
	var start_id := _find_closest_node(goal_pos)
	var target_id := _find_closest_node(source_pos)
	
	if start_id == -1 or target_id == -1:
		return PackedVector3Array()
		
	if start_id == target_id:
		return PackedVector3Array([_snap_vector(source_pos)])

	var target_pos_2d := (_nodes[target_id] as RadialNode).get_position()

	var open_set: Array[int] = [start_id]
	var came_from: Dictionary = {}
	
	var g_score: Dictionary = {}
	var f_score: Dictionary = {}
	
	for id: int in _nodes:
		g_score[id] = INF
		f_score[id] = INF
		
	g_score[start_id] = 0.0
	f_score[start_id] = _compute_heuristic((_nodes[start_id] as RadialNode).get_position(), target_pos_2d, mode)
	
	var path_found := false
	
	while open_set.size() > 0:
		var current_id: int = open_set[0]
		var min_f: float = f_score[current_id]
		var current_idx := 0
		for i in range(1, open_set.size()):
			var id: int = open_set[i]
			var f: float = f_score[id]
			if f < min_f:
				min_f = f
				current_id = id
				current_idx = i
				
		if current_id == target_id:
			path_found = true
			break
			
		open_set.remove_at(current_idx)
		
		_evaluate_neighbors(current_id, mode, target_pos_2d, open_set, came_from, g_score, f_score)

	if not path_found:
		return PackedVector3Array()
		
	var path := PackedVector3Array()
	var current_reconstruct := target_id
	while came_from.has(current_reconstruct):
		var p2d := (_nodes[current_reconstruct] as RadialNode).get_position()
		var p3d := Vector3(p2d.x, p2d.y, 0.0)
		path.append(_snap_vector(p3d))
		current_reconstruct = came_from[current_reconstruct]
		
	var p2d_goal := (_nodes[start_id] as RadialNode).get_position()
	var p3d_goal := Vector3(p2d_goal.x, p2d_goal.y, 0.0)
	path.append(_snap_vector(p3d_goal))
	
	return path
