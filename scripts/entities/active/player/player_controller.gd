extends CharacterBody2D

@onready var tree:AnimationTree = $tree;

const SPEED:float = 75.0;

func _physics_process(delta):
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * SPEED;
	if(direction):
		tree.get("parameters/playback").travel("walk");
		tree.set("parameters/walk/blend_position", direction);
		tree.set("parameters/idle/blend_position", direction);
	else:
		tree.get("parameters/playback").travel("idle");

	move_and_slide();
