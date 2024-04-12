extends Sprite2D;

var active_entity:ActiveEntity;

func initialize(entity:ActiveEntity):
	active_entity = entity;
	texture = active_entity.battle_sprite;
	print(active_entity.display_name, ": Nice weather out here, eh?");

func battle_turn(allies:Array):
	var rand_ally = RandomNumberGenerator.new();
	var ally_index = rand_ally.randi_range(0, len(allies)) - 1; # the subtraction of 1 is to account for how array indexes start at 0
	print(active_entity.display_name, ": shazam!!");
	allies[ally_index].hurt();
