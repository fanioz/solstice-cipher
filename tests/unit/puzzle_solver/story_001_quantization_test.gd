class_name Story001QuantizationTest extends "res://addons/gut/test.gd"

const OpticalRadialAStar = preload("res://src/puzzle_solver/optical_radial_astar.gd")

var solver: OpticalRadialAStar

func before_each() -> void:
	solver = OpticalRadialAStar.new()

func test_snap_vector3() -> void:
	# Given: An arbitrary Vector3 with high-precision or slightly imprecise floating-point values
	var input_vec := Vector3(1.0004, 2.0006, -3.0009)
	# When: The snap utility function is applied
	var snapped := solver._snap_vector(input_vec)
	# Then: The resulting vector precisely matches the expected quantized coordinates
	assert_almost_eq(snapped.x, 1.000, 0.0001)
	assert_almost_eq(snapped.y, 2.001, 0.0001)
	assert_almost_eq(snapped.z, -3.001, 0.0001)

func test_snap_vector3_edge_cases() -> void:
	# Edge cases: Zero vectors, extremely small values, large coordinate values.
	var zero_vec := solver._snap_vector(Vector3.ZERO)
	assert_almost_eq(zero_vec.x, 0.0, 0.0001)
	assert_almost_eq(zero_vec.y, 0.0, 0.0001)
	assert_almost_eq(zero_vec.z, 0.0, 0.0001)

	var small_vec := solver._snap_vector(Vector3(0.0001, 0.0004, -0.0001))
	assert_almost_eq(small_vec.x, 0.0, 0.0001)
	assert_almost_eq(small_vec.y, 0.0, 0.0001)
	assert_almost_eq(small_vec.z, 0.0, 0.0001)

	var large_vec := solver._snap_vector(Vector3(1000000.0004, 2000000.0006, -3000000.0009))
	assert_almost_eq(large_vec.x, 1000000.0, 0.0001)
	assert_almost_eq(large_vec.y, 2000000.0, 0.0001)
	assert_almost_eq(large_vec.z, -3000000.0, 0.0001)

func test_angular_quantization() -> void:
	# Given: A starting angle and an iterative rotation operation of exactly 15 degrees.
	var start_angle := 0.0
	var current_angle := start_angle
	var step := deg_to_rad(15.0)
	
	# When: The rotation is applied iteratively 24 times (totaling 360 degrees).
	for i in range(24):
		current_angle += step
		# Intentionally introduce floating-point drift
		current_angle += 0.0000001
		current_angle = solver.quantize_angle(current_angle)
	
	# Then: The final accumulated angle precisely matches the starting angle
	assert_almost_eq(current_angle, start_angle, 0.000001)

func test_angular_quantization_edge_cases() -> void:
	# Negative rotation angles
	var current_angle := 0.0
	var step := deg_to_rad(-15.0)
	for i in range(24):
		current_angle += step
		current_angle -= 0.0000001
		current_angle = solver.quantize_angle(current_angle)
	assert_almost_eq(current_angle, 0.0, 0.000001)
	
	# Alternating positive and negative rotations
	current_angle = solver.quantize_angle(deg_to_rad(15.0) + 0.0000001)
	current_angle = solver.quantize_angle(current_angle + deg_to_rad(-15.0) - 0.0000001)
	assert_almost_eq(current_angle, 0.0, 0.000001)

func test_radial_graph_data_structures() -> void:
	# Given: An empty radial graph data structure.
	# When: Multiple off-grid nodes are added and connected with defined edges.
	var id1 := solver.add_node(10.0, deg_to_rad(15.0))
	var id2 := solver.add_node(20.0, deg_to_rad(30.0))
	var id3 := solver.add_node(30.0, deg_to_rad(45.0))
	
	solver.connect_nodes(id1, id2)
	solver.connect_nodes(id2, id3)
	
	# Then: The graph correctly stores the nodes
	var node1 := solver.get_node(id1)
	assert_eq(node1.radius, 10.0)
	assert_almost_eq(node1.angle_rad, deg_to_rad(15.0), 0.00001)
	
	# retrieves connected neighbors
	var n1_neighbors := solver.get_neighbors(id1)
	assert_true(n1_neighbors.has(id2))
	assert_false(n1_neighbors.has(id3))
	
	var n2_neighbors := solver.get_neighbors(id2)
	assert_true(n2_neighbors.has(id1))
	assert_true(n2_neighbors.has(id3))
	
	# and calculates correct edge costs based on radial geometry
	var expected_cost := node1.get_position().distance_to(solver.get_node(id2).get_position())
	assert_eq(n1_neighbors[id2], expected_cost)

func test_radial_graph_edge_cases() -> void:
	# Duplicate nodes: Graph stores them correctly (as new unique IDs)
	var id1 := solver.add_node(10.0, 0.0)
	var id2 := solver.add_node(10.0, 0.0)
	assert_ne(id1, id2)
	
	# Self-referencing edges
	solver.connect_nodes(id1, id1)
	assert_false(solver.get_neighbors(id1).has(id1))
	
	# Querying non-existent nodes
	var non_existent := solver.get_node(999)
	assert_null(non_existent)
	
	var non_existent_neighbors := solver.get_neighbors(999)
	assert_eq(non_existent_neighbors.size(), 0)
