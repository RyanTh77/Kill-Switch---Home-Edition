extends CharacterBody3D

enum AIState { IDLE, PATROL, CHASE }

@export var patrol_speed: float = 9.0
@export var chase_speed: float = 12.0
@export var patrol_radius: float = 15.0
@export var player_node: Node3D
@export var ai_max_health: float = 50.0
@export var start_pos: Vector3 = Vector3(120.406, 5.045, 18.086)

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var raycast: RayCast3D = $RayCast3D
@onready var enemy_mesh: MeshInstance3D = $MeshInstance3D

var current_state: AIState = AIState.PATROL
var current_speed: float = 9.0
var last_patrol_target: Vector3 = Vector3.ZERO
var patrol_target: Vector3 = Vector3.ZERO
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var ai_current_health: float = 50.0
var is_dead: bool = false

func _ready() -> void:
	raycast.add_exception(self)
	actor_setup.call_deferred()
	ai_current_health = ai_max_health

func actor_setup() -> void:
	await get_tree().physics_frame
	_choose_new_patrol_zone()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	_evaluate_states()
	_execute_movement(delta)

func _evaluate_states() -> void:
	if not player_node:
		current_state = AIState.PATROL
		current_speed = patrol_speed
		return

	if _can_see_player():
		current_state = AIState.CHASE
		current_speed = chase_speed
		nav_agent.target_position = player_node.global_transform.origin
	else:
		if current_state == AIState.CHASE:
			current_state = AIState.PATROL
			current_speed = patrol_speed
			_choose_new_patrol_zone()
		
		elif nav_agent.is_navigation_finished():
			_choose_new_patrol_zone()

func _execute_movement(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		velocity.x = move_toward(velocity.x, 0, current_speed * delta * 10.0)
		velocity.z = move_toward(velocity.z, 0, current_speed * delta * 10.0)
		move_and_slide()
		return

	var current_pos: Vector3 = global_transform.origin
	var next_path_pos: Vector3 = nav_agent.get_next_path_position()
	
	if current_pos.distance_to(next_path_pos) < 0.2:
		move_and_slide()
		return 

	var target_direction: Vector3 = (next_path_pos - current_pos)
	target_direction.y = 0
	target_direction = target_direction.normalized()
	
	var target_vel_x = target_direction.x * current_speed
	var target_vel_z = target_direction.z * current_speed
	
	velocity.x = move_toward(velocity.x, target_vel_x, current_speed * delta * 8.0)
	velocity.z = move_toward(velocity.z, target_vel_z, current_speed * delta * 8.0)
	
	if velocity.length() > 0.2:
		var target_angle: float = atan2(-velocity.x, -velocity.z)
		rotation.y = lerp_angle(rotation.y, target_angle, 6.0 * delta)
		
	move_and_slide()

func _can_see_player() -> bool:
	if not is_instance_valid(player_node):
		return false

	raycast.target_position = raycast.to_local(player_node.global_transform.origin)
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		return raycast.get_collider() == player_node
	return false

func _choose_new_patrol_zone() -> void:
	var min_patrol_distance: float = 20.0
	var min_distance_from_last_spot: float = 20.0 
	var valid_target_found: bool = false
	var chosen_target: Vector3 = Vector3.ZERO
	
	for attempt in range(15):
		var random_offset = Vector3(
			randf_range(-patrol_radius, patrol_radius),
			0,
			randf_range(-patrol_radius, patrol_radius)
		)
		var test_target = global_transform.origin + random_offset
		var far_from_current = global_transform.origin.distance_to(test_target) >= min_patrol_distance
		var far_from_last = last_patrol_target.distance_to(test_target) >= min_distance_from_last_spot
		
		if far_from_current and far_from_last:
			chosen_target = test_target
			valid_target_found = true
			break
			
	if not valid_target_found:
		var push_dir = global_transform.basis.x if randf() > 0.5 else -global_transform.basis.x
		chosen_target = global_transform.origin + (push_dir * min_patrol_distance)

	last_patrol_target = chosen_target
	patrol_target = chosen_target
	nav_agent.target_position = patrol_target
	
@export var attack_damage: float = 20.0
@export var attack_cooldown: float = 1.0
var can_attack: bool = true

func _on_attack_zone_body_entered(body: Node3D) -> void:
	if body == player_node:
		if can_attack:
			_execute_attack(body)

func _execute_attack(target: Node3D) -> void:
	can_attack = false
	
	if target.has_method("take_damage"):
		target.take_damage(attack_damage)
		
	if is_inside_tree():
		await get_tree().create_timer(attack_cooldown).timeout
	else:
		return

	can_attack = true
	
	if is_inside_tree() and has_node("AttackZone"):
		var targets_inside = $AttackZone.get_overlapping_bodies()
		if player_node in targets_inside:
			_execute_attack(player_node)

func _on_hitbox_body_entered(body: Node3D) -> void:
	if is_dead:
		return

	if body is RigidBody3D and body.is_in_group("Pickable"):
		
		if body.linear_velocity.length() > 5.0:
			_enemy_take_damage(25.0) 
			
			var rebound_vector = (global_transform.origin - body.global_transform.origin).normalized()
			body.apply_central_impulse(rebound_vector * 5.0)

func _enemy_take_damage(amount: float) -> void:
	ai_current_health -= amount
	
	_flash_red_effect()
	
	if ai_current_health <= 0:
		_enemy_die()

func _enemy_die() -> void:
	$".".global_position = Vector3(35, -25, 7)
	patrol_speed = 0
 
func _flash_red_effect() -> void:
	if not enemy_mesh:
		return
	
	var mesh_material = enemy_mesh.get_active_material(0) as StandardMaterial3D
	
	if mesh_material:
		mesh_material.albedo_color = Color(5.0, 0.1, 0.1)
		
		if is_inside_tree():
			await get_tree().create_timer(0.15).timeout
			
		if is_instance_valid(enemy_mesh) and mesh_material:
			mesh_material.albedo_color = Color(1.0, 1.0, 0.0)

func _on_character_body_3d_character_died() -> void:
	set_physics_process(false)

func _on_restart_button_pressed() -> void:
	ai_current_health = ai_max_health
	$".".global_position = start_pos
	patrol_speed = 9.0
	set_physics_process(true)
