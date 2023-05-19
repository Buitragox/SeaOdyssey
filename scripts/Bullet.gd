extends KinematicBody2D

class_name Bullet

var speed = 600
var damage = 25 #Default value
var velocity = Vector2.ZERO

func set_bullet_data(pos, vel, color):
	$Polygon2D.color = color
	global_position = pos
	velocity = vel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _init():
	#Spawn outside of screen so it doesn't collide with the ship
	position = Vector2(2000, 2000)

func _process(delta):
	if not $VisibilityNotifier2D.is_on_screen():
		queue_free()

func _physics_process(delta):
	
	velocity = velocity.normalized() * speed * delta;
	
	var collision = move_and_collide(velocity)
	if collision:
		if collision.collider.has_method("hit"):
			collision.collider.hit(damage)
		queue_free()
