extends Control

@export var main_menu_scene: String = "res://menu.tscn"

@onready var texture_selector: OptionButton = $"PanelContainer/VBoxContainer/GridContainer/Texture Quality Selector"
@onready var shadow_selector: OptionButton = $"PanelContainer/VBoxContainer/GridContainer/Shadow Quality Selector"
@onready var reflection_selector: OptionButton = $"PanelContainer/VBoxContainer/GridContainer/Reflection Quality Selector"
@onready var ssao_selector: OptionButton = $"PanelContainer/VBoxContainer/GridContainer/SSAO Selector"
@onready var indirect_lighting_selector: OptionButton = $"PanelContainer/VBoxContainer/GridContainer/Indirect Lighting Selector"
@onready var glow_upscale_selector: OptionButton = $"PanelContainer/VBoxContainer/GridContainer/Glow Upscale Mode Selector"
@onready var msaa_selector: OptionButton = $"PanelContainer/VBoxContainer/GridContainer/Antialiasing Selector"
@onready var exit_button: Button = $"PanelContainer/VBoxContainer/Settings/Back To Menu"
@onready var fsr_selector: OptionButton = $"PanelContainer/VBoxContainer/GridContainer/Upscaling Selector"
@onready var master_bus_index: int = AudioServer.get_bus_index("Master")

const SAVE_PATH = "user://settings.cfg"

func _ready() -> void:
	$"PanelContainer/VBoxContainer/Settings/Back To Menu".pressed.connect(_on_exit_button_pressed)
	$"PanelContainer/VBoxContainer/GridContainer/Texture Quality Selector".item_selected.connect(_on_texture_quality_selected)
	$"PanelContainer/VBoxContainer/GridContainer/Shadow Quality Selector".item_selected.connect(_on_shadow_quality_selected)
	$"PanelContainer/VBoxContainer/GridContainer/Reflection Quality Selector".item_selected.connect(_on_reflection_quality_selected)
	$"PanelContainer/VBoxContainer/GridContainer/SSAO Selector".item_selected.connect(_on_ssao_quality_selected)
	$"PanelContainer/VBoxContainer/GridContainer/Indirect Lighting Selector".item_selected.connect(_on_indirect_lighting_quality_selected)
	$"PanelContainer/VBoxContainer/GridContainer/Glow Upscale Mode Selector".item_selected.connect(_on_glow_upscale_selected)
	$"PanelContainer/VBoxContainer/GridContainer/Antialiasing Selector".item_selected.connect(_on_msaa_selected)
	$"PanelContainer/VBoxContainer/GridContainer/Upscaling Selector".item_selected.connect(_on_fsr_mode_selected)
	load_settings()

# Save System
func save_settings() -> void:
	var config = ConfigFile.new()
	
	config.set_value("Graphics", "TextureQuality", $"PanelContainer/VBoxContainer/GridContainer/Texture Quality Selector".selected)
	config.set_value("Graphics", "ShadowQuality", $"PanelContainer/VBoxContainer/GridContainer/Shadow Quality Selector".selected)
	config.set_value("Graphics", "ReflectionQuality", $"PanelContainer/VBoxContainer/GridContainer/Reflection Quality Selector".selected)
	config.set_value("Graphics", "SSAOQuality", $"PanelContainer/VBoxContainer/GridContainer/SSAO Selector".selected)
	config.set_value("Graphics", "IndirectLightingQuality", $"PanelContainer/VBoxContainer/GridContainer/Indirect Lighting Selector".selected)
	config.set_value("Graphics", "GlowUpscale", $"PanelContainer/VBoxContainer/GridContainer/Glow Upscale Mode Selector".selected)
	config.set_value("Graphics", "MSAAQuality", $"PanelContainer/VBoxContainer/GridContainer/Antialiasing Selector".selected)
	config.set_value("Graphics", "FSRMode", $"PanelContainer/VBoxContainer/GridContainer/Upscaling Selector".selected)
	
	var error = config.save(SAVE_PATH)
	if error == OK:
		print("Settings successfully written to storage: ", SAVE_PATH)
	else:
		print("Error saving config file: ", error)

