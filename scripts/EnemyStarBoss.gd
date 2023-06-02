extends Enemy

enum states {moveS, shootS, shotgunS, spiralS}

var state = states.moveS

var angles = [0, 5, -5]
onready var positions = [$ShootDirection/BulletSpawn1,
						 $ShootDirection/BulletSpawn2, 
						 $ShootDirection/BulletSpawn3]

func move(_delta):	
	to_go_pos = Vector2(940, 360)
	if abs(position.x - to_go_pos.x) > CONF.MOV_ERROR and abs(position.y - to_go_pos.y) > CONF.MOV_ERROR :
		var direction = (to_go_pos - position).normalized()
		velocity = direction * speed
		velocity = move_and_slide(velocity)
	elif state == states.moveS:
		state = states.shootS

func shotgun_shoot():
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

func get_health_percentaje():
	return float(health) / float(max_health) * 100.0
	

func rotate_shoot_direction(delta):
	if state == states.shootS or state == states.shotgunS:
		var ship = get_parent().get_node_or_null("./Ship")
		if ship:
			$ShootDirection.look_at(ship.global_position)
	elif state == states.spiralS:
		var angle = $ShootDirection.rotate(10 * delta)

		
func verify_shoot(delta):
	rotate_shoot_direction(delta)
	
	if state != states.moveS:
		
		if get_health_percentaje() < 30:
			attack_speed = 40.0
			shoot_rate = 1.0/attack_speed
			state = states.spiralS
		
		elif get_health_percentaje() < 60:
			attack_speed = 3.0
			shoot_rate = 1.0/attack_speed
			state = states.shotgunS
		
		elif get_health_percentaje() < 80:
			attack_speed = 7.0
			shoot_rate = 1.0/attack_speed
		
		
		shoot_time += delta
		if shoot_time >= shoot_rate:
			has_shot = false
			shoot_time = 0

		if not has_shot:
			has_shot = true
			if state == states.shootS or state == states.spiralS:
				shoot()
			elif state == states.shotgunS:
				shotgun_shoot()


# Called when the node enters the scene tree for the first time.
func _ready():
	attack_speed = 3
	speed = 150
	max_health = 500
	health = max_health
	$Healthbar/EnemyHealthbar/TextureProgress.max_value = max_health
	$Healthbar/EnemyHealthbar/TextureProgress.value = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

