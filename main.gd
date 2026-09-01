extends Node3D

const SAVE_PATH = "user://settings.cfg"

@onready var world_env: WorldEnvironment = $WorldEnvironment

func _ready() -> void:
	apply_saved_graphics_settings()

func apply_saved_graphics_settings() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		return
		
	if world_env and world_env.environment:
		var env = world_env.environment
		var ssao_idx = config.get_value("Graphics", "SSAOQuality", 1)
		var ssil_idx = config.get_value("Graphics", "IndirectLightingQuality", 1)
		var ssr_idx = config.get_value("Graphics", "ReflectionQuality", 1)
		var glow_idx = config.get_value("Graphics", "GlowUpscale", 0)
		
		env.ssao_enabled = (ssao_idx != 0)
		env.ssil_enabled = (ssil_idx != 0)
		env.ssr_enabled = (ssr_idx != 0)
		env.glow_enabled = (glow_idx != 0)
		
		if env.ssao_enabled: 
			env.ssao_detail = lerp(0.25, 1.0, (ssao_idx - 1) / 3.0)
		
		if env.ssil_enabled: 
			env.ssil_sharpness = lerp(0.25, 1.0, (ssil_idx - 1) / 3.0)
			
		if env.glow_enabled:
			var quality_val = 1 if glow_idx == 1 else 0
			ProjectSettings.set_setting("rendering/glow/glow_quality", quality_val)
			
		if env.ssr_enabled:
			match ssr_idx:
				1: env.ssr_max_steps = 8
				2: env.ssr_max_steps = 16
				3: env.ssr_max_steps = 32
				4: env.ssr_max_steps = 64

	# Antialiasing
	var vp = get_viewport()
	if vp:
		var msaa_idx = config.get_value("Graphics", "MSAAQuality", 1)
		match msaa_idx:
			0:
				vp.msaa_3d = Viewport.MSAA_DISABLED
				vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
			1:
				vp.msaa_3d = Viewport.MSAA_DISABLED
				vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
			2:
				vp.msaa_3d = Viewport.MSAA_2X
				vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
			3:
				vp.msaa_3d = Viewport.MSAA_4X
				vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
			4:
				vp.msaa_3d = Viewport.MSAA_8X
				vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED

	var texture_idx = config.get_value("Graphics", "TextureQuality", 1)
	match texture_idx:
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

	# Shadow Quality
	var shadow_idx = config.get_value("Graphics", "ShadowQuality", 1)
	match shadow_idx:
		0: # Lowest
			RenderingServer.directional_shadow_atlas_set_size(128, true)
			RenderingServer.viewport_set_positional_shadow_atlas_size(get_viewport().get_viewport_rid(), 124, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
		1: # Low
			RenderingServer.directional_shadow_atlas_set_size(256, true)
			RenderingServer.viewport_set_positional_shadow_atlas_size(get_viewport().get_viewport_rid(), 256, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		2: # Medium
			RenderingServer.directional_shadow_atlas_set_size(512, true)
			RenderingServer.viewport_set_positional_shadow_atlas_size(get_viewport().get_viewport_rid(), 512, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		3: # High
			RenderingServer.directional_shadow_atlas_set_size(1024, true)
			RenderingServer.viewport_set_positional_shadow_atlas_size(get_viewport().get_viewport_rid(), 1024, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		4: # Ultra
			RenderingServer.directional_shadow_atlas_set_size(2048, true)
			RenderingServer.viewport_set_positional_shadow_atlas_size(get_viewport().get_viewport_rid(), 2048, true)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"): # Press Enter/Space mid-game
		var texture_vram_bytes = Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)
		var texture_vram_mb = texture_vram_bytes / 1024.0 / 1024.0
		print("--- TRUE TEXTURE VRAM USAGE ---")
		print("Texture Asset Memory: ", snapped(texture_vram_mb, 0.01), " MB")
