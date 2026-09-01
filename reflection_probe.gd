extends ReflectionProbe

func _ready():
	visible = false

	await get_tree().process_frame
	await get_tree().process_frame

	visible = true
