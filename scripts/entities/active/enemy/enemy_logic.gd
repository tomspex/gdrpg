extends CharacterBody2D;

func physics_process(active_entity:ActiveEntity, nodes:Dictionary)->Vector2:
	var toPlayer:Vector2 = global_position-nodes.player.global_position.normalized() * active_entity.walk_speed;
	return(toPlayer);
