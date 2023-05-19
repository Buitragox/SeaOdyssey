extends KinematicBody2D
const CONF = preload("res://scripts/config.gd")

class_name Enemy

var velocity = Vector2()
var to_go_pos = Vector2()
var speed = 100
var health = 100

func _ready():
	to_go_pos = Vector2(rand_range(CONF.WIDTH / 2 + 50, CONF.WIDTH - 50), rand_range(0 + 50, CONF.HEIGHT - 50))

func move():
	
	if abs(position.x - to_go_pos.x) > 2 and abs(position.y - to_go_pos.y) > 2 :
		var direction = (to_go_pos - position).normalized()
		velocity = direction * speed
		move_and_slide(velocity)
	
func _physics_process(delta):
	
	move()	
	
	
