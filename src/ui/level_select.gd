extends Control

@onready var grid_container: GridContainer = $ScrollContainer/MarginContainer/GridContainer
@onready var back_button: Button = $MarginContainer/VBoxContainer/TopBar/BackButton
@onready var options_button: Button = $MarginContainer/VBoxContainer/TopBar/OptionsButton

var options_menu_scene = preload("res://src/ui/options_menu.tscn")
var options_menu_instance = null

# Replaced hardcoded max_unlocked_level. We will pull it dynamically in _ready().
var max_unlocked_level: int = 1
var total_levels: int = 100

func _ready() -> void:
	if has_node("/root/SaveManager"):
		max_unlocked_level = get_node("/root/SaveManager").current_max_unlocked_level

	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_bgm("bgm_ambient")

	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(func():
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("ui_hover")
	)
	
	options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	
	options_button.pressed.connect(_on_options_pressed)
	options_button.mouse_entered.connect(func():
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("ui_hover")
	)
	
	_populate_grid()

func _populate_grid() -> void:
	for i in range(1, total_levels + 1):
		var btn := Button.new()
		btn.text = str(i)
		btn.custom_minimum_size = Vector2(80, 80)
		btn.focus_mode = Control.FOCUS_NONE
		
		# Styling for the Neon Cipher aesthetic
		var font_size = 24
		btn.add_theme_font_size_override("font_size", font_size)
		
		var style_normal = StyleBoxFlat.new()
		style_normal.bg_color = Color(0.1, 0.1, 0.15, 1.0)
		style_normal.border_width_bottom = 2
		style_normal.border_width_top = 2
		style_normal.border_width_left = 2
		style_normal.border_width_right = 2
		style_normal.border_color = Color(0.2, 0.2, 0.3, 1.0)
		style_normal.corner_radius_top_left = 8
		style_normal.corner_radius_top_right = 8
		style_normal.corner_radius_bottom_right = 8
		style_normal.corner_radius_bottom_left = 8
		
		if i <= max_unlocked_level:
			# Unlocked state
			style_normal.border_color = Color(0.4, 0.8, 1.0, 1.0)
			btn.add_theme_stylebox_override("normal", style_normal)
			btn.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
			
			var style_hover = style_normal.duplicate()
			style_hover.bg_color = Color(0.2, 0.4, 0.6, 1.0)
			btn.add_theme_stylebox_override("hover", style_hover)
			
			btn.pressed.connect(func(): _on_level_selected(i))
			btn.mouse_entered.connect(func(): 
				if has_node("/root/AudioManager"):
					get_node("/root/AudioManager").play_sfx("ui_hover")
			)
		else:
			# Locked state
			style_normal.bg_color = Color(0.05, 0.05, 0.05, 0.8)
			style_normal.border_color = Color(0.1, 0.1, 0.1, 1.0)
			btn.add_theme_stylebox_override("normal", style_normal)
			btn.add_theme_stylebox_override("hover", style_normal)
			btn.add_theme_color_override("font_color", Color(0.3, 0.3, 0.3, 1.0))
			btn.disabled = true
			
		grid_container.add_child(btn)

func _on_level_selected(level_num: int) -> void:
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("ui_click")
	if level_num <= 15:
		var path = "res://src/gameplay/level_%d.tscn" % level_num
		# Use TransitionManager if it exists, otherwise change directly
		if has_node("/root/TransitionManager"):
			get_node("/root/TransitionManager").transition_to(path)
		else:
			get_tree().change_scene_to_file(path)
	else:
		pass

func _on_back_pressed() -> void:
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("ui_click")
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://src/ui/title_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://src/ui/title_screen.tscn")

func _on_options_pressed() -> void:
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("ui_click")
	if options_menu_instance:
		options_menu_instance.open()
