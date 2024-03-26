extends CharacterBody2D

@onready var tree:AnimationTree = $tree;
@onready var detector:RayCast2D = $interact_detector;

const SPEED:float = 75.0;

func _input(event)->void:
	if(Input.is_action_just_pressed("interact")):
		if(detector.is_colliding()):
			var collider = detector.get_collider().get_parent();
			if(collider.has_method("interact")):
				collider.interact();

func _physics_process(delta)->void:
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * SPEED;
	if(direction):
		detector.target_position = direction * 32;
		
		tree.get("parameters/playback").travel("walk");
		tree.set("parameters/walk/blend_position", direction);
		tree.set("parameters/idle/blend_position", direction);
	else:
		tree.get("parameters/playback").travel("idle");

	move_and_slide();
