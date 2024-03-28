extends CharacterBody2D;

func physics_process(active_entity:ActiveEntity, detector:RayCast2D, tree:AnimationTree, animator_audio:AnimationPlayer)->Vector2:
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

	return(velocity);
