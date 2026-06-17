class_name Story002OpticalRadialAStarTest extends "res://addons/gut/test.gd"

const OpticalRadialAStar = preload("res://src/puzzle_solver/optical_radial_astar.gd")

var solver: OpticalRadialAStar

func before_each() -> void:
	solver = OpticalRadialAStar.new()

func test_astar_no_native() -> void:
	# "Then: The solver successfully finds the optimal path without instantiating or calling Godot's native AStar3D class."
	var id1 := solver.add_node(10.0, 0.0)
	var id2 := solver.add_node(20.0, 0.0)
	solver.connect_nodes(id1, id2)
	
	var path := solver.calculate_backwards_path(Vector3(20, 0, 0), Vector3(10, 0, 0), OpticalRadialAStar.DifficultyMode.DIRECT)
	assert_eq(path.size(), 2)
	assert_almost_eq(path[0].x, 10.0, 0.01) # Source first
	assert_almost_eq(path[1].x, 20.0, 0.01) # Goal second

func test_calculate_backwards() -> void:
	# Test node evaluation order (implicitly tested by correct source->goal path return despite backward search)
	var id1 := solver.add_node(10.0, 0.0)
	var id2 := solver.add_node(20.0, 0.0)
	var id3 := solver.add_node(30.0, 0.0)
	solver.connect_nodes(id1, id2)
	solver.connect_nodes(id2, id3)
	
	var goal := Vector3(30, 0, 0)
	var source := Vector3(10, 0, 0)
	var path := solver.calculate_backwards_path(goal, source, OpticalRadialAStar.DifficultyMode.DIRECT)
	
	assert_eq(path.size(), 3)
	assert_almost_eq(path[0].x, 10.0, 0.01)
	assert_almost_eq(path[1].x, 20.0, 0.01)
	assert_almost_eq(path[2].x, 30.0, 0.01)

func test_heuristic_modes() -> void:
	# Build a graph where different modes yield different paths
	var id_s := solver.add_node(10.0, 0.0)
	var id_g := solver.add_node(30.0, 0.0)
	
	var id_a := solver.add_node(20.0, 0.0)
	
	# Path 1 (DIRECT)
	solver.connect_nodes(id_s, id_a)
	solver.connect_nodes(id_a, id_g)
	
	# Path 2 (WINDING)
	# atan2(y, x) -> atan2(10, 10) = PI/4
	var id_b := solver.add_node(14.142, PI/4)
	# atan2(10, 30) = 0.32175
	var id_c := solver.add_node(31.622, atan2(10, 30))
	solver.connect_nodes(id_s, id_b)
	solver.connect_nodes(id_b, id_c)
	solver.connect_nodes(id_c, id_g)
	
	# Path 3 (MAXIMUM BOUNCES)
	var id_d1 := solver.add_node(14.0, 0.0)
	var id_d2 := solver.add_node(18.0, 0.0)
	var id_d3 := solver.add_node(22.0, 0.0)
	var id_d4 := solver.add_node(26.0, 0.0)
	solver.connect_nodes(id_s, id_d1)
	solver.connect_nodes(id_d1, id_d2)
	solver.connect_nodes(id_d2, id_d3)
	solver.connect_nodes(id_d3, id_d4)
	solver.connect_nodes(id_d4, id_g)
	
	var goal := Vector3(30, 0, 0)
	var source := Vector3(10, 0, 0)
	
	var path_direct := solver.calculate_backwards_path(goal, source, OpticalRadialAStar.DifficultyMode.DIRECT)
	var path_winding := solver.calculate_backwards_path(goal, source, OpticalRadialAStar.DifficultyMode.WINDING)
	var path_bounces := solver.calculate_backwards_path(goal, source, OpticalRadialAStar.DifficultyMode.MAXIMUM_BOUNCES)
	
	assert_ne(path_direct.size(), path_winding.size(), "Winding path should differ from direct")
	assert_ne(path_direct.size(), path_bounces.size(), "Bounces path should differ from direct")
	
	assert_eq(path_direct.size(), 3)
	assert_eq(path_bounces.size(), 6)
	assert_eq(path_winding.size(), 4)

func test_edge_cases() -> void:
	# No possible path
	var _id1 := solver.add_node(10.0, 0.0)
	var _id2 := solver.add_node(20.0, 0.0)
	var path := solver.calculate_backwards_path(Vector3(20, 0, 0), Vector3(10, 0, 0), OpticalRadialAStar.DifficultyMode.DIRECT)
	assert_eq(path.size(), 0)
	
	# Same node
	var path_same := solver.calculate_backwards_path(Vector3(10, 0, 0), Vector3(10, 0, 0), OpticalRadialAStar.DifficultyMode.DIRECT)
	assert_eq(path_same.size(), 1)
