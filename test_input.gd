extends SceneTree

func _init():
    var root_node = Node2D.new()
    self.root.add_child(root_node)
    
    var control = Control.new()
    control.mouse_filter = Control.MOUSE_FILTER_PASS
    control.size = Vector2(1000, 1000)
    root_node.add_child(control)
    
    var area = Area2D.new()
    area.input_event.connect(_on_area_input)
    root_node.add_child(area)
    
    var shape = CollisionShape2D.new()
    var rect = RectangleShape2D.new()
    rect.size = Vector2(100, 100)
    shape.shape = rect
    area.add_child(shape)
    
    await process_frame
    
    var event = InputEventMouseButton.new()
    event.button_index = MOUSE_BUTTON_LEFT
    event.pressed = true
    event.position = Vector2(10, 10)
    
    root.push_input(event)
    
    await get_tree().create_timer(0.2).timeout
    quit()

func _on_area_input(viewport, event, shape_idx):
    if event is InputEventMouseButton and event.pressed:
        print("AREA RECEIVED INPUT!")
