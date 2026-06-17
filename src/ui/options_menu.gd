extends CanvasLayer

@onready var master_slider = $ColorRect/CenterContainer/VBoxContainer/MasterHBox/MasterSlider
@onready var bgm_slider = $ColorRect/CenterContainer/VBoxContainer/BGMHBox/BGMSlider
@onready var sfx_slider = $ColorRect/CenterContainer/VBoxContainer/SFXHBox/SFXSlider
@onready var fullscreen_check = $ColorRect/CenterContainer/VBoxContainer/FullscreenHBox/FullscreenCheck
@onready var close_button = $ColorRect/CenterContainer/VBoxContainer/CloseButton

func _ready() -> void:
	hide() # Start hidden
	
	close_button.pressed.connect(_on_close_pressed)
	
	master_slider.value_changed.connect(_on_master_changed)
	bgm_slider.value_changed.connect(_on_bgm_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)

func open() -> void:
	if has_node("/root/SaveManager"):
		var sm = get_node("/root/SaveManager")
		master_slider.set_value_no_signal(sm.get_setting("audio", "master_volume", 0.0))
		bgm_slider.set_value_no_signal(sm.get_setting("audio", "bgm_volume", -6.0))
		sfx_slider.set_value_no_signal(sm.get_setting("audio", "sfx_volume", 0.0))
		fullscreen_check.set_pressed_no_signal(sm.get_setting("video", "fullscreen", false))
	show()

func _on_close_pressed() -> void:
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("ui_click")
	if has_node("/root/SaveManager"):
		get_node("/root/SaveManager").save_settings(
			master_slider.value,
			bgm_slider.value,
			sfx_slider.value,
			fullscreen_check.button_pressed
		)
	hide()

func _on_master_changed(value: float) -> void:
	var idx = AudioServer.get_bus_index("Master")
	if idx >= 0: AudioServer.set_bus_volume_db(idx, value)

func _on_bgm_changed(value: float) -> void:
	var idx = AudioServer.get_bus_index("BGM")
	if idx >= 0: AudioServer.set_bus_volume_db(idx, value)

func _on_sfx_changed(value: float) -> void:
	var idx = AudioServer.get_bus_index("SFX")
	if idx >= 0: AudioServer.set_bus_volume_db(idx, value)
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("ui_click")

func _on_fullscreen_toggled(pressed: bool) -> void:
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
