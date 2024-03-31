extends Sprite2D;

var active_entity:ActiveEntity;

func initialize(entity:ActiveEntity):
	active_entity = entity;
	texture = active_entity.battle_sprite;
	print(active_entity.display_name, ": Nice weather out here, eh?");

func battle_turn(allies:Array):
	var rand_ally = RandomNumberGenerator.new();
	var ally_index = rand_ally.randi_range(0, len(allies));
	allies[ally_index].hurt();
	rand_ally.queue_free();
