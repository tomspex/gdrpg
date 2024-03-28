extends CharacterBody2D;

@export var active_entity:ActiveEntity;

@onready var sprites:AnimatedSprite2D = $sprites;
@onready var collision:CollisionShape2D = $collision;
@onready var tree:AnimationTree = $tree;
@onready var step_sound:AudioStreamPlayer = $audio_holder/step;
@onready var animator_audio:AnimationPlayer = $animator_audio;
@onready var detector:RayCast2D = $interact_detector;

func _ready():
	var nodes:Dictionary = {
		"sprites":sprites,
		"collision":collision,
		"step_sound":step_sound,
		"detector":detector
	};
	active_entity.apply_resources(nodes);

func _physics_process(_delta):
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * active_entity.walk_speed;
	if(direction):
		detector.target_position = direction * active_entity.detector_range;
		
		tree.get("parameters/playback").travel("walk");
		tree.set("parameters/walk/blend_position", direction);
		tree.set("parameters/idle/blend_position", direction);
		animator_audio.play("walk");
	else:
		tree.get("parameters/playback").travel("idle");
		animator_audio.play("idle");
	
	if(Input.is_action_just_pressed("interact")):
		if(detector.is_colliding()):
			var collider = detector.get_collider().get_parent();
			if(collider.has_method("interact")):
				collider.interact();
	
	move_and_slide();
	position = round(position);
