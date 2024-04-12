extends CanvasLayer;

@export var pointer_offset = 0;
@export var pointer_init_parent:Control;

@onready var pointer:TextureRect = $pointer;

var pointer_parent;
var pointer_index:int;

func _ready():
	set_pointer_parent(pointer_init_parent);
	set_pointer_selection(0);

func _process(_delta):
	var input:Vector2i;
	if(Input.is_action_just_pressed("up")):
		input.y -= 1;
	if(Input.is_action_just_pressed("down")):
		input.y += 1;
	if(Input.is_action_just_pressed("left")):
		input.x -= 1;
	if(Input.is_action_just_pressed("right")):
		input.x += 1;
	if(input):
		set_pointer_selection(pointer_index + input.x + input.y*pointer_parent.columns);

func set_pointer_parent(control_node)->void:
	pointer_parent = control_node;

func set_pointer_selection(index:int)->void:
	pointer_index = index%pointer_parent.get_child_count();
	var selection_pos = pointer_parent.get_child(pointer_index).position;
	pointer.set_position(Vector2(selection_pos.x-pointer_offset, selection_pos.y+(pointer.texture.get_size().y/2)));
