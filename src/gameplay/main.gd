extends Node2D

const MIRROR_SCENE = preload("res://src/gameplay/mirror.tscn")
const SPLITTER_SCENE = preload("res://src/gameplay/splitter.tscn")

const MAX_BOUNCES = 15
const RAY_LENGTH = 3000.0
const LIGHT_SPEED = 5000.0

const COLOR_MAP = {
	"white": Color(2.0, 1.8, 1.0, 0.8), # Default HDR gold/white
	"red": Color(2.5, 0.2, 0.2, 0.8),
	"green": Color(0.2, 2.5, 0.2, 0.8),
	"blue": Color(0.2, 0.5, 2.5, 0.8),
	"magenta": Color(2.5, 0.2, 2.5, 0.8),
	"yellow": Color(2.5, 2.5, 0.2, 0.8),
	"cyan": Color(0.2, 2.5, 2.5, 0.8)
}

@export var initial_inventory: Dictionary = {"mirror": 1}
@export var next_level_path: String = ""

@onready var sun = $Sun
@onready var ray_lines = $RayLines

var ray_segments: Array[Dictionary] = []
var animated_dist: float = 0.0
var active_rays: Array[Dictionary] = []

func _ready() -> void:
	var briefcase = get_tree().get_first_node_in_group("briefcase_ui")
	if briefcase:
		briefcase.initialize_inventory(initial_inventory)
		
	# Connect existing nodes
	for mirror in get_tree().get_nodes_in_group("mirrors"):
		if mirror.has_signal("state_changed"):
			mirror.state_changed.connect(calculate_light_rays)
		mirror.tree_exiting.connect(_on_piece_tree_exiting)
	for splitter in get_tree().get_nodes_in_group("splitters"):
		if splitter.has_signal("state_changed"):
			splitter.state_changed.connect(calculate_light_rays)
		splitter.tree_exiting.connect(_on_piece_tree_exiting)
	for filter_node in get_tree().get_nodes_in_group("filters"):
		if filter_node.has_signal("state_changed"):
			filter_node.state_changed.connect(calculate_light_rays)
		filter_node.tree_exiting.connect(_on_piece_tree_exiting)
	for portal in get_tree().get_nodes_in_group("portals"):
		if portal.has_signal("state_changed"):
			portal.state_changed.connect(calculate_light_rays)
		portal.tree_exiting.connect(_on_piece_tree_exiting)
	for combiner in get_tree().get_nodes_in_group("combiners"):
		if combiner.has_signal("state_changed"):
			combiner.state_changed.connect(calculate_light_rays)
		combiner.tree_exiting.connect(_on_piece_tree_exiting)
			
	var cipher_ui = get_node_or_null("CipherUI")
	if cipher_ui:
		cipher_ui.cipher_solved.connect(_on_level_solved)
		
	var drop_zone = get_node_or_null("BoardDropZone")
	if drop_zone:
		drop_zone.item_dropped_on_board.connect(_on_board_drop_zone_item_dropped_on_board)
		
	call_deferred("calculate_light_rays")

func _on_board_drop_zone_item_dropped_on_board(tool_type: String, drop_position: Vector2, slot_ref: BriefcaseSlot) -> void:
	# Decrement count
	slot_ref.consume_item()
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("ui_click")
	
	const FILTER_SCENE = preload("res://src/gameplay/filter.tscn")
	var new_piece: Node2D = null
	
	if tool_type == "mirror":
		new_piece = MIRROR_SCENE.instantiate()
	elif tool_type == "prism":
		new_piece = SPLITTER_SCENE.instantiate()
	elif tool_type.begins_with("filter_"):
		new_piece = FILTER_SCENE.instantiate()
		new_piece.filter_color = tool_type.trim_prefix("filter_")
	elif tool_type == "portal":
		# Spawn linked pair
		const PORTAL_SCENE = preload("res://src/gameplay/portal.tscn")
		var portal_a = PORTAL_SCENE.instantiate()
		var portal_b = PORTAL_SCENE.instantiate()
		portal_a.linked_portal = portal_b
		portal_b.linked_portal = portal_a
		
		add_child(portal_a)
		add_child(portal_b)
		
		for p in [portal_a, portal_b]:
			if p.has_signal("state_changed"):
				p.state_changed.connect(calculate_light_rays)
			p.tree_exiting.connect(_on_piece_tree_exiting)
			
		portal_a.global_position = $BoardDropZone.get_global_transform() * drop_position
		portal_b.global_position = $BoardDropZone.get_global_transform() * (drop_position + Vector2(120, 0))
		
		call_deferred("calculate_light_rays")
		return
	elif tool_type == "combiner":
		const COMBINER_SCENE = preload("res://src/gameplay/combiner.tscn")
		new_piece = COMBINER_SCENE.instantiate()
	elif tool_type == "shade":
		const SHADE_SCENE = preload("res://src/gameplay/shade.tscn")
		new_piece = SHADE_SCENE.instantiate()
	elif tool_type == "bender":
		const BENDER_SCENE = preload("res://src/gameplay/bender.tscn")
		new_piece = BENDER_SCENE.instantiate()
		
	if new_piece:
		add_child(new_piece)
		if new_piece.has_signal("state_changed"):
			new_piece.state_changed.connect(calculate_light_rays)
		new_piece.tree_exiting.connect(_on_piece_tree_exiting)
		# Convert control local position to global, then to Node2D local space
		new_piece.global_position = $BoardDropZone.get_global_transform() * drop_position
		# Update rays
		call_deferred("calculate_light_rays")

