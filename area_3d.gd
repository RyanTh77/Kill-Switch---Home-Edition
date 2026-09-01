extends Area3D

@export var speed: float = 15.0
var direction: Vector3 = Vector3.FORWARD

func _process(delta: float) -> void:
	# Move the item forward in 3D space
	global_position += direction * speed * delta



func _on_area_3d_body_entered(body: Node3D) -> void:
	# Check if the hit physics body is in the enemy group
	if body.is_in_group("Enemy"):
		body.queue_free()  # Makes the AI disappear
		queue_free()       # Destroys the thrown item
	
	# Optional: Destroy the item if it hits a wall or floor
	elif body.is_in_group("Pickables") or body is StaticBody3D:
		queue_free()
