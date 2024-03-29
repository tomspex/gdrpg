extends Node;

var sprites:AnimatedSprite2D;
var collision:CollisionShape2D;
var tree:AnimationTree;
var step_sound:AudioStreamPlayer;
var animator_audio:AnimationPlayer;
var detector:RayCast2D;

var active_entity:ActiveEntity;

func assign_active_entity(entity:ActiveEntity):
	sprites = $"../sprites";
	collision = $"../collision";
	tree = 	$"../tree";
	step_sound = $"../audio_holder/step";
	animator_audio = $"../animator_audio";
	detector = $"../interact_detector";
	
	active_entity = entity;
	var nodes = {
		"sprites":sprites,
		"collision":collision,
		"step_sound":step_sound,
		"animator_audio":animator_audio,
		"detector":detector,
		"tree":tree
	};
	active_entity.apply_resources(nodes);
	

func logic_process()->Vector2:
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down");
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
	
	return(direction * active_entity.walk_speed);