func _on_level_solved() -> void:
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("target_lit")
	
	if has_node("/root/SaveManager"):
		var level_name = String(name)
		var level_num_str = level_name.trim_prefix("Level")
		if level_num_str.is_valid_int():
			var level_num = level_num_str.to_int()
			var save_mgr = get_node("/root/SaveManager")
			save_mgr.unlock_level(level_num + 1)
			save_mgr.save_game()
			
	await get_tree().create_timer(1.0).timeout
	if next_level_path != "":
		TransitionManager.transition_to(next_level_path)

func _on_piece_tree_exiting() -> void:
	call_deferred("calculate_light_rays")

func get_color_name(c: Color) -> String:
	if c.r > 0.5 and c.g < 0.2 and c.b > 0.5:
		return "magenta"
	elif c.r > 0.5 and c.g > 0.5 and c.b < 0.2:
		return "yellow"
	elif c.r < 0.2 and c.g > 0.5 and c.b > 0.5:
		return "cyan"
	elif c.r > 0.5 and c.g < 0.2 and c.b < 0.2:
		return "red"
	elif c.r < 0.2 and c.g > 0.5 and c.b < 0.2:
		return "green"
	elif c.r < 0.2 and c.g < 0.2 and c.b > 0.5:
		return "blue"
	return "white"

func calculate_light_rays() -> void:
	if not is_inside_tree():
		return
		
	for symbol in get_tree().get_nodes_in_group("symbols"):
		if symbol.has_method("set_illuminated"):
			symbol.set_illuminated(false)
			
	for child in ray_lines.get_children():
		child.queue_free()
		
	ray_segments.clear()
	
	var is_any_dragging = false
	for m in get_tree().get_nodes_in_group("mirrors"):
		if m.get("is_dragging") or m.get("is_rotating") or m.get("is_moving"):
			is_any_dragging = true
	for s in get_tree().get_nodes_in_group("splitters"):
		if s.get("is_dragging") or s.get("is_rotating") or s.get("is_moving"):
			is_any_dragging = true
	for f in get_tree().get_nodes_in_group("filters"):
		if f.get("is_moving"):
			is_any_dragging = true
	for p in get_tree().get_nodes_in_group("portals"):
		if p.get("is_moving") or p.get("is_rotating"):
			is_any_dragging = true
	for c in get_tree().get_nodes_in_group("combiners"):
		if c.get("is_moving") or c.get("is_rotating"):
			is_any_dragging = true
			
	if is_any_dragging:
		animated_dist = INF
	else:
		animated_dist = 0.0

	var space_state = get_world_2d().direct_space_state
	
	# Clear all combiners
	var combiners = get_tree().get_nodes_in_group("combiners")
	for combiner in combiners:
		if combiner.has_method("clear_inputs"):
			combiner.clear_inputs()
			
	active_rays.clear()
	active_rays.append({
		"origin": sun.global_position,
		"direction": Vector2.RIGHT.rotated(sun.rotation),
		"color": "white",
		"bounces_left": MAX_BOUNCES,
		"exclude": [],
		"current_dist": 0.0
	})
	
	var pass_count = 0
	var fired_combiners: Dictionary = {}
	
	# Multi-pass loop for combiner resolution
	while active_rays.size() > 0 and pass_count < 10:
		var propagation_queue = active_rays.duplicate()
		active_rays.clear()
		
		while propagation_queue.size() > 0:
			var ray = propagation_queue.pop_front()
			_cast_ray_segment(space_state, ray, propagation_queue)
			
		var combiner_outputs: Array[Dictionary] = []
		for combiner in combiners:
			if combiner in fired_combiners:
				continue
			if combiner.has_method("resolve_beams"):
				var results = combiner.resolve_beams()
				if not results.is_empty():
					fired_combiners[combiner] = true
					for res in results:
						combiner_outputs.append({
							"origin": combiner.global_position + res["direction"] * 20.0,
							"direction": res["direction"],
							"color": get_color_name(res["color"]),
							"bounces_left": MAX_BOUNCES,
							"exclude": [],
							"current_dist": 0.0
						})
					
		active_rays = combiner_outputs
		pass_count += 1

