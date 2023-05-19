extends KinematicBody2D
class_name Ship

# Constants
const MAX_SPEED = 200

# Variables
var velocity = Vector2.ZERO
var health = 100
var max_health = 100
var mouse_pos

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
const bulletPath = preload("res://nodes/Bullet.tscn")


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
	bullet.add_to_group("bullets")
	get_parent().add_child(bullet)
	bullet.global_position = pos
	bullet.velocity = pos - $Node2D.global_position
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_global_mouse_position()
	$Node2D.look_at(mouse_pos)
	if Input.is_action_just_pressed("Shoot"):
		shoot()


func _physics_process(delta):
	movement()

