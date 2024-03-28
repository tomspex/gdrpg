extends CharacterBody2D;

@export var active_entity:ActiveEntity;

@onready var sprites:AnimatedSprite2D = $sprites;
@onready var collision:CollisionShape2D = $collision;
@onready var tree:AnimationTree = $tree;
@onready var step_sound:AudioStreamPlayer = $audio_holder/step;
@onready var animator_audio:AnimationPlayer = $animator_audio;
@onready var detector:RayCast2D = $interact_detector;

var logic;

func _ready():
	logic = active_entity.logic.new();
	
	sprites.sprite_frames = active_entity.sprite_frames;
	collision.shape = active_entity.collision_shape;
	collision.position = active_entity.collision_transform;
	step_sound.stream = active_entity.step_sound;

func _physics_process(_delta):
	velocity = logic.physics_process(active_entity, detector, tree, animator_audio);
	move_and_slide();
	position = round(position);
