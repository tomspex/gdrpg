extends Node;

var sprites:AnimatedSprite2D;
var collision:CollisionShape2D;
var tree:AnimationTree;
var step_sound:AudioStreamPlayer;
var animator_audio:AnimationPlayer;

var active_entity:ActiveEntity;

func assign_active_entity(entity:ActiveEntity):
	sprites = $"../sprites";
	collision = $"../collision";
	tree = 	$"../tree";
	step_sound = $"../audio_holder/step";
	animator_audio = $"../animator_audio";
	
	active_entity = entity;
	var nodes = {
		"sprites":sprites,
		"collision":collision,
		"step_sound":step_sound,
		"animator_audio":animator_audio,
		"tree":tree
	};
	active_entity.apply_resources(nodes);

func logic_process()->Vector2:
	var pos = get_parent().global_position;
	var player = get_tree().get_first_node_in_group("player");
	var player_pos:Vector2 = player.global_position;
	var dir_to_player:Vector2 = (player_pos-pos).normalized();
	var walk_to_player:Vector2 = dir_to_player * Vector2(active_entity.walk_speed, active_entity.walk_speed);
	
	if(walk_to_player):
		tree.get("parameters/playback").travel("walk");
		tree.set("parameters/walk/blend_position", walk_to_player);
		tree.set("parameters/idle/blend_position", walk_to_player);
		animator_audio.play("walk");
	else:
		tree.get("parameters/playback").travel("idle");
		animator_audio.play("idle");
	
	if(pos.distance_to(player_pos) < active_entity.detector_range):
		SceneManager.switch_to_battle([player.active_entity, active_entity]);
	return(walk_to_player);
