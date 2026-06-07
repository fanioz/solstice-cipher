extends CanvasLayer

signal cipher_solved

@onready var container = $MarginContainer/HBoxContainer

var slots: Array = []
var _is_solved: bool = false

func _ready() -> void:
    # Wait a frame so all symbols are ready and in the tree
    call_deferred("setup_ui")

func setup_ui() -> void:
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
        
    for label in slots:
        if label.text == "_":
            return
            
    _is_solved = true
    cipher_solved.emit()
