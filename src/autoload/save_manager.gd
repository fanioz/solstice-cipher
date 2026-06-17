extends Node

const SAVE_FILE_PATH = "user://savegame.sav"
const SAVE_TMP_PATH = "user://savegame.sav.tmp"
const SETTINGS_FILE_PATH = "user://settings.cfg"

# Internal Game State
var current_max_unlocked_level: int = 1

func _ready() -> void:
	load_game()
	load_settings()

func get_state_dict() -> Dictionary:
	# Story 001: Data Serialization
	# Only use primitives to prevent ACE vulnerabilities
	return {
		"max_unlocked_level": current_max_unlocked_level
	}

func load_state_dict(data: Dictionary) -> void:
	if data.has("max_unlocked_level"):
		var lvl = data["max_unlocked_level"]
		if typeof(lvl) == TYPE_INT or typeof(lvl) == TYPE_FLOAT:
			current_max_unlocked_level = int(lvl)

func save_game() -> void:
	# Story 002: Atomic File Writing
	var data = get_state_dict()
	
	# Open temp file
	var file = FileAccess.open(SAVE_TMP_PATH, FileAccess.WRITE)
	if not file:
		push_error("Failed to open save temp file for writing")
		return
		
	# Store securely
	file.store_var(data)
	file.close()
	
	# Atomic rename to prevent corruption
	var dir = DirAccess.open("user://")
	if dir:
		# If an old save exists, rename will overwrite it safely
		var err = dir.rename(SAVE_TMP_PATH, SAVE_FILE_PATH)
		if err != OK:
			push_error("Failed to rename temp save file to actual save file. Error code: " + str(err))
	else:
		push_error("Failed to open user:// directory for save rename")

func load_game() -> void:
	# Story 002: Secure Loading
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to open save file for reading")
		return
		
	# Security: allow_objects = false prevents arbitrary code execution via loaded resources
	var data = file.get_var(false)
	file.close()
	
	if typeof(data) == TYPE_DICTIONARY:
		load_state_dict(data)
	else:
		push_error("Save file data is not a Dictionary. Corrupted? Starting fresh.")

func unlock_level(level_num: int) -> void:
	if level_num > current_max_unlocked_level:
		current_max_unlocked_level = level_num

func save_settings(master_vol: float, bgm_vol: float, sfx_vol: float, fullscreen: bool) -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_vol)
	config.set_value("audio", "bgm_volume", bgm_vol)
	config.set_value("audio", "sfx_volume", sfx_vol)
	config.set_value("video", "fullscreen", fullscreen)
	config.save(SETTINGS_FILE_PATH)
	apply_settings(master_vol, bgm_vol, sfx_vol, fullscreen)

func load_settings() -> void:
	var config = ConfigFile.new()
	if config.load(SETTINGS_FILE_PATH) != OK:
		# Apply defaults if no settings file
		apply_settings(0.0, -6.0, 0.0, false)
		return
		
	var master_vol = config.get_value("audio", "master_volume", 0.0)
	var bgm_vol = config.get_value("audio", "bgm_volume", -6.0)
	var sfx_vol = config.get_value("audio", "sfx_volume", 0.0)
	var fullscreen = config.get_value("video", "fullscreen", false)
	
	apply_settings(master_vol, bgm_vol, sfx_vol, fullscreen)

func apply_settings(master_vol: float, bgm_vol: float, sfx_vol: float, fullscreen: bool) -> void:
	var master_idx = AudioServer.get_bus_index("Master")
	var bgm_idx = AudioServer.get_bus_index("BGM")
	var sfx_idx = AudioServer.get_bus_index("SFX")
	
	if master_idx >= 0: AudioServer.set_bus_volume_db(master_idx, master_vol)
	if bgm_idx >= 0: AudioServer.set_bus_volume_db(bgm_idx, bgm_vol)
	if sfx_idx >= 0: AudioServer.set_bus_volume_db(sfx_idx, sfx_vol)
	
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func get_setting(section: String, key: String, default_val: Variant) -> Variant:
	var config = ConfigFile.new()
	if config.load(SETTINGS_FILE_PATH) == OK:
		return config.get_value(section, key, default_val)
	return default_val
