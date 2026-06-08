extends Area2D

signal illumination_changed(is_lit: bool, index: int, letter: String)

@export var letter: String = "?"
@export var cipher_index: int = 0
@export_enum("white", "red", "green", "blue") var required_color: String = "white"

var is_illuminated: bool = false
@onready var visual = $Sprite2D

func set_illuminated(state: bool, hit_color: String = "white") -> void:
	# If we are trying to turn it on, but the color doesn't match, force it off
	if state and hit_color != required_color:
		state = false
		
	if is_illuminated == state:
		return
		
	is_illuminated = state
	if is_illuminated:
		# Use a dynamic glow based on the required color
		var color_map = {
			"white": Color(2.5, 2.0, 0.5, 1.0),
			"red": Color(2.5, 0.2, 0.2, 1.0),
			"green": Color(0.2, 2.5, 0.2, 1.0),
			"blue": Color(0.2, 0.5, 2.5, 1.0)
		}
		visual.modulate = color_map.get(required_color, color_map["white"])
	else:
		visual.modulate = Color(0.3, 0.3, 0.3, 1.0) # Dim gray
		
	illumination_changed.emit(is_illuminated, cipher_index, letter)
