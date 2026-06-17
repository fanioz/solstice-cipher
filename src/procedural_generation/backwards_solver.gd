class_name BackwardsSolver extends Node

const BOARD_COLS: int = 12
const BOARD_ROWS: int = 18

func get_piece_budget(tier: int) -> int:
	match tier:
		1: return 3
		2: return 4
		3: return 5
		4: return 5
		5: return 6
		6: return 6
		7: return 7
		8: return 7
		9: return 6
		10, _: return 6

## Grid-based BFS pathfinder to ensure perfectly straight segments on the 2D board.
func find_grid_path(start: Vector2i, target: Vector2i) -> Array[Vector2i]:
	var queue: Array[Vector2i] = [start]
	var came_from: Dictionary = {}
	came_from[start] = start
	
	while not queue.is_empty():
		var current: Vector2i = queue.pop_front()
		if current == target:
			break
			
		for dir: Vector2i in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			var neighbor := current + dir
			if neighbor.x >= 0 and neighbor.x < BOARD_COLS and neighbor.y >= 0 and neighbor.y < BOARD_ROWS:
				if not came_from.has(neighbor):
					came_from[neighbor] = current
					queue.append(neighbor)
					
	if not came_from.has(target):
		var empty: Array[Vector2i] = []
		return empty
		
	var path: Array[Vector2i] = []
	var curr := target
	while curr != start:
		path.append(curr)
		curr = came_from[curr]
	path.append(start)
	path.reverse()
	return path

## Solves backwards from level glyphs to the source, placing required tools.
## Returns a dictionary of placed tools, or empty dictionary if unsolvable/over-budget.
func solve_backwards(level_config: Dictionary, tier: int) -> Dictionary:
	var source_pos: Vector2i = level_config["source_position"]
	var glyphs: Array = level_config["glyphs"]
	
	# Calculate paths from each glyph to the source
	var paths: Array[Array] = []
	
	for glyph: Dictionary in glyphs:
		var g_pos: Vector2i = glyph["position"]
		# We find path from source to glyph
		var path: Array[Vector2i] = find_grid_path(source_pos, g_pos)
		
		if path.is_empty():
			return {} # Unsolvable path
			
		paths.append(path)
		
	# Trace directions and identify intersections/turns
	var outgoing_dirs: Dictionary = {}
	var incoming_dirs: Dictionary = {}
	var path_cells_set: Dictionary = {}
	
	for path_var: Variant in paths:
		var path: Array = path_var
		for i in range(path.size() - 1):
			var c1: Vector2i = path[i]
			var c2: Vector2i = path[i+1]
			var dir: Vector2i = c2 - c1
			
			path_cells_set[c1] = true
			path_cells_set[c2] = true
			
			if not outgoing_dirs.has(c1):
				outgoing_dirs[c1] = []
			if not outgoing_dirs[c1].has(dir):
				outgoing_dirs[c1].append(dir)
				
			if not incoming_dirs.has(c2):
				incoming_dirs[c2] = []
			if not incoming_dirs[c2].has(dir):
				incoming_dirs[c2].append(dir)
				
	var tools: Array[Dictionary] = []
	var tools_by_pos: Dictionary = {}
	
	for cell: Vector2i in path_cells_set:
		if cell == source_pos:
			continue
			
		# Check if cell is a glyph position
		var is_glyph := false
		for glyph: Dictionary in glyphs:
			if glyph["position"] == cell:
				is_glyph = true
				break
		if is_glyph:
			continue
			
		var cell_out: Array = outgoing_dirs.get(cell, [])
		var cell_in: Array = incoming_dirs.get(cell, [])
		
		if cell_out.size() > 1:
			# Split point -> Place Prism/Splitter
			var dir_in: Vector2i = cell_in[0] if not cell_in.is_empty() else Vector2i.UP
			var rot := atan2(dir_in.y, dir_in.x)
			var tool := {
				"type": "prism",
				"position": cell,
				"rotation": rot
			}
			tools.append(tool)
			tools_by_pos[cell] = tool
		elif cell_out.size() == 1 and not cell_in.is_empty():
			# Turn point -> Place Mirror
			var dir_in: Vector2i = cell_in[0]
			var dir_out: Vector2i = cell_out[0]
			
			if dir_in != dir_out:
				var n := (Vector2(dir_out) - Vector2(dir_in)).normalized()
				var rot := atan2(n.y, n.x)
				var tool := {
					"type": "mirror",
					"position": cell,
					"rotation": rot
				}
				tools.append(tool)
				tools_by_pos[cell] = tool
				
	# Place color filters for colored glyphs
	for glyph: Dictionary in glyphs:
		var required_color: String = glyph.get("color", "white")
		if required_color == "white":
			continue
			
		# Find glyph path
		var path_of_glyph: Array = []
		for path_var: Variant in paths:
			var path: Array = path_var
			if path.back() == glyph["position"]:
				path_of_glyph = path
				break
				
		# Find an empty intermediate cell on the path to place the filter
		var filter_placed := false
		for i in range(path_of_glyph.size() - 2, 0, -1):
			var cell: Vector2i = path_of_glyph[i]
			if not tools_by_pos.has(cell):
				# Calculate filter rotation (along the beam path)
				var next_cell: Vector2i = path_of_glyph[i+1]
				var dir: Vector2 = Vector2(next_cell - cell).normalized()
				var rot := atan2(dir.y, dir.x)
				
				var tool := {
					"type": "filter",
					"position": cell,
					"rotation": rot,
					"color": required_color
				}
				tools.append(tool)
				tools_by_pos[cell] = tool
				filter_placed = true
				break
				
		if not filter_placed:
			return {} # Over-constrained path, no place for filter
			
	# Budget check
	if tools.size() > get_piece_budget(tier):
		return {} # Over budget
		
	return {
		"tools": tools
	}
