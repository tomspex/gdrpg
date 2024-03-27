extends Node

var scene;
var scene_instance;

var player_pos:Vector2;

func switchToScene(src:String, posX:float, posY:float)->void:
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
	
	newSceneProcess(scene_instance);

func newSceneProcess(scene_instance)->void:
	var scene_tools = scene_instance.get_node("scene_tools");
	
	var player = scene_instance.get_node("player");
	if(player):
		player.position = player_pos;
	
	if(scene_tools):
		var animator = scene_tools.get_node("animator");
		animator.play("wipe_in");