# Load System
func load_settings() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		print("No settings file found. Using layout defaults.")
		_apply_menu_defaults()
		return
		
	$"PanelContainer/VBoxContainer/GridContainer/Texture Quality Selector".selected = config.get_value("Graphics", "TextureQuality", 1)
	$"PanelContainer/VBoxContainer/GridContainer/Shadow Quality Selector".selected = config.get_value("Graphics", "ShadowQuality", 1)
	$"PanelContainer/VBoxContainer/GridContainer/Reflection Quality Selector".selected = config.get_value("Graphics", "ReflectionQuality", 1)
	$"PanelContainer/VBoxContainer/GridContainer/SSAO Selector".selected = config.get_value("Graphics", "SSAOQuality", 1)
	$"PanelContainer/VBoxContainer/GridContainer/Indirect Lighting Selector".selected = config.get_value("Graphics", "IndirectLightingQuality", 1)
	$"PanelContainer/VBoxContainer/GridContainer/Glow Upscale Mode Selector".selected = config.get_value("Graphics", "GlowUpscale", 0)
	$"PanelContainer/VBoxContainer/GridContainer/Antialiasing Selector".selected = config.get_value("Graphics", "MSAAQuality", 1)
	$"PanelContainer/VBoxContainer/GridContainer/Upscaling Selector".selected = config.get_value("Graphics", "FSRMode", 3)
	
	_on_shadow_quality_selected($"PanelContainer/VBoxContainer/GridContainer/Texture Quality Selector".selected)
	_on_shadow_quality_selected($"PanelContainer/VBoxContainer/GridContainer/Shadow Quality Selector".selected)
	_on_reflection_quality_selected($"PanelContainer/VBoxContainer/GridContainer/Reflection Quality Selector".selected)
	_on_ssao_quality_selected($"PanelContainer/VBoxContainer/GridContainer/SSAO Selector".selected)
	_on_indirect_lighting_quality_selected($"PanelContainer/VBoxContainer/GridContainer/Indirect Lighting Selector".selected)
	_on_glow_upscale_selected($"PanelContainer/VBoxContainer/GridContainer/Glow Upscale Mode Selector".selected)
	_on_msaa_selected($"PanelContainer/VBoxContainer/GridContainer/Antialiasing Selector".selected)
	_on_fsr_mode_selected($"PanelContainer/VBoxContainer/GridContainer/Upscaling Selector".selected)
	
	print("Settings successfully loaded and active!")

func _apply_menu_defaults() -> void:
	_on_texture_quality_selected(1)
	_on_shadow_quality_selected(1)
	_on_reflection_quality_selected(1)
	_on_ssao_quality_selected(1)
	_on_indirect_lighting_quality_selected(1)
	_on_glow_upscale_selected(0)
	_on_msaa_selected(1)
	_on_fsr_mode_selected(3)

# Graphics Processing Loops
func _get_active_environment() -> Environment:
	var viewport = get_viewport()
	if viewport:
		var camera = viewport.get_camera_3d()
		if camera and camera.environment:
			return camera.environment
			 
	var world_3d = get_tree().root.get_world_3d()
	if world_3d and world_3d.environment:
		return world_3d.environment
		
	return null

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

