extends Node3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var enemy_instance = load(SceneManager.battle_enemy_arrangement).instantiate()
	add_child(enemy_instance)