func _cast_ray_segment(space_state: PhysicsDirectSpaceState2D, ray: Dictionary, ray_queue: Array) -> void:
	var bounces_left: int = ray["bounces_left"]
	if bounces_left <= 0:
		return
		
	var origin: Vector2 = ray["origin"]
	var direction: Vector2 = ray["direction"]
	var ray_color: String = ray["color"]
	var exclude: Array = ray["exclude"]
	var start_dist: float = ray["current_dist"]
	
	var target = origin + direction * RAY_LENGTH
	var query = PhysicsRayQueryParameters2D.create(origin, target)
	query.collide_with_areas = true
	query.exclude = exclude
	query.collision_mask = 1
	
	var result = space_state.intersect_ray(query)
	
	var line = Line2D.new()
	line.width = 4.0
	line.default_color = COLOR_MAP.get(ray_color, COLOR_MAP["white"])
	line.add_point(origin)
	line.add_point(origin)
	
	ray_lines.add_child(line)
	
	var end_pos = target
	var collider = null
	var rid = null
	
	if result:
		end_pos = result.position
		collider = result.collider
		rid = result.rid
		
	var seg_length = origin.distance_to(end_pos)
	var end_dist = start_dist + seg_length
	
	ray_segments.append({
		"line": line,
		"start": origin,
		"end": end_pos,
		"start_dist": start_dist,
		"end_dist": end_dist,
		"collider": collider,
		"color": ray_color,
		"chime_played": false
	})
	
	if result:
		if collider.has_method("process_beam"):
			var color_val = COLOR_MAP.get(ray_color, Color.WHITE)
			var outputs = collider.process_beam(end_pos, direction, color_val)
			for out_beam in outputs:
				var new_dir: Vector2 = out_beam["direction"]
				var new_origin: Vector2 = out_beam["origin"] + new_dir * 1.0
				var new_color := get_color_name(out_beam["color"])
				var new_exclude = out_beam.get("exclude", [rid])
				ray_queue.append({
					"origin": new_origin,
					"direction": new_dir,
					"color": new_color,
					"bounces_left": bounces_left - 1,
					"exclude": new_exclude,
					"current_dist": end_dist
				})

func _process(delta: float) -> void:
	if animated_dist < INF:
		animated_dist += LIGHT_SPEED * delta
		
	for seg in ray_segments:
		if animated_dist < seg.start_dist:
			seg.line.hide()
			if seg.collider and seg.collider.is_in_group("symbols"):
				if seg.collider.has_method("set_illuminated"):
					seg.collider.set_illuminated(false, seg.color)
		else:
			seg.line.show()
			if animated_dist >= seg.end_dist:
				seg.line.set_point_position(1, seg.end)
				
				# Play bounce/chime sound exactly when the ray hits
				if not seg.chime_played and seg.collider:
					seg.chime_played = true
					if seg.collider.is_in_group("mirrors") or seg.collider.is_in_group("splitters") or seg.collider.is_in_group("benders") or seg.collider.is_in_group("combiners"):
						if has_node("/root/AudioManager"):
							get_node("/root/AudioManager").play_sfx("crystal_chime")
				
				if seg.collider and seg.collider.is_in_group("symbols"):
					if seg.collider.has_method("set_illuminated"):
						seg.collider.set_illuminated(true, seg.color)
			else:
				var t = (animated_dist - seg.start_dist) / (seg.end_dist - seg.start_dist)
				seg.line.set_point_position(1, seg.start.lerp(seg.end, t))
				if seg.collider and seg.collider.is_in_group("symbols"):
					if seg.collider.has_method("set_illuminated"):
						seg.collider.set_illuminated(false, seg.color)
