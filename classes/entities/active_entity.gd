extends Resource

class_name ActiveEntity

@export var display_name:String
@export var ally:bool
@export var stats:EntityStats
@export var walk_speed:int
@export var fps_walk_speed:float
@export var fps_jump_velocity:float
@export var fps_mass:float
@export var detector_range:int
@export var logic:GDScript
@export var collision_shape:Shape2D
@export var collision_transform:Vector2
@export var sprite_frames:SpriteFrames
@export var battle_sprite:Texture
@export var step_sound:AudioStream

func apply_resources(nodes:Dictionary):
	if(nodes.sprites):
		nodes.sprites.sprite_frames = sprite_frames
	
	if(nodes.collision):
		nodes.collision.shape = collision_shape
		nodes.collision.position = collision_transform
	
	if(nodes.step_sound):
		nodes.step_sound.stream = step_sound
