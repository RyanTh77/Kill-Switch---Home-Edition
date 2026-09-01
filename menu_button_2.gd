extends Control

@export var play_game_scene: String = "res://main.tscn"
@export var settings_menu_scene: String = "res://Tutorial Settings.tscn"

@onready var settings_button: MenuButton = $"."

func _ready() -> void:
	settings_button.pressed.connect(_on_settings_button_pressed)

func _on_settings_button_pressed() -> void:
	var error = get_tree().change_scene_to_file("res://Tutorial Settings.tscn")
	
	if error != OK:
		print("Error: Settings scene failed to load. Check file path!")
