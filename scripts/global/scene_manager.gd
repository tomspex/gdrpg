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
	
	var player = instance.get_node("entities/active/player");
	if(player):
		player.position = player_pos;
	
	if(scene_tools):
		var animator = scene_tools.get_node("animator");
		animator.play("wipe_in");

func switch_to_battle(entities:Array)->void:
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
	
	new_battle_process(scene_instance, entities);

func new_battle_process(instance, entities:Array):
	var scene_tools = instance.get_node("scene_tools");
	var entity_list = instance.get_node("entity_holder");
	var battle_manager = instance.get_node("battle_manager");
	
	if(scene_tools):
		var animator = scene_tools.get_node("animator");
		animator.play("wipe_in");
		get_tree().paused = false;
	
	for i in range(len(entities)):
		var entity_instance;
		if(entities[i].ally == false):
			entity_instance = Sprite2D.new();
			battle_manager.opponents.append(entity_instance);
		else:
			entity_instance = Node2D.new();
			battle_manager.allies.append(entity_instance);
		entity_instance.set_script(entities[i].battle_logic);
		entity_list.add_child(entity_instance);
		entity_instance.initialize(entities[i]);
			
	
	battle_manager.initialize();
