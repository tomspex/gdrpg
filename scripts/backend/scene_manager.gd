extends Node

var player_initial_position
var battle_enemy_arrangement

var paused = false

@onready var animation_player = $AnimationPlayer
@onready var pause_layer = $PauseLayer

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		get_tree().paused = paused
		if paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pause_layer.visible = paused
			animation_player.play("blur_in")
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			animation_player.play_backwards("blur_in")
			await(animation_player.animation_finished)
			pause_layer.visible = paused

func switch_to_scene(scene:String, player_pos:Vector2):
	player_initial_position = player_pos
	
	animation_player.play("wipe_out")
	await(animation_player.animation_finished)
	get_tree().change_scene_to_file(scene)
	animation_player.play("wipe_in")

func load_battle(battle_map:String, enemy_arrangement:String = "", sky_shader:String = ""):
	battle_enemy_arrangement = enemy_arrangement
	
	animation_player.play("wipe_out")
	await(animation_player.animation_finished)
	get_tree().change_scene_to_file(battle_map)
	animation_player.play("wipe_in")
