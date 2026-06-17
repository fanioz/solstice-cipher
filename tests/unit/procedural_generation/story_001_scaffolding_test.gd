class_name Story001ScaffoldingTest extends "res://addons/gut/test.gd"

const LevelScaffolderClass = preload("res://src/procedural_generation/level_scaffolder.gd")

func test_select_word_by_tier() -> void:
	var scaffolder = add_child_autofree(LevelScaffolderClass.new())
	
	# Tier 1 word length is 3
	var level_t1: Dictionary = scaffolder.generate_level(12345, 1)
	assert_eq(level_t1["word"].length(), 3, "Tier 1 word length must be 3")
	assert_true(scaffolder.WORDS[3].has(level_t1["word"]), "Word must be in Tier 1 curated list")
	
	# Tier 3 word length is 4
	var level_t3: Dictionary = scaffolder.generate_level(67890, 3)
	assert_eq(level_t3["word"].length(), 4, "Tier 3 word length must be 4")
	assert_true(scaffolder.WORDS[4].has(level_t3["word"]), "Word must be in Tier 3 curated list")

func test_place_source_at_fixed_position() -> void:
	var scaffolder = add_child_autofree(LevelScaffolderClass.new())
	var level: Dictionary = scaffolder.generate_level(11111, 1)
	
	assert_eq(level["source_position"], Vector2i(1, 16), "Source position must be fixed at (1, 16)")

func test_place_glyphs_valid_positions_no_overlap() -> void:
	var scaffolder = add_child_autofree(LevelScaffolderClass.new())
	var level: Dictionary = scaffolder.generate_level(54321, 5) # Tier 5 -> length 5
	
	var word: String = level["word"]
	var glyphs: Array = level["glyphs"]
	
	assert_eq(glyphs.size(), word.length(), "Should generate one glyph per letter")
	
	var placed_positions: Array[Vector2i] = []
	
	for i in range(glyphs.size()):
		var glyph = glyphs[i]
		assert_eq(glyph["letter"], word[i], "Glyph letter must match word letter at index")
		assert_eq(glyph["index"], i, "Glyph index must match")
		
		var pos: Vector2i = glyph["position"]
		
		# Bound checks
		assert_true(pos.x >= 0 and pos.x < scaffolder.BOARD_COLS, "Glyph X position must be within board width")
		assert_true(pos.y >= 0 and pos.y < scaffolder.BOARD_ROWS, "Glyph Y position must be within playable board height")
		
		# Overlap checks
		assert_ne(pos, level["source_position"], "Glyph cannot overlap the Source")
		assert_false(pos in placed_positions, "Glyph position must be unique (no overlap with other glyphs)")
		
		placed_positions.append(pos)
		
		# Color checks
		# Tier 5 is >= 3, so some glyphs can be colored
		assert_true(glyph["color"] in ["white", "red", "green", "blue"], "Glyph color must be a valid option")

func test_determinism() -> void:
	var scaffolder = add_child_autofree(LevelScaffolderClass.new())
	
	var level_a: Dictionary = scaffolder.generate_level(999, 2)
	var level_b: Dictionary = scaffolder.generate_level(999, 2)
	var level_c: Dictionary = scaffolder.generate_level(1000, 2)
	
	# Same seed -> identical output
	assert_eq(level_a["word"], level_b["word"], "Same seed must produce the same word")
	assert_eq(level_a["source_position"], level_b["source_position"])
	
	for i in range(level_a["glyphs"].size()):
		assert_eq(level_a["glyphs"][i]["position"], level_b["glyphs"][i]["position"], "Same seed must produce identical glyph positions")
		assert_eq(level_a["glyphs"][i]["color"], level_b["glyphs"][i]["color"], "Same seed must produce identical colors")
		
	# Different seed -> usually different output
	# We assert that it doesn't match completely or the word differs
	# (though theoretically they could collide, it is extremely unlikely)
	assert_ne(level_a["word"] + str(level_a["glyphs"][0]["position"]), level_c["word"] + str(level_c["glyphs"][0]["position"]), "Different seeds should produce different layouts")
