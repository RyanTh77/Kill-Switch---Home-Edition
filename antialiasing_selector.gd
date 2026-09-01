extends OptionButton

@onready var msaa_selector: OptionButton = $"."

func _ready() -> void:
	msaa_selector.item_selected.connect(_on_msaa_selected)
	msaa_selector.selected = 2
	_on_msaa_selected(2)

func _on_msaa_selected(index: int) -> void:
	var current_viewport: Viewport = get_viewport()

	match index:
		0: #Disabled
			current_viewport.msaa_3d = Viewport.MSAA_DISABLED
			current_viewport.msaa_2d = Viewport.MSAA_DISABLED
		1: #2X
			current_viewport.msaa_3d = Viewport.MSAA_2X
			current_viewport.msaa_2d = Viewport.MSAA_2X
		2: #4X
			current_viewport.msaa_3d = Viewport.MSAA_4X
			current_viewport.msaa_2d = Viewport.MSAA_4X
		3: #8X
			current_viewport.msaa_3d = Viewport.MSAA_8X
			current_viewport.msaa_2d = Viewport.MSAA_8X
