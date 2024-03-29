extends CharacterBody2D

@export var active_entity:ActiveEntity;

@onready var logic:Node = $logic;

func _ready():
	logic.set_script(active_entity.logic);
	logic.assign_active_entity(active_entity);

func _physics_process(delta):
	velocity = logic.logic_process();
	move_and_slide();
	
