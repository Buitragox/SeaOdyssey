extends Node2D
const CONF = preload("res://scripts/config.gd")

class_name Level_1

var enemy_scene = preload("res://nodes/Enemy.tscn")
var ship_scene = preload("res://nodes/Ship.tscn")
var num_enemies = 4

func _ready():
	var ship = ship_scene.instance()
	ship.add_to_group("ship")
	ship.position = Vector2(CONF.WIDTH/4, CONF.HEIGHT/2)
	add_child(ship)
	
func _on_Timer_timeout():
	
	if get_tree().get_nodes_in_group("enemies").size() != num_enemies:
		var enemy = enemy_scene.instance()
		enemy.add_to_group("enemies")
		enemy.position = Vector2(rand_range(CONF.WIDTH/2, CONF.WIDTH), -20)
		add_child(enemy)
	
	

	

	
	
