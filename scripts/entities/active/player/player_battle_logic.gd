extends Node2D;

var active_entity:ActiveEntity;

var gui_name:RichTextLabel;
var gui_health:RichTextLabel;

func initialize(entity:ActiveEntity):
	active_entity = entity;
	print(active_entity.display_name, ": go away");
	
	var gui:CanvasLayer = $"../../gui";
	var player_gui = load("res://scenes/entities/gui/player/player_battle_gui.tscn");
	var player_gui_instance = player_gui.instantiate();
	gui.add_child(player_gui_instance);
	gui_name = player_gui_instance.get_node("name");
	gui_health = player_gui_instance.get_node("health");
	gui_name.text = active_entity.display_name;
	gui_health.text = str(active_entity.stats.health);

func battle_turn(opponents:Array):
	print(active_entity.display_name, ": hell yeah");

func hurt():
	print(active_entity.display_name, ": ow");
