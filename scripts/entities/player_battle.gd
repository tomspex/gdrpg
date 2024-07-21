extends CharacterBody3D

#input properties
#NOTE: might wanna move this to a global script
const MOUSE_SENSITIVITY = 0.005

const KEY_SENSITIVITY = 0.05

enum {
	WALL,
	FLOOR,
	SLIDE,
	AIR,
	POUND
}

#stats
var health = 100
const MAX_HEALTH = 100

#movement properties
var state = FLOOR
var speed = 0.0
var wall_jumps = 0
const WALK_SPEED = 15.0
const SPRINT_SPEED = 25.0
const SLIDE_SPEED = 30.0
const FRICTION = 6.0
const JUMP_VELOCITY = 15
const WALL_JUMP_VELOCITY = 30
const MAX_WALL_JUMPS = 3
const POUND_VELOCITY = -100
const MASS = 2

#bob properties
const BOB_FREQ = 1.0
const BOB_AMP = 0.1
var t_bob = 0.0

#camera properties
var head_shake = 0.0
const HEAD_SHAKE_RECOVER_SPEED = 0.5
const CAMERA_TILT = 0.1
const BASE_FOV = 75.0
const FOV_AMP = 1.0

#weapon properties
var weapons_loaded = []
var weapon_index
var weapon_instance
const PUNCH_DAMAGE = 20

#global properties (why can't this be a const)
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#linked nodes
@onready var head = $Head
@onready var camera = $Head/Camera
@onready var interact_raycast = $Head/Camera/InteractRaycast
@onready var hit_sfx = $SFX/Hit
@onready var heal_sfx = $SFX/Heal

@onready var health_meter = $Head/Camera/GUI/HealthMeter

func _init():
	for i in len(Weapons.weapons):
		weapons_loaded.append(load(Weapons.weapons[i]["scene"]))

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	change_weapon(0)

func _input(event):
	if event is InputEventMouseMotion:
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		
		if state == SLIDE:
			head.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		else:
			rotate_y(-event.relative.x * MOUSE_SENSITIVITY)

func _physics_process(delta):  
	if health == 0:
		velocity.y -= gravity * delta * MASS
		head.rotation.x = lerp(head.rotation.x, deg_to_rad(-90), 0.05)
		head.position.y = lerp(head.position.y, 0.0, 0.05)
		move_and_slide()
		return
	
	jump()
	
	if head_shake > 0:
		head.rotation.x = deg_to_rad(randf_range(-head_shake, head_shake))
		head.rotation.z = deg_to_rad(randf_range(-head_shake, head_shake))
		
		head_shake -= HEAD_SHAKE_RECOVER_SPEED

	if state == AIR || state == WALL:
		velocity.y -= gravity * delta * MASS
	if state == FLOOR:
		wall_jumps = 0
	if state == POUND:
		velocity.y = POUND_VELOCITY
		velocity.x = 0
		velocity.z = 0
	
	if Input.is_action_just_pressed("next_weapon"):
		weapon_index += 1
		change_weapon(weapon_index % len(Weapons.weapons))
	if Input.is_action_just_pressed("last_weapon"):
		weapon_index -= 1
		change_weapon(weapon_index % len(Weapons.weapons))

	#get directional input and set velocity
	if state != SLIDE:
		if Input.is_action_pressed("sprint"):
			speed = SPRINT_SPEED
		else:
			speed = WALK_SPEED
		
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if state == FLOOR and direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * FRICTION)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * FRICTION)
		
		#head
		head_tilt(input_dir.x, delta)
	else:
		speed = SLIDE_SPEED
		var direction = -transform.basis.z.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
	#fix head rotation after sliding
	if Input.is_action_just_released("pound"):
			rotation.y += head.rotation.y
			head.rotation.y = 0
	
	head.position.y = lerp(head.position.y, 1.5 - float(state == SLIDE), 0.1)
	
	var camera_dir = Input.get_vector("turn_left", "turn_right", "turn_up", "turn_down")
	camera.rotate_x(-camera_dir.y * KEY_SENSITIVITY)
	rotate_y(-camera_dir.x * KEY_SENSITIVITY)
	
	move_and_slide()
	
	update_state()
	
	#bob
	t_bob += delta * velocity.length() * float(state == FLOOR)
	camera.transform.origin = _head_bob(t_bob)
	
	#weapon
	if Input.is_action_just_pressed("fire"):
		weapon_instance.fire()
	
	if weapon_instance.has_method("aim_from"):
		weapon_instance.aim_from(head.global_position)
	
	#interact
	if Input.is_action_just_pressed("interact"):
		if interact_raycast.is_colliding():
			var collider = interact_raycast.get_collider().get_parent().get_parent()
			if collider.has_method("interact"):
				collider.interact()
	
	if Input.is_action_just_pressed("punch"):
		if interact_raycast.is_colliding():
			var collider = interact_raycast.get_collider()
			if collider.has_method("damage"):
				collider.damage(PUNCH_DAMAGE)
	
	#camera
	var velocity_clamped = clamp(Vector3(velocity.x, 0, velocity.z).length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_AMP * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func _head_bob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

func _head_bob_with_side(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func head_tilt(input_x, delta):
	head.rotation.z = lerp(head.rotation.z, -input_x * CAMERA_TILT, 10 * delta)

func change_weapon(index):
	weapon_index = index
	
	if weapon_instance:
		weapon_instance.queue_free()
	
	weapon_instance = weapons_loaded[index].instantiate()
	if "players" in weapon_instance:
		weapon_instance.players = true
	camera.add_child(weapon_instance)

func damage(amount):
	health -= amount
	health = clamp(health, 0, MAX_HEALTH)
	shake(10)
	hit_sfx.play()
	
	if health == 0:
		SceneManager.change_scene("res://scenes/gui/game_over.tscn")

func heal(amount):
	health += amount
	health = clamp(health, 0, MAX_HEALTH)
	heal_sfx.play()

func shake(amount):
	head_shake = amount

func jump():
	if Input.is_action_just_pressed("jump"):
		if state == FLOOR || state == SLIDE:
			velocity.y = JUMP_VELOCITY
		if state == WALL:
			if wall_jumps < MAX_WALL_JUMPS:
				velocity = get_wall_normal() * WALL_JUMP_VELOCITY
				velocity.y += JUMP_VELOCITY * 0.7
				wall_jumps += 1

func update_state():
	if is_on_floor():
		if Input.is_action_pressed("pound"):
			state = SLIDE
		else:
			state = FLOOR
	else:
		if is_on_wall_only():
			state = WALL
		else:
			state = AIR
		
		if Input.is_action_just_pressed("pound"):
			state = POUND
