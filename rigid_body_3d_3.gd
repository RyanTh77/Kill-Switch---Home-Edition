extends RigidBody3D

@export var start_pos: Vector3 = Vector3(119.0, 6.5, -6.0)

func _on_restart_button_pressed() -> void:
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	constant_force = Vector3.ZERO
	constant_torque = Vector3.ZERO
	$".".global_position = start_pos
