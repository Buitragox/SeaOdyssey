extends KinematicBody2D
class_name Ship


const bulletPath = preload("res://nodes/Bullet.tscn")
var Layers = preload("res://scripts/config.gd").Layers


# Constants
const MAX_SPEED = 200

# Variables
var velocity = Vector2.ZERO
var health = 100
var max_health = 100

#Data related to bullets
var mouse_pos
var attack_speed = 5.0 # amount of bullets to shoot per second
var shoot_rate # The shooting rate equals 1/attack_speed
var shoot_time = 0 
var has_shot = false

const BULLET_COLOR = Color("#cecf9e")

# simple movemenst without ifs
func movement():
	var horizontal = Input.get_action_strength("MovRight") - Input.get_action_strength("MovLeft")
	var vertical = Input.get_action_strength("MovDown") - Input.get_action_strength("MovUp")
	
	velocity.x = MAX_SPEED * horizontal
	velocity.y = MAX_SPEED * vertical
	velocity = move_and_slide(velocity)
	
func shoot():
	var pos = $Node2D/Position2D.global_position
	var bullet = bulletPath.instance()
	
	# configure collision layers
	bullet.set_collision_layer_bit(Layers.ALLY_BULLET, true)
	bullet.set_collision_mask_bit(Layers.ENEMY, true)
	
	# add to group and tree
	bullet.add_to_group("bullets")
	get_parent().add_child(bullet)
	
	#set position, velocity and color
	bullet.set_bullet_data(pos, pos - $Node2D.global_position, BULLET_COLOR)

	print("bullets:", get_tree().get_nodes_in_group("bullets").size())
	
func verify_shoot(delta):
	mouse_pos = get_global_mouse_position()
	$Node2D.look_at(mouse_pos)
	
	# CHECK
	if has_shot:
		shoot_time += delta
		if shoot_time >= shoot_rate:
			has_shot = false
			shoot_time = 0
	
		
	if Input.is_action_pressed("Shoot") and not has_shot:
		has_shot = true
		shoot()

func hit(damage):
	health -= damage
	if health <= 0:
		die()

func die():
	
	# Maybe put here some animation
	
	queue_free()
		
# Called when the node enters the scene tree for the first time.
func _ready():
	shoot_rate = 1.0/attack_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	verify_shoot(delta)

func _physics_process(_delta):
	movement()

