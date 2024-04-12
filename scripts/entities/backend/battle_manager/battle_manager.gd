extends Node2D;

@export var entity_holder:Node2D;

var current_entity_index:int = 0;
var allies:Array;
var opponents:Array;

func _process(_delta):
	var current_entity = entity_holder.get_child(current_entity_index);
	print(name, ": Starting battler \"", current_entity.active_entity.display_name, "\"'s turn");
	if(current_entity.active_entity.ally == false):
		await(current_entity.battle_turn(allies));
	else:
		await(current_entity.battle_turn(opponents));
	current_entity_index = (current_entity_index + 1) % entity_holder.get_child_count();
