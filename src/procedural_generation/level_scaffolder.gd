class_name LevelScaffolder extends "res://src/procedural_generation/procedural_puzzle_generator.gd"

const WORDS := {
	3: ["SUN", "RAY", "ARC", "ORB", "SKY", "DAY", "DIM", "LIT", "AWE", "ZEN", "DEW", "FOG", "ICE", "GEM", "OAK", "SEA", "AIR", "EYE", "RED", "GOD"],
	4: ["GLOW", "BEAM", "DAWN", "DUSK", "HAZE", "RISE", "WARM", "GOLD", "RUBY", "IRIS", "OPAL", "JADE", "ONYX", "HALO", "MOON", "STAR", "FIRE", "MIST", "WAVE", "WIND"],
	5: ["PRISM", "LIGHT", "BLAZE", "EMBER", "FLAME", "SPARK", "SHINE", "SHADE", "NIGHT", "LUNAR", "AMBER", "FLARE", "GLEAM", "OCEAN", "STORM", "FROST", "BLOOM", "CLOUD", "ABYSS", "EARTH"],
	6: ["CIPHER", "QUASAR", "PHOTON", "COSMOS", "ASTRAL", "CORONA", "NEBULA", "ZENITH", "AURORA", "COSMIC", "LUSTER", "CANDLE", "SILVER", "BRONZE", "SUNSET", "FROZEN", "MYSTIC", "SPIRIT", "PRIMAL", "DIVINE"],
	7: ["ECLIPSE", "EQUINOX", "SOLARIA", "STARLIT", "SHIMMER", "HALCYON", "LUMINAL", "SPECTRA", "CRYSTAL", "HORIZON", "COMPASS", "THUNDER", "MORNING", "BLOSSOM", "GLACIER", "FIREFLY", "RAINBOW", "MONSOON", "LANTERN", "ALCHEMY"],
	8: ["SOLSTICE", "LUMINOUS", "CRESCENT", "MERIDIAN", "STARFALL", "DAYBREAK", "TWILIGHT", "MIDNIGHT", "SPECTRUM", "RADIANCE"]
}

const BOARD_COLS: int = 12
const BOARD_ROWS: int = 18

# Fixed bottom-left position for Source
const SOURCE_POS := Vector2i(1, 16)

func get_word_length_range(tier: int) -> Vector2i:
	match tier:
		1: return Vector2i(3, 3)
		2: return Vector2i(3, 4)
		3: return Vector2i(4, 4)
		4: return Vector2i(4, 5)
		5: return Vector2i(5, 5)
		6: return Vector2i(5, 6)
		7: return Vector2i(6, 6)
		8: return Vector2i(6, 7)
		9: return Vector2i(7, 7)
		10, _: return Vector2i(7, 8)

func generate_level(difficulty_seed: int, tier: int) -> Dictionary:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = difficulty_seed
	
	# Select word length range based on tier
	var length_range: Vector2i = get_word_length_range(tier)
	
	# Gather all word lengths available within range
	var possible_lengths: Array[int] = []
	for length: int in WORDS:
		if length >= length_range.x and length <= length_range.y:
			possible_lengths.append(length)
			
	if possible_lengths.is_empty():
		# Fallback to length 3
		possible_lengths.append(3)
		
	var selected_length: int = possible_lengths[rng.randi() % possible_lengths.size()]
	var word_list: Array = WORDS.get(selected_length, WORDS[3])
	var selected_word: String = word_list[rng.randi() % word_list.size()]
	
	# Glyph placement with overlap prevention
	var occupied_cells: Array[Vector2i] = [SOURCE_POS]
	var glyphs: Array[Dictionary] = []
	
	for i in range(selected_word.length()):
		var letter: String = selected_word[i]
		var placed: bool = false
		var attempts: int = 0
		var pos: Vector2i = Vector2i.ZERO
		
		while not placed and attempts < 100:
			attempts += 1
			var rx: int = rng.randi_range(0, BOARD_COLS - 1)
			var ry: int = rng.randi_range(0, BOARD_ROWS - 1)
			var candidate := Vector2i(rx, ry)
			
			if not candidate in occupied_cells:
				pos = candidate
				occupied_cells.append(pos)
				placed = true
				
		if not placed:
			# Systematic fallback scan for empty cell
			for ry: int in range(BOARD_ROWS):
				for rx: int in range(BOARD_COLS):
					var candidate := Vector2i(rx, ry)
					if not candidate in occupied_cells:
						pos = candidate
						occupied_cells.append(pos)
						placed = true
						break
				if placed:
					break
					
		# Determine Glyph color constraint (introduced from Tier 3 onwards)
		var required_color: String = "white"
		if tier >= 3:
			# Tier 3+ supports colored filters & glyphs. Let's make ~75% of glyphs colored.
			if rng.randf() < 0.75:
				var colors: Array[String] = ["red", "green", "blue"]
				required_color = colors[rng.randi() % colors.size()]
				
		glyphs.append({
			"letter": letter,
			"index": i,
			"position": pos,
			"color": required_color
		})
		
	return {
		"word": selected_word,
		"source_position": SOURCE_POS,
		"glyphs": glyphs
	}
