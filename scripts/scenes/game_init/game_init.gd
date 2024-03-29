extends Node2D

@export var first_scene:String;
@export var start_pos:Vector2;

func _ready():
	SceneManager.switch_to_scene(first_scene, start_pos.x, start_pos.y);
