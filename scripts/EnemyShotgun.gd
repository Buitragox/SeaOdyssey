extends Enemy


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var angles = [0, 5, -5]
onready var positions = [$ShootDirection/BulletSpawn1,
						 $ShootDirection/BulletSpawn2, 
						 $ShootDirection/BulletSpawn3]

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_color = Color("#de7c0e")
	attack_speed = 0.75
	shoot_rate = 1.0/attack_speed

func shoot():
	for i in range(3):
		var bullet = bulletPath.instance()
		
		# configure collision layers
		bullet.set_collision_layer_bit(Layers.ENEMY_BULLET, true)
		bullet.set_collision_mask_bit(Layers.SHIP, true)
		
		# add to group and tree
		bullet.add_to_group("bullets")
		get_parent().add_child(bullet)
		
		#set position, velocity and color
		var pos = positions[i].global_position
		var dir : Vector2 = (pos - $ShootDirection.global_position)
		
		# warning-ignore:return_value_discarded
		dir.rotated(deg2rad(angles[i]))
		bullet.set_bullet_data(pos, pos - $ShootDirection.global_position, bullet_color)
		bullet.speed = 150
		bullet.damage = damage
	
