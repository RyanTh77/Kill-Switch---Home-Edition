extends Camera3D

var rotation_speed : float = 0.01

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion_event: InputEventMouseMotion = event as InputEventMouseMotion
		rotation.x -= mouse_motion_event.relative.y * rotation_speed
		rotation.x = clampf(rotation.x, PI/-3, PI/3)
