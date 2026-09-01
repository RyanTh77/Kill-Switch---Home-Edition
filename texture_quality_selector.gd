extends OptionButton
@onready var texture_selector: OptionButton = $"."

func _ready() -> void:
	texture_selector.item_selected.connect(_on_texture_quality_selected)
	texture_selector.selected = 2
	_on_texture_quality_selected(2)

func _on_texture_quality_selected(index: int) -> void:
	match index:
		0: # Lowest
			ProjectSettings.set_setting("rendering/textures/vram_compression/vram_mipmap_drop_limit", 4)
		1: # Low
			ProjectSettings.set_setting("rendering/textures/vram_compression/vram_mipmap_drop_limit", 3)
		2: # Medium
			ProjectSettings.set_setting("rendering/textures/vram_compression/vram_mipmap_drop_limit", 2)
		3: # High
			ProjectSettings.set_setting("rendering/textures/vram_compression/vram_mipmap_drop_limit", 1)
		4: # Ultra
			ProjectSettings.set_setting("rendering/textures/vram_compression/vram_mipmap_drop_limit", 0)
			
func _set_runtime_texture_bias(bias_value: float) -> void:
	ProjectSettings.set_setting("rendering/textures/default_filters/texture_mipmap_bias", bias_value)
	ProjectSettings.save() 
