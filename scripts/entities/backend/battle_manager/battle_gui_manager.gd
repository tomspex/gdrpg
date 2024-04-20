extends CanvasLayer;

signal player_gui_finished;

@export var pointer_offset = 0;

@onready var master_select:Control = $action_select/action_select_grid;
@onready var enemy_select:Control = $action_select/action_select_grid;
@onready var pointer:TextureRect = $pointer;

var pointer_parent;
var pointer_pos:Vector2i;
var pointer_index:int;
var selected_option_name:String;
var selected_option_return_data;

func _ready()->void:
	set_pointer_parent(master_select);
	set_pointer_selection(0);

func _process(_delta)->void:
	if(visible):
		battle_gui();

func battle_gui()->void:
	var input:Vector2i;
	input.y = int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"));
	input.x = int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left"));
	if(input):
		pointer_pos.y += input.y;
		pointer_pos.x += input.x;
		pointer_index = pointer_pos.x%pointer_parent.columns + ((pointer_pos.y*pointer_parent.columns)%pointer_parent.get_child_count()/pointer_parent.columns)*pointer_parent.columns;
		set_pointer_selection(pointer_index);
	if(Input.is_action_just_pressed("interact")):
		var selected:Control = pointer_parent.get_child(pointer_index);
		selected_option_name = selected.name;
		if(selected.has_signal("gui_option_finished")):
			selected.gui_option_finished.connect(_on_gui_option_finished);
		if(selected.has_method("execute")):
			selected_option_return_data = selected.execute();

func set_pointer_parent(control_node)->void:
	pointer_parent = control_node;

func set_pointer_selection(index:int)->void:
	var selection_pos = pointer_parent.get_child(index).position;
	pointer.set_position(Vector2(selection_pos.x-pointer_offset, selection_pos.y+(pointer.texture.get_size().y/2)));

func _on_gui_option_finished()->void:
	player_gui_finished.emit();
