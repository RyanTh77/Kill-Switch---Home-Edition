extends Button

@export var main_menu_scene: String = "res://Home Menu.tscn"

@onready var main_menu_button: Button = $"."

func _ready() -> void:
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _on_main_menu_button_pressed() -> void:
	var _error = get_tree().change_scene_to_file("res://Home Menu.tscn")
