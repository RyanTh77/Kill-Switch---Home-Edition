extends Button

@export var main_menu_scene: String = "res://Home Menu.tscn"

@onready var exit_button: Button = $"."

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_exit_button_pressed() -> void:
	var _error = get_tree().change_scene_to_file("res://Home Menu.tscn")
