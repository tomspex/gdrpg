extends Node2D;

@export var entity_holder:Node2D;

var current_entity;
var current_entity_index:int = 0;
var allies:Array;
var opponents:Array;

func initialize():
	start_entity_turn();

func start_entity_turn():
	current_entity = entity_holder.get_child(current_entity_index);
	print(name, ": Starting battler \"", current_entity.active_entity.display_name, "\"'s turn");
	if(current_entity.active_entity.ally == false):
		current_entity.battle_turn(allies);
	else:
		current_entity.battle_turn(opponents);
	if(current_entity.has_signal("turn_finished")):
		current_entity.turn_finished.connect(_on_turn_finished);
	else:
		_on_turn_finished();
	
func _on_turn_finished():
	if(current_entity.has_signal("turn_finished")):
		current_entity.turn_finished.disconnect(_on_turn_finished);
	current_entity_index = (current_entity_index + 1) % entity_holder.get_child_count();
	start_entity_turn();
