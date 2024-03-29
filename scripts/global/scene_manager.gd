extends Node;

var scene;
var scene_instance;

var player_pos:Vector2;

func switch_to_scene(src:String, posX:float, posY:float)->void:
	player_pos = Vector2(posX, posY);
	
	var scene_tools = get_tree().get_first_node_in_group("scene_tools");
	
	if(scene_tools):
		var animator = scene_tools.get_node("animator");
		animator.play("wipe_out");
		await(animator.animation_finished);
	
	if(scene_instance):
		scene_instance.queue_free();
	
	scene = load(src);
	scene_instance = scene.instantiate();
	add_child(scene_instance);
	
	new_scene_process(scene_instance);

func new_scene_process(instance)->void:
	var scene_tools = instance.get_node("scene_tools");
	
	var player = instance.get_node("player");
	if(player):
		player.position = player_pos;
	
	if(scene_tools):
		var animator = scene_tools.get_node("animator");
		animator.play("wipe_in");

func switch_to_battle(opponent:ActiveEntity)->void:
	var scene_tools = get_tree().get_first_node_in_group("scene_tools");
	
	if(scene_tools):
		get_tree().paused = true;
		var animator = scene_tools.get_node("animator");
		animator.play("wipe_out");
		await(animator.animation_finished);
	
	if(scene_instance):
		scene_instance.queue_free();
	
	scene = load("res://scenes/maps/gameplay/battle/battle_test.tscn");
	scene_instance = scene.instantiate();
	add_child(scene_instance);
	
	new_battle_process(scene_instance, opponent);

func new_battle_process(instance, opponent:ActiveEntity):
	var scene_tools = instance.get_node("scene_tools");
	var opponents_list = instance.get_node("gui/opponents");
	
	if(scene_tools):
		var animator = scene_tools.get_node("animator");
		animator.play("wipe_in");
		get_tree().paused = false;
	
	var opponent_sprite = TextureRect.new();
	opponent_sprite.texture = opponent.battle_sprite;
	opponents_list.add_child(opponent_sprite);
