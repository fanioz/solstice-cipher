extends CanvasLayer

@onready var instruction_1 = get_node_or_null("Instruction1")
@onready var instruction_2 = get_node_or_null("Instruction2")
@onready var instruction_3 = get_node_or_null("Instruction3")

func _ready():
	if instruction_3:
		instruction_3.hide()
	for child in get_children():
		if child is CanvasItem:
			child.modulate.a = 0.3
			var tween = create_tween().set_loops()
			tween.tween_property(child, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(child, "modulate:a", 0.3, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			
	var drop_zone = get_parent().get_node_or_null("BoardDropZone")
	if drop_zone:
		drop_zone.item_dropped_on_board.connect(_on_item_dropped)

func _on_item_dropped(tool_type: String, drop_position: Vector2, _slot_ref: Node) -> void:
	if instruction_1:
		instruction_1.hide()
		
	if tool_type == "mirror" and instruction_3 and not instruction_3.visible:
		instruction_3.show()
		# Position Instruction 3 above the drop position
		# Center the label (width is 600)
		instruction_3.position = drop_position + Vector2(-300, -80)
