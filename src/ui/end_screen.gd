extends Control

func _on_menu_button_pressed() -> void:
	TransitionManager.transition_to("res://src/ui/title_screen.tscn")
