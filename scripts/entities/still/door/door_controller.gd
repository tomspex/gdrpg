extends Node2D

@export var scene_target:String;
@export var next_position:Vector2;

@onready var sprite:Sprite2D = $sprite;
@onready var dooropen = $audio_holder/dooropen;

func interact()->void:
	dooropen.play();
	print(name, ": Changing scene...");
	SceneManager.switchToScene(scene_target, next_position.x, next_position.y);
