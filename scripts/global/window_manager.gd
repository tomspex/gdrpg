extends Node;

@export var ratio:Vector2i;
@export var min_x:int;

@onready var currentSize:Vector2i = get_window().size;
@onready var previousSize:Vector2i = currentSize;
@onready var scale:Vector2;

@onready var hault_x:bool = false;
@onready var hault_y:bool = false;

func _process(delta)->void:
	if(DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN):
		currentSize = get_window().size;
		scale = currentSize/ratio;
		
		
		if(currentSize.x != previousSize.x && hault_x == false):
			get_window().size.y = ratio.y*scale.x;
			hault_y = true;
		elif(currentSize.x == previousSize.x && hault_x == true):
			hault_x = false;
		
		if(currentSize.y != previousSize.y && hault_y == false):
			get_window().size.x = ratio.x*scale.y;
			hault_x = true;
		elif(currentSize.y == previousSize.y && hault_y == true):
			hault_y = false;
		
		previousSize = currentSize;

		if(currentSize.x < min_x):
			get_window().size.x = min_x;
