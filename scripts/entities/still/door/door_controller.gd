extends Node2D

@export var scene_target:String;

func interact()->void:
	print("interacted!");
	get_tree().change_scene_to_file(scene_target);
