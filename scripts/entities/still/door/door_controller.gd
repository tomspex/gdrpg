extends Node2D

@export var scene_target:String;
@export var next_position:Vector2;
@export var direction:int;

@onready var sprite = $sprites;
@onready var dooropen = $audio_holder/dooropen;

func _ready():
	sprite.frame = direction;

func interact()->void:
	dooropen.play();
	print(name, ": Changing scene...");
	SceneManager.switchToScene(scene_target, next_position.x, next_position.y);
