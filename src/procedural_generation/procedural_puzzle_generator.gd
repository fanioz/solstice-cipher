# @abstract
class_name ProceduralPuzzleGenerator extends Node

## Subclasses override this method to generate a level configuration dictionary.
func generate_level(difficulty_seed: int, tier: int) -> Dictionary:
	push_error("generate_level must be overridden")
	return {}
