extends CanvasLayer

@onready var color_rect = $ColorRect

func _ready() -> void:
	color_rect.modulate.a = 0.0
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func transition_to(scene_path: String) -> void:
	# Block input during transition so the user can't click things
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Fade to black
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.0)
	await tween.finished
	
	# Swap scene
	get_tree().change_scene_to_file(scene_path)
	
	# Fade back in
	var tween2 = create_tween()
	tween2.tween_property(color_rect, "modulate:a", 0.0, 1.0)
	await tween2.finished
	
	# Restore input
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
