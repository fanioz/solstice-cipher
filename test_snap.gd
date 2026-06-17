extends SceneTree
func _init():
    var v = Vector3(1.0004, 2.0005, -3.0009).snapped(Vector3(0.001, 0.001, 0.001))
    print(v)
    quit()
