extends CharacterBody2D;

@onready var tree:AnimationTree = $tree;
@onready var animator_audio:AnimationPlayer = $animator_audio;
@onready var detector:RayCast2D = $interact_detector;

const DETECTOR_RANGE:int = 32; 
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
		detector.target_position = direction * DETECTOR_RANGE;
		
		tree.get("parameters/playback").travel("walk");
		tree.set("parameters/walk/blend_position", direction);
		tree.set("parameters/idle/blend_position", direction);
		animator_audio.play("walk");
	else:
		tree.get("parameters/playback").travel("idle");
		animator_audio.play("idle");

	move_and_slide();
	position = round(position);
