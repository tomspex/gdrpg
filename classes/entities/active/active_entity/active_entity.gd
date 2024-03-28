extends Resource

class_name ActiveEntity;

@export var display_name:String;
@export var stats:EntityStats;
@export var walk_speed:int;
@export var detector_range:int;
@export var logic:GDScript;
@export var collision_shape:Shape2D;
@export var collision_transform:Vector2;
@export var sprite_frames:SpriteFrames;
@export var step_sound:AudioStream;
