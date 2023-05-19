extends KinematicBody2D

class_name Bullet

var speed = 600

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#position = Vector2(2000, 2000)
	
func _init():
	#Spawn outside of screen so it doesn't collide with the ship
	position = Vector2(2000, 2000)

func _physics_process(delta):
	
	velocity = velocity.normalized() * speed * delta;
	
	var collision = move_and_collide(velocity)
