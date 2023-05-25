extends Node2D
const CONF = preload("res://scripts/config.gd")

class_name Level_1

const MAX_ENEMIES_IN_SCREEN = 4

var enemy_scene = preload("res://nodes/Enemy.tscn")
var ship_scene = preload("res://nodes/Ship.tscn")
var positions
var cont = 0

func get_position():
	var pos_aux = Vector2()
	
	if cont % 4 == 0: 
		pos_aux = Vector2(rand_range(CONF.WIDTH/2, CONF.WIDTH + 20), rand_range(-20, 0))
		
	if cont % 4 == 1:
		pos_aux = Vector2(rand_range(CONF.WIDTH, CONF.WIDTH + 20), rand_range(0, CONF.HEIGHT))
		
	if cont % 4 == 2:
		pos_aux = Vector2(rand_range(CONF.WIDTH, CONF.WIDTH + 20), rand_range(0, CONF.HEIGHT))
	
	if cont % 4 == 3:
		pos_aux = Vector2(rand_range(CONF.WIDTH/2, CONF.WIDTH + 20), rand_range(CONF.HEIGHT, CONF.HEIGHT + 20))
	
	cont += 1
	
	if cont > 3:
		cont = 0
	
	return pos_aux

	
func _ready():
	randomize()
	print(positions)
	var ship = ship_scene.instance()
	ship.add_to_group("ship")
	ship.position = Vector2(CONF.WIDTH/4, CONF.HEIGHT/2)
	add_child(ship)
	
func _on_Timer_timeout():
	
	if get_tree().get_nodes_in_group("enemies").size() != MAX_ENEMIES_IN_SCREEN:
		var enemy = enemy_scene.instance()
		enemy.add_to_group("enemies")
		enemy.position = get_position()
		add_child(enemy)
		
		
		
	
	

	

	
	
