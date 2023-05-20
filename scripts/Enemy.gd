extends KinematicBody2D
const CONF = preload("res://scripts/config.gd")

class_name Enemy

var velocity = Vector2()
var to_go_pos = Vector2()
var speed = 500
var health = 100

func move():	
	if abs(position.x - to_go_pos.x) > CONF.MOV_ERROR and abs(position.y - to_go_pos.y) > CONF.MOV_ERROR :
		var direction = (to_go_pos - position).normalized()
		velocity = direction * speed
		move_and_slide(velocity)

func hit(damage):
	health -= damage
	$Enemy_healthbar/TextureProgress.value -= damage
	die()

func die():
	if health <= 0:
		queue_free()

func _ready():
	randomize()
	$Enemy_healthbar/TextureProgress.max_value = health
	if position.x >= CONF.WIDTH/2 and position.x <= CONF.WIDTH + 20 and position.y >= -20 and position.y <= 0:
		to_go_pos = Vector2(rand_range(CONF.WIDTH/2 + 50 , CONF.WIDTH - CONF.WIDTH/4 - 50), rand_range(50, CONF.HEIGHT/2 - 50))
		
	if position.x >= CONF.WIDTH and position.x <= CONF.WIDTH + 20 and position.y >= 0 and position.y <=  CONF.HEIGHT:
		to_go_pos = Vector2(rand_range(CONF.WIDTH - CONF.WIDTH/4 + 50 , CONF.WIDTH - 50), rand_range(50, CONF.HEIGHT - 50))	
	
	if position.x >= CONF.WIDTH/2 and position.x <= CONF.WIDTH + 20 and position.y >= CONF.HEIGHT and position.y <=  CONF.HEIGHT + 20:
		to_go_pos = Vector2(rand_range(CONF.WIDTH/2 + 50, CONF.WIDTH - CONF.WIDTH/4 - 50), rand_range(CONF.HEIGHT/2 + 50, CONF.HEIGHT - 50))
	
func _physics_process(delta):
	move()	
	
	
	