func _on_shadow_quality_selected(index: int) -> void:
	match index:
		0: # Lowest
			RenderingServer.directional_shadow_atlas_set_size(128, true)
			RenderingServer.viewport_set_positional_shadow_atlas_size(get_viewport().get_viewport_rid(), 256, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
		1: # Low
			RenderingServer.directional_shadow_atlas_set_size(256, true)
			RenderingServer.viewport_set_positional_shadow_atlas_size(get_viewport().get_viewport_rid(), 512, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		2: # Medium
			RenderingServer.directional_shadow_atlas_set_size(512, true)
			RenderingServer.viewport_set_positional_shadow_atlas_size(get_viewport().get_viewport_rid(), 1024, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		3: # High
			RenderingServer.directional_shadow_atlas_set_size(1024, true)
			RenderingServer.viewport_set_positional_shadow_atlas_size(get_viewport().get_viewport_rid(), 2048, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		4: # Ultra
			RenderingServer.directional_shadow_atlas_set_size(2048, true)
			RenderingServer.viewport_set_positional_shadow_atlas_size(get_viewport().get_viewport_rid(), 4096, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)

func _on_reflection_quality_selected(index: int) -> void:
	var env = _get_active_environment()
	if not env: return
	
	match index:
		0: # Lowest
			env.ssr_enabled = false
		1: # Low
			env.ssr_enabled = true
			env.ssr_max_steps = 8
		2: # Medium
			env.ssr_enabled = true
			env.ssr_max_steps = 16
		3: # High
			env.ssr_enabled = true
			env.ssr_max_steps = 32
		4: # Ultra
			env.ssr_enabled = true
			env.ssr_max_steps = 64

func _on_ssao_quality_selected(index: int) -> void:
	var env = _get_active_environment()
	if not env: return
	
	if index == 0:
		env.ssao_enabled = false
	else:
		env.ssao_enabled = true
		match index:
			1: env.ssao_detail = 0.25
			2: env.ssao_detail = 0.5
			3: env.ssao_detail = 0.75
			4: env.ssao_detail = 1.0

func _on_indirect_lighting_quality_selected(index: int) -> void:
	var env = _get_active_environment()
	if not env: return
	
	if index == 0:
		env.ssil_enabled = false
	else:
		env.ssil_enabled = true
		match index:
			1: env.ssil_detail = 0.25
			2: env.ssil_detail = 0.5
			3: env.ssil_detail = 0.75
			4: env.ssil_detail = 1.0

func _on_glow_upscale_selected(index: int) -> void:
	var env = _get_active_environment()
	if not env: return
	
	if index == 0:
		env.glow_enabled = false
	else:
		env.glow_enabled = true
		env.glow_bicubic_upscale = (index == 1)

# Antialiasing
func _on_msaa_selected(index: int) -> void:
	var current_viewport = get_viewport()
	if not current_viewport: return
	
	match index:
		0: # Disabled
			current_viewport.msaa_3d = Viewport.MSAA_DISABLED
			current_viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		1: # FXAA
			current_viewport.msaa_3d = Viewport.MSAA_DISABLED
			current_viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		2: # MSAA 2X
			current_viewport.msaa_3d = Viewport.MSAA_2X
			current_viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		3: # MSAA 4X
			current_viewport.msaa_3d = Viewport.MSAA_4X
			current_viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		4: # MSAA 8X
			current_viewport.msaa_3d = Viewport.MSAA_8X
			current_viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED

# FSR
func _on_fsr_mode_selected(index: int) -> void:
	var current_viewport = get_viewport()
	if not current_viewport: return
	
	match index:
		0: # Disabled
			current_viewport.scaling_3d_mode = 0
			current_viewport.scaling_3d_scale = 1.0
		1: # FSR 2 Quality
			current_viewport.scaling_3d_mode = 2
			current_viewport.scaling_3d_scale = 0.77
		2: # FSR 2 Balanced
			current_viewport.scaling_3d_mode = 2
			current_viewport.scaling_3d_scale = 0.59
		3: # FSR 2 Performance
			current_viewport.scaling_3d_mode = 2
			current_viewport.scaling_3d_scale = 0.50
		4: # FSR 2 Extreme
			current_viewport.scaling_3d_mode = 2
			current_viewport.scaling_3d_scale = 0.25
			
# Exit
func _on_exit_button_pressed() -> void:
	save_settings()
	
	var tree = get_tree()
	if tree:
		tree.call_deferred("change_scene_to_file", main_menu_scene)
	else:
		print("Error: Scene tree became null before scene switch could execute.")
