extends Node2D;

var active_entity:ActiveEntity;

@onready var gui_manager:CanvasLayer = $"../../gui_manager";

func initialize(entity:ActiveEntity):
	active_entity = entity;
	print(active_entity.display_name, ": go away");

func battle_turn(opponents:Array):
	print(active_entity.display_name, ": no thanks. i'll pass");

func hurt():
	print(active_entity.display_name, ": ow");
