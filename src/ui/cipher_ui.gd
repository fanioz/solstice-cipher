extends CanvasLayer

signal cipher_solved

@onready var container = $MarginContainer/VBoxContainer/HBoxContainer
@onready var level_label = $MarginContainer/VBoxContainer/LevelLabel

const LEVEL_NAMES = {
	1: "Introduction",
	2: "Split",
	3: "Sun",
	4: "Grid Reflection",
	5: "Ray Path",
	6: "Light Wave",
	7: "Arc Path",
	8: "Orbit",
	9: "Sky Vault",
	10: "Daybreak",
	11: "Dawn Refraction",
	12: "Dusk Shadow",
	13: "Star Field",
	14: "Moonlight",
	15: "Halo Corona"
}

var slots: Array = []
var _is_solved: bool = false
var win_timer: Timer

func _ready() -> void:
	win_timer = Timer.new()
	win_timer.wait_time = 1.0
	win_timer.one_shot = true
	win_timer.timeout.connect(_on_win_timer_timeout)
	add_child(win_timer)
	
	# Wait a frame so all symbols are ready and in the tree
	call_deferred("setup_ui")

func setup_ui() -> void:
	if not is_inside_tree():
		return
		
	# Set level indicator text
	var scene_name = get_tree().current_scene.name
	var level_num_str = scene_name.trim_prefix("Level")
	if level_num_str.is_valid_int():
		var num = level_num_str.to_int()
		var level_title = LEVEL_NAMES.get(num, "")
		if level_title != "":
			level_label.text = "LEVEL %d: %s" % [num, level_title.to_upper()]
		else:
			level_label.text = "LEVEL %d" % num
	else:
		level_label.text = scene_name.to_upper()
		
	level_label.add_theme_font_size_override("font_size", 20)
	level_label.add_theme_color_override("font_color", Color(0.6, 0.8, 1.0, 0.7))
		
	var symbols = get_tree().get_nodes_in_group("symbols")
	
	# Sort symbols by their cipher index to ensure the word is spelled left-to-right
	symbols.sort_custom(func(a, b): return a.cipher_index < b.cipher_index)
	
	# Create a Label slot for each symbol
	for symbol in symbols:
		var label = Label.new()
		label.text = "_"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 48)
		label.add_theme_color_override("font_color", Color(0.3, 0.3, 0.3, 1.0))
		container.add_child(label)
		slots.append(label)
		
		# Connect to the symbol's signal
		symbol.illumination_changed.connect(_on_symbol_illumination_changed)

func _on_symbol_illumination_changed(is_lit: bool, index: int, letter: String) -> void:
	if index < 0 or index >= slots.size():
		return
		
	var label = slots[index]
	if is_lit:
		label.text = letter
		label.add_theme_color_override("font_color", Color(2.5, 2.0, 0.5, 1.0)) # HDR Glowing gold
	else:
		label.text = "_"
		label.add_theme_color_override("font_color", Color(0.3, 0.3, 0.3, 1.0))
		
	check_win_condition()

func check_win_condition() -> void:
	if _is_solved:
		return
		
	var all_solved = true
	for label in slots:
		if label.text == "_":
			all_solved = false
			break
			
	if all_solved:
		if win_timer.is_stopped():
			win_timer.start()
	else:
		if not win_timer.is_stopped():
			win_timer.stop()

func _on_win_timer_timeout() -> void:
	if _is_solved:
		return
	_is_solved = true
	cipher_solved.emit()
