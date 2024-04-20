extends Node2D;

signal turn_finished;

var active_entity:ActiveEntity;
var enemies:Array;

@onready var gui_manager:CanvasLayer = $"../../gui_manager";

func initialize(entity:ActiveEntity):
	gui_manager.player_gui_finished.connect(_on_player_gui_finished);
	active_entity = entity;

func battle_turn(opponents:Array):
	enemies = opponents;

func hurt():
	print(active_entity.display_name, ": that didn't do crap, you moron.");

func _on_player_gui_finished():
	if(has_method(gui_manager.selected_option_name)):
		call(gui_manager.selected_option);
	turn_finished.emit();

func fight():
	print(active_entity.display_name, ": fight function called!");
