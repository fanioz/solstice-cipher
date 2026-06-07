extends Node2D

const MAX_BOUNCES = 15
const RAY_LENGTH = 3000.0
const LIGHT_SPEED = 5000.0

@export var next_level_path: String = ""

@onready var sun = $Sun
@onready var ray_lines = $RayLines

var ray_segments: Array[Dictionary] = []
var animated_dist: float = 0.0

func _ready() -> void:
    for mirror in get_tree().get_nodes_in_group("mirrors"):
        if mirror.has_signal("state_changed"):
            mirror.state_changed.connect(calculate_light_rays)
    for splitter in get_tree().get_nodes_in_group("splitters"):
        if splitter.has_signal("state_changed"):
            splitter.state_changed.connect(calculate_light_rays)
            
    var cipher_ui = get_node_or_null("CipherUI")
    if cipher_ui:
        cipher_ui.cipher_solved.connect(_on_level_solved)
        
    call_deferred("calculate_light_rays")

func _on_level_solved() -> void:
    print("Cipher Solved! Loading next level...")
    await get_tree().create_timer(1.0).timeout
    if next_level_path != "":
        TransitionManager.transition_to(next_level_path)
    else:
        print("You win the game!")

func calculate_light_rays() -> void:
    for symbol in get_tree().get_nodes_in_group("symbols"):
        if symbol.has_method("set_illuminated"):
            symbol.set_illuminated(false)
            
    for child in ray_lines.get_children():
        child.queue_free()
        
    ray_segments.clear()
    
    var is_any_dragging = false
    for m in get_tree().get_nodes_in_group("mirrors"):
        if m.get("is_dragging") or m.get("is_rotating"):
            is_any_dragging = true
    for s in get_tree().get_nodes_in_group("splitters"):
        if s.get("is_dragging") or s.get("is_rotating"):
            is_any_dragging = true
            
    if is_any_dragging:
        animated_dist = INF
    else:
        animated_dist = 0.0

    var space_state = get_world_2d().direct_space_state
    
    var origin = sun.global_position
    var direction = Vector2.RIGHT.rotated(sun.rotation)
    
    _cast_ray(space_state, origin, direction, MAX_BOUNCES, [], 0.0)

func _cast_ray(space_state: PhysicsDirectSpaceState2D, origin: Vector2, direction: Vector2, bounces_left: int, exclude: Array, current_dist: float) -> void:
    if bounces_left <= 0:
        return
        
    var target = origin + direction * RAY_LENGTH
    var query = PhysicsRayQueryParameters2D.create(origin, target)
    query.collide_with_areas = true
    query.exclude = exclude
    query.collision_mask = 1
    
    var result = space_state.intersect_ray(query)
    
    var line = Line2D.new()
    line.width = 4.0
    line.default_color = Color(2.0, 1.8, 1.0, 0.8) # HDR Soft golden light
    line.add_point(origin)
    line.add_point(origin) # Start at length 0
    
    ray_lines.add_child(line)
    
    var end_pos = target
    var collider = null
    var rid = null
    
    if result:
        end_pos = result.position
        collider = result.collider
        rid = result.rid
        
    var seg_length = origin.distance_to(end_pos)
    var end_dist = current_dist + seg_length
    
    ray_segments.append({
        "line": line,
        "start": origin,
        "end": end_pos,
        "start_dist": current_dist,
        "end_dist": end_dist,
        "collider": collider
    })
    
    if result:
        if collider.is_in_group("mirrors"):
            var normal = collider.get_normal() if collider.has_method("get_normal") else result.normal
            var reflection = direction.bounce(normal)
            var new_origin = end_pos + reflection * 1.0
            _cast_ray(space_state, new_origin, reflection, bounces_left - 1, [rid], end_dist)
            
        elif collider.is_in_group("splitters"):
            var normal = collider.get_normal() if collider.has_method("get_normal") else result.normal
            var reflection = direction.bounce(normal)
            
            # Ray 1: Reflected
            var reflected_origin = end_pos + reflection * 1.0
            _cast_ray(space_state, reflected_origin, reflection, bounces_left - 1, [rid], end_dist)
            
            # Ray 2: Transmitted (passes straight through)
            var transmitted_origin = end_pos + direction * 1.0
            _cast_ray(space_state, transmitted_origin, direction, bounces_left - 1, [rid], end_dist)

func _process(delta: float) -> void:
    if animated_dist < INF:
        animated_dist += LIGHT_SPEED * delta
        
    for seg in ray_segments:
        if animated_dist < seg.start_dist:
            seg.line.hide()
            if seg.collider and seg.collider.is_in_group("symbols"):
                if seg.collider.has_method("set_illuminated"):
                    seg.collider.set_illuminated(false)
        else:
            seg.line.show()
            if animated_dist >= seg.end_dist:
                seg.line.set_point_position(1, seg.end)
                if seg.collider and seg.collider.is_in_group("symbols"):
                    if seg.collider.has_method("set_illuminated"):
                        seg.collider.set_illuminated(true)
            else:
                var t = (animated_dist - seg.start_dist) / (seg.end_dist - seg.start_dist)
                seg.line.set_point_position(1, seg.start.lerp(seg.end, t))
                if seg.collider and seg.collider.is_in_group("symbols"):
                    if seg.collider.has_method("set_illuminated"):
                        seg.collider.set_illuminated(false)
