extends CanvasLayer

func _ready():
	for child in get_children():
		if child is CanvasItem:
			child.modulate.a = 0.3
			var tween = create_tween().set_loops()
			tween.tween_property(child, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(child, "modulate:a", 0.3, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
