extends OptionButton

@onready var reflection_selector: OptionButton = $"."

func _ready() -> void:
	reflection_selector.item_selected.connect(_on_reflection_quality_selected)
	reflection_selector.selected = 2 #Medium
	_on_reflection_quality_selected(2)

func _on_reflection_quality_selected(index: int) -> void:
	match index:
		0: #Lowest
			ProjectSettings.set_setting("rendering/reflections/reflection_atlas/size", 64)
			ProjectSettings.set_setting("rendering/reflections/reflection_atlas/count", 8)
		1: #Low
			ProjectSettings.set_setting("rendering/reflections/reflection_atlas/size", 128)
			ProjectSettings.set_setting("rendering/reflections/reflection_atlas/count", 16)
		2: #Medium
			ProjectSettings.set_setting("rendering/reflections/reflection_atlas/size", 256)
			ProjectSettings.set_setting("rendering/reflections/reflection_atlas/count", 32)
		3: #High
			ProjectSettings.set_setting("rendering/reflections/reflection_atlas/size", 512)
			ProjectSettings.set_setting("rendering/reflections/reflection_atlas/count", 64)
		4: #Ultra
			ProjectSettings.set_setting("rendering/reflections/reflection_atlas/size", 1024)
			ProjectSettings.set_setting("rendering/reflections/reflection_atlas/count", 128)

	RenderingServer.call_deferred("force_draw_to_viewport")
