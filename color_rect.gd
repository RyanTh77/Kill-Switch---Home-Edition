extends ColorRect

func _on_pressed() -> void:
	$".".visible = false

func _on_button_pressed() -> void:
	$"../ColorRect2".visible = true
