extends Control

@export_file("*.tscn") var main_scene_path: String = "res://main.tscn"

func _ready() -> void:
	ResourceLoader.load_threaded_request(main_scene_path, "", true)

func _process(_delta: float) -> void:
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(main_scene_path, progress)
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		var packed_scene = ResourceLoader.load_threaded_get(main_scene_path)
		get_tree().change_scene_to_packed.call_deferred(packed_scene)
	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		set_process(false)
