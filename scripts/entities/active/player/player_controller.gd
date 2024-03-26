extends CharacterBody2D

const SPEED:float = 75.0;

func _physics_process(delta):
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down");
	if(direction):
		velocity = direction * Vector2(SPEED, SPEED);
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED));

	move_and_slide();
