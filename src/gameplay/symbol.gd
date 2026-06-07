extends Area2D

signal illumination_changed(is_lit: bool, index: int, letter: String)

@export var letter: String = "?"
@export var cipher_index: int = 0

var is_illuminated: bool = false
@onready var visual = $Sprite2D

func set_illuminated(state: bool) -> void:
    if is_illuminated == state:
        return
        
    is_illuminated = state
    if is_illuminated:
        visual.modulate = Color(2.5, 2.0, 0.5, 1.0) # HDR Glowing gold
    else:
        visual.modulate = Color(0.3, 0.3, 0.3, 1.0) # Dim gray
        
    illumination_changed.emit(is_illuminated, cipher_index, letter)
