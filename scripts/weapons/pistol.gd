extends Control

#weapon stats
const DAMAGE = 20

@onready var cooldown = $Cooldown
@onready var raycast = $Raycast
@onready var animator = $Animator
@onready var fire_sfx = $SFX/Fire

func fire():
	if !cooldown.is_stopped():
		return
	
	animator.stop()
	animator.play("fire")
	
	fire_sfx.stop()
	fire_sfx.play()
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		var collider_normal = raycast.get_collision_normal()
		var collider_point = raycast.get_collision_point()
		
		if !collider: #if an enemy is shot at twice in the same frame, the game crashes. This is here to try and prevent that.
			return
		
		var bullet_hole_decal_instance = Weapons.bullet_hole_decal.instantiate()
		collider.add_child(bullet_hole_decal_instance)
		bullet_hole_decal_instance.transform.origin = collider_point + (collider_normal * 0.01)
		bullet_hole_decal_instance.look_at(collider_point + collider_normal, Vector3.UP)
		
		if collider.has_method("damage"):
			collider.damage(DAMAGE)
	
	cooldown.start()

func aim_from(target_position:Vector3):
	raycast.global_position = target_position
