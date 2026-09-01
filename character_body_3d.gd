extends CharacterBody3D

signal character_died 

var speed : float = 18
var jump_speed : float = 9
var look_direction = -global_transform.basis.z.normalized()
var current_health: float = 100.0

@export var rotation_speed: float = 0.005
@export var edge_rotation_speed: float = 1.5
@export var edge_margin: float = 20.0
@export var max_health: float = 100.0
@export var start_pos: Vector3 = Vector3(-19, 0.578, 1)
@export var is_dead: bool = false:
	set(value):
		is_dead = value
		if is_dead:
			character_died.emit()

@onready var camera : Camera3D = $Camera3D
@onready var health_bar: ProgressBar = %HealthBar

func _physics_process(delta):
	if Input.is_action_pressed("sprint"):
		speed = 36
	else:
		speed = 18
	
	var move_input : Vector2 = -Input.get_vector("move_back", "move_forward", "move_forward", "move_back")
	var move_dir : Vector3 = Vector3(move_input.x, 0, move_input.y)
	
	velocity.y -= 0.49
	
	var velocity_x = -move_dir.x * speed * sin(rotation.y)
	var velocity_z = move_dir.z * speed * cos(rotation.y)
	
	velocity.x = velocity_x
	velocity.z = velocity_z
	
	move_and_slide()
	
	var move_input_side : Vector2 = -Input.get_vector("move_left", "move_right", "move_left", "move_right")
	var move_dir_side : Vector3 = Vector3(move_input_side.x, 0, move_input_side.y)
	var velocity_side_x = -move_dir_side.x * speed * cos(rotation.y)
	var velocity_side_z = move_dir_side.z * speed * sin(rotation.y)
	
	velocity.x = -velocity_side_x
	velocity.z = -velocity_side_z
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_speed
	
	if held_object:
		held_object.global_transform = hold_position.global_transform
	if held_object:
		held_object.global_position = held_object.global_position.lerp(hold_position.global_position, 10.0 * delta)
		
		held_object.global_basis = held_object.global_basis.slerp(hold_position.global_basis, 10.0 * delta)
	
	move_and_slide()
	
func _smooth_rotation(delta):
	var vel = -velocity
	var target_y_rot : float = 0
	var rotate_rate : float = 20
	if vel.x != 0 or vel.z != 0:
		target_y_rot = atan2(vel.x, vel.z)
		
		rotation.y = lerp_angle(rotation.y, target_y_rot, rotate_rate *
		delta)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		get_tree().change_scene_to_file("res://Home Menu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * rotation_speed
		camera.rotation.x -= event.relative.y * rotation_speed
		camera.rotation.x = clamp(camera.rotation.x, PI/-3, PI/3)
	
	if event.is_action_pressed("interact") and not event.is_echo(): 
		
		if is_instance_valid(held_object):
			drop_object()
		else:
			try_pickup_object()
	
	if event.is_action_pressed("Interact"):
		if held_object:
			drop_object()
		else:
			try_pickup_object()
	
	if event.is_action_pressed("Throw"):
		if held_object:
			throw_object()

@onready var interaction_ray = $Camera3D/InteractionRay
@onready var hold_position = $Camera3D/HoldPosition

var held_object: RigidBody3D = null

func try_pickup_object():
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		
		if collider is RigidBody3D and collider.is_in_group("Pickable"):
			held_object = collider
			
			held_object.freeze = true
			
			held_object.get_node("CollisionShape3D").disabled = true 
	
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		
		if collider is RigidBody3D and collider.is_in_group("Pickable"):
			
			held_object = collider
			held_object.freeze = true 
			held_object.get_node("CollisionShape3D").disabled = true 
	
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		
		if collider is RigidBody3D and collider.is_in_group("pickable"):
			held_object = collider
			
			held_object.gravity_scale = 0.0
			
			held_object.lock_rotation = true 
			
			held_object.set_collision_mask_value(1, false)
			
func drop_object():
	if held_object:
		
		held_object.freeze = false
		held_object.get_node("CollisionShape3D").disabled = false
		
		held_object = null

func throw_object():
	if held_object:
		
		held_object.freeze = false
		held_object.get_node("CollisionShape3D").disabled = false
		var throw_direction: Vector3 = -interaction_ray.global_transform.basis.z
		var throw_speed: float = 35.0
		
		held_object.linear_velocity = throw_direction * throw_speed
		held_object = null
		
func _ready() -> void:
	current_health = max_health
	_update_health_bar()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_unhandled_input(true)
	set_process_input(true)

func take_damage(amount: float) -> void:
	if current_health <= 0:
		return
		
	current_health -= amount
	current_health = clamp(current_health, 0.0, max_health)
	_update_health_bar()
	
	if current_health <= 0:
		_die()

func heal(amount: float) -> void:
	current_health += amount
	current_health = clamp(current_health, 0.0, max_health)
	_update_health_bar()

func _update_health_bar() -> void:
	if health_bar:
		health_bar.value = current_health

func _die() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	set_physics_process(false)
	is_dead = true
	$"../CanvasLayer".visible = true

func _on_restart_button_pressed() -> void:
	current_health = max_health
	$".".global_position = start_pos
	_update_health_bar()
	set_physics_process(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	is_dead = false
