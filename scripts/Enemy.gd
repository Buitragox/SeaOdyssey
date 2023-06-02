extends KinematicBody2D

class_name Enemy

signal enemy_dead(parameter)

const CONF = preload("res://scripts/config.gd")
const bulletPath = preload("res://nodes/Bullet.tscn")
var Layers = preload("res://scripts/config.gd").Layers

var velocity = Vector2()
var to_go_pos = Vector2()
var speed = 100
var health = 100
var max_health = 100
var damage = 20

var attack_speed = 2.0 # amount of bullets to shoot per second
var shoot_rate = 0.0 # The shooting rate equals 1/attack_speed
var shoot_time = 0.0 
var has_shot = false

var bullet_color = Color("#e852ea") # Pink


func shoot():
	var pos = $ShotDirection/ShotSpawn.global_position
	var bullet = bulletPath.instance()
	
	# configure collision layers
	bullet.set_collision_layer_bit(Layers.ENEMY_BULLET, true)
	bullet.set_collision_mask_bit(Layers.SHIP, true)
	
	# add to group and tree
	bullet.add_to_group("bullets")
	get_parent().add_child(bullet)
	
	#set position, velocity and color
	bullet.set_bullet_data(pos, pos - $ShotDirection.global_position, bullet_color)
	bullet.speed = 150
	bullet.damage = damage
	
	
func verify_shoot(delta):
	var ship = get_parent().get_node_or_null("./Ship")
	if ship:
		$ShotDirection.look_at(ship.global_position)

	shoot_time += delta
	if shoot_time >= shoot_rate:
		has_shot = false
		shoot_time = 0

	if not has_shot:
		has_shot = true
		shoot()


func move(_delta):	
	if abs(position.x - to_go_pos.x) > CONF.MOV_ERROR and abs(position.y - to_go_pos.y) > CONF.MOV_ERROR :
		var direction = (to_go_pos - position).normalized()
		velocity = direction * speed
		velocity = move_and_slide(velocity)


func hit(dmg):
	health -= dmg
	$Enemy_healthbar/TextureProgress.value -= dmg
	
	if health <= 0:
		die()


func die():
	emit_signal("enemy_dead")
	queue_free()


func _ready():
	connect("enemy_dead", get_node("/root/Game/Level"), "_on_enemy_dead")
	shoot_rate = 1.0/attack_speed
	health = max_health
	randomize()
	$Enemy_healthbar/TextureProgress.max_value = health
	if position.x >= CONF.WIDTH/2.0 and position.x <= CONF.WIDTH + 20 and position.y >= -20 and position.y <= 0:
		to_go_pos = Vector2(rand_range(CONF.WIDTH/2.0 + 100 , CONF.WIDTH - CONF.WIDTH/4.0 - 100), rand_range(100, CONF.HEIGHT/2.0 - 100))
		
	if position.x >= CONF.WIDTH and position.x <= CONF.WIDTH + 20 and position.y >= 0 and position.y <=  CONF.HEIGHT:
		to_go_pos = Vector2(rand_range(CONF.WIDTH - CONF.WIDTH/4.0 + 100 , CONF.WIDTH - 100), rand_range(100, CONF.HEIGHT - 100))	
	
	if position.x >= CONF.WIDTH/2.0 and position.x <= CONF.WIDTH + 20 and position.y >= CONF.HEIGHT and position.y <=  CONF.HEIGHT + 20:
		to_go_pos = Vector2(rand_range(CONF.WIDTH/2.0 + 100, CONF.WIDTH - CONF.WIDTH/4.0 - 100), rand_range(CONF.HEIGHT/2.0 + 100, CONF.HEIGHT - 100))


func _process(delta):
	verify_shoot(delta)


func _physics_process(_delta):
	move(_delta)
