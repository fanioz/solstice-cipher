extends Control

@onready var laser1 = $LaserBeam1
@onready var laser2 = $LaserBeam2

var options_menu_scene = preload("res://src/ui/options_menu.tscn")
var options_menu_instance = null

func _ready() -> void:
	# Ensure they start with 2 points so we can modify index 1
	if laser1.get_point_count() < 2:
		laser1.add_point(Vector2(-100, 0))
		laser1.add_point(Vector2(-100, 0))
	if laser2.get_point_count() < 2:
		laser2.add_point(Vector2(0, 0))
		laser2.add_point(Vector2(0, 0))
		
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_bgm("bgm_ambient")
		
	var btn = $VBoxContainer/MarginContainer/VBoxContainer2/PlayButton
	btn.grab_focus()
	btn.mouse_entered.connect(func():
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("ui_hover")
	)
		
	options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	
	var opt_btn = $VBoxContainer/MarginContainer/VBoxContainer2/OptionsButton
	opt_btn.pressed.connect(_on_options_button_pressed)
	opt_btn.mouse_entered.connect(func():
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("ui_hover")
	)
		
	_start_laser_loop()

func _start_laser_loop() -> void:
	while is_inside_tree():
		laser1.set_point_position(1, Vector2(-100, 0))
		laser2.set_point_position(1, Vector2(0, 0))
		laser1.modulate.a = 1.0
		laser2.modulate.a = 1.0
		
		var tween = create_tween()
		
		# Laser 1 travels slowly from left to right (500 pixels per second)
		# Distance is 1500 (-100 to 1400), so it takes 3.0 seconds
		tween.tween_method(
			func(val: float): laser1.set_point_position(1, Vector2(val, 0)),
			-100.0, 1400.0, 3.0
		)
		
		# The splitter is at X=900.
		# It takes Laser 1 exactly 2.0 seconds to reach the splitter.
		# So at exactly 2.0s, Laser 2 (the reflection) shoots upward!
		tween.parallel().tween_method(
			func(val: float): laser2.set_point_position(1, Vector2(0, val)),
			0.0, -600.0, 1.2
		).set_delay(2.0)
		
		# Hold the fully lit lasers for 3 seconds
		tween.tween_interval(3.0)
		
		# Gracefully fade out into the dark
		tween.tween_property(laser1, "modulate:a", 0.0, 2.0)
		tween.parallel().tween_property(laser2, "modulate:a", 0.0, 2.0)
		
		await tween.finished
		# Wait 1 second in total darkness, then loop!
		await get_tree().create_timer(1.0).timeout

func _on_play_button_pressed() -> void:
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("ui_click")
	TransitionManager.transition_to("res://src/ui/level_select.tscn")

func _on_options_button_pressed() -> void:
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("ui_click")
	if options_menu_instance:
		options_menu_instance.open()


