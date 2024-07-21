extends CharacterBody2D

enum {
	IDLE,
	CHASING
}

const WALK_SPEED = 25
const INTERACT_RANGE = 16

var state = IDLE
var target

@onready var sprites = $Sprites 
@onready var collision = $Collision
@onready var animation_tree = $tree

func _physics_process(delta):
	if state == CHASING:
		velocity = (target.global_position - global_position).normalized() * WALK_SPEED
	else:
		velocity = Vector2(0, 0)
		
	if velocity:
		animation_tree.get("parameters/playback").travel("walk")
		animation_tree.set("parameters/walk/blend_position", velocity)
		animation_tree.set("parameters/idle/blend_position", velocity)
	else:
		animation_tree.get("parameters/playback").travel("idle")
	
	move_and_slide()

func _on_interact_range_body_entered(body):
	if body.is_in_group("player"):
		SceneManager.load_battle("res://scenes/maps/battle/fps_test_battle.tscn", "res://scenes/enemy_arrangements/canadian_zombie_arrangement.tscn")

func _on_detect_range_body_entered(body):
	if body.is_in_group("player"):
		target = body
		state = CHASING

func _on_detect_range_body_exited(body):
	if body.is_in_group("player"):
		state = IDLE
