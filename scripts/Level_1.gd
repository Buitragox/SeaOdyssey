extends Node2D
const CONF = preload("res://scripts/config.gd")

class_name Level_1

var enemy_scene = preload("res://nodes/Enemy.tscn")
var ship_scene = preload("res://nodes/Ship.tscn")
var positions
var num_enemies = 15
var cont = 0

func get_positions():
	var pos_aux = Vector2()
	var positions = []
	for i in range(num_enemies):
		
		if i % 3 == 0: 
			pos_aux = Vector2(rand_range(CONF.WIDTH/2, CONF.WIDTH + 20), rand_range(-20, 0))
			
		if i % 3 == 1:
			pos_aux = Vector2(rand_range(CONF.WIDTH, CONF.WIDTH + 20), rand_range(0, CONF.HEIGHT))
		
		if i % 3 == 2:
			pos_aux = Vector2(rand_range(CONF.WIDTH/2, CONF.WIDTH + 20), rand_range(CONF.HEIGHT, CONF.HEIGHT + 20))
		
		positions.append(pos_aux)

	return positions

	
func _ready():
	randomize()
	positions = get_positions()
	print(positions)
	var ship = ship_scene.instance()
	ship.add_to_group("ship")
	ship.position = Vector2(CONF.WIDTH/4, CONF.HEIGHT/2)
	add_child(ship)
	
func _on_Timer_timeout():
	
	if get_tree().get_nodes_in_group("enemies").size() != num_enemies:
		var enemy = enemy_scene.instance()
		enemy.add_to_group("enemies")
		enemy.position = positions[cont]
		add_child(enemy)
		cont += 1
	
	

	

	
	
