extends CharacterBody2D

const INTERACT_RANGE = 32
const WALK_SPEED = 75

@onready var sprites = $Sprites
@onready var collision = $Collision
@onready var animation_tree = $tree
@onready var step_sound = $AudioHolder/Step
@onready var animator_audio = $animator_audio
@onready var interact_raycast = $InteractRayCast

func _ready():
	if SceneManager.player_initial_position:
		position = SceneManager.player_initial_position

func _physics_process(delta):
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * WALK_SPEED
	move_and_slide()
	
	if(direction):
		interact_raycast.target_position = direction * INTERACT_RANGE
		
		animation_tree.get("parameters/playback").travel("walk")
		animation_tree.set("parameters/walk/blend_position", direction)
		animation_tree.set("parameters/idle/blend_position", direction)
		animator_audio.play("walk")
	else:
		animation_tree.get("parameters/playback").travel("idle")
		animator_audio.play("idle")
	
	if(Input.is_action_just_pressed("interact")):
		if(interact_raycast.is_colliding()):
			var collider = interact_raycast.get_collider().get_parent()
			if(collider.has_method("interact")):
				collider.interact()
