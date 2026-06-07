extends Area2D

signal state_changed

var is_moving: bool = false
var is_rotating: bool = false
var move_offset: Vector2 = Vector2.ZERO
var initial_angle: float = 0.0

@onready var interact_area = $InteractArea

func _ready() -> void:
    interact_area.input_event.connect(_on_interact_area_input_event)

func _draw() -> void:
    draw_arc(Vector2.ZERO, 60.0, 0, TAU, 32, Color(1.0, 1.0, 1.0, 0.2), 2.0, true)

func _on_interact_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            var local_mouse = get_local_mouse_position()
            var dist = local_mouse.length()
            
            if dist < 30.0:
                is_moving = true
                move_offset = global_position - get_global_mouse_position()
            else:
                is_rotating = true
                initial_angle = get_global_mouse_position().angle_to_point(global_position) - rotation
                
            get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
        if is_moving:
            is_moving = false
            global_position = global_position.snapped(Vector2(10, 10))
            state_changed.emit()
            
        if is_rotating:
            is_rotating = false
            var snapped_rotation = round(rotation / (PI / 12.0)) * (PI / 12.0) # Snap to 15 degrees
            rotation = snapped_rotation
            state_changed.emit()
            
    if event is InputEventMouseMotion:
        if is_moving:
            global_position = get_global_mouse_position() + move_offset
            state_changed.emit()
        elif is_rotating:
            var current_angle = get_global_mouse_position().angle_to_point(global_position)
            rotation = current_angle - initial_angle
            state_changed.emit()

func get_normal() -> Vector2:
    return Vector2.UP.rotated(rotation).normalized()
