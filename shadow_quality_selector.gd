extends OptionButton
@onready var shadow_selector: OptionButton = $"."

func _ready() -> void:
	shadow_selector.item_selected.connect(_on_shadow_quality_selected)
	shadow_selector.selected = 2
	_on_shadow_quality_selected(2)

func _on_shadow_quality_selected(index: int) -> void:
	match index:
		0: #Lowest
			RenderingServer.directional_shadow_atlas_set_size(128, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
			_set_positional_atlas_size(128)
		1: #Low
			RenderingServer.directional_shadow_atlas_set_size(256, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
			_set_positional_atlas_size(256)
		2: #Medium
			RenderingServer.directional_shadow_atlas_set_size(512, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
			_set_positional_atlas_size(512)
		3: #High
			RenderingServer.directional_shadow_atlas_set_size(1024, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
			_set_positional_atlas_size(1024)
		4: #Ultra
			RenderingServer.directional_shadow_atlas_set_size(2048, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
			_set_positional_atlas_size(2048)
			
func _set_positional_atlas_size(size: int) -> void:
	var current_viewport: Viewport = get_viewport()
	if current_viewport:
		current_viewport.positional_shadow_atlas_size = size
