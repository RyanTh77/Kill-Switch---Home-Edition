extends Control

@onready var video_player_looking: VideoStreamPlayer = $"Looking Around"
@onready var video_player_movement: VideoStreamPlayer = $Movement
@onready var video_player_sprinting: VideoStreamPlayer = $Sprinting
@onready var video_player_jumping: VideoStreamPlayer = $Jumping
@onready var video_player_picking: VideoStreamPlayer = $"Picking Up"
@onready var video_player_dropping: VideoStreamPlayer = $Dropping
@onready var video_player_throwing: VideoStreamPlayer = $Throwing
@onready var video_player_killing: VideoStreamPlayer = $"Killing Enemies"

func _ready() -> void:
	video_player_looking.visible = false
	video_player_looking.stop()
	video_player_movement.visible = false
	video_player_movement.stop()
	video_player_sprinting.visible = false
	video_player_sprinting.stop()
	video_player_jumping.visible = false
	video_player_jumping.stop()
	video_player_picking.visible = false
	video_player_picking.stop()
	video_player_dropping.visible = false
	video_player_dropping.stop()
	video_player_throwing.visible = false
	video_player_throwing.stop()
	video_player_killing.visible = false
	video_player_killing.stop()

func _on_looking_mouse_entered() -> void:
	video_player_looking.visible = true
	video_player_looking.play()

func _on_looking_mouse_exited() -> void:
	video_player_looking.visible = false
	video_player_looking.stop() 

func _on_movement_mouse_entered() -> void:
	video_player_movement.visible = true
	video_player_movement.play()

func _on_movement_mouse_exited() -> void:
	video_player_movement.visible = false
	video_player_movement.stop() 

func _on_sprinting_mouse_entered() -> void:
	video_player_sprinting.visible = true
	video_player_sprinting.play()

func _on_sprinting_mouse_exited() -> void:
	video_player_sprinting.visible = false
	video_player_sprinting.stop()

func _on_jumping_mouse_entered() -> void:
	video_player_jumping.visible = true
	video_player_jumping.play()

func _on_jumping_mouse_exited() -> void:
	video_player_jumping.visible = false
	video_player_jumping.stop()

func _on_picking_mouse_entered() -> void:
	video_player_picking.visible = true
	video_player_picking.play()

func _on_picking_mouse_exited() -> void:
	video_player_picking.visible = false
	video_player_picking.stop()

func _on_dropping_mouse_entered() -> void:
	video_player_dropping.visible = true
	video_player_dropping.play()

func _on_dropping_mouse_exited() -> void:
	video_player_dropping.visible = false
	video_player_dropping.stop()

func _on_throwing_mouse_entered() -> void:
	video_player_throwing.visible = true
	video_player_throwing.play()

func _on_throwing_mouse_exited() -> void:
	video_player_throwing.visible = false
	video_player_throwing.stop()

func _on_killing_mouse_entered() -> void:
	video_player_killing.visible = true
	video_player_killing.play()

func _on_killing_mouse_exited() -> void:
	video_player_killing.visible = false
	video_player_killing.stop()
