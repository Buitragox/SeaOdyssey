extends Enemy

func verify_shoot(_delta):
	pass

func move(_delta):
	var ship = get_parent().get_node_or_null("./Ship")
	if ship:
		to_go_pos = ship.global_position
	
	var direction = (to_go_pos - position).normalized()
	velocity = direction * speed * _delta
	
	var collision = move_and_collide(velocity)
	if collision:
		if collision.collider.has_method("hit"):
			collision.collider.hit(damage)
		queue_free()
	
	$Body.rotate(deg2rad(120 * _delta))

func _ready():
	speed = 125
	
