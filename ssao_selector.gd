extends OptionButton

func _ready() -> void:
	# Connect the signal using the newer Callable syntax
	item_selected.connect(_on_ssao_quality_selected)
	
	# Initialise the default dropdown state
	selected = 2
	_on_ssao_quality_selected(2)

func _on_ssao_quality_selected(index: int) -> void:
	match index:
		0: # Lowest
			ProjectSettings.set_setting("rendering/environment/screen_space_reflection/roughness_quality", 0) # Example of lowering global values
			RenderingServer.environment_set_ssao_quality(RenderingServer.ENV_SSAO_QUALITY_VERY_LOW, true, 0.5, 1, 4, 15.0)
		1: # Low
			RenderingServer.environment_set_ssao_quality(RenderingServer.ENV_SSAO_QUALITY_LOW, true, 0.5, 2, 4, 15.0)
		2: # Medium
			RenderingServer.environment_set_ssao_quality(RenderingServer.ENV_SSAO_QUALITY_MEDIUM, true, 0.5, 3, 4, 15.0)
		3: # High
			RenderingServer.environment_set_ssao_quality(RenderingServer.ENV_SSAO_QUALITY_HIGH, true, 0.5, 4, 4, 15.0)
		4: # Ultra
			RenderingServer.environment_set_ssao_quality(RenderingServer.ENV_SSAO_QUALITY_ULTRA, true, 0.5, 5, 4, 15.0)

	# Crucial: Notify Godot's rendering engine that project settings have changed
	ProjectSettings.save()
