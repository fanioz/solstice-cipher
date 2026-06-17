extends Node

var _sfx_players: Array[AudioStreamPlayer] = []
var _bgm_player: AudioStreamPlayer

var _sounds: Dictionary = {
	"ui_click": preload("res://assets/audio/ui_click.wav"),
	"ui_hover": preload("res://assets/audio/ui_hover.wav"),
	"crystal_chime": preload("res://assets/audio/crystal_chime.wav"),
	"target_lit": preload("res://assets/audio/target_lit.wav"),
	"error": preload("res://assets/audio/error.wav"),
	"bgm_ambient": preload("res://assets/audio/bgm_ambient.wav")
}

func _ready() -> void:
	# Create pool of SFX players
	for i in range(8):
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_sfx_players.append(p)
		
	# Create BGM player
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "BGM"
	add_child(_bgm_player)

func play_sfx(sound_name: String) -> void:
	if not _sounds.has(sound_name):
		push_warning("Sound not found: ", sound_name)
		return
		
	for p in _sfx_players:
		if not p.playing:
			p.stream = _sounds[sound_name]
			p.play()
			return

func play_bgm(track_name: String) -> void:
	if not _sounds.has(track_name):
		push_warning("Track not found: ", track_name)
		return
		
	if _bgm_player.stream == _sounds[track_name] and _bgm_player.playing:
		return
		
	_bgm_player.stream = _sounds[track_name]
	_bgm_player.play()

func stop_bgm() -> void:
	_bgm_player.stop()
