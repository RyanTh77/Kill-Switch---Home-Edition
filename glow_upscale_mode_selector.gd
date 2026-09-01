extends OptionButton

@onready var glow_upscale_selector: OptionButton = $"."

func _ready() -> void:
	glow_upscale_selector.item_selected.connect(_on_glow_upscale_selected)
	glow_upscale_selector.selected = 1
	_on_glow_upscale_selected(1)

func _on_glow_upscale_selected(index: int) -> void:
	var world_3d = get_tree().root.get_world_3d()
	var env: Environment = world_3d.environment

	match index:
		0: #Linear
			env.glow_bicubic_upscale = false
		1: #Bicubic
			env.glow_bicubic_upscale = true
