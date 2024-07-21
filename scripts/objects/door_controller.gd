@tool

extends Node2D

@export var scene_target:String
@export var player_target:Vector2
@export var frame:int

@onready var sprite = $sprites
@onready var dooropen = $audio_holder/dooropen

func _ready():
	sprite.frame = frame

func interact()->void:
	dooropen.play()
	print(name, ": Changing scene...")
	SceneManager.switch_to_scene(scene_target, player_target)
