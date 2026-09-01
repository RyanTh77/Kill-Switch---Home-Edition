extends Button

@export var tutorial_menu_scene: String = "res://Home Menu.tscn"

@onready var exit_button_tutorial: Button = $"."

func _ready() -> void:
	exit_button_tutorial.pressed.connect(_on_exit_button_tutorial_pressed)

func _on_exit_button_tutorial_pressed() -> void:
	var _error = get_tree().change_scene_to_file("res://Home Menu.tscn")
