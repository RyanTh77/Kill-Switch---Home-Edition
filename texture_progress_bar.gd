extends TextureProgressBar

# Adjust this speed value in the Inspector to spin faster or slower
@export var rotation_speed: float = 2.0 

func _process(delta: float) -> void:
	# Adds to the rotation every frame continuously
	rotation += rotation_speed * delta
