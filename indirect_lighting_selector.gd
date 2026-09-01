extends OptionButton

func _ready() -> void:
	# Clean Callable connection without needing a redundant @onready variable
	item_selected.connect(_on_ssil_quality_selected)
	
	# Initialise the default dropdown selection
	selected = 2
	_on_ssil_quality_selected(2)

func _on_ssil_quality_selected(index: int) -> void:
	# Updates the backend drivers globally, completely avoiding null instance errors
	match index:
		0: # Lowest
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_VERY_LOW, true, 0.5, 1, 4, 15.0)
		1: # Low
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_LOW, true, 0.5, 2, 4, 15.0)
		2: # Medium
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_MEDIUM, true, 0.5, 3, 4, 15.0)
		3: # High
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_HIGH, true, 0.5, 4, 4, 15.0)
		4: # Ultra
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_ULTRA, true, 0.5, 5, 4, 15.0)

	# Optional: Flush changes down to your disk/project config
	ProjectSettings.save()
